<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%-- hospEmail.jsp — 이메일정보 (적정성평가 월간보고서 메일 수신자) 관리 화면. 2026-07-30 신규.
     · 왜 만들었나 : 원래 이 기능은 [적정성평가 월간보고서] 목록의 '📥 메일주소 일괄등록' 모달이었다.
       목록 화면에 얹혀 있어 찾기 어렵고, 관리 대상(병원별 수신자)은 계약정보와 같은 '기준정보' 성격이라
       사이드바 [병원정보 관리] > [이메일정보] 로 옮겼다(계약관리 바로 아래).
     · 노출 : 계약관리와 완전히 같은 조건 — 사이드바 hospcont(병원정보 관리) 가 위너넷 외 계정에는
       hosp_conact() 로 통째로 숨겨진다. 여기서는 주소로 직접 들어온 경우까지 막으려고 화면에서도 한 번 더 본다.
     · 화면 양식 : 계약정보(mangr/hospcd.jsp) 와 같은 부트스트랩 카드 + [btn-outline-dark] 툴바 스타일.
     · 서버 : 새로 만든 것 없음 — 기존 엔드포인트를 그대로 쓴다(자바 재빌드 불필요).
         · /main/select_HospitalMst.do : 병원목록(기관기호→병원명 자동표시·검색)
         · /main/evalMailAddrBulk.do   : 담은 목록 일괄등록(같은 병원+같은 주소는 이름만 갱신)
         · /main/evalMailAddrAll.do    : 등록 현황 조회(findData 검색)
         · /main/evalMailAddrDel.do    : 한 건 삭제(소프트 삭제)
     · 주의: 이 파일 안에서 Deferred EL 표기(샵 + 중괄호) 금지 — 변환에러로 content 타일만 빈 화면이 된다. --%>

<%-- 알림·확인 공통 컴포넌트(_alertBox/_confirmBox) — 목록 화면과 같은 모양(작은 창 + 넓은 파란 버튼) --%>
<script src="/asset/js/ui-message.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

<style>
/* ===== 이메일정보 화면 전용 (hem-*) =====
     스타일은 월보고서 목록의 일괄등록 모달에서 가져와, 계약정보 화면(카드+툴바)에 맞게 다듬었다.
     ★ 클래스는 모두 hem- 접두사 — 다른 화면(erl-*)과 섞이지 않게 한다. */
#hemPage .hem-role{ font-size:11px; font-weight:700; color:#fff; background:linear-gradient(135deg,#1f5a4b,#2a7665);
  padding:2px 9px; border-radius:20px; vertical-align:middle; margin-left:6px; }
#hemPage .hem-guide{ font-size:13px; color:#5b6b80; margin:6px 0 8px; }
#hemPage .hem-sect{ padding:10px 12px 12px; background:#f5f8fc; border:1px solid #dde6f0; border-radius:8px; }
#hemPage .hem-row{ display:flex; gap:10px; flex-wrap:wrap; align-items:flex-start; }
#hemPage .hem-row label{ display:block; margin:0 0 3px; font-size:12.5px; font-weight:700; color:#37475a; }
#hemPage .hem-row input[type=text]{ width:100%; padding:6px 10px; font-size:13px; border:1px solid #cfd8e6; border-radius:6px; font-family:inherit; }
#hemPage .hem-hospnm{ margin-top:4px; font-size:12px; color:#9aa7b3; white-space:nowrap; }
#hemPage .hem-hospnm.ok{ color:#2e7d32; font-weight:800; }
#hemPage .hem-hospnm.ng{ color:#c0392b; font-weight:800; }

/* 구분선 — 가운데 글자를 얹은 선(등록할 내용 / 등록 현황) */
#hemPage .hem-div{ display:flex; align-items:center; gap:10px; margin:16px 0 6px; }
#hemPage .hem-div::before, #hemPage .hem-div::after{ content:''; flex:1 1 auto; height:2px; background:#c9d6e5; }
#hemPage .hem-div span{ flex:0 0 auto; font-size:12.5px; font-weight:800; color:#1e3c72;
  background:#eef4fb; border:1px solid #c9d6e5; border-radius:999px; padding:2px 12px; }

#hemPage .hem-note{ margin-top:8px; font-size:12.5px; color:#8a5a00; }
#hemPage .hem-box{ max-height:260px; overflow:auto; border:1px solid #dfe6ef; border-radius:8px; background:#fbfdff;
  padding:6px 8px; font-size:12.5px; color:#5b6b80; }
#hemPage .hem-empty{ padding:10px 4px; color:#9aa7b3; }
#hemPage table.hem-tbl{ width:100%; border-collapse:collapse; font-size:12.5px; background:#fff; }
#hemPage table.hem-tbl th{ background:#eef3f8; color:#37475a; font-weight:800; border:1px solid #e3eaf2; padding:4px 8px; white-space:nowrap; }
#hemPage table.hem-tbl td{ border:1px solid #eef2f7; padding:4px 8px; color:#1b2733; white-space:nowrap; }
#hemPage table.hem-tbl tr.hem-bad td{ background:#fdf3f2; }
#hemPage table.hem-tbl .del{ border:none; background:none; color:#c0392b; cursor:pointer; font-size:12px; padding:0 4px; }
#hemPage table.hem-tbl .edt{ border:none; background:none; color:#1e3c72; cursor:pointer; font-size:13px; padding:0 4px; font-weight:800; }
#hemPage table.hem-tbl .edt:hover{ color:#0f2550; }

/* 엑셀 대량등록 — 기본 접힘(자주 쓰지 않는다) */
#hemPage details.hem-dev{ margin-top:10px; border:1px solid #e2e8ef; border-radius:8px; background:#fafcfe; padding:8px 10px; }
#hemPage details.hem-dev > summary{ cursor:pointer; font-size:13px; font-weight:800; color:#1f5a4b; list-style:none; }
#hemPage details.hem-dev > summary::-webkit-details-marker{ display:none; }
#hemPage details.hem-dev > summary::before{ content:'▸ '; color:#7b8a99; }
#hemPage details.hem-dev[open] > summary::before{ content:'▾ '; }
#hemPage details.hem-dev > summary span{ font-weight:600; font-size:12px; color:#8a97a4; }
#hemPage details.hem-dev label{ display:block; margin:10px 0 4px; font-size:12.5px; font-weight:700; color:#37475a; }

/* 병원 검색 팝업 — 기관기호 입력칸 바로 아래 작게 뜬다(서버 조회 없이 받아둔 목록에서 고른다) */
#hemHospPop{ display:none; position:absolute; top:100%; left:0; z-index:1500; width:330px; max-width:88vw;
  background:#fff; border:1px solid #c9d6e5; border-radius:8px; box-shadow:0 10px 26px rgba(16,22,29,.22); padding:8px; }
#hemHospPop.on{ display:block; }
#hemHospPop .hp-head{ display:flex; align-items:center; justify-content:space-between; font-size:12.5px; font-weight:800; color:#1e3c72; margin-bottom:6px; }
#hemHospPop .hp-head button{ border:none; background:none; cursor:pointer; color:#7b8a99; font-size:13px; }
#hemHospPop input[type=text]{ width:100%; padding:6px 8px; font-size:13px; border:1px solid #cfd8e6; border-radius:6px; }
#hemHospPop .hp-list{ max-height:230px; overflow:auto; margin-top:6px; border-top:1px solid #eef2f7; }
#hemHospPop .hp-row{ display:flex; gap:8px; align-items:center; padding:5px 4px; cursor:pointer; border-bottom:1px dashed #eef2f7; font-size:12.5px; }
#hemHospPop .hp-row:hover{ background:#eef4fb; }
#hemHospPop .hp-row .cd{ flex:0 0 78px; color:#6b7a89; font-variant-numeric:tabular-nums; }
#hemHospPop .hp-row .nm{ flex:1 1 auto; color:#1b2733; font-weight:700; }
#hemHospPop .hp-none{ padding:10px 4px; font-size:12.5px; color:#9aa7b3; }
</style>

<!-- ============================================================== -->
<!-- Main Form start -->
<!-- ============================================================== -->
<div class="dashboard-wrapper" id="hemPage">
	<div class="container-fluid dashboard-content">
		<div class="row">
			<div class="col-xl-12 col-lg-12 col-md-12 col-sm-12 col-12">
				<div class="card">
					<div class="card-body">

						<%-- 툴바 — 계약정보 화면과 같은 모양([btn-outline-dark] + "글자." + 아이콘) --%>
						<div class="d-flex justify-content-between align-items-center border p-2 rounded mb-2">
							<h6 class="mb-0 fw-bold text-dark">이메일정보 <span class="hem-role">위너넷</span></h6>
							<div class="btn-group ml-auto">
								<button type="button" class="btn btn-outline-dark" id="hemSaveBtn"
									data-toggle="tooltip" data-placement="top" title="아래 [등록할 내용] 을 주소록에 저장"
									onClick="hemSave()">등록. <i class="far fa-save"></i></button>
								<button type="button" class="btn btn-outline-dark"
									data-toggle="tooltip" data-placement="top" title="담아둔 내용 비우기(저장된 자료는 그대로)"
									onClick="hemClear()">비우기. <i class="far fa-trash-alt"></i></button>
								<button type="button" class="btn btn-outline-dark"
									data-toggle="tooltip" data-placement="top" title="엑셀 등록 양식 내려받기"
									onClick="hemSample()">양식받기. <i class="fas fa-download"></i></button>
							</div>
						</div>

						<div class="hem-guide">
							기관기호를 입력하면 <b>병원명이 자동으로 표시</b>됩니다. 한 건씩 <b>추가</b>한 뒤 마지막에 <b>등록</b>을 누르세요.
							<span style="color:#8a97a4;">— 같은 병원의 같은 주소는 중복 등록되지 않고 이름만 갱신됩니다.</span>
						</div>

						<%-- 직접 입력 — 기관기호(자동표시·검색) · 이메일 · 성함 --%>
						<div class="hem-sect">
							<div class="hem-row">
								<div id="hemHospWrap" style="flex:1 1 190px; position:relative;">
									<label>요양기관기호</label>
									<div style="display:flex; gap:4px; flex-wrap:nowrap;">
										<input id="hemInHosp" type="text" placeholder="예) 11223344" style="flex:1 1 auto; min-width:0;"
											oninput="hemInHospNm()" onkeydown="if(event.keyCode===13){document.getElementById('hemInEmail').focus();}">
										<button type="button" class="btn btn-outline-dark btn-sm" style="flex:0 0 auto;"
											onclick="hemPickOpen()" title="병원 검색"><i class="fas fa-search"></i></button>
									</div>
									<div id="hemInHospNm" class="hem-hospnm">기관기호 입력 또는 검색</div>

									<%-- 병원 검색 팝업 — 이미 받아둔 병원 목록에서 이름·기호로 걸러 고른다(서버 조회 없음) --%>
									<div id="hemHospPop">
										<div class="hp-head">
											<span>병원 검색</span>
											<button type="button" onclick="hemPickClose()">✕</button>
										</div>
										<input id="hemHospPopQ" type="text" placeholder="병원명 또는 기관기호" oninput="hemPickRender()"
											onkeydown="if(event.keyCode===27){hemPickClose();}">
										<div id="hemHospPopList" class="hp-list"></div>
									</div>
								</div>
								<div style="flex:2 1 220px;">
									<label>이메일</label>
									<input id="hemInEmail" type="text" placeholder="name@domain.com"
										onkeydown="if(event.keyCode===13){document.getElementById('hemInName').focus();}">
								</div>
								<div style="flex:1 1 140px;">
									<label>성함 / 직책</label>
									<input id="hemInName" type="text" placeholder="예) 김간호 팀장"
										onkeydown="if(event.keyCode===13){hemAdd();}">
								</div>
								<div style="flex:0 0 auto; align-self:flex-end;">
									<button type="button" class="btn btn-outline-dark" onclick="hemAdd()">추가. <i class="far fa-edit"></i></button>
								</div>
							</div>
						</div>

						<%-- 엑셀 파일 — 한 번에 많이 넣을 때만 사용(기본 접힘) --%>
						<details class="hem-dev">
							<summary>엑셀 파일로 한 번에 넣기 <span>(대량 등록용 — 눌러서 펼치기)</span></summary>
							<label>엑셀 파일 (.xlsx / .csv)
								<span style="font-weight:600; color:#6b7a89;">— A열 기관기호 · B열 이메일 · C열 성함 순서여야 합니다</span></label>
							<input type="file" id="hemFile" accept=".xlsx,.xls,.csv" onchange="hemFileRead(this)" style="font-size:13px;">
						</details>

						<div class="hem-div"><span>등록할 내용</span></div>
						<div id="hemPreview" class="hem-box"></div>
						<div id="hemNote" class="hem-note"></div>

					</div>
				</div>
			</div>
		</div>

		<%-- 등록 현황 — 계약정보 화면의 하단 패널과 같은 자리·같은 모양 --%>
		<div class="bottom-section mt-0">
			<div class="col-xl-12 col-lg-12 col-md-12 col-sm-12 col-12">
				<div class="card">
					<div class="card-body">
						<div class="d-flex justify-content-between align-items-center border p-2 rounded mb-2">
							<h6 class="mb-0 fw-bold text-dark">등록 현황 (관리)</h6>
							<div class="input-group" style="max-width:430px;">
								<input id="hemFind" type="text" class="form-control"
									placeholder="병원명 · 기관기호 · 이메일 검색 후 [ enter ]"
									onkeydown="if(event.keyCode===13){hemAllLoad();}">
								<div class="input-group-append">
									<button type="button" class="btn btn-info btn-sm px-2"
										style="background-color:#ffd43b; color:black;" onClick="hemAllLoad()">
										조회. <i class="fas fa-search"></i>
									</button>
								</div>
							</div>
						</div>
						<div id="hemAllBox" class="hem-box" style="max-height:none;"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- ============================================================== -->
<!-- Main Form end -->
<!-- ============================================================== -->

<script>
jQuery(function(){
  "use strict";
  var ctx = (typeof CommonUtil !== 'undefined' && CommonUtil.getContextPath) ? CommonUtil.getContextPath() : '';
  function cookie(n){ var m=document.cookie.match('(^|;)\\s*'+n+'\\s*=\\s*([^;]+)'); return m?decodeURIComponent(m.pop()):''; }
  function _ck(n){ try{ if(typeof getCookie==='function') return (getCookie(n)||'').trim(); }catch(e){} return cookie(n); }
  function el(id){ return document.getElementById(id); }
  function esc(s){ return String(s==null?'':s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
  /* onclick 속성 안에 넣는 JS 문자열용 — 따옴표·역슬래시 제거 */
  function _sj(v){ return String(v==null?'':v).replace(/[\\'"]/g,''); }

  /* 알림·확인 — 목록 화면과 같은 공통 컴포넌트(/asset/js/ui-message.js).
     라이브러리가 없으면 기본 alert/confirm 으로 떨어져 동작은 유지된다. */
  function _icon(i){ return (i==='error')?'❌':(i==='success')?'✅':(i==='warning')?'⚠️':(i==='question')?'❓':'ℹ️'; }
  function hemAlert(icon, msg, opt){
    opt = opt || {};
    var body = String(msg==null?'':msg).replace(/\n/g,'<br>');
    if(typeof window._alertBox !== 'function'){ alert(String(msg||'').replace(/<[^>]*>/g,'')); if(opt.done) opt.done(); return; }
    window._alertBox(body, { icon:_icon(icon), okColor:(icon==='error'?'red':'blue'), onOk:opt.done });
  }
  function hemConfirm(msg, onYes){
    var body = String(msg==null?'':msg).replace(/\n/g,'<br>');
    if(typeof window._confirmBox !== 'function'){ if(window.confirm(String(msg||''))){ if(onYes) onYes(); } return; }
    window._confirmBox({ msg:body, icon:_icon('question'), okText:'확인', okColor:'blue', onOk:onYes });
  }

  /* ★위너넷 전용 — 메뉴(병원정보 관리)는 위너넷 외 계정에 아예 안 보이지만,
       주소(/user/hospEmail.do)로 직접 들어오는 경우까지 여기서 막는다. 계약정보 화면들과 같은 방침. */
  if(_ck('s_wnn_yn') !== 'Y'){
    el('hemPage').innerHTML =
      '<div class="container-fluid dashboard-content"><div class="card"><div class="card-body">'
      + '<h6 class="fw-bold text-dark">관리자(위너넷) 전용 화면입니다.</h6>'
      + '<div style="font-size:13px;color:#5b6b80;margin-top:6px;">메일 수신자 정보는 위너넷 담당자만 관리합니다.</div>'
      + '</div></div></div>';
    return;
  }

  var HOSP_NM = {};      // 기관기호 → 병원명 (자동표시·검색·미리보기 확인용)
  var _rows = [];        // 등록할 내용(담아둔 목록) — [등록] 을 눌러야 서버에 저장된다

  /* 병원목록 — 목록 화면과 같은 엔드포인트. 받아두면 기관기호 자동표시·검색이 서버 조회 없이 된다 */
  jQuery.ajax({ url:ctx+'/main/select_HospitalMst.do', type:'POST', dataType:'json', data:{ hosp_cd:'' },
    success:function(res){
      var arr=(res&&res.data)||[];
      arr.forEach(function(h){
        var cd=h.hosp_cd||h.HOSP_CD||'', nm=h.hosp_nm||h.HOSP_NM||cd;
        if(cd) HOSP_NM[cd]=nm;
      });
      hemInHospNm();
    }
  });

  /* 기관기호 → 병원명 찾기.
     ★대소문자를 가리지 않는다 (2026-07-30) — 위너넷 계정처럼 기호가 'w1234567' 로 소문자인 곳이 있고,
       병원목록(select_HospitalMst)에는 대문자로 들어 있는 경우가 있어 그냥 대괄호로 찾으면
       이미 등록된 병원인데도 '등록된 병원이 아닙니다' 가 떴다(등록 현황의 ✎ 수정에서 실제 발생). */
  function hospNmOf(cd){
    cd = String(cd==null?'':cd).trim();
    if(!cd) return '';
    if(HOSP_NM[cd]) return HOSP_NM[cd];
    var low = cd.toLowerCase(), keys = Object.keys(HOSP_NM);
    for(var i=0;i<keys.length;i++){ if(keys[i].toLowerCase()===low) return HOSP_NM[keys[i]]; }
    return '';
  }

  /* ===== 병원 검색 팝업 ===== */
  window.hemPickOpen = function(){
    var p=el('hemHospPop'); if(!p) return;
    p.classList.add('on');
    el('hemHospPopQ').value = (el('hemInHosp').value||'').trim();
    hemPickRender();
    el('hemHospPopQ').focus();
  };
  window.hemPickClose = function(){ var p=el('hemHospPop'); if(p) p.classList.remove('on'); };
  window.hemPickRender = function(){
    var q=((el('hemHospPopQ').value)||'').trim().toLowerCase();
    var codes=Object.keys(HOSP_NM).sort(function(a,b){ return (HOSP_NM[a]||'').localeCompare(HOSP_NM[b]||''); });
    var h='', n=0;
    codes.forEach(function(cd){
      var nm=HOSP_NM[cd]||'';
      if(q && cd.toLowerCase().indexOf(q)<0 && nm.toLowerCase().indexOf(q)<0) return;
      if(n++ >= 200) return;                                  // 너무 많으면 앞부분만(검색해서 좁히도록)
      h += '<div class="hp-row" onclick="hemPickSel(\''+_sj(cd)+'\')">'
         +   '<span class="cd">'+esc(cd)+'</span><span class="nm">'+esc(nm)+'</span></div>';
    });
    el('hemHospPopList').innerHTML = h || '<div class="hp-none">검색 결과가 없습니다.</div>';
  };
  window.hemPickSel = function(cd){
    el('hemInHosp').value = cd;
    hemInHospNm();
    hemPickClose();
    el('hemInEmail').focus();
  };
  /* 팝업 밖 클릭 → 닫기.
     ★기준은 팝업이 아니라 '기관기호 칸 전체(#hemHospWrap)' — 검색 버튼도 이 안에 있어서,
       팝업만 기준으로 하면 버튼을 누른 그 클릭이 문서까지 올라와 방금 열린 팝업을 다시 닫는다. */
  document.addEventListener('click', function(ev){
    var p=el('hemHospPop'); if(!p || !p.classList.contains('on')) return;
    var wrap=el('hemHospWrap');
    if(wrap && !wrap.contains(ev.target)) hemPickClose();
  });
  document.addEventListener('keydown', function(ev){ if(ev.keyCode===27) hemPickClose(); });

  /* 기관기호 → 병원명 표시. 목록에 없는 기호면 빨갛게 알려준다 */
  window.hemInHospNm = function(){
    var cd=(el('hemInHosp').value||'').trim(), box=el('hemInHospNm');
    if(!box) return;
    if(!cd){ box.textContent='기관기호를 입력하세요'; box.className='hem-hospnm'; return; }
    var nm=hospNmOf(cd);
    if(nm){ box.textContent='✔ '+nm; box.className='hem-hospnm ok'; }
    else   { box.textContent='등록된 병원이 아닙니다'; box.className='hem-hospnm ng'; }
  };

  /* ===== 담기(추가) · 미리보기 ===== */
  window.hemAdd = function(){
    var cd=(el('hemInHosp').value||'').trim();
    var em=(el('hemInEmail').value||'').trim();
    var nm=(el('hemInName').value||'').trim();
    if(!cd){ el('hemNote').textContent='요양기관기호를 입력하세요.'; el('hemInHosp').focus(); return; }
    if(em.indexOf('@')<1){ el('hemNote').textContent='이메일 형식이 올바르지 않습니다.'; el('hemInEmail').focus(); return; }
    var dup=_rows.some(function(r){ return r.hospCd===cd && r.email.toLowerCase()===em.toLowerCase(); });
    if(dup){ el('hemNote').textContent='이미 목록에 있는 주소입니다.'; return; }
    _rows.push({ hospCd:cd, email:em, addrNm:nm });
    el('hemInEmail').value=''; el('hemInName').value='';   // 기관기호는 남겨 같은 병원 여러 명을 이어서 넣게
    el('hemNote').textContent='';
    hemPreview();
    el('hemInEmail').focus();
  };
  window.hemRowDel = function(i){ _rows.splice(i,1); hemPreview(); };
  window.hemClear = function(){
    if(!_rows.length){ el('hemNote').textContent='담긴 내용이 없습니다.'; return; }
    hemConfirm('담아둔 '+_rows.length+'건을 비울까요?\n(이미 등록된 자료는 지워지지 않습니다)', function(){
      _rows=[]; var f=el('hemFile'); if(f) f.value='';
      el('hemNote').textContent=''; hemPreview();
    });
  };

  /* 미리보기 — 등록 전에 기관기호가 실제 병원인지, 이메일 형식이 맞는지 표시한다 */
  function hemPreview(){
    if(!_rows.length){
      el('hemPreview').innerHTML='<div class="hem-empty">아직 담긴 내용이 없습니다. 위에서 [추가] 하거나 엑셀 파일을 고르세요. 여기 담긴 것만 [등록] 으로 저장됩니다.</div>';
      el('hemNote').textContent='';
      return;
    }
    var okN=0, ngN=0;
    var h='<table class="hem-tbl"><thead><tr><th>기관기호</th><th>병원명</th><th>이메일</th><th>성함/직책</th><th>확인</th><th></th></tr></thead><tbody>';
    _rows.forEach(function(r, i){
      var nm=hospNmOf(r.hospCd);
      var bad = (!r.hospCd || r.email.indexOf('@')<1) ? '형식오류' : (nm ? '' : '기관기호 없음');
      if(bad) ngN++; else okN++;
      h += '<tr class="'+(bad?'hem-bad':'')+'"><td>'+esc(r.hospCd)+'</td><td>'+esc(nm||'-')+'</td><td>'+esc(r.email)+'</td><td>'+esc(r.addrNm||'')+'</td>'
         + '<td>'+(bad? '<span style="color:#c0392b">'+bad+'</span>' : '<span style="color:#2e7d32">확인</span>')+'</td>'
         + '<td><button type="button" class="del" title="목록에서 빼기" onclick="hemRowDel('+i+')">✕</button></td></tr>';
    });
    el('hemPreview').innerHTML = h+'</tbody></table>';
    el('hemNote').textContent = '총 '+_rows.length+'건 · 등록 가능 '+okN+'건'
      + (ngN? (' · 확인 필요 '+ngN+'건 (기관기호가 목록에 없거나 이메일 형식 오류)') : '');
  }

  /* ===== 엑셀 ===== */
  function _push(out, cd, em, nm){
    cd=String(cd==null?'':cd).trim(); em=String(em==null?'':em).trim(); nm=String(nm==null?'':nm).trim();
    if(!cd && !em) return;
    if(em.indexOf('@')<1 && /기관|기호|이메일|메일|주소|이름|성함/.test(cd+em)) return;   // 머리글 줄
    out.push({ hospCd:cd, email:em, addrNm:nm });
  }
  window.hemSample = function(){
    if(typeof XLSX==='undefined'){ hemAlert('warning','엑셀 라이브러리를 불러오지 못했습니다.'); return; }
    var aoa=[['요양기관기호','이메일','성함/직책'],
             ['11223344','hospital@example.com','김간호 팀장'],
             ['11282347','staff@example.com','']];
    var wb=XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, XLSX.utils.aoa_to_sheet(aoa), '수신자');
    XLSX.writeFile(wb, '메일수신자_등록양식.xlsx');
  };
  window.hemFileRead = function(input){
    var f=input.files && input.files[0]; if(!f) return;
    if(typeof XLSX==='undefined'){ el('hemNote').textContent='엑셀 라이브러리를 불러오지 못했습니다. 화면 입력을 이용하세요.'; return; }
    var fr=new FileReader();
    fr.onload=function(e){
      try{
        var wb=XLSX.read(new Uint8Array(e.target.result), {type:'array'});
        var ws=wb.Sheets[wb.SheetNames[0]];
        var aoa=XLSX.utils.sheet_to_json(ws, {header:1, raw:false, defval:''});
        var out=[]; aoa.forEach(function(r){ _push(out, r[0], r[1], r[2]); });
        // 이메일이 하나도 없으면 양식이 다른 파일이다 — 그대로 담으면 '형식오류' 수백 건이 쌓인다
        var mails = out.filter(function(r){ return r.email.indexOf('@')>0; }).length;
        if(!mails){
          input.value='';
          hemAlert('warning','이 파일에서 이메일을 찾지 못했습니다.\nA열 기관기호 · B열 이메일 · C열 성함 순서인지 확인하세요.\n[양식받기] 로 양식을 내려받을 수 있습니다.');
          return;
        }
        out.forEach(function(r){
          if(!_rows.some(function(x){ return x.hospCd===r.hospCd && x.email.toLowerCase()===r.email.toLowerCase(); })) _rows.push(r);
        });
        hemPreview();
      }catch(err){ el('hemNote').textContent='엑셀을 읽지 못했습니다: '+err.message; }
    };
    fr.readAsArrayBuffer(f);
  };

  /* ===== 등록(저장) ===== */
  window.hemSave = function(){
    if(!_rows.length){ el('hemNote').textContent='등록할 자료가 없습니다. 먼저 [추가] 하세요.'; return; }
    var valid=_rows.filter(function(r){ return r.hospCd && r.email.indexOf('@')>0; });
    if(!valid.length){ el('hemNote').textContent='형식이 맞는 행이 없습니다.'; return; }
    hemConfirm(valid.length+'건을 주소록에 등록할까요?\n(같은 병원의 같은 주소는 중복 등록되지 않고 이름만 갱신됩니다)', function(){
      var btn=el('hemSaveBtn'); btn.disabled=true; btn.innerHTML='등록 중… <i class="fas fa-spinner fa-spin"></i>';
      jQuery.ajax({ url:ctx+'/main/evalMailAddrBulk.do', type:'POST', contentType:'application/json', dataType:'json',
        data: JSON.stringify(valid),
        success:function(r){
          btn.disabled=false; btn.innerHTML='등록. <i class="far fa-save"></i>';
          if(!r || r.result!=='OK'){ hemAlert('error',(r&&r.message)?r.message:'등록에 실패했습니다.'); return; }
          _rows=[];
          var f=el('hemFile'); if(f) f.value='';
          hemPreview();
          el('hemNote').textContent='';
          hemAllLoad();
          hemAlert('success','등록 '+r.okCnt+'건'+((r.ngCnt||0)? (' · 실패 '+r.ngCnt+'건') : ''));
        },
        error:function(){ btn.disabled=false; btn.innerHTML='등록. <i class="far fa-save"></i>'; hemAlert('error','서버 통신 오류로 등록하지 못했습니다.'); }
      });
    });
  };

  /* ===== 등록 현황 ===== */
  window.hemAllLoad = function(){
    var q=(el('hemFind')?el('hemFind').value:'')||'';
    jQuery.ajax({ url:ctx+'/main/evalMailAddrAll.do', type:'POST', dataType:'json', data:{ findData:q },
      success:function(r){
        var list=(r&&r.result==='OK')?(r.list||[]):[];
        if(!list.length){ el('hemAllBox').innerHTML='<div class="hem-empty">등록된 주소가 없습니다.</div>'; return; }
        var h='<table class="hem-tbl"><thead><tr><th>기관기호</th><th>병원명</th><th>이름/직책</th><th>이메일</th><th>수정일</th><th>수정</th><th>삭제</th></tr></thead><tbody>';
        list.forEach(function(a){
          /* 이 목록의 병원명(서버 조인 결과)을 기호→병원명 캐시에 넣어 둔다 —
             병원목록(select_HospitalMst)에 없는 기호(위너넷 계정 등)도 ✎ 수정·미리보기에서 ✔ 로 뜨게 한다. */
          if(a.hospcd && a.hospnm && !HOSP_NM[a.hospcd]) HOSP_NM[a.hospcd]=a.hospnm;
          var oc = "hemEdit('"+_sj(a.hospcd)+"','"+_sj(a.email)+"','"+_sj(a.addrnm||'')+"','"+_sj(a.hospnm||'')+"')";
          h += '<tr><td>'+esc(a.hospcd)+'</td><td>'+esc(a.hospnm||'-')+'</td><td>'+esc(a.addrnm||'')+'</td><td>'+esc(a.email)+'</td>'
             + '<td>'+esc(a.upddttm||'')+'</td>'
             + '<td><button type="button" class="edt" title="이 주소를 위 입력칸으로 불러와 고칩니다" onclick="'+oc+'">✎</button></td>'
             + '<td><button type="button" class="del" title="삭제" onclick="hemAllDel('+Number(a.addrseq)+')">✕</button></td></tr>';
        });
        el('hemAllBox').innerHTML = h+'</tbody></table>';
      },
      error:function(){ el('hemAllBox').innerHTML='<div class="hem-empty">조회 중 오류가 발생했습니다.</div>'; }
    });
  };
  /* 등록된 주소 수정 — 값을 위 입력칸으로 불러온다.
     이름/직책만 고쳐 [추가]→[등록] 하면 같은 병원+같은 이메일이라 새 행이 생기지 않고 이름만 갱신된다.
     이메일 자체를 바꾸려면 기존 것을 ✕ 로 지우고 새로 등록해야 한다(이메일이 키라서). */
  window.hemEdit = function(hospCd, email, addrNm, hospNm){
    // 목록이 알고 있는 병원명을 먼저 캐시에 넣는다 — 병원목록에 없는 기호도 '등록된 병원이 아닙니다' 가 안 뜨게
    if(hospCd && hospNm && !HOSP_NM[hospCd]) HOSP_NM[hospCd]=hospNm;
    el('hemInHosp').value = hospCd; hemInHospNm();
    el('hemInEmail').value = email;
    el('hemInName').value  = addrNm;
    el('hemNote').textContent = '';
    el('hemInName').focus();
    try{ el('hemInName').select(); }catch(e){}
  };
  window.hemAllDel = function(addrSeq){
    hemConfirm('이 주소를 주소록에서 뺄까요?', function(){
      jQuery.ajax({ url:ctx+'/main/evalMailAddrDel.do', type:'POST', dataType:'json', data:{ addrSeq:addrSeq, hospCd:'' },
        success:function(){ hemAllLoad(); },
        error:function(){ hemAlert('error','삭제 중 오류가 발생했습니다.'); }
      });
    });
  };

  // 화면 진입 시 — 담긴 내용 안내 + 등록 현황 바로 조회(계약정보 화면처럼 열면 목록이 보이게)
  hemPreview();
  hemAllLoad();
});
</script>
