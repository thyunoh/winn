# 검색 노출 작업 — 새 공개 페이지 추가 절차

## 현재 구조
- 공개 페이지: `wnn_consult/src/main/webapp/WEB-INF/jsp/login/wnnpage_consult1~5.jsp`
  (주소: `https://winner797.co.kr/wnn_consult/login/wnnpage_consultN.do`)
- 사이트맵: `wnn_consult/src/main/webapp/sitemap.xml` → `https://winner797.co.kr/wnn_consult/sitemap.xml`
- robots.txt: 도메인 최상위라서 **wnn_medcost 쪽**에 둡니다.
  - 소스: `wnn_medcost/src/main/webapp/robots.txt`
  - 서버: `/usr/share/tomcat9/webapps/wnn_medcost-1.0.0/robots.txt`
  - 주의: `ROOT` 폴더는 공개 주소와 무관합니다.
- 로그인 화면(`LoginWinCT.jsp`)은 `noindex, nofollow`로 검색에서 뺍니다. 사이트맵에도 넣지 않습니다.

## 새 공개 페이지를 추가할 때 (순서대로)
1. **페이지 head 작성**: 페이지마다 고유한 `<title>`(「○○ 컨설팅 | 위너넷 컨설팅」), `description`, `robots index,follow`, `canonical`, `og:` 태그, JSON-LD(Service)를 넣습니다. 기존 `wnnpage_consult1.jsp` 머리를 복사해 고치면 됩니다.
2. **사이트맵에 추가**: `sitemap.xml`에 `<url><loc>…</loc><lastmod>오늘 날짜</lastmod></url>`을 넣습니다.
   - 주소가 실제로 200으로 열리는 것만 넣습니다. 404 주소가 들어가면 검색엔진 신뢰가 떨어집니다.
   - 페이지를 빼거나 내릴 때는 사이트맵에서도 지웁니다.
3. **서버 배포**: 바뀐 JSP와 `sitemap.xml`을 `/usr/share/tomcat9/webapps/wnn_consult-1.0.0/`(같은 상대 경로)에 덮어씁니다. 재기동은 필요 없습니다. 자바 코드를 건드렸다면 WAR 재빌드가 필요합니다.
4. **확인**: 새 주소를 열어 `<title>`이 바뀌었는지, `https://winner797.co.kr/wnn_consult/sitemap.xml`에 주소가 보이는지 확인합니다.
5. **커밋**: 변경분은 직접 커밋합니다.

## Search Console
- 사이트맵은 한 번 제출하면 같은 주소를 구글이 주기적으로 다시 읽습니다. 보통 주소가 바뀔 때마다 다시 제출할 필요는 없습니다.
- 급하게 반영하고 싶을 때만 색인 메뉴에서 사이트맵을 다시 제출합니다.

## 역할
- 마케팅: 새 페이지 주소와 제목·설명 문구를 개발팀에 전달합니다.
- 개발: 1~4단계를 처리하고 결과를 알려 줍니다.
- 커밋과 Search Console 제출은 담당자가 직접 합니다.

## 나중에 자동화를 검토할 시점
- 공개 페이지가 10개를 넘거나 자주 바뀌면, 사이트맵을 DB나 목록 기준으로 자동 생성하는 방식으로 바꾸는 것을 검토합니다. 지금은 수동으로 충분합니다.
