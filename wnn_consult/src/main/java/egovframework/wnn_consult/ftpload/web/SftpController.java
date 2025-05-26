package egovframework.wnn_consult.ftpload.web;

import com.jcraft.jsch.*;
import egovframework.wnn_consult.ftpload.service.SftpService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.Properties;

@RestController
@RequestMapping("/sftp")
public class SftpController {

    private final SftpService sftpService;

    public SftpController(SftpService sftpService) {
        this.sftpService = sftpService;
    }

    // ✅ SFTP 연결 정보 (임시 하드코딩 – properties 방식 권장)
    private static final String SFTP_HOST      = "114.108.153.178";
    private static final int    SFTP_PORT      = 22;
    private static final String SFTP_USER      = "winner";
    private static final String SFTP_PASSWORD  = "winner_20@%";
    private static final String BASE_DIRECTORY = "/home/winner/upload/";

    // ✅ 전역 에러 핸들링
    @RestControllerAdvice
    public static class GlobalRestExceptionHandler {
        @ExceptionHandler(Exception.class)
        public ResponseEntity<String> handleException(Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("❌ 서버 오류: " + e.getMessage());
        }
    }

    @GetMapping("/download.do")
    public void downloadFile(@RequestParam("filePath") String filePath, HttpServletResponse response) {
        Session session = null;
        ChannelSftp channelSftp = null;

        try {
            JSch jsch = new JSch();
            session = jsch.getSession(SFTP_USER, SFTP_HOST, SFTP_PORT);
            session.setPassword(SFTP_PASSWORD);

            Properties config = new Properties();
            config.put("StrictHostKeyChecking", "no");
            session.setConfig(config);

            session.connect();
            channelSftp = (ChannelSftp) session.openChannel("sftp");
            channelSftp.connect();

            String cleanedPath = filePath;
            if (filePath.startsWith(BASE_DIRECTORY)) {
                cleanedPath = filePath.substring(BASE_DIRECTORY.length());
            }
            String remoteFilePath = BASE_DIRECTORY + cleanedPath;
            
            String fileName = filePath.substring(filePath.lastIndexOf("/") + 1);

            System.out.println("📁 요청된 파일 경로: " + remoteFilePath);

            // ✅ 경로 존재 여부 확인
            try {
                SftpATTRS attrs = channelSftp.lstat(remoteFilePath);
                System.out.println("✅ 경로 확인 완료 (파일 존재): " + remoteFilePath);
            } catch (SftpException e) {
                System.err.println("❌ 경로 오류 또는 파일이 존재하지 않음: " + remoteFilePath);
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("파일을 찾을 수 없습니다.");
                return;
            }

            // ✅ 응답 헤더 설정
            response.setHeader("Content-Disposition", "attachment; filename=\"" + java.net.URLEncoder.encode(fileName, "UTF-8") + "\"");
            response.setContentType("application/octet-stream");

            try (OutputStream out = response.getOutputStream();
                 InputStream in = channelSftp.get(remoteFilePath)) {

                byte[] buffer = new byte[4096];
                int len;
                while ((len = in.read(buffer)) > 0) {
                    out.write(buffer, 0, len);
                }

                out.flush();
                System.out.println("✅ 파일 다운로드 완료: " + fileName);
            }

        } catch (Exception e) {
            e.printStackTrace();
            try {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("❌ 서버 오류 발생");
            } catch (IOException ignored) {}
        } finally {
            disconnectSftp(session, channelSftp);
        }
    }



    // ✅ 연결 해제 메서드
    private void disconnectSftp(Session session, ChannelSftp channelSftp) {
        try {
            if (channelSftp != null && channelSftp.isConnected()) {
                channelSftp.disconnect();
                System.out.println("🔌 SFTP 채널 해제 완료");
            }
            if (session != null && session.isConnected()) {
                session.disconnect();
                System.out.println("🔌 SFTP 세션 해제 완료");
            }
        } catch (Exception e) {
            System.err.println("⚠️ SFTP 연결 해제 중 오류: " + e.getMessage());
        }
    }
}
