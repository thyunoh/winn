<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
  신규병원 — 승인 후 동의서 원본 제출                                    2026-08-19

  승인(30)만으로는 프로그램을 쓸 수 없다. 이 화면에서 서명·날인한 동의서를 올려야
  상태가 40 이 되고, 위너넷이 계약을 넣으면 메뉴가 열린다.

  · 조회는 전부 쿠키의 요양기관기호로만 한다 → 자기 병원 것만 보인다.
  · 파일은 기존 /sftp/fileupload.do 를 그대로 쓴다(계약 폴더 <기호>/1/C).
    계약관리 화면의 파일 목록에 같이 뜨게 하려고 폴더 규칙을 맞춘다.
--%>
<div class="dashboard-wrapper">
<div id="joinDocs">

<style>
  #joinDocs{ padding:16px 18px 40px; font-size:13px; color:#243746; }
  #joinDocs .jd-head{ display:flex; align-items:center; gap:10px; margin-bottom:14px; }
  #joinDocs .jd-head h3{ font-size:19px; font-weight:700; margin:0; color:#1f5a4b; }
  #joinDocs .jd-step{ display:flex; gap:0; margin:0 0 18px; }
  #joinDocs .jd-step div{ flex:1; text-align:center; padding:9px 4px; font-size:12.5px;
      background:#f2f5f7; color:#8a97a2; border:1px solid #e2e8ed; border-right:0; }
  #joinDocs .jd-step div:last-child{ border-right:1px solid #e2e8ed; }
  #joinDocs .jd-step div.on{ background:#1f5a4b; color:#fff; border-color:#1f5a4b; font-weight:600; }
  #joinDocs .jd-step div.done{ background:#e8f1ee; color:#1f5a4b; font-weight:600; }
  #joinDocs .jd-card{ border:1px solid #e2e8ed; border-radius:8px; background:#fff;
      padding:16px 18px; margin-bottom:14px; }
  #joinDocs .jd-card h4{ font-size:14.5px; font-weight:700; margin:0 0 10px; color:#1f5a4b;
      display:flex; align-items:center; gap:6px; }
  #joinDocs .jd-btn.mini{ padding:4px 12px; font-size:12px; }
  #joinDocs td input.jd-in{ width:100%; border:1px solid #b9c8d2; border-radius:4px;
      padding:4px 7px; font-size:12.5px; font-family:inherit; }
  #joinDocs td input.jd-in:focus{ outline:none; border-color:#1f5a4b; }
  #joinDocs table.jd-tb{ width:100%; border-collapse:collapse; }
  #joinDocs table.jd-tb th, #joinDocs table.jd-tb td{ border:1px solid #e2e8ed; padding:7px 10px;
      font-size:12.5px; text-align:left; }
  #joinDocs table.jd-tb th{ background:#f7f9fa; width:130px; font-weight:600; color:#48606f; }
  #joinDocs .jd-drop{ border:2px dashed #b9c8d2; border-radius:8px; padding:26px 14px;
      text-align:center; color:#7b8b97; background:#fbfcfd; cursor:pointer; }
  #joinDocs .jd-drop.on{ border-color:#1f5a4b; background:#f1f7f5; color:#1f5a4b; }
  #joinDocs .jd-file{ margin-top:10px; font-size:12.5px; }
  #joinDocs .jd-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:8px 20px; font-size:13.5px; font-weight:600; cursor:pointer; }
  #joinDocs .jd-btn.ghost{ background:#fff; color:#1f5a4b; }
  #joinDocs .jd-btn[disabled]{ background:#b9c8d2; border-color:#b9c8d2; cursor:not-allowed; }
  #joinDocs .jd-note{ font-size:12px; color:#7b8b97; line-height:1.7; margin-top:8px; }
  #joinDocs .jd-ok{ color:#1f5a4b; font-weight:700; }
  #joinDocs .jd-wait{ color:#c07a2a; font-weight:700; }
  .jd-swal{ font-size:13px !important; }
  .jd-swal .swal2-title{ font-size:15px !important; }
  .jd-swal .swal2-icon{ width:48px !important; height:48px !important; }
  .jd-swal .swal2-styled{ font-size:13px !important; padding:7px 18px !important; }
</style>

<div class="jd-head">
  <h3>신청서 제출</h3>
  <span style="font-size:12.5px; color:#7b8b97;" id="jdSub"></span>
</div>

<div class="jd-step">
  <div class="done">① 가입신청</div>
  <div class="done">② 위너넷 승인</div>
  <div class="on" id="jdStep3">③ 신청서 제출</div>
  <div id="jdStep4">④ 사용시작</div>
</div>

<div class="jd-card">
  <h4>신청 내용
    <button type="button" class="jd-btn ghost mini" id="jdEditBtn" onclick="jdEdit(true);">수정</button>
    <button type="button" class="jd-btn mini"       id="jdSaveBtn" onclick="jdSave();"   style="display:none;">저장</button>
    <button type="button" class="jd-btn ghost mini" id="jdCancelBtn" onclick="jdEdit(false);" style="display:none;">취소</button>
  </h4>
  <table class="jd-tb"><tbody id="jdInfo">
    <tr><td colspan="4" style="text-align:center; color:#8a97a2;">불러오는 중…</td></tr>
  </tbody></table>
</div>

<div class="jd-card">
  <h4>동의 내역</h4>
  <table class="jd-tb"><thead>
    <tr><th style="width:auto;">동의서</th><th style="width:80px;">필수</th><th style="width:90px;">동의</th><th style="width:80px;">버전</th><th style="width:150px;">동의일시</th></tr>
  </thead><tbody id="jdAgree">
    <tr><td colspan="5" style="text-align:center; color:#8a97a2;">불러오는 중…</td></tr>
  </tbody></table>
</div>

<div class="jd-card" id="jdUpBox">
  <h4>신청서 제출</h4>
  <div style="padding:4px 0 2px;">
    <button type="button" class="jd-btn" id="jdMakeBtn" onclick="jdMakePdf();">신청서 PDF 만들기</button>
    <%-- [제거 2026-08-19] 만들면 미리보기 창이 바로 뜨므로 따로 둘 필요가 없다.
         jdPrint() 는 남겨둔다 — 필요하면 버튼만 되살리면 된다. --%>
  </div>
  <div class="jd-file" id="jdFileList"></div>
  <div style="margin-top:14px; text-align:right;">
    <button type="button" class="jd-btn" id="jdSubmit" onclick="jdSubmit();" disabled>제출</button>
  </div>
  <div class="jd-note">
    신청내용·동의내역과 <b>신규가입 때 등록하신 대표자 도장</b>이 그대로 들어간 PDF 가 만들어집니다.
    따로 인쇄해 서명·날인하실 필요 없습니다.<br>
    제출하시면 <b>바로 프로그램을 사용하실 수 있습니다.</b>
  </div>
</div>

<%-- PDF 생성용 : 화면 밖에 문서를 그려두고 html2canvas 로 캡처한다.
     display:none 이면 캡처가 빈 화면이 되므로 화면 밖으로 밀어낸다. --%>

<%-- 만든 PDF 미리보기 — 확인하고 그 자리에서 제출한다 --%>
<div id="jdPv" style="display:none; position:fixed; inset:0; z-index:1800;
     background:rgba(20,30,36,.55); align-items:center; justify-content:center;">
  <div style="background:#fff; border-radius:10px; width:min(880px,94vw); height:88vh;
       display:flex; flex-direction:column; overflow:hidden; box-shadow:0 10px 40px rgba(0,0,0,.3);">
    <div style="display:flex; align-items:center; gap:10px; padding:11px 16px;
         border-bottom:1px solid #e2e8ed;">
      <b style="font-size:14.5px; color:#1f5a4b;">신청서 미리보기</b>
      <span id="jdPvNm" style="font-size:12px; color:#7b8b97;"></span>
      <span style="flex:1;"></span>
      <button type="button" class="jd-btn" onclick="jdPvSubmit();">제출</button>
      <button type="button" class="jd-btn ghost" onclick="jdPvClose();">닫기</button>
    </div>
    <iframe id="jdPvFrame" style="flex:1; width:100%; border:0; background:#525659;"></iframe>
  </div>
</div>
<%-- PDF 생성용 : A4 실제 폭(210mm)으로 그려야 인쇄와 같은 줄바꿈이 된다.
     좁게 잡으면 글자가 두 줄로 접힌다(2026-08-19). --%>
<div id="jdDocBox" style="position:fixed; left:-9999px; top:0; width:210mm; background:#fff;"></div>
<iframe id="jdPrintFrame" style="position:fixed; right:0; bottom:0; width:0; height:0; border:0;"></iframe>

<script type="text/javascript">
(function(){
  var PICKED = [];      /* 고른 파일 */
  var HOSP   = '<c:out value="${hospCd}"/>';
  var REQNO  = null;
  var INFO   = null;      /* 인쇄용 — 마지막으로 불러온 신청내용 */
  var AGREE  = [];
  var MGRS   = [];
  var PDF_BLOB = null, PDF_NAME = '';   /* 방금 만든 신청서 PDF */

  function gel(id){ return document.getElementById(id); }
  function esc(s){ return String(s == null ? '' : s)
      .replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
  function nv(s){ return (s == null || s === '') ? '<span style="color:#b9c8d2;">-</span>' : esc(s); }

  function box(msg, icon){
    if (window.Swal) Swal.fire({ icon: icon || undefined, title:String(msg), width:380,
        customClass:{ popup:'jd-swal' }, confirmButtonText:'확인', confirmButtonColor:'#1f5a4b' });
    else alert(msg);
  }

  /* ── 내 병원 승인건 ─────────────────────────────────────────────── */
  function jdInfo(){
    $.ajax({
      type:'post', url:'/join/joinDocsInfo.do', dataType:'json',
      success:function(d){
        if (d.error_code !== '0'){ box(d.error_msg || '조회하지 못했습니다.'); return; }
        var i = d.info;
        if (!i){
          gel('jdInfo').innerHTML =
            '<tr><td colspan="4" style="text-align:center; color:#8a97a2; padding:22px;">'
          + '승인된 가입신청이 없습니다. 위너넷 승인 후에 이용하실 수 있습니다.</td></tr>';
          gel('jdUpBox').style.display = 'none';
          gel('jdEditBtn').style.display = 'none';
          return;
        }
        REQNO = i.reqNo; INFO = i;
        gel('jdSub').innerHTML = esc(i.hospNm || '') + ' (' + esc(i.hospCd || '') + ')';

        var submitted = (i.docYn === 'Y');


        /* 동의내역 — 최초 로그인 때 "무엇에 동의했는지" 를 보여준다 */
        AGREE = d.agreeList || []; MGRS = d.mgrList || [];
        jdPaint(false);   /* 담당자·동의내역을 받은 뒤에 그린다 */
        gel('jdAgree').innerHTML = AGREE.length
          ? AGREE.map(function(a){
              return '<tr><td>' + nv(a.agreeNmTxt || a.agreeCd) + '</td>'
                   + '<td>' + (a.essYn === 'Y' ? '필수' : '선택') + '</td>'
                   + '<td>' + (a.agreeYn === 'Y'
                        ? '<b style="color:#1f5a4b;">동의</b>'
                        : '<b style="color:#d9534f;">미동의</b>') + '</td>'
                   + '<td>' + nv(a.verNo) + '</td><td>' + nv(a.agreeDttm) + '</td></tr>';
            }).join('')
          : '<tr><td colspan="5" style="text-align:center; color:#8a97a2;">동의내역이 없습니다.</td></tr>';
        if (submitted){
          gel('jdStep3').className = 'done';
          gel('jdStep4').className = 'on';
          gel('jdUpBox').innerHTML =
              '<h4>제출 완료</h4>'
            + '<div style="padding:14px 4px; line-height:1.9;">'
            + '신청서가 접수되었습니다. <b>이제 프로그램을 사용하실 수 있습니다.</b><br>'
            + '<span style="font-size:12px; color:#7b8b97;">'
            + '제출일시 ' + esc(i.docDttm || '') + ' · 파일 ' + esc(i.docFileNm || '') + '</span></div>';
        }
      },
      error:function(){ box('조회하지 못했습니다.'); }
    });
  }

  /* ── 신청 내용 그리기 : 보기 / 수정 두 모드 ────────────────────────
     고칠 수 있는 것은 문서에 찍히는 병원정보 7가지뿐이다.
     요양기관기호(키)·이메일(로그인 ID)·비밀번호는 승인으로 만들어진 병원·계정과
     묶여 있어 손대면 어긋난다. */
  var EDIT = false;

  function ip(id, val, ph){
    return '<input type="text" class="jd-in" id="jd_' + id + '" value="'
         + esc(val == null ? '' : val) + '"' + (ph ? ' placeholder="' + ph + '"' : '') + '>';
  }

  /* 대표자 도장 — 신규가입 때 올린 이미지를 그대로 쓴다 */
  /* 담당자 요약 — 도장 옆 칸. 접수담당자(신청자)를 맨 위에 함께 보여준다 */
  function jdMgrText(){
    var i = INFO, out = [];

    if (i && (i.mbrNm || i.email)){
      var a = [];
      if (i.jobNm)  a.push(esc(i.jobNm));
      if (i.mbrTel) a.push(esc(i.mbrTel));
      if (i.email)  a.push(esc(i.email));
      out.push('<div style="padding:2px 0;"><b>접수담당자</b> ' + esc(i.mbrNm || '')
             + (a.length ? ' <span style="color:#7b8b97;">· ' + a.join(' · ') + '</span>' : '')
             + '</div>');
    }

    for (var n = 0; n < MGRS.length; n++){
      var m = MGRS[n], t = [];
      if (m.deptNm) t.push(esc(m.deptNm));
      if (m.jobNm)  t.push(esc(m.jobNm));
      if (m.mgrTel) t.push(esc(m.mgrTel));
      if (m.email || m.mgrEmail) t.push(esc(m.email || m.mgrEmail));
      out.push('<div style="padding:2px 0;"><b>' + esc(m.mgrGbNm || m.mgrGb || '') + '</b> '
             + esc(m.mgrNm || '') + (t.length ? ' <span style="color:#7b8b97;">· '
             + t.join(' · ') + '</span>' : '') + '</div>');
    }

    return out.length ? out.join('') : '<span style="color:#b9c8d2;">없음</span>';
  }

  function jdSealTag(px){
    var i = INFO;
    if (!i || !i.sealImg) return '<span style="color:#b9c8d2;">없음</span>';
    return '<img src="data:' + (i.sealMime || 'image/png') + ';base64,' + i.sealImg
         + '" style="width:' + px + 'px; height:auto;">';
  }

  window.jdPaint = function(edit){
    if (typeof edit === 'boolean') EDIT = edit;
    var i = INFO; if (!i) return;
    var submitted = (i.docYn === 'Y');
    var v = function(id, val){ return EDIT ? ip(id, val) : nv(val); };

    gel('jdInfo').innerHTML =
        '<tr><th>병원명</th><td>' + v('hospNm', i.hospNm) + '</td>'
      + '<th>요양기관기호</th><td>' + nv(i.hospCd) + '</td></tr>'
      + '<tr><th>대표자</th><td>' + v('hospCeo', i.hospCeo) + '</td>'
      + '<th>사업자등록번호</th><td>' + v('busiNum', i.busiNum) + '</td></tr>'
      + '<tr><th>전화번호</th><td>' + v('hospTel', i.hospTel) + '</td>'
      + '<th>FAX</th><td>' + v('hospFax', i.hospFax) + '</td></tr>'
      + '<tr><th>우편번호</th><td>' + v('zipCd', i.zipCd) + '</td>'
      + '<th>병상수</th><td>' + v('wardcnt', i.wardcnt) + '</td></tr>'
      + '<tr><th>주소</th><td colspan="3">' + v('hospAddr', i.hospAddr) + '</td></tr>'
      + '<tr><th>상세주소</th><td colspan="3">' + v('hospExtradr', i.hospExtradr) + '</td></tr>'
      + '<tr><th>신청일시</th><td>' + nv(i.reqDttm) + '</td>'
      + '<th>승인일시</th><td>' + nv(i.cfmDttm) + '</td></tr>'
      + '<tr><th>심평원 인증서암호</th><td colspan="3">' + nv(i.hiraCertPw) + '</td></tr>'
      + '<tr><th>대표자 도장</th><td>' + jdSealTag(120) + '</td>'
      + '<th>담당자</th><td>' + jdMgrText() + '</td></tr>'
      + '<tr><th>동의서</th><td colspan="3">'
      + (submitted
          ? '<span class="jd-ok">제출완료</span> · ' + nv(i.docDttm)
            + ' <span style="font-size:12px; color:#7b8b97;">' + nv(i.docFileNm) + '</span>'
          : '<span class="jd-wait">미제출</span>')
      + '</td></tr>';

    gel('jdEditBtn').style.display   = EDIT ? 'none' : '';
    gel('jdSaveBtn').style.display   = EDIT ? '' : 'none';
    gel('jdCancelBtn').style.display = EDIT ? '' : 'none';
  };

  /* 수정 시작 / 취소 */
  window.jdEdit = function(on){ jdPaint(!!on); };

  /* 저장 — 고친 뒤에는 PDF 를 다시 만들어 올려야 내용이 맞는다 */
  window.jdSave = function(){
    if (!INFO) return;
    var g = function(id){ var e = gel('jd_' + id); return e ? e.value.trim() : ''; };

    if (g('hospNm')  === ''){ box('병원명을 입력하세요.', 'warning'); return; }
    if (g('hospCeo') === ''){ box('대표자를 입력하세요.', 'warning'); return; }

    var data = {
      hospNm:g('hospNm'), hospCeo:g('hospCeo'), busiNum:g('busiNum'),
      hospTel:g('hospTel'), hospFax:g('hospFax'), zipCd:g('zipCd'),
      hospAddr:g('hospAddr'), hospExtradr:g('hospExtradr'), wardcnt:g('wardcnt')
    };

    gel('jdSaveBtn').disabled = true;
    $.ajax({
      type:'post', url:'/join/joinDocsSave.do', dataType:'json', data:data,
      success:function(d){
        gel('jdSaveBtn').disabled = false;
        if (d.error_code !== '0'){ box(d.error_msg || '수정하지 못했습니다.'); return; }
        EDIT = false;
        jdInfo();
        if (window.Swal){
          Swal.fire({ icon:'success', title:'수정했습니다', width:420,
            html:'<div style="font-size:13px; line-height:1.7;">'
               + '바뀐 내용으로 <b>신청서 PDF 를 다시 만들어</b> 올려 주세요.</div>',
            customClass:{ popup:'jd-swal' }, confirmButtonText:'확인', confirmButtonColor:'#1f5a4b' });
        }
      },
      error:function(){ gel('jdSaveBtn').disabled = false; box('수정하지 못했습니다.'); }
    });
  };

  /* ── 파일 고르기 ────────────────────────────────────────────────── */
  /* 올릴 것 목록 — 만든 PDF 가 있으면 그것이 먼저다 */
  function render(){
    var list = [];
    if (PDF_BLOB) list.push({ name: PDF_NAME, size: PDF_BLOB.size, made: true });
    for (var k = 0; k < PICKED.length; k++) list.push({ name: PICKED[k].name, size: PICKED[k].size });

    if (!list.length){ gel('jdFileList').innerHTML = ''; gel('jdSubmit').disabled = true; return; }
    gel('jdFileList').innerHTML = list.map(function(f, n){
      return '<div style="padding:4px 0;">· ' + esc(f.name)
           + ' <span style="color:#7b8b97;">(' + Math.round(f.size/1024) + 'KB)</span>'
           + (f.made ? ' <span class="jd-ok" style="font-size:12px;">방금 만듦</span>' : '')
           + ' <a href="javascript:void(0);" onclick="jdDel(' + (f.made ? -1 : n - (PDF_BLOB ? 1 : 0)) + ');"'
           + ' style="color:#b23b3b; margin-left:6px;">삭제</a></div>';
    }).join('');
    gel('jdSubmit').disabled = false;
  }
  window.jdDel = function(n){
    if (n < 0){ PDF_BLOB = null; PDF_NAME = ''; } else PICKED.splice(n, 1);
    render();
  };

  function add(list){
    for (var n = 0; n < list.length; n++){
      var f = list[n];
      if (f.size > 20 * 1024 * 1024){ box(esc(f.name) + ' 은 20MB 를 넘습니다.', 'warning'); continue; }
      PICKED.push(f);
    }
    render();
  }

  /* 끌어놓기 자리는 없앴다(PDF 를 화면에서 만들므로).
     따로 만든 파일을 올리고 싶을 때를 대비해, 요소가 있을 때만 연결한다. */
  if (gel('jdDrop')){
    gel('jdDrop').onclick = function(){ gel('jdFile').click(); };
    gel('jdFile').onchange = function(){ add(this.files); this.value = ''; };
    gel('jdDrop').ondragover  = function(e){ e.preventDefault(); this.classList.add('on'); };
    gel('jdDrop').ondragleave = function(){ this.classList.remove('on'); };
    gel('jdDrop').ondrop = function(e){
      e.preventDefault(); this.classList.remove('on');
      if (e.dataTransfer && e.dataTransfer.files) add(e.dataTransfer.files);
    };
  }

  /* ── 제출 : 파일이 올라간 뒤에만 상태를 바꾼다.
        순서를 바꾸면 "제출됨인데 파일이 없는" 상태가 남는다. ─────────── */
  window.jdSubmit = function(){
    if ((!PICKED.length && !PDF_BLOB) || !REQNO) return;

    var go = function(){
      var fd = new FormData();
      if (PDF_BLOB) fd.append('file', PDF_BLOB, PDF_NAME);
      for (var n = 0; n < PICKED.length; n++) fd.append('file', PICKED[n]);
      fd.append('hospCd',  HOSP);
      fd.append('fileGb',  'C');      /* 계약 폴더 — 계약관리 목록에 같이 뜬다 */
      fd.append('notiSeq', '1');
      fd.append('regUser', '');
      fd.append('regIp',   '');

      gel('jdSubmit').disabled = true;
      gel('jdSubmit').innerHTML = '올리는 중…';

      $.ajax({
        type:'post', url:'/sftp/fileupload.do', data:fd,
        processData:false, contentType:false,
        success:function(){
          var nm = (PDF_BLOB ? [PDF_NAME] : []).concat(PICKED.map(function(f){ return f.name; })).join(', ');
          $.ajax({
            type:'post', url:'/join/joinDocsSubmit.do', dataType:'json', data:{ docFileNm: nm },
            success:function(d){
              gel('jdSubmit').innerHTML = '제출';
              if (d.error_code !== '0'){
                gel('jdSubmit').disabled = false;
                box(d.error_msg || '제출하지 못했습니다.');
                return;
              }
              if (window.Swal){
                Swal.fire({ icon:'success', title:'제출했습니다', width:400,
                  html:'<div style="font-size:13px; line-height:1.7;">'
                     + '이제 <b>프로그램을 사용하실 수 있습니다.</b></div>',
                  customClass:{ popup:'jd-swal' }, confirmButtonText:'확인', confirmButtonColor:'#1f5a4b'
                /* 제출이 끝나면 화면을 다시 연다.
                   사이드바 잠금은 페이지가 뜰 때 한 번 판정하므로, 이 자리에서 다시
                   불러오지 않으면 "제출했는데 메뉴가 그대로"가 된다(2026-08-19). */
                }).then(function(){ location.href = '/user/dashboard.do'; });
              } else { location.href = '/user/dashboard.do'; }
            },
            error:function(){
              gel('jdSubmit').disabled = false; gel('jdSubmit').innerHTML = '제출';
              box('제출하지 못했습니다.');
            }
          });
        },
        error:function(){
          gel('jdSubmit').disabled = false; gel('jdSubmit').innerHTML = '제출';
          box('파일을 올리지 못했습니다. 잠시 후 다시 시도해 주세요.');
        }
      });
    };

    if (window.Swal){
      Swal.fire({ icon:'question', title:'신청서 제출',
        html:'<div style="font-size:13px; line-height:1.7;">제출하면 바로 프로그램을 사용하실 수 있습니다.</div>',
        width:400, customClass:{ popup:'jd-swal' },
        showCancelButton:true, confirmButtonText:'제출', cancelButtonText:'취소',
        confirmButtonColor:'#1f5a4b'
      }).then(function(r){ if (r.isConfirmed) go(); });
    } else if (confirm('제출하시겠습니까?')) go();
  };

  /* ── 신청서 만들기 : 서식 3장을 그대로 낸다 ─────────────────────────
     신규가입 화면의 텝 3개(① 컨설팅 의뢰서 ② 원격접속·DB접근 동의서
     ③ 개인정보 수집·이용 동의서)와 같은 구성으로, 한 장씩 나눠 인쇄한다.
     동의서 본문은 TBL_AGREE_MST 의 원문을 그대로 쓴다 — 화면과 문서가
     다른 글을 쓰면 서명받은 문서의 근거가 흔들린다.

     window.open 은 팝업차단에 막혀 숨긴 iframe 으로 띄우고,
     @page margin:0 으로 브라우저가 넣는 날짜·주소 머리말/꼬리말을 없앤다. */
  function jdBuildDoc(){
    if (!INFO){ box('신청내용을 먼저 불러와 주세요.'); return null; }
    var i = INFO;

    var row = function(l1, v1, l2, v2){
      return '<tr><th>' + l1 + '</th><td>' + nv(v1) + '</td>'
           + '<th>' + l2 + '</th><td>' + nv(v2) + '</td></tr>';
    };
    var wide = function(l, v){
      return '<tr><th>' + l + '</th><td colspan="3">' + nv(v) + '</td></tr>';
    };

    var addr = (i.zipCd ? '(' + esc(i.zipCd) + ') ' : '')
             + esc(i.hospAddr || '') + ' ' + esc(i.hospExtradr || '');

    var pcTxt = i.pcUseGb === '1' ? '단독사용 가능'
              : i.pcUseGb === '2' ? '단독사용 불가' + (i.pcUseTime ? ' (' + esc(i.pcUseTime) + ')' : '')
              : i.pcUseGb === '3' ? '사용시작일 지정' + (i.pcUseStdt ? ' (' + esc(i.pcUseStdt) + ')' : '')
              : '';
    var svcTxt = i.conactGb === '1' ? '진료비 분석'
               : i.conactGb === '2' ? '적정성 평가'
               : i.conactGb === 'A' ? '진료비 분석 · 적정성 평가' : '';

    var mgr = MGRS.length
      ? MGRS.map(function(m){
          return '<tr><td>' + nv(m.mgrGbNm || m.mgrGb) + '</td><td>' + nv(m.deptNm) + '</td>'
               + '<td>' + nv(m.jobNm) + '</td><td>' + nv(m.mgrNm) + '</td>'
               + '<td>' + nv(m.mgrTel) + '</td><td>' + nv(m.mgrEmail || m.email) + '</td></tr>';
        }).join('')
      : '<tr><td colspan="6">담당자 없음</td></tr>';

    var seal = i.sealImg
      ? '<img class="seal" src="data:' + (i.sealMime || 'image/png') + ';base64,' + i.sealImg + '">'
      : '<span class="noseal">(서명 또는 인)</span>';

    var today = (i.cfmDttm || i.reqDttm || '').substring(0, 10);

    /* 서명란 — 의뢰서 서식 그대로.
       문구 / 날짜(년·월·일) / 왼쪽 두 줄(요양기관명·주소) + 오른쪽 대표자(인) 세로병합 /
       「위너넷 귀하」. 신규가입 화면(join_apply.jsp)의 .ja-sign 과 같은 배치다. */
    var ymd = String(today || '').split('-');
    var signBlock = function(txt){
      return '<div class="sg-txt">' + esc(txt) + '</div>'
           + '<div class="sg-date">' + nv(ymd[0]) + '년 &nbsp;&nbsp;' + nv(ymd[1])
           + '월 &nbsp;&nbsp;' + nv(ymd[2]) + '일</div>'
           + '<table class="ja-sheet sg-box">'
           + '<colgroup><col style="width:110px;"><col>'
           + '<col style="width:90px;"><col style="width:26%;"></colgroup>'
           + '<tr>'
           + '<th>요양기관명</th><td>' + nv(i.hospNm) + '</td>'
           + '<th rowspan="2">대표자</th>'
           + '<td rowspan="2" class="sg-ceo">' + nv(i.hospCeo)
           + '<span class="sg-sealbox">' + seal + '</span></td>'
           + '</tr>'
           + '<tr><th>주&nbsp;&nbsp;&nbsp;&nbsp;소</th><td>' + addr + '</td></tr>'
           + '</table>'
           + '<div class="sg-to">위너넷 &nbsp;귀하</div>';
    };

    /* ② ③ 동의서 — 본문 + 동의여부 + 서명 */
    var agreePage = function(a, no){
      var body = a.contents
        ? '<div class="body">' + esc(a.contents) + '</div>'
        : '<div class="body empty">본문이 등록되어 있지 않습니다.</div>';
      return '<div class="page">'
           + '<h1>' + esc(a.agreeNmTxt || a.agreeCd) + '</h1>'
           + '<div class="sub">' + (a.essYn === 'Y' ? '필수 동의' : '선택 동의')
           + ' · 버전 ' + esc(a.verNo == null ? '1' : a.verNo) + '</div>'
           + body
           + '<table class="ja-sheet agr"><tr>'
           + '<th style="width:120px;">동의 여부</th>'
           + '<td>' + (a.agreeYn === 'Y' ? '<b>동의합니다</b>' : '동의하지 않습니다')
           + '</td>'
           + '<th style="width:100px;">동의일시</th><td>' + nv(a.agreeDttm) + '</td>'
           + '</tr></table>'
           + ''
           + signBlock('위와 같이 ' + (a.agreeNmTxt || '') + ' 내용에 동의합니다.')
           + '</div>';
    };

    var pages = '';

    /* ── 1장 : 컨설팅 의뢰서 — 신규가입 화면의 .ja-sheet 서식 그대로 ──
       라벨칸(th) + 값칸(td) 3쌍, 필수는 라벨에 빨간 * 와 노란 바탕.
       화면에서 입력하던 자리에 값이 들어간 모양이라 서식과 나란히 놓아도 같다. */
    var q = function(v){ return (v == null || v === '') ? '' : esc(v); };
    var TH  = function(l, rq){ return '<th>' + l + (rq ? ' <span class="rq">*</span>' : '') + '</th>'; };
    var TD  = function(v, rq, span){
      return '<td' + (span ? ' colspan="' + span + '"' : '') + (rq ? ' class="must"' : '') + '>'
           + q(v) + '</td>';
    };
    var cell = function(l, v, rq){ return TH(l, rq) + TD(v, rq); };

    pages +=
        '<div class="page">'
      + '<h1>위너넷 적정성 컨설팅 의뢰서</h1>'
      + '<div class="sub">신규병원 가입신청서</div>'

      + '<table class="ja-sheet"><colgroup>'
      + '<col style="width:132px;"><col><col style="width:118px;"><col>'
      + '<col style="width:100px;"><col></colgroup><tbody>'

      + '<tr>' + cell('병원명', i.hospNm, 1)
              + cell('요양기관기호', i.hospCd, 1)
              + cell('전화번호', i.hospTel, 1) + '</tr>'

      + '<tr>' + TH('주소', 1) + TD(addr, 1, 5) + '</tr>'

      + '<tr>' + cell('대표자', i.hospCeo, 1)
              + cell('사업자등록번호', i.busiNum)
              + cell('FAX', i.hospFax) + '</tr>'

      + '<tr>' + cell('병상수', i.wardcnt)
              + TH('희망 서비스') + TD(svcTxt, 0, 3) + '</tr>'

      + '<tr><th class="grp" colspan="6">전산프로그램 정보 (MASTER)</th></tr>'
      + '<tr>' + cell('프로그램명', i.ocsCompany, 1)
              + cell('프로그램 ID', i.ocsUserId)
              + cell('PC 사용여부', pcTxt) + '</tr>'
      + '<tr>' + TH('심평원 인증서암호', 1) + TD(i.hiraCertPw, 1, 5) + '</tr>'

      + '<tr><th class="grp" colspan="6">평가 일정</th></tr>'
      + '<tr>' + cell('환자평가표 작성완료일', i.asqDay ? '매월 ' + i.asqDay + '일' : '', 1)
              + cell('적정성평가 목표', i.evalGoal, 1)
              + cell('작성 비고', i.asqBigo) + '</tr>'


      + '</tbody></table>'

      + '<h2>담당자</h2>'
      + '<table class="ja-sheet"><tbody>'
      + '<tr><th style="width:90px;">구분</th><th style="width:100px;">부서</th>'
      + '<th style="width:90px;">직책</th><th style="width:90px;">성명</th>'
      + '<th style="width:115px;">전화번호</th><th>이메일 주소</th></tr>' + mgr
      + '</tbody></table>'


      /* 접수담당자 — 담당자 표 아래, 비고 위(2026-08-19 요청) */
      + '<h2>접수담당자 (신청자)</h2>'
      + '<table class="ja-sheet"><colgroup>'
      + '<col style="width:132px;"><col><col style="width:118px;"><col></colgroup><tbody>'
      + '<tr>' + cell('성명', i.mbrNm, 1) + cell('직책', i.jobNm) + '</tr>'
      + '<tr>' + cell('연락처', i.mbrTel, 1) + cell('접수일시', i.reqDttm) + '</tr>'
      + '<tr>' + TH('이메일 (로그인 ID)', 1) + TD(i.email, 1, 3) + '</tr>'
      + '</tbody></table>'
      + '<h2>비고</h2>'
      + '<div class="memo">' + q(i.bigo) + '</div>'
      + '</div>';

    /* ── 2·3장 : 동의서 ───────────────────────────────────────── */

    for (var n = 0; n < AGREE.length; n++) pages += agreePage(AGREE[n], n + 2);
    var html =
        '<html><head><meta charset="utf-8"><title>가입신청서</title><style>'
      + '@page{ size:A4; margin:0; }'
      + 'body{ font-family:"맑은 고딕","Malgun Gothic",sans-serif; font-size:12px; color:#000;'
      + '      margin:0; background:#fff; }'
      + '.page{ padding:15mm 14mm; page-break-after:always; break-after:page; }'
      + '.page:last-child{ page-break-after:auto; break-after:auto; }'
      + 'h1{ font-size:19px; text-align:center; margin:0 0 4px; letter-spacing:3px; }'
      + '.sub{ text-align:center; font-size:11px; color:#555; margin-bottom:12px; }'
      + 'h2{ font-size:12.5px; margin:13px 0 5px; }'
      + 'table{ width:100%; border-collapse:collapse; }'
      + 'th,td{ border:1px solid #000; padding:5px 7px; font-size:11px; text-align:center;'
      + '       word-break:break-all; }'
      + 'th{ background:#f2f2f2; }'
      + 'table.ja-sheet{ table-layout:fixed; margin-bottom:4px; }'
      + 'table.ja-sheet th{ background:#eef2f5; text-align:left; font-weight:700;'
      + ' color:#3a4a53; padding:5px 8px; white-space:normal; line-height:1.35; }'
      + 'table.ja-sheet th.grp{ background:#dde5ea; text-align:center; }'
      + 'table.ja-sheet td{ text-align:left; padding:5px 7px; height:22px; }'
      + 'table.ja-sheet td.must{ background:#fff6c9; }'
      + '.rq{ color:#d9534f; font-weight:900; }'
      + '.body{ border:1px solid #000; padding:9px 11px; font-size:10.5px; line-height:1.75;'
      + '       white-space:pre-wrap; height:150mm; overflow:hidden; }'
      + '.body.empty{ color:#777; height:auto; }'
      + 'table.agr{ margin-top:10px; }'
      + 'table.agr td{ text-align:left; }'
      + '.note{ margin-top:12px; font-size:11px; line-height:1.9; }'
      + '.memo{ border:1px solid #000; padding:9px 11px; font-size:11px; line-height:1.8;'
      + ' min-height:26mm; white-space:pre-wrap; }'
      + '.sg-txt{ margin-top:16px; font-weight:700; }'
      + '.sg-date{ margin:8px 0 9px; letter-spacing:1px; }'
      + 'table.sg-box td{ text-align:left; height:34px; }'
      + 'td.sg-ceo{ height:64px; vertical-align:middle; position:relative; }'
      + '.sg-sealbox{ float:right; margin-right:6px; }'
      + '.sg-to{ margin-top:10px; font-weight:700; }'
      + '.seal{ width:80px; height:auto; vertical-align:middle; }'
      + '.noseal{ color:#555; }'
      + '</style></head><body>' + pages + '</body></html>';

    return { html: html, pages: pages };
  }

  /* ── 미리보기 · 인쇄 : 숨긴 iframe 으로 띄운다 ──────────────────────
     window.open 은 팝업차단에 막힌다. @page margin:0 으로 브라우저가 넣는
     날짜·주소 머리말/꼬리말을 없앤다. */
  window.jdPrint = function(){
    var d = jdBuildDoc(); if (!d) return;
    var fr = gel('jdPrintFrame');
    var doc = fr.contentWindow.document;
    doc.open(); doc.write(d.html); doc.close();
    setTimeout(function(){ fr.contentWindow.focus(); fr.contentWindow.print(); }, 400);
  };

  /* ── 신청서 PDF 만들기 ──────────────────────────────────────────
     월간보고서와 같은 방식이다 — 화면 밖에 문서를 그려 html2canvas 로 장마다
     캡처하고 jsPDF 로 A4 에 얹는다. 서버에 만들 필요도, 인쇄해서 스캔할 필요도 없다.
     도장은 신규가입 때 등록한 이미지가 문서에 이미 들어가 있다. */
  /* ── 만든 PDF 미리보기 ─────────────────────────────────────────
     월간보고서와 같은 흐름이다 — 만들고 눈으로 확인한 뒤 그 자리에서 올린다.
     blob URL 은 닫을 때 반드시 해제한다(안 하면 메모리에 남는다). */
  var PV_URL = null;

  function jdPvOpen(){
    if (!PDF_BLOB) return;
    if (PV_URL) URL.revokeObjectURL(PV_URL);
    PV_URL = URL.createObjectURL(PDF_BLOB);
    gel('jdPvNm').innerHTML = esc(PDF_NAME) + ' · ' + Math.round(PDF_BLOB.size/1024) + 'KB';
    gel('jdPvFrame').src = PV_URL;
    gel('jdPv').style.display = 'flex';
  }

  window.jdPvClose = function(){
    gel('jdPv').style.display = 'none';
    gel('jdPvFrame').src = 'about:blank';
    if (PV_URL){ URL.revokeObjectURL(PV_URL); PV_URL = null; }
  };

  window.jdPvSubmit = function(){ jdPvClose(); jdSubmit(); };

  window.jdMakePdf = function(){
    var d = jdBuildDoc(); if (!d) return;

    if (!window.jspdf || typeof html2canvas === 'undefined'){
      box('PDF 생성 라이브러리를 불러오지 못했습니다.', 'error'); return;
    }

    var btn = gel('jdMakeBtn');
    btn.disabled = true; btn.innerHTML = '만드는 중…';

    var box0 = gel('jdDocBox');
    box0.innerHTML =
        '<style>' + d.html.replace(/^[\s\S]*<style>/, '').replace(/<\/style>[\s\S]*$/, '') + '</style>'
      + d.pages;

    var sheets = box0.querySelectorAll('.page');
    var jsPDF = window.jspdf.jsPDF, pdf = new jsPDF('p', 'mm', 'a4');
    var W = 210, H = 297, n = 0;

    var next = function(){
      if (n >= sheets.length){
        try {
          PDF_BLOB = pdf.output('blob');
          PDF_NAME = '가입신청서_' + (INFO.hospCd || '') + '_' + (INFO.reqNo || '') + '.pdf';
          PICKED = [];                       // 직접 고른 파일보다 방금 만든 것이 우선이다
          render();
          jdPvOpen();
        } catch (e) {
          box('PDF 를 만들지 못했습니다.', 'error');
        }
        box0.innerHTML = '';
        btn.disabled = false; btn.innerHTML = '신청서 PDF 만들기';
        return;
      }

      html2canvas(sheets[n], { scale: 2, backgroundColor: '#ffffff', useCORS: true,
                               width: sheets[n].offsetWidth, windowWidth: sheets[n].offsetWidth })
        .then(function(cv){
          var img = cv.toDataURL('image/jpeg', 0.92);
          var h = cv.height * W / cv.width;
          if (n > 0) pdf.addPage();
          pdf.addImage(img, 'JPEG', 0, 0, W, Math.min(h, H));
          n++; next();
        })
        .catch(function(){
          box0.innerHTML = '';
          btn.disabled = false; btn.innerHTML = '신청서 PDF 만들기';
          box('PDF 를 만들지 못했습니다.', 'error');
        });
    };
    next();
  };

  jdInfo();
})();
</script>

</div>
</div>
