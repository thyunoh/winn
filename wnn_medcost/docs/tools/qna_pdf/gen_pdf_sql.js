/* rows.json(원문 재추출분) → <PDF 지식만> 교체하는 패치 SQL
   ★사내 확정지식(SRC_TYPE='IN')은 건드리지 않는다 — DB 에서 손질한 내용이 살아 있어야 한다. */
const fs = require('fs');
const ROWS = JSON.parse(fs.readFileSync('rows.json', 'utf8'));

const PDF_CAT = {
  PVAL:  { id: 'PDF_PVAL',  nm: '환자평가표 작성매뉴얼', desc: '심평원 매뉴얼 — 항목별(A~K) 작성 기준', ord: 6 },
  CLS:   { id: 'PDF_CLS',   nm: '환자군 분류·급여기준',   desc: '의료최고도~선택입원군 산정 기준',        ord: 7 },
  QNA:   { id: 'PDF_QNA',   nm: '고시 질의응답',         desc: '개정고시별 심평원 공식 질의·응답',       ord: 8 },
  SUGA:  { id: 'PDF_SUGA',  nm: '수가 산정지침',         desc: '요양병원 급여 일반원칙·정액수가 산정',    ord: 9 },
  CLAIM: { id: 'PDF_CLAIM', nm: '청구·명세서 작성요령',   desc: '명세서 작성·특정내역·평가표 제출',       ord: 10 },
  ADM:   { id: 'PDF_ADM',   nm: '행정해석 질의응답',      desc: '요양병원 관련 행정해석(연번순 질의·답변)', ord: 11 },
  LAW:   { id: 'PDF_LAW',   nm: '관련 법령',             desc: '건강보험법·요양급여기준·의료급여법',      ord: 12 },
};
/* 행정해석은 이제 질의/답변으로 갈렸으므로 검색 가중치를 원문(3)에서 올린다 */
const W = { PVAL: 10, CLS: 9, QNA: 8, SUGA: 7, CLAIM: 6, ADM: 6, LAW: 4 };

const q = v => v == null ? 'NULL' : "'" + String(v)
  .replace(/\\/g, '\\\\').replace(/'/g, "''").replace(/\r/g, '').replace(/\n/g, '\\n') + "'";

const out = [];
out.push('-- ============================================================================');
out.push('-- 적정성평가 Q&A — 심평원 원문 지식 <재추출본으로 교체> (2026-08-04)');
out.push('--   · 원인 : -layout 추출은 표의 한 행을 여러 줄로 흩어 놓아, 질병명과 질병코드가');
out.push('--            따로 놀고 행정해석은 질의·답변이 한 줄에 섞여 읽을 수 없었다.');
out.push('--   · 조치 : pdftotext -table 로 다시 뽑아 행을 붙이고(넓은 공백은 한 칸으로 축약),');
out.push('--            2단 표(질의응답 02절·행정해석)는 답변 칼럼 위치를 찾아 질의/답변으로 분리.');
out.push('--   · 사내 확정지식(SRC_TYPE=IN)은 손대지 않는다.');
out.push('-- ============================================================================');
out.push("DELETE FROM TBL_QNA_KB  WHERE SRC_TYPE = 'PDF';");
out.push("DELETE FROM TBL_QNA_CAT WHERE SRC_TYPE = 'PDF';");
out.push('');

const subId = new Map();
for (const k of Object.keys(PDF_CAT)) {
  const c = PDF_CAT[k];
  out.push(`INSERT INTO TBL_QNA_CAT (CAT_ID,P_CAT_ID,CAT_NM,CAT_DESC,SRC_TYPE,SORT_NO) VALUES (${q(c.id)},NULL,${q(c.nm)},${q(c.desc)},'PDF',${c.ord});`);
  const secs = [...new Set(ROWS.filter(r => r.ch === k).map(r => r.sec))];
  secs.forEach((sec, i) => {
    const id = c.id + '_' + String(i + 1).padStart(2, '0');
    subId.set(k + '|' + sec, id);
    out.push(`INSERT INTO TBL_QNA_CAT (CAT_ID,P_CAT_ID,CAT_NM,CAT_DESC,SRC_TYPE,SORT_NO) VALUES (${q(id)},${q(c.id)},${q(sec)},'','PDF',${i + 1});`);
  });
}
out.push('');

ROWS.forEach((r, i) => {
  const code = 'pdf-' + String(i + 1).padStart(4, '0');
  const src = `2022 요양병원 수가 실무교육자료(건강보험심사평가원) ${r.page - 4}쪽`;

  /* 행정해석의 질의문은 한 문단이 통째로 오기도 한다(400자 초과 → TITLE 컬럼 초과).
     제목은 줄이고, 잘린 원문은 본문 맨 앞에 [질의] 로 온전히 남긴다. */
  let title = r.title, body = r.body;
  if (title.length > 180) {
    body = '[질의] ' + title + '\n\n' + body;
    title = title.slice(0, 178) + '…';
  }
  out.push('INSERT INTO TBL_QNA_KB (KB_CODE,CAT_ID,SUB_ID,SRC_TYPE,KIND,TITLE,SHORT_TITLE,KEYWORDS,BODY,'
    + 'GO_JSON,REL_IDS,SRC_NM,DOC_PAGE,WEIGHT,SORT_NO) VALUES ('
    + [q(code), q(PDF_CAT[r.ch].id), q(subId.get(r.ch + '|' + r.sec)), "'PDF'", q(r.kind),
       q(title), q(r.short), q(r.kw), q(body), "''", "''", q(src), r.page - 4, W[r.ch], i + 1].join(',') + ');');
});

const dst = 'C:/Users/user/git/winn/wnn_medcost/docs/sql/TBL_QNA_pdf_rebuild_20260804.sql';
fs.writeFileSync(dst, out.join('\n') + '\n', 'utf8');
console.log('→', dst, ROWS.length + '건', (fs.statSync(dst).size / 1024).toFixed(0) + 'KB');
