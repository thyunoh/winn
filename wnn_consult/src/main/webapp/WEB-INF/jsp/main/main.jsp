<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

  
</head> 

<body>
<!-- 1:1 문의 답변완료 알림: 병원 로그인(메인 진입) 시 미확인 답변이 있으면 표시.
     확인 처리는 1:1 문의 답변 열람(selectAnsrInfo.do) 시 자동 수행됨. -->
<script>
(function(){
  function markAsqRead(hc){
    try {
      fetch('/mangr/asqReadAll.do', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'hospCd=' + encodeURIComponent(hc)
      }).catch(function(){});
    } catch(e){}
  }
  function run(){
    try {
      var hc = '';
      try { hc = sessionStorage.getItem('s_hospid') || ''; } catch(e){}
      if (!hc && typeof getCookie === 'function') { try { hc = getCookie('s_hospid') || ''; } catch(e){} }
      if (!hc) return;
      fetch('/mangr/asqUnreadCnt.do', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'hospCd=' + encodeURIComponent(hc)
      }).then(function(r){ return r.json(); }).then(function(res){
        var cnt = (res && res.cnt) ? parseInt(res.cnt, 10) : 0;
        if (cnt > 0) {
          if (typeof Swal !== 'undefined') {
            if (!document.getElementById('asqAlertPopupStyle')) {
              var _st = document.createElement('style');
              _st.id = 'asqAlertPopupStyle';
              _st.innerHTML =
                '.asqAlertPopup .swal2-title{font-size:1.05em;padding:0.45em 0 0;margin:0;}' +
                '.asqAlertPopup .swal2-html-container{font-size:0.9em;margin:0.55em 0 0;}' +
                '.asqAlertPopup .swal2-icon{width:2.4em;height:2.4em;margin:0.7em auto 0.4em;}' +
                '.asqAlertPopup .swal2-icon .swal2-icon-content{font-size:1.5em;}' +
                '.asqAlertPopup .swal2-actions{margin-top:0.9em;margin-bottom:0.4em;}' +
                '.asqAlertPopup .swal2-confirm{font-size:0.9em;padding:0.45em 1.4em;}';
              document.head.appendChild(_st);
            }
            Swal.fire({ icon: 'info', title: '1:1 문의 답변 완료',
              html: '확인하지 않은 답변이 <b>' + cnt + '건</b> 있습니다.<br>1:1 문의에서 확인해 주세요.',
              confirmButtonText: '확인', width: 460, padding: '0.9em 1.8em',
              customClass: { popup: 'asqAlertPopup' } }).then(function(result){
                if (result.isConfirmed) { markAsqRead(hc); }
              });
          } else {
            alert('확인하지 않은 1:1 문의 답변이 ' + cnt + '건 있습니다.\n1:1 문의에서 확인해 주세요.');
            markAsqRead(hc);
          }
        }
      }).catch(function(){});
    } catch(e){}
  }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', run);
  else run();
})();
</script>
</body>

</html>