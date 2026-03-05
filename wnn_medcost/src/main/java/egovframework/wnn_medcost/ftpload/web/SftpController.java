package egovframework.wnn_medcost.ftpload.web;

import egovframework.wnn_medcost.ftpload.service.SftpService;
import egovframework.wnn_medcost.magam.web.MagamController;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpATTRS;
import com.jcraft.jsch.SftpException;

import javax.servlet.http.HttpServletResponse;

import java.io.*;
import java.nio.file.Files;
import java.util.*;

@RestController
@RequestMapping("/sftp")
public class SftpController {

	
	private static final Logger log = LoggerFactory.getLogger(SftpController.class);
	
    private final SftpService sftpService;

    public SftpController(SftpService sftpService) {
        this.sftpService = sftpService;
    }
    // ✅ SFTP 연결 정보 (임시 하드코딩 – properties 방식 권장)
    private static final String SFTP_HOST      = "localhost";
  //  private static final String SFTP_HOST      = "114.108.153.178";

    private static final int    SFTP_PORT      = 22;
    private static final String SFTP_USER      = "winner";
    private static final String SFTP_PASSWORD  = "winner_20@%";
    private static final String BASE_DIRECTORY = "/home/winner/upload/";
    @RestControllerAdvice
    public class GlobalRestExceptionHandler {

        @ExceptionHandler(Exception.class)
        public ResponseEntity<String> handleException(Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("❌ 서버 오류: " + e.getMessage());
        }
    }
    /**@   sftp -p 22 winner@SFTP_HOST
     * ✅ 다중 파일 업로드 처리 (ResponseEntity로 결과 반환)
     */
    @PostMapping("/fileupload.do")
    public ResponseEntity<String> uploadFile(
        @RequestParam("file") MultipartFile[] files,
        @RequestParam String hospCd,
        @RequestParam String fileGb,
        @RequestParam String notiSeq,
        @RequestParam String regUser,
        @RequestParam String regIp
    ) {
        try {
            System.out.println("파일 수: " + files.length);

            for (MultipartFile file : files) {
                if (file.isEmpty()) continue;

                String originalFilename = file.getOriginalFilename();
                System.out.println("파일명: " + originalFilename);

                String fileName = UUID.randomUUID() + "_" + originalFilename;
                File tempFile = Files.createTempFile("upload_", fileName).toFile();
                file.transferTo(tempFile);

                String folder = hospCd + "/" + notiSeq + "/" + fileGb;
                
                long fileSizeInKB = file.getSize(); // ➤ 파일 크기 (단위: 바이트)
                String fileSize = Long.toString(fileSizeInKB / 1024); // KB 단위 (소수점 없이)
                
                System.out.println("파일사이즈: " + fileSize);
                boolean result = sftpService.uploadFile(
                    tempFile.getAbsolutePath(), originalFilename, folder,  //fileName에서 변경
                    hospCd, fileGb, notiSeq, regUser, regIp ,fileSize);

                if (!result) {
                    return ResponseEntity.status(500).body("❌ 일부 업로드 실패");
                }
            }

            return ResponseEntity.ok("✅ 모든 파일 업로드 성공");

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("❌ 업로드 실패: " + e.getMessage());
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

            log.error("📁 요청된 파일 경로: " + remoteFilePath);	
            System.out.println("📁 요청된 파일 경로: " + remoteFilePath);

            System.out.println("filePath: " + filePath);
            System.out.println("BASE_DIRECTORY: " + BASE_DIRECTORY);
            System.out.println("cleanedPath: " + cleanedPath);
            System.out.println("remoteFilePath: " + remoteFilePath);
            
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
    
    @PostMapping("/deleteFile.do")
    public ResponseEntity<String> deleteFile(@RequestParam String hospCd,
    		                                 @RequestParam String filePath,
                                             @RequestParam String fileSeq,
                                             @RequestParam String fileGb ,
                                             @RequestParam String updUser ,
                                             @RequestParam String updIp) {
        boolean result = sftpService.deleteFile(hospCd,filePath, fileSeq, fileGb ,updUser, updIp);

        if (result) {
            return ResponseEntity.ok("✅ 삭제 성공");
        } else {
            return ResponseEntity.status(500).body("❌ 삭제 실패");
        }
    }    
}
