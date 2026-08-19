package egovframework.wnn_medcost.ftpload.service;

import com.jcraft.jsch.*;
import egovframework.wnn_medcost.mangr.model.FileDTO;
import egovframework.wnn_medcost.mangr.service.MangrService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.io.*;
import java.util.Properties;

@Service
public class SftpService {

    private static final String SFTP_HOST =
        System.getProperty("os.name", "").toLowerCase().startsWith("win")
        ? "114.108.153.178"
        : "localhost"; // 서버(Linux)에서는 localhost, 로컬(Windows)에서는 원격 IP
    private static final int    SFTP_PORT = 22; // SFTP 포트
    private static final String SFTP_USER = "winner"; // 사용자명
    private static final String SFTP_PASSWORD = "winner_20@%"; // 비밀번호
    private static final String BASE_DIRECTORY = "/home/winner/upload/"; // 기본 업로드 폴더
    
    @Resource(name = "MangrService") // DB 저장을 위한 서비스
    private MangrService svc;

    /**
     * ★전송 전용 업로드 (2026-08-10, QPS 공통 첨부용).
     *   uploadFile 은 TBL_FILE_MST(공지·FAQ 전용) 에 자동 저장하지만, QPS 첨부는 TBL_QPS_FILE 로 가야 하므로
     *   여기서는 SFTP 전송만 하고 DB 저장은 호출측(QpsService)이 한다. 반환값 = 저장된 원격 경로(실패 시 null).
     *   기존 uploadFile 은 그대로 둔다(월보고서·공지 업로드가 쓰고 있어 건드리지 않는다).
     */
    public String putFile(String localFilePath, String remoteFolder, String remoteFileName) {
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

            String fullRemotePath = BASE_DIRECTORY + remoteFolder + "/";
            createDirectory(channelSftp, fullRemotePath);
            String remoteFilePath = fullRemotePath + remoteFileName;
            try (InputStream in = new FileInputStream(localFilePath)) {
                channelSftp.put(in, remoteFilePath);
            }
            return remoteFilePath;
        } catch (Exception e) {
            System.err.println("❌ QPS 첨부 SFTP 전송 실패: " + e.getMessage());
            return null;
        } finally {
            disconnectSftp(session, channelSftp);
        }
    }

    // ✅ SFTP 파일 업로드 기능 + DB 저장
    @Transactional
    public boolean uploadFile(String localFilePath, String remoteFileName, String remoteFolder,
                              String hospCd, String fileGb, String notiSeq, String regUser, String regIp , String fileSize) {
        Session session = null;
        ChannelSftp channelSftp = null;
        boolean success = false;

        try {
            JSch jsch = new JSch();
            session = jsch.getSession(SFTP_USER, SFTP_HOST, SFTP_PORT);
            session.setPassword(SFTP_PASSWORD);

            // SSH 보안 설정 (테스트 환경에서는 StrictHostKeyChecking="no" 사용)
            Properties config = new Properties();
            config.put("StrictHostKeyChecking", "no");
            session.setConfig(config);

            // 🚀 SFTP 연결
            try {
                session.connect();
                channelSftp = (ChannelSftp) session.openChannel("sftp");
                channelSftp.connect();
            } catch (JSchException e) {
                System.err.println("❌ SFTP 연결 실패: " + e.getMessage());
                return false;
            }

            // 📂 병원 코드별 디렉토리 생성 및 이동
            String fullRemotePath = BASE_DIRECTORY + remoteFolder + "/";
            createDirectory(channelSftp, fullRemotePath);

            // 📤 파일 업로드 수행
            try (InputStream inputStream = new FileInputStream(localFilePath)) {
                String remoteFilePath = fullRemotePath + remoteFileName;
                channelSftp.put(inputStream, remoteFilePath);
                System.out.println("✅ SFTP 파일 업로드 성공: " + remoteFilePath);
                success = true;

                // 🗂️ 파일 정보를 DB에 저장
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

    // ✅ SFTP 파일 다운로드 기능
    public boolean downloadFile(String remoteFileName, String localFilePath) {
        Session session = null;
        ChannelSftp channelSftp = null;
        boolean success = false;

        try {
            JSch jsch = new JSch();
            session = jsch.getSession(SFTP_USER, SFTP_HOST, SFTP_PORT);
            session.setPassword(SFTP_PASSWORD);

            // SSH 보안 설정
            Properties config = new Properties();
            config.put("StrictHostKeyChecking", "no");
            session.setConfig(config);

            // 🚀 SFTP 연결
            try {
                session.connect();
                channelSftp = (ChannelSftp) session.openChannel("sftp");
                channelSftp.connect();
            } catch (JSchException e) {
                System.err.println("❌ SFTP 연결 실패: " + e.getMessage());
                return false;
            }

            // 📥 파일 다운로드 수행
            String remoteFilePath = BASE_DIRECTORY + remoteFileName;
            try (OutputStream outputStream = new FileOutputStream(localFilePath)) {
                channelSftp.get(remoteFilePath, outputStream);
                System.out.println("✅ SFTP 파일 다운로드 성공: " + remoteFilePath + " → " + localFilePath);
                success = true;
            }

        } catch (Exception e) {
            System.err.println("❌ SFTP 다운로드 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            disconnectSftp(session, channelSftp);
        }
        return success;
    }

    // ✅ 디렉토리 자동 생성 기능
    private void createDirectory(ChannelSftp sftp, String fullPath) {
        String[] folders = fullPath.split("/");
        String currentPath = "";

        for (String folder : folders) {
            if (folder == null || folder.trim().isEmpty()) continue;
            currentPath += "/" + folder;

            try {
                sftp.cd(currentPath); // 디렉토리 존재시 이동
            } catch (SftpException e) {
                try {
                    sftp.mkdir(currentPath); // 없으면 생성
                    System.out.println("📁 생성됨: " + currentPath);
                    sftp.cd(currentPath);
                } catch (SftpException ex) {
                    System.err.println("❌ 생성 실패: " + currentPath);
                }
            }
        }
    }

    // ✅ SFTP 연결 종료 처리
    private void disconnectSftp(Session session, ChannelSftp channelSftp) {
        if (channelSftp != null && channelSftp.isConnected()) channelSftp.disconnect();
        if (session != null && session.isConnected()) session.disconnect();
        System.out.println("🔌 SFTP 연결 종료");
    }
    @Transactional
    public boolean deleteFile(String hospCd ,String filePath, String fileSeq, String fileGb,String updUser, String updIp) {
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

            // ✅ SFTP 파일 삭제
            channelSftp.rm(filePath);
            System.out.println("🗑️ SFTP 파일 삭제 완료: " + filePath);

            // ✅ DB 레코드 삭제
            svc.deleteFile(hospCd ,filePath ,fileSeq, fileGb ,updUser , updIp );
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
    
}
