/* =====================================================================
   공통 UI — **마우스로 끌어 넓이·높이 바꾸기** (2026-09-03)
   ---------------------------------------------------------------------
   사용법: 페이지에 <script src="/asset/js/ui-split.js"></script> 한 줄.
     화면 표시(마크업)에 이렇게 적어 두면 끝이다 —

       <div class="rd-body" data-split="가로" data-split-key="rptdef.body">
         <div class="rd-left">…</div>        ← 첫 칸이 조절 대상
         <div class="rd-right">…</div>
       </div>

       <div class="rd-left" data-split="세로" data-split-key="rptdef.left">
         <div>…</div>                        ← 첫 칸이 조절 대상
         <div>…</div>
       </div>

     · `data-split="가로"` = 옆으로 나뉜 것 → **세로 손잡이**를 넣어 좌우 넓이를 바꾼다
     · `data-split="세로"` = 위아래로 나뉜 것 → **가로 손잡이**를 넣어 높이를 바꾼다
     · `data-split-key` 를 주면 **그 사람 브라우저에 기억**한다(localStorage). 안 주면 안 기억한다.
     · 손잡이를 **두 번 누르면** 처음 크기로 돌아간다.

   ★왜 공통으로 두나 — 화면마다 손잡이를 따로 만들면 **화면마다 조금씩 다르게 움직인다.**
     쓰는 사람은 한 번 익히면 어디서나 같아야 한다. 그래서 한 곳에만 둔다.

   ⚠**기억은 이 브라우저에만 남는다**(localStorage). PC 를 바꾸면 처음 크기다 —
     자리 배치는 사람마다·화면마다 달라서 서버에 담을 값이 아니다.
     ***「다른 PC 에서도 그대로였으면」 하는 말이 나오면 그때 서버로 옮긴다.***

   · jQuery 불필요 — 어느 화면에서나 동작
   ===================================================================== */
(function(){
  if (window._uiSplitLoaded) return;      // 중복 로드 방지
  window._uiSplitLoaded = true;

  var KEY = 'wnnSplit.';
  var MIN = 120;                          // 어느 쪽도 이보다 작아지지 않는다 — 0 이 되면 되돌릴 길이 없다

  /* ── 손잡이 모양 ──────────────────────────────────────────────────
     ★가늘게 두되 **잡는 자리는 넓게**(가운데 선은 3px, 잡히는 폭은 9px).
       선을 굵게 그리면 화면이 답답하고, 잡는 자리가 좁으면 못 잡는다. */
  var CSS =
    '.uisp-h{flex:0 0 9px;align-self:stretch;cursor:col-resize;position:relative;touch-action:none;}'
  + '.uisp-v{flex:0 0 9px;align-self:stretch;cursor:row-resize;position:relative;touch-action:none;}'
  + '.uisp-h::before{content:"";position:absolute;top:0;bottom:0;left:3px;width:3px;border-radius:2px;background:#dde5ea;transition:background .12s;}'
  + '.uisp-v::before{content:"";position:absolute;left:0;right:0;top:3px;height:3px;border-radius:2px;background:#dde5ea;transition:background .12s;}'
  + '.uisp-h:hover::before,.uisp-v:hover::before,.uisp-on::before{background:#2a7665 !important;}'
  + '.uisp-drag,.uisp-drag *{user-select:none !important;}'
  + '.uisp-drag{cursor:inherit;}';

  var st = document.createElement('style');
  st.textContent = CSS;
  document.head.appendChild(st);

  function num(v, d){ v = parseFloat(v); return isFinite(v) ? v : d; }
  function save(key, v){ if (!key) return; try { localStorage.setItem(KEY + key, String(v)); } catch (e) {} }
  function load(key){ if (!key) return null; try { return localStorage.getItem(KEY + key); } catch (e) { return null; } }

  /**
   * 한 곳을 조절할 수 있게 만든다.
   * @param box  나뉜 두 칸을 담고 있는 상자(flex)
   */
  function arm(box){
    if (box._uispDone) return;
    var kids = [];
    for (var i = 0; i < box.children.length; i++) {
      var c = box.children[i];
      if (c.nodeType === 1 && !c.classList.contains('uisp-h') && !c.classList.contains('uisp-v')) kids.push(c);
    }
    if (kids.length < 2) return;           // 나눌 것이 없으면 아무것도 안 한다
    box._uispDone = true;

    var mode = (box.getAttribute('data-split') || '').trim();
    var col  = (mode === '가로' || mode === 'x' || mode === 'col');   // 옆으로 나뉜 것
    var key  = box.getAttribute('data-split-key') || '';
    var a    = kids[0];                    // 조절 대상은 **첫 칸**

    // 처음 크기를 적어 둔다 — 두 번 누르면 여기로 돌아온다
    var base = col ? a.getBoundingClientRect().width : a.getBoundingClientRect().height;

    function put(px){
      px = Math.round(px);
      if (col) { a.style.width = px + 'px'; a.style.flex = '0 0 ' + px + 'px'; }
      else     { a.style.height = px + 'px'; a.style.flex = '0 0 ' + px + 'px'; }
    }
    // 기억해 둔 것이 있으면 되살린다
    var had = num(load(key), 0);
    if (had >= MIN) put(had);

    var bar = document.createElement('div');
    bar.className = col ? 'uisp-h' : 'uisp-v';
    bar.setAttribute('title', '끌어서 크기 조절 · 두 번 누르면 처음대로');
    box.insertBefore(bar, kids[1]);

    var drag = null;
    function down(ev){
      var p = ev.touches ? ev.touches[0] : ev;
      var r = a.getBoundingClientRect();
      drag = { s: col ? p.clientX : p.clientY, w: col ? r.width : r.height };
      bar.classList.add('uisp-on');
      document.body.classList.add('uisp-drag');
      document.body.style.cursor = col ? 'col-resize' : 'row-resize';
      ev.preventDefault();
    }
    function move(ev){
      if (!drag) return;
      var p = ev.touches ? ev.touches[0] : ev;
      var d = (col ? p.clientX : p.clientY) - drag.s;
      var br = box.getBoundingClientRect();
      // ★반대쪽도 MIN 은 남겨 둔다 — 한쪽을 끝까지 밀어 **못 되돌리는 일**이 없게
      var most = (col ? br.width : br.height) - MIN - 9;
      put(Math.max(MIN, Math.min(most, drag.w + d)));
      ev.preventDefault();
    }
    function up(){
      if (!drag) return;
      drag = null;
      bar.classList.remove('uisp-on');
      document.body.classList.remove('uisp-drag');
      document.body.style.cursor = '';
      save(key, col ? a.getBoundingClientRect().width : a.getBoundingClientRect().height);
      if (typeof window.uiSplitChanged === 'function') window.uiSplitChanged(box);
    }
    bar.addEventListener('mousedown', down);
    bar.addEventListener('touchstart', down, { passive: false });
    document.addEventListener('mousemove', move);
    document.addEventListener('touchmove', move, { passive: false });
    document.addEventListener('mouseup', up);
    document.addEventListener('touchend', up);
    bar.addEventListener('dblclick', function(){
      a.style.width = ''; a.style.height = ''; a.style.flex = '';
      if (key) { try { localStorage.removeItem(KEY + key); } catch (e) {} }
      if (typeof window.uiSplitChanged === 'function') window.uiSplitChanged(box);
    });
  }

  /** 화면에 있는 `data-split` 을 전부 찾아 손잡이를 단다. 화면을 다시 그린 뒤 또 불러도 된다. */
  window.uiSplitInit = function(root){
    var list = (root || document).querySelectorAll('[data-split]');
    for (var i = 0; i < list.length; i++) arm(list[i]);
  };

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', function(){ window.uiSplitInit(); });
  else window.uiSplitInit();
})();
