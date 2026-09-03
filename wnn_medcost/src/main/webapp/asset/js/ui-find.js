/* =====================================================================
   공통 UI — **목록 찾기** (2026-09-03)
   ---------------------------------------------------------------------
   사용법: 페이지에 <script src="/asset/js/ui-find.js"></script> 한 줄.
     목록 상자에 표시만 달면 끝이다 —

       <div class="sr-list" id="srListBox" data-find="보고서 찾기">…</div>

     · `data-find` 값 = 찾기 칸에 흐리게 보일 글(안 적으면 「찾기」)
     · 찾기 칸은 **바로 위 머리(h4 · .hd)** 안에 끼워 넣는다. 머리가 없으면 목록 위에 한 줄 만든다.
     · 목록의 **바로 아래 자식**을 글자로 걸러 보여 준다(안 맞는 것은 숨긴다).

   ★★***화면마다 거르는 코드를 따로 짜지 않는다.***
     화면마다 목록을 그리는 방식(자료 모양·그리는 함수)이 다 다르지만,
     **그려진 뒤의 글자**는 어느 화면이나 같다. 그래서 화면이 아니라 **결과를 본다.**
     ⇒ 화면 쪽 자바스크립트는 한 줄도 안 고친다.

   ★목록을 다시 그려도 걸러 둔 것이 풀리지 않는다 — 바뀌는 것을 지켜보다 다시 건다.
     ***이게 없으면 저장 한 번에 찾기가 조용히 풀린다.***

   ⚠**보이는 것만 걸러진다.** 「전체 켬/끔」 같은 단추가 있는 화면은 그 단추가 보이는 것에만
     걸릴 수 있다 — 그래서 몇 개가 숨었는지 **찾기 칸 옆에 적어 둔다.**

   · jQuery 불필요 — 어느 화면에서나 동작
   ===================================================================== */
(function(){
  if (window._uiFindLoaded) return;
  window._uiFindLoaded = true;

  var CSS =
    '.uifd-w{display:inline-flex;align-items:center;gap:5px;flex:0 1 auto;margin-left:auto;}'
  + '.uifd-i{border:1px solid #cfd8e0;border-radius:5px;padding:3px 7px;font-size:12px;font-weight:400;'
  + 'background:#fff;font-family:inherit;flex:0 1 160px;min-width:92px;color:#1f2a30;}'
  + '.uifd-i:focus{outline:none;border-color:#2a7665;}'
  + '.uifd-n{font-size:11px;font-weight:700;color:#b26a00;white-space:nowrap;}'
  + '.uifd-bar{display:flex;align-items:center;gap:5px;margin-bottom:6px;}'
  + '.uifd-none{color:#8a99a3;font-size:12.5px;padding:16px;text-align:center;}';
  var st = document.createElement('style'); st.textContent = CSS; document.head.appendChild(st);

  function txt(el){ return (el.textContent || '').toLowerCase(); }

  function arm(list){
    if (list._uifdDone) return;
    list._uifdDone = true;

    var ph = list.getAttribute('data-find') || '찾기';

    // ★목록이 **표의 몸통(tbody)** 인 화면도 있다 — 그때 머리(h4)는 표 **밖**에 있다.
    //   형제만 훑으면 못 찾고 찾기 칸이 표 위에 따로 생겨 어색하다. ⇒ 표를 건너뛰고 위로 올라간다.
    var isBody = (list.tagName === 'TBODY');
    var from = isBody ? (list.closest('table') || list) : list;

    // ── 찾기 칸을 놓을 자리 : 바로 위 머리(h4 · .hd) 안. 없으면 목록 위에 한 줄.
    var host = null, p = from.previousElementSibling;
    while (p) {
      var t = p.tagName;
      if (t === 'H4' || (p.classList && p.classList.contains('hd'))) { host = p; break; }
      p = p.previousElementSibling;
    }
    var wrap = document.createElement('span');
    wrap.className = 'uifd-w';
    var inp = document.createElement('input');
    inp.type = 'text'; inp.className = 'uifd-i'; inp.placeholder = ph;
    var num = document.createElement('span');
    num.className = 'uifd-n';
    wrap.appendChild(num); wrap.appendChild(inp);

    if (host) {
      // 머리가 한 줄로 늘어서야 오른쪽 끝에 붙는다
      var cs = window.getComputedStyle(host);
      if (cs.display.indexOf('flex') < 0) { host.style.display = 'flex'; host.style.alignItems = 'center'; host.style.gap = '6px'; }
      host.appendChild(wrap);
    } else {
      var bar = document.createElement("div");
      bar.className = "uifd-bar";
      bar.appendChild(wrap);
      from.parentNode.insertBefore(bar, from);
    }

    // 「찾는 것이 없습니다」 — 우리가 만든 것만 우리가 지운다(화면이 만든 빈 안내와 섞지 않는다)
    // 표이면 안내도 **행**이어야 한다 — div 를 tbody 에 넣으면 브라우저가 밖으로 밀어낸다
    var none = document.createElement(isBody ? "tr" : "div");
    if (isBody) {
      var td = document.createElement("td");
      td.colSpan = 99; td.className = "uifd-none"; td.textContent = "찾는 것이 없습니다.";
      none.appendChild(td);
    } else none.className = "uifd-none";
    none.style.display = "none";
    if (!isBody) none.textContent = "찾는 것이 없습니다.";
    list.appendChild(none);

    var busy = false;
    function run(){
      var q = String(inp.value || '').trim().toLowerCase();
      var all = 0, hit = 0;
      for (var i = 0; i < list.children.length; i++) {
        var c = list.children[i];
        // 우리가 넣은 안내는 센 것에서 뺀다. ***같은 물건인지(===)만 보면 안 된다*** —
        // 화면이 innerHTML 을 통째로 다시 넣으면 **안내가 복사된 다른 물건**이 되어 항목으로 세어진다.
        if (c === none || (c.className && String(c.className).indexOf('uifd-none') >= 0)) continue;
        if (c.tagName === 'TR' && c.querySelector && c.querySelector('.uifd-none')) continue;
        // 화면이 넣어 둔 빈 안내는 세지도 숨기지도 않는다.
        //   · div 목록 : 클래스에 `empty` 가 붙는다(이 시스템의 규칙)
        //   · 표       : `<td colspan=여러칸>` 한 칸짜리 줄이다 — ***자료 줄은 칸이 나뉘어 있다***
        if (c.className && String(c.className).indexOf('empty') >= 0) continue;
        if (c.tagName === 'TR' && c.cells && c.cells.length === 1 && c.cells[0].colSpan > 1) continue;
        all++;
        var ok = !q || txt(c).indexOf(q) >= 0;
        if (ok) hit++;
        c.style.display = ok ? '' : 'none';
      }
      num.textContent = (q && all) ? (hit + '/' + all) : '';
      none.style.display = (q && all && hit === 0) ? '' : 'none';
    }

    inp.addEventListener('input', run);
    // ★다시 그려도 걸러 둔 것이 풀리지 않게 — 바뀌면 다시 건다
    if (window.MutationObserver) {
      new MutationObserver(function(){
        if (busy) return;
        busy = true;
        setTimeout(function(){
          busy = false;
          // 다시 그리면서 우리 안내가 날아갔으면 도로 넣는다
          if (none.parentNode !== list) list.appendChild(none);
          run();
        }, 0);
      }).observe(list, { childList: true });
    }
  }

  window.uiFindInit = function(root){
    var l = (root || document).querySelectorAll('[data-find]');
    for (var i = 0; i < l.length; i++) arm(l[i]);
  };

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', function(){ window.uiFindInit(); });
  else window.uiFindInit();
})();
