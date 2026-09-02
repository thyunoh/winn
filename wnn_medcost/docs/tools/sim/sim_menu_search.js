const fs=require('fs'); const {JSDOM}=require('jsdom');
const src=fs.readFileSync(require('path').resolve(__dirname, '../../../src/main/webapp/WEB-INF/tiles/main/sidebar.jsp'),'utf8');
const a=src.indexOf('/* ═══ QPS 메뉴 검색'); const b=src.indexOf('</script>', a); if(a<0||b<0) throw new Error('블록 없음');
const block=src.slice(a,b);
const html=`<!doctype html><body><div id="qps-sub" class="collapse submenu show"><ul>
 <li id="qpsMenuQWrap"><input id="qpsMenuQ"><span id="qpsMenuQCnt"></span></li>
 <li id="gQI"><a class="nav-link" href="#" data-target="#qps-g-qi">▸ QI</a><div id="qps-g-qi" class="collapse"><ul>
   <li id="l1"><a class="nav-link" href="/main/qpsQiPlan.do">QI 계획서</a></li>
   <li id="l2"><a class="nav-link" href="/main/qpsFall.do">낙상 지표</a></li></ul></div></li>
 <li id="gChk"><a class="nav-link" href="#" data-target="#qps-g-chk">▸ 점검표</a><div id="qps-g-chk" class="collapse show"><ul>
   <li id="l3"><a class="nav-link" href="/main/qpsChk.do">점검표 작성</a></li>
   <li id="l4" style="display:none;"><a class="nav-link" href="/main/qpsChkForm.do">서식 관리 (위너넷)</a></li></ul></div></li>
 <li id="gDept" style="display:none;"><a class="nav-link" href="#" data-target="#qps-g-dept">▸ 부서별 점검표</a><div id="qps-g-dept" class="collapse"><ul>
   <li id="l5"><a class="nav-link" href="/main/qpsChk.do?dept=NURSE">간호 · 병동 점검표</a></li></ul></div></li>
 <li id="gEtc"><a class="nav-link" href="#" data-target="#qps-g-etc">▸ 공통</a><div id="qps-g-etc" class="collapse"><ul>
   <li id="l6"><a class="nav-link" href="/main/qpsHoliday.do">공휴일 관리</a></li></ul></div></li>
</ul></div></body>`;
const dom=new JSDOM(html,{url:'http://localhost/'}); const {window}=dom, document=window.document;
const loc={href:''};
new Function('window','document','location',block)(window,document,loc);
const $=s=>document.querySelector(s); const vis=id=>$('#'+id).style.display!=='none';
const type=v=>{const i=$('#qpsMenuQ'); i.value=v; i.dispatchEvent(new window.Event('input',{bubbles:true}));};
let pass=0,fail=0; const ok=(n,c)=>{(c?pass++:fail++);console.log((c?'  ✅ ':'  ❌ ')+n);};
type('점검');
ok('「점검」: 점검표 작성만 남고 QI 계획서·낙상 숨김', vis('l3')&&!vis('l1')&&!vis('l2'));
ok('위너넷 전용(원래 숨김) 서식 관리는 안 나옴', !vis('l4'));
ok('부서별(원래 숨김 그룹)은 「점검표」가 들어도 안 나옴', !vis('gDept'));
ok('QI 그룹 숨김 · 점검표 그룹 표시', !vis('gQI')&&vis('gChk'));
ok('건수 1개', $('#qpsMenuQCnt').textContent==='1개');
type('낙 상');
ok('띄어쓰기 무시 「낙 상」 → 낙상 지표 · QI 그룹 자동 펼침', vis('l2')&&!vis('l1')&&vis('gQI')&&$('#qps-g-qi').classList.contains('show')&&!vis('gChk'));
type('없는말'); ok('없으면 「없음」', $('#qpsMenuQCnt').textContent==='없음');
type('공휴'); $('#qpsMenuQ').dispatchEvent(new window.KeyboardEvent('keydown',{key:'Enter',bubbles:true,cancelable:true}));
ok('Enter → 첫 항목(공휴일 관리)으로 이동', loc.href==='/main/qpsHoliday.do');
type('');
ok('지우면 원래대로: 잎 전부 표시 · 위너넷 줄·부서별 그룹은 여전히 숨김', vis('l1')&&vis('l2')&&vis('l3')&&!vis('l4')&&!vis('gDept')&&vis('gQI'));
ok('펼침 상태 복원(QI 접힘 · 점검표 펼침)', !$('#qps-g-qi').classList.contains('show')&&$('#qps-g-chk').classList.contains('show'));
ok('건수 표시 지움', $('#qpsMenuQCnt').textContent==='');
console.log('결과 : 통과 '+pass+' · 실패 '+fail); process.exit(fail?1:0);
