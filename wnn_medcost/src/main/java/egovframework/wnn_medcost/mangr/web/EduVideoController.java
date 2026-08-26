package egovframework.wnn_medcost.mangr.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.io.RandomAccessFile;

/**
 * 적정성평가 교육 동영상 (2026-08-26 사용자 「2026년 2주기 8차 요양병원 적정성평가 이해 — 좌측메뉴에 연결」).
 *   파일 = 운영 서버 /home/winner/video/01_01.mp4 (SFTP 로 올려 둔 265MB mp4).
 *   ★SftpController.download.do 는 upload 폴더 전용(경로 탈출 차단)이고 attachment 라 재생이 안 된다 —
 *     여기서는 video/mp4 + Range(구간탐색) 로 스트리밍해, 새 창에서 브라우저 내장 플레이어로 바로 재생된다.
 *   개발 PC 처럼 파일이 없으면 404 — 운영에서만 동작한다(파일서버 = 자기 자신, download.do 의 로컬 직결 개선과 같은 전제).
 */
@Controller
public class EduVideoController {

    private static final String VIDEO_PATH = "/home/winner/video/01_01.mp4";

    @GetMapping("/eduvideo/stream.do")
    public void stream(HttpServletRequest request, HttpServletResponse response) throws IOException {
        File f = new File(VIDEO_PATH);
        if (!f.isFile()) {
            // 앱의 404 페이지가 빈 html 이라 sendError 면 흰 화면만 보인다(2026-08-26 실제 혼동) — 안내 문구를 직접 내보낸다.
            // 개발 PC 는 톰캣 실행 드라이브 기준(D:) home/winner/video/01_01.mp4 에 파일을 두면 로컬에서도 재생 확인 가능.
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<html><body style='font-family:Malgun Gothic, sans-serif; padding:40px; color:#333;'>"
                + "<h3>교육 동영상을 찾을 수 없습니다</h3>"
                + "<p>서버에 파일이 없습니다: " + VIDEO_PATH + "</p>"
                + "<p style='color:#888;'>운영 서버에서만 재생됩니다 (개발 PC 는 파일 없음).</p></body></html>");
            return;
        }
        long len = f.length();
        long start = 0, end = len - 1;

        String range = request.getHeader("Range");
        if (range != null && range.startsWith("bytes=")) {
            try {
                String[] p = range.substring(6).split("-", 2);
                if (!p[0].isEmpty()) start = Long.parseLong(p[0].trim());
                if (p.length > 1 && !p[1].trim().isEmpty()) end = Long.parseLong(p[1].trim());
            } catch (NumberFormatException ignore) { start = 0; end = len - 1; }
            if (end >= len) end = len - 1;
            if (start > end || start >= len) {
                response.setHeader("Content-Range", "bytes */" + len);
                response.sendError(416);   // Range Not Satisfiable
                return;
            }
            response.setStatus(HttpServletResponse.SC_PARTIAL_CONTENT);
            response.setHeader("Content-Range", "bytes " + start + "-" + end + "/" + len);
        }

        response.setContentType("video/mp4");
        response.setHeader("Accept-Ranges", "bytes");
        response.setHeader("Content-Disposition", "inline; filename=\"eduvideo.mp4\"");
        long clen = end - start + 1;
        response.setContentLengthLong(clen);

        try (RandomAccessFile raf = new RandomAccessFile(f, "r");
             OutputStream out = response.getOutputStream()) {
            raf.seek(start);
            byte[] buf = new byte[64 * 1024];
            long remain = clen;
            while (remain > 0) {
                int n = raf.read(buf, 0, (int) Math.min(buf.length, remain));
                if (n < 0) break;
                out.write(buf, 0, n);
                remain -= n;
            }
        } catch (IOException ignore) {
            // 재생 중 창을 닫거나 구간을 건너뛰면 클라이언트가 연결을 끊는다 — 정상 흐름
        }
    }
}
