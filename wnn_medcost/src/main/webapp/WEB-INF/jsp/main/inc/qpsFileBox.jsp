<%--
  qpsFileBox.jsp — QPS 공통 첨부 위젯 (2026-08-10)
  ★정적 include(<%@ include %>) 전용 조각 — <%@ page %> 지시자를 넣지 않는다
    (부모 JSP 의 contentType·pageEncoding 지시자와 충돌해 번역 에러가 난다).
    회의록·연간계획서·라운딩 점검표·자료실이 <%@ include %> 로 한 벌씩 끌어 쓰는 첨부 UI.
    · window.qpsFileBox({ mount, refGb, needSaveMsg }) 로 생성 → api.setKey(문서키) / api.reload().
    · 문서가 저장되기 전(refKey 없음)에는 업로드를 막고 안내만 — 첨부는 어느 문서에 붙는지가 정해져야 한다.
    · 실제 파일은 파일서버(SFTP), 다운로드는 /sftp/download.do?filePath= 재사용.
    · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지.
--%>
<style>
  .qfb{ border:1px solid #e0e6ea; border-radius:10px; background:#fbfcfd; padding:11px 13px; }
  .qfb-head{ display:flex; align-items:center; gap:8px; margin-bottom:8px; }
  .qfb-head .t{ font-size:13px; font-weight:800; color:#20303a; }
  .qfb-head .sub{ font-size:11.5px; color:#8a99a3; }
  .qfb-head .sp{ flex:1; }
  .qfb-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:5px 12px; font-size:12.5px; font-weight:700; cursor:pointer; }
  .qfb-btn[disabled]{ opacity:.45; cursor:not-allowed; }
  .qfb-list{ display:flex; flex-direction:column; gap:5px; }
  .qfb-row{ display:flex; align-items:center; gap:9px; font-size:12.5px; padding:5px 8px;
      border:1px solid #eef2f5; border-radius:7px; background:#fff; }
  .qfb-row .nm{ flex:1; min-width:0; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;
      color:#1f5a4b; font-weight:600; text-decoration:none; }
  .qfb-row .nm:hover{ text-decoration:underline; }
  .qfb-row .sz{ color:#9aa7ae; font-variant-numeric:tabular-nums; }
  .qfb-row .del{ color:#b23b3b; cursor:pointer; font-size:12px; border:1px solid #e6c6c6;
      border-radius:5px; padding:1px 7px; background:#fff; }
  .qfb-empty{ font-size:12px; color:#9aa7ae; padding:3px 2px; }
</style>
<script>
window.qpsFileBox = function(opts){
  var host = document.getElementById(opts.mount);
  if (!host) return null;
  var refGb = opts.refGb;
  var refKey = '';
  var saveMsg = opts.needSaveMsg || '문서를 먼저 저장하면 첨부할 수 있습니다.';

  host.innerHTML =
    '<div class="qfb">' +
      '<div class="qfb-head">' +
        '<span class="t">📎 첨부</span>' +
        '<span class="sub">' + (opts.hint || '사진·파일. 문서에 붙습니다.') + '</span>' +
        '<span class="sp"></span>' +
        '<button type="button" class="qfb-btn" data-add disabled>파일 추가</button>' +
        '<input type="file" data-inp multiple style="display:none;">' +
      '</div>' +
      '<div class="qfb-list" data-list></div>' +
    '</div>';

  var $add  = host.querySelector('[data-add]');
  var $inp  = host.querySelector('[data-inp]');
  var $list = host.querySelector('[data-list]');

  function post(url, data){
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') throw new Error(res.message || '처리에 실패했습니다.');
      return res;
    });
  }
  function toast(m, t){ try { if (typeof _toast==='function') _toast(m, t||'ok'); } catch(e){} }
  function warn(m){ try { if (typeof _alertBox==='function') _alertBox(m, {icon:'⚠️'}); else alert(m); } catch(e){ alert(m); } }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function fmtSize(b){ b=Number(b||0); if(b<1024) return b+' B';
      if(b<1048576) return (b/1024).toFixed(0)+' KB'; return (b/1048576).toFixed(1)+' MB'; }

  function render(rows){
    if (!rows || !rows.length){ $list.innerHTML = '<div class="qfb-empty">첨부된 파일이 없습니다.</div>'; return; }
    $list.innerHTML = rows.map(function(r){
      var url = '/sftp/download.do?filePath=' + encodeURIComponent(r.filepath);
      return '<div class="qfb-row">' +
        '<a class="nm" href="' + url + '" title="내려받기">' + esc(r.filenm) + '</a>' +
        '<span class="sz">' + fmtSize(r.filesize) + '</span>' +
        '<button type="button" class="del" data-seq="' + r.fileseq + '">삭제</button>' +
      '</div>';
    }).join('');
    Array.prototype.forEach.call($list.querySelectorAll('.del'), function(b){
      b.onclick = function(){ doDelete(b.getAttribute('data-seq')); };
    });
  }

  function reload(){
    if (!refKey){ $list.innerHTML = '<div class="qfb-empty">' + esc(saveMsg) + '</div>'; return; }
    post('/qps/fileList.do', { refGb:refGb, refKey:refKey }).then(function(res){ render(res.list); })
      .catch(function(e){ $list.innerHTML = '<div class="qfb-empty">첨부 목록을 불러오지 못했습니다.</div>'; });
  }

  function doUpload(files){
    if (!refKey){ warn(saveMsg); return; }
    if (!files || !files.length) return;
    var fd = new FormData();
    fd.append('refGb', refGb); fd.append('refKey', refKey);
    for (var i=0; i<files.length; i++) fd.append('file', files[i]);
    $add.disabled = true;
    $.ajax({ url:'/qps/fileUpload.do', type:'POST', data:fd,
             processData:false, contentType:false, dataType:'json' })
      .then(function(res){
        if (res && res.result === 'FAIL') { warn(res.message || '업로드에 실패했습니다.'); return; }
        toast((res.saved||0) + '개 파일을 첨부했습니다.');
        reload();
      })
      .always(function(){ $add.disabled = !refKey; $inp.value = ''; })
      .fail(function(){ warn('업로드 중 오류가 발생했습니다.'); });
  }

  function doDelete(seq){
    var run = function(){
      post('/qps/fileDelete.do', { fileSeq:seq }).then(function(){ toast('삭제되었습니다.'); reload(); })
        .catch(function(e){ warn(e.message); });
    };
    if (typeof _confirmBox === 'function')
      _confirmBox({ msg:'이 첨부를 삭제할까요?', icon:'⚠️', okText:'삭제', okColor:'#b23b3b', onOk:run });
    else if (confirm('이 첨부를 삭제할까요?')) run();
  }

  $add.onclick = function(){ if (!refKey){ warn(saveMsg); return; } $inp.click(); };
  $inp.onchange = function(){ doUpload($inp.files); };

  reload();
  return {
    setKey: function(k){ refKey = k ? String(k) : ''; $add.disabled = !refKey; reload(); },
    reload: reload
  };
};
</script>
