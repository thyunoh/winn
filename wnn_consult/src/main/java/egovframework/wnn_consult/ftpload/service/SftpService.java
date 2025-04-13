package egovframework.wnn_consult.ftpload.service;

import com.jcraft.jsch.*;
import egovframework.wnn_consult.mangr.model.FileDTO;
import egovframework.wnn_consult.mangr.service.MangrService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import java.io.*;
import java.util.Properties;

@Service
public class SftpService {

    private static final String SFTP_HOST = "114.108.153.178";
    private static final int    SFTP_PORT = 22;
    private static final String SFTP_USER = "winner";
    private static final String SFTP_PASSWORD = "winner_20@%";
    private static final String BASE_DIRECTORY = "/home/winner/upload/";

    public void downloadFile(String filePath, HttpServletResponse response) {
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

            String remoteFilePath = BASE_DIRECTORY + filePath;
            String fileName = filePath.substring(filePath.lastIndexOf("/") + 1);

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
                System.out.println("✅ 다운로드 성공: " + remoteFilePath);

            } catch (SftpException e) {
                System.err.println("❌ SFTP get 실패: " + e.getMessage());
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } finally {
            disconnectSftp(session, channelSftp);
        }
    }

    // ✅ 바깥으로 분리된 메서드
    private void disconnectSftp(Session session, ChannelSftp channelSftp) {
        try {
            if (channelSftp != null && channelSftp.isConnected()) {
                channelSftp.disconnect();
                System.out.println("🔌 SFTP 채널 연결 해제됨");
            }
            if (session != null && session.isConnected()) {
                session.disconnect();
                System.out.println("🔌 SFTP 세션 연결 해제됨");
            }
        } catch (Exception e) {
            System.err.println("⚠️ SFTP 연결 해제 중 오류 발생: " + e.getMessage());
        }
    }
}