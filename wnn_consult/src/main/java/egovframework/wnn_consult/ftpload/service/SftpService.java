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

    private static final String SFTP_HOST =
        System.getProperty("os.name", "").toLowerCase().startsWith("win")
        ? "114.108.153.178"
        : "localhost"; // 서버(Linux)에서는 localhost, 로컬(Windows)에서는 원격 IP
    private static final int    SFTP_PORT = 22;
    private static final String SFTP_USER = "winner";
    private static final String SFTP_PASSWORD = "winner_20@%";
    private static final String BASE_DIRECTORY = "/home/winner/upload/";

    @Resource(name = "MangrService")
    private MangrService svc;

    // ✅ SFTP 파일 업로드 기능 + DB 저장
    @Transactional
    public boolean uploadFile(String localFilePath, String remoteFileName, String remoteFolder,
                              String hospCd, String fileGb, String notiSeq, String regUser, String regIp, String fileSize) {
        Session session = null;
        ChannelSftp channelSftp = null;
        boolean success = false;

        try {
            JSch jsch = new JSch();
            session = jsch.getSession(SFTP_USER, SFTP_HOST, SFTP_PORT);
            session.setPassword(SFTP_PASSWORD);

            Properties config = new Properties();
            config.put("StrictHostKeyChecking", "no");
            session.setConfig(config);

            try {
                session.connect();
                channelSftp = (ChannelSftp) session.openChannel("sftp");
                channelSftp.connect();
            } catch (JSchException e) {
                System.err.println("❌ SFTP 연결 실패: " + e.getMessage());
                return false;
            }

            String fullRemotePath = BASE_DIRECTORY + remoteFolder + "/";
            createDirectory(channelSftp, fullRemotePath);

            try (InputStream inputStream = new FileInputStream(localFilePath)) {
                String remoteFilePath = fullRemotePath + remoteFileName;
                channelSftp.put(inputStream, remoteFilePath);
                System.out.println("✅ SFTP 파일 업로드 성공: " + remoteFilePath);
                success = true;

                FileDTO dto = new FileDTO();
                dto.setFileTitle(remoteFileName);
                dto.setFilePath(remoteFilePath);
                dto.setHospCd(hospCd);
                dto.setFileGb(fileGb);
                dto.setFileSeq(notiSeq);
                dto.setRegUser(regUser);
                dto.setRegIp(regIp);
                dto.setFileSize(fileSize);

                svc.saveFile(dto.getFileTitle(), dto.getFilePath(), dto.getHospCd(),
                        dto.getFileGb(), dto.getFileSeq(), dto.getRegUser(), dto.getRegIp(), dto.getFileSize());

                System.out.println("✅ 파일 정보가 DB에 저장되었습니다: " + dto);
            }

        } catch (Exception e) {
            System.err.println("❌ SFTP 업로드 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            disconnectSftp(session, channelSftp);
        }
        return success;
    }

    // ✅ SFTP 파일 삭제 기능 + DB 삭제
    @Transactional
    public boolean deleteFile(String hospCd, String filePath, String fileSeq, String fileGb, String updUser, String updIp) {
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

            channelSftp.rm(filePath);
            System.out.println("🗑️ SFTP 파일 삭제 완료: " + filePath);

            svc.deleteFile(hospCd, filePath, fileSeq, fileGb, updUser, updIp);
            System.out.println("🗃️ DB 파일 정보 삭제 완료: seq=" + fileSeq + ", gb=" + fileGb);

            return true;

        } catch (Exception e) {
            System.err.println("❌ 파일 삭제 실패: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            disconnectSftp(session, channelSftp);
        }
    }

    // ✅ 디렉토리 자동 생성 기능
    private void createDirectory(ChannelSftp sftp, String fullPath) {
        String[] folders = fullPath.split("/");
        String currentPath = "";

        for (String folder : folders) {
            if (folder == null || folder.trim().isEmpty()) continue;
            currentPath += "/" + folder;

            try {
                sftp.cd(currentPath);
            } catch (SftpException e) {
                try {
                    sftp.mkdir(currentPath);
                    System.out.println("📁 생성됨: " + currentPath);
                    sftp.cd(currentPath);
                } catch (SftpException ex) {
                    System.err.println("❌ 생성 실패: " + currentPath);
                }
            }
        }
    }

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