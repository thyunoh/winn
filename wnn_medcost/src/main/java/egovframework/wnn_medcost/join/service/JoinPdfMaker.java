package egovframework.wnn_medcost.join.service;

import java.io.File;
import java.io.FileOutputStream;
import java.util.Base64;
import java.util.List;

import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

import egovframework.wnn_medcost.join.model.JoinAgreeDTO;
import egovframework.wnn_medcost.join.model.JoinMgrDTO;
import egovframework.wnn_medcost.join.model.JoinReqDTO;

/**
 * 가입신청 PDF 만들기 — 승인 시 계약 폴더에 올릴 문서.
 *
 * <p>한글은 <b>번들 TTF 를 임베딩</b>해서 찍는다. 서버(Linux)에 한글 폰트가 있으리라 기대하지 않는다 —
 * 없으면 글자가 통째로 깨지는데 그때는 이미 파일이 올라간 뒤라 알아채기 어렵다.
 * 폰트는 webapp 의 asset/fonts 에 이미 들어 있는 것을 쓴다(별도 설치 불필요).</p>
 *
 * <p>화면 PDF(브라우저 인쇄)와 달리 이쪽은 <b>서버가 만든다</b> — 승인 시 사람 손을 타지 않고
 * 같은 문서가 남아야 하기 때문이다.</p>
 */
public class JoinPdfMaker {

    /** webapp 안 폰트 위치 — 없으면 만들지 않고 예외를 던진다(깨진 문서를 남기지 않는다) */
    private static final String FONT_REL = "/asset/fonts/GmarketSansTTFMedium.ttf";

    private final BaseFont bf;
    private final Font fTitle, fHead, fBody, fSmall;

    public JoinPdfMaker(String webappRealPath) throws Exception {
        File font = new File(webappRealPath + FONT_REL);
        if (!font.exists()) {
            throw new IllegalStateException("한글 폰트를 찾지 못했습니다 : " + font.getAbsolutePath());
        }
        bf     = BaseFont.createFont(font.getAbsolutePath(), BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        fTitle = new Font(bf, 16, Font.BOLD);
        fHead  = new Font(bf, 9,  Font.BOLD);
        fBody  = new Font(bf, 9);
        fSmall = new Font(bf, 7.5f);
    }

    /**
     * 신청서 + 동의서를 한 파일로 만든다.
     * @return 만들어진 임시 PDF 파일 (호출한 쪽이 업로드 후 지운다)
     */
    public File make(JoinReqDTO i, List<JoinMgrDTO> mgrList, List<JoinAgreeDTO> agreeList) throws Exception {

        File out = File.createTempFile("joinreq_" + i.getReqNo() + "_", ".pdf");
        Document doc = new Document(PageSize.A4, 36, 36, 36, 36);
        PdfWriter.getInstance(doc, new FileOutputStream(out));
        doc.open();

        /* ── 1쪽 : 컨설팅 의뢰서 ───────────────────────────── */
        doc.add(title("컨설팅 의뢰서"));
        doc.add(gap(8));

        PdfPTable t = grid(new float[]{ 22, 38, 22, 38 });
        row(t, "병원명",        nv(i.getHospNm()),   "요양기관기호", nv(i.getHospCd()));
        row(t, "대표자",        nv(i.getHospCeo()),  "사업자등록번호", nv(i.getBusiNum()));
        row(t, "전화번호",      nv(i.getHospTel()),  "FAX",         nv(i.getHospFax()));
        String addr = (i.getZipCd() != null && i.getZipCd().length() > 0 ? "(" + i.getZipCd() + ") " : "")
                    + nv(i.getHospAddr())
                    + (i.getHospExtradr() != null && i.getHospExtradr().length() > 0 ? " " + i.getHospExtradr() : "");
        rowWide(t, "주소", addr);
        row(t, "병상수",        nv(i.getWardcnt()),  "희망 서비스", conact(i.getConactGb()));
        rowWide(t, "전산프로그램(MASTER)",
                "프로그램명 " + nv(i.getOcsCompany()) + "   ·   ID " + nv(i.getOcsUserId())
                + "   ·   PW " + nv(i.getOcsUserPw()));
        row(t, "심평원 인증서암호", nv(i.getHiraCertPw()), "PC 사용여부", pcUse(i));
        row(t, "환자평가표 작성완료일",
                (i.getAsqDay() != null && i.getAsqDay().length() > 0 ? "매월 " + i.getAsqDay() + "일" : "-")
                + (i.getAsqBigo() != null && i.getAsqBigo().length() > 0 ? " (" + i.getAsqBigo() + ")" : ""),
                "적정성평가 목표", nv(i.getEvalGoal()));
        row(t, "신청자", nv(i.getMbrNm()) + (i.getJobNm() != null && i.getJobNm().length() > 0 ? " / " + i.getJobNm() : ""),
               "연락처", nv(i.getMbrTel()));
        rowWide(t, "이메일 (로그인 ID)", nv(i.getEmail()));
        rowWide(t, "비 고", nv(i.getBigo()));
        rowWide(t, "신청일시", nv(i.getReqDttm()));
        doc.add(t);

        doc.add(gap(12));
        doc.add(new Paragraph("담당자", fHead));
        doc.add(gap(4));
        PdfPTable m = grid(new float[]{ 16, 17, 17, 17, 17, 16 });
        headRow(m, "구분", "부서", "직책", "성명", "전화번호", "이메일 주소");
        if (mgrList != null) {
            for (JoinMgrDTO g : mgrList) {
                if (g == null) continue;
                body(m, mgrGb(g.getMgrGb()));
                body(m, nv(g.getDeptNm()));
                body(m, nv(g.getJobNm()));
                body(m, nv(g.getMgrNm()));
                body(m, nv(g.getMgrTel()));
                body(m, nv(g.getEmail()));
            }
        }
        doc.add(m);

        /* ── 2쪽 이후 : 동의서 ─────────────────────────────── */
        if (agreeList != null) {
            for (JoinAgreeDTO a : agreeList) {
                if (a == null) continue;
                doc.newPage();
                doc.add(title(nv(a.getAgreeNmTxt())));
                doc.add(gap(8));

                PdfPTable s = grid(new float[]{ 100 });
                PdfPCell c = new PdfPCell(new Phrase(
                        "동의여부 : " + ("Y".equals(a.getAgreeYn()) ? "동의함" : "동의하지 않음")
                        + "        본문 버전 : " + nv(String.valueOf(a.getVerNo()))
                        + "        동의 IP : " + nv(a.getAgreeIp())
                        + "        동의자 : " + nv(a.getAgreeNm()), fBody));
                c.setPadding(6);
                s.addCell(c);
                doc.add(s);

                doc.add(gap(14));
                doc.add(center("위와 같이 동의합니다.", fHead));
                doc.add(gap(10));

                PdfPTable g = grid(new float[]{ 18, 42, 15, 25 });
                body(g, "요양기관명"); body(g, nv(i.getHospNm()));
                PdfPCell ceoLbl = cell("대표자", fHead, Element.ALIGN_LEFT);
                ceoLbl.setRowspan(2);
                g.addCell(ceoLbl);
                PdfPCell ceoVal = new PdfPCell();
                ceoVal.setRowspan(2);
                ceoVal.setPadding(4);
                Paragraph pc = new Paragraph(nv(i.getHospCeo()), fBody);
                ceoVal.addElement(pc);
                Image seal = seal(i);                 // 대표자 도장 — 신청 때 올린 이미지를 그대로 찍는다
                if (seal != null) {
                    seal.scaleToFit(46, 46);
                    ceoVal.addElement(seal);
                } else {
                    ceoVal.addElement(new Paragraph("(인)", fSmall));
                }
                g.addCell(ceoVal);
                body(g, "주　　소"); body(g, addr);
                doc.add(g);

                doc.add(gap(10));
                doc.add(center("위너넷  귀하", fHead));
            }
        }

        doc.add(gap(16));
        doc.add(center("본 문서는 가입신청 승인 시 시스템이 자동으로 만든 것입니다. (신청번호 "
                + i.getReqNo() + ")", fSmall));

        doc.close();
        return out;
    }

    /* ── 조각 ─────────────────────────────────────────────── */

    private Image seal(JoinReqDTO i) {
        try {
            if (i.getSealImg() == null || i.getSealImg().trim().length() == 0) return null;
            return Image.getInstance(Base64.getDecoder().decode(i.getSealImg().trim()));
        } catch (Exception ignore) {
            return null;                    // 도장이 깨져도 문서는 만든다
        }
    }

    private Paragraph title(String s) {
        Paragraph p = new Paragraph(s, fTitle);
        p.setAlignment(Element.ALIGN_CENTER);
        return p;
    }
    private Paragraph center(String s, Font f) {
        Paragraph p = new Paragraph(s, f);
        p.setAlignment(Element.ALIGN_CENTER);
        return p;
    }
    private Paragraph gap(float h) {
        Paragraph p = new Paragraph(" ");
        p.setSpacingAfter(h);
        return p;
    }
    private PdfPTable grid(float[] widths) throws Exception {
        PdfPTable t = new PdfPTable(widths.length);
        t.setWidthPercentage(100);
        t.setWidths(widths);
        return t;
    }
    private PdfPCell cell(String s, Font f, int align) {
        PdfPCell c = new PdfPCell(new Phrase(s == null ? "" : s, f));
        c.setPadding(4);
        c.setHorizontalAlignment(align);
        c.setVerticalAlignment(Element.ALIGN_MIDDLE);
        c.setBorderColor(new com.itextpdf.text.BaseColor(0xC8, 0xD2, 0xD9));
        return c;
    }
    private void body(PdfPTable t, String v) { t.addCell(cell(v, fBody, Element.ALIGN_LEFT)); }
    private void headRow(PdfPTable t, String... hs) {
        for (String h : hs) {
            PdfPCell c = cell(h, fHead, Element.ALIGN_CENTER);
            c.setBackgroundColor(new com.itextpdf.text.BaseColor(0xEE, 0xF2, 0xF5));
            t.addCell(c);
        }
    }
    private void row(PdfPTable t, String l1, String v1, String l2, String v2) {
        PdfPCell a = cell(l1, fHead, Element.ALIGN_LEFT);
        a.setBackgroundColor(new com.itextpdf.text.BaseColor(0xEE, 0xF2, 0xF5));
        t.addCell(a);
        body(t, v1);
        PdfPCell b = cell(l2, fHead, Element.ALIGN_LEFT);
        b.setBackgroundColor(new com.itextpdf.text.BaseColor(0xEE, 0xF2, 0xF5));
        t.addCell(b);
        body(t, v2);
    }
    private void rowWide(PdfPTable t, String l, String v) {
        PdfPCell a = cell(l, fHead, Element.ALIGN_LEFT);
        a.setBackgroundColor(new com.itextpdf.text.BaseColor(0xEE, 0xF2, 0xF5));
        t.addCell(a);
        PdfPCell b = cell(v, fBody, Element.ALIGN_LEFT);
        b.setColspan(t.getNumberOfColumns() - 1);
        t.addCell(b);
    }
    private String nv(String s) { return (s == null || s.trim().length() == 0) ? "-" : s.trim(); }
    private String conact(String g) {
        if ("A".equals(g)) return "진료비 분석 + 적정성평가";
        if ("1".equals(g)) return "진료비 분석";
        if ("2".equals(g)) return "적정성평가";
        return "-";
    }
    private String pcUse(JoinReqDTO i) {
        String g = i.getPcUseGb();
        String s = "1".equals(g) ? "단독사용 가능" : "2".equals(g) ? "단독불가" : "3".equals(g) ? "시작일 지정" : "-";
        if (i.getPcUseTime() != null && i.getPcUseTime().length() > 0) s += " (가능시간 " + i.getPcUseTime() + ")";
        if (i.getPcUseStdt() != null && i.getPcUseStdt().length() > 0) s += " (시작일 " + i.getPcUseStdt() + ")";
        return s;
    }
    private String mgrGb(String g) {
        if ("1".equals(g)) return "총 관리자";
        if ("2".equals(g)) return "간호과";
        if ("3".equals(g)) return "심사과";
        if ("4".equals(g)) return "전산담당";
        return "기타";
    }
}
