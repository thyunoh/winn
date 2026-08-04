import java.io.*;
import java.nio.charset.StandardCharsets;
import java.sql.*;

/** 운영DB의 TBL_QNA_CAT / TBL_QNA_KB 를 시드 SQL 로 다시 뽑는다.
 *  (DB 에서 지식을 고친 뒤 실행하면 docs/sql/TBL_QNA_seed.sql 이 현재 DB 와 같아진다) */
public class Export {
  static String q(String v) {
    if (v == null) return "NULL";
    return "'" + v.replace("\\", "\\\\").replace("'", "''").replace("\r", "").replace("\n", "\\n") + "'";
  }

  public static void main(String[] a) throws Exception {
    String url = "jdbc:mysql://114.108.153.178:3306/WNN?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
    String dst = "C:/Users/user/git/winn/wnn_medcost/docs/sql/TBL_QNA_seed.sql";
    int cat = 0, kb = 0;

    try (Connection c = DriverManager.getConnection(url, "winner", "winnerdb_20@%");
         Statement s = c.createStatement();
         PrintWriter w = new PrintWriter(new OutputStreamWriter(new FileOutputStream(dst), StandardCharsets.UTF_8))) {

      ResultSet r = s.executeQuery("SELECT COUNT(*) n FROM TBL_QNA_KB WHERE SRC_TYPE='IN'");
      r.next(); int inCnt = r.getInt(1);
      r = s.executeQuery("SELECT COUNT(*) n FROM TBL_QNA_KB WHERE SRC_TYPE='PDF'");
      r.next(); int pdfCnt = r.getInt(1);

      w.println("-- ============================================================");
      w.println("-- 적정성평가 Q&A 지식 시드");
      w.println("--   · 위너넷 확정 지식 " + inCnt + "건");
      w.println("--   · 심평원 「2022 요양병원 수가 실무교육자료」 " + pdfCnt + "건");
      w.println("-- 이 파일은 <운영DB 내용을 그대로 뽑은 것>이다(scratchpad/Export.java).");
      w.println("-- DB 에서 지식을 고쳤으면 다시 뽑아 이 파일을 갱신할 것.");
      w.println("-- 재적재: 아래 DELETE 두 줄로 비우고 다시 실행하면 된다.");
      w.println("--   ※ HIT_CNT(조회수)는 담지 않는다 — 재적재해도 0 부터 다시 쌓인다.");
      w.println("-- ============================================================");
      w.println("DELETE FROM TBL_QNA_KB;");
      w.println("DELETE FROM TBL_QNA_CAT;");
      w.println();

      r = s.executeQuery("SELECT CAT_ID,P_CAT_ID,CAT_NM,CAT_DESC,SRC_TYPE,SORT_NO FROM TBL_QNA_CAT "
                       + "ORDER BY IFNULL(P_CAT_ID,CAT_ID),(P_CAT_ID IS NOT NULL),SORT_NO");
      while (r.next()) {
        w.println("INSERT INTO TBL_QNA_CAT (CAT_ID,P_CAT_ID,CAT_NM,CAT_DESC,SRC_TYPE,SORT_NO) VALUES ("
          + q(r.getString(1)) + "," + q(r.getString(2)) + "," + q(r.getString(3)) + ","
          + q(r.getString(4)) + "," + q(r.getString(5)) + "," + r.getInt(6) + ");");
        cat++;
      }
      w.println();

      r = s.executeQuery("SELECT KB_CODE,CAT_ID,SUB_ID,SRC_TYPE,KIND,TITLE,SHORT_TITLE,KEYWORDS,BODY,"
                       + "GO_JSON,REL_IDS,SRC_NM,DOC_PAGE,WEIGHT,SORT_NO FROM TBL_QNA_KB ORDER BY KB_ID");
      while (r.next()) {
        w.println("INSERT INTO TBL_QNA_KB (KB_CODE,CAT_ID,SUB_ID,SRC_TYPE,KIND,TITLE,SHORT_TITLE,KEYWORDS,BODY,"
          + "GO_JSON,REL_IDS,SRC_NM,DOC_PAGE,WEIGHT,SORT_NO) VALUES ("
          + q(r.getString(1)) + "," + q(r.getString(2)) + "," + q(r.getString(3)) + "," + q(r.getString(4)) + ","
          + q(r.getString(5)) + "," + q(r.getString(6)) + "," + q(r.getString(7)) + "," + q(r.getString(8)) + ","
          + q(r.getString(9)) + "," + q(r.getString(10)) + "," + q(r.getString(11)) + "," + q(r.getString(12)) + ","
          + r.getInt(13) + "," + r.getInt(14) + "," + r.getInt(15) + ");");
        kb++;
      }
    }
    System.out.println("내보냄 — 카테고리 " + cat + " · 지식 " + kb);
  }
}
