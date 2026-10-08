/* mis-split.js — MIS 공통 「가운데 막대로 좌우 크기 조절」 (2026-10-08, 사용자 「mis 공통으로 중간 막대로 크기조절」)
 *
 * 쓰는 법 : 두 칸짜리 grid 에  data-split="고유키"  만 붙인다.  예) <div class="ms-grid" data-split="stat.main">
 *   · 막대를 끌면 왼쪽/오른쪽 비율이 바뀌고(localStorage misSplit.<키>), 다음에 열 때 그대로다. 두 번 누르면 원래 비율.
 *   · 창이 좁아져 한 칸(미디어쿼리)으로 접히면 막대를 숨기고 인라인 비율도 거둔다 — data-split-bp(기본 1000px) 아래.
 *   · 막대는 position:absolute 라 grid 칸을 차지하지 않는다(기존 자식 2개 구조 그대로). 왼쪽 칸의 오른쪽 변에 붙어 다닌다.
 * 화면이 다시 그려져도(innerHTML) grid 자신은 그대로라 한 번 붙이면 된다. */
(function(){
  if (window.misSplit) return;
  var KEY = 'misSplit.';
  var css = '.mis-split-grid{position:relative}'
    + '.mis-split-bar{position:absolute;top:0;bottom:0;width:10px;margin-left:-5px;cursor:col-resize;z-index:5;border-radius:5px;background:transparent;transition:background .15s}'
    + '.mis-split-bar::after{content:"";position:absolute;left:4px;top:50%;width:2px;height:48px;margin-top:-24px;border-radius:2px;background:#c5d0d8}'
    + '.mis-split-bar:hover,.mis-split-bar.on{background:rgba(31,90,75,.10)} .mis-split-bar:hover::after,.mis-split-bar.on::after{background:#1f5a4b}'
    + '.mis-split-bar .tip{position:absolute;left:14px;top:50%;transform:translateY(-50%);background:#20303a;color:#fff;font-size:11px;padding:2px 7px;border-radius:6px;white-space:nowrap;display:none}'
    + '.mis-split-bar:hover .tip{display:block} body.mis-split-drag{cursor:col-resize;user-select:none}';
  var st = document.createElement('style'); st.textContent = css; document.head.appendChild(st);

  function load(k){ try { var v = parseFloat(localStorage.getItem(KEY + k)); return (v > 0.15 && v < 0.85) ? v : null; } catch(e){ return null; } }
  function save(k, v){ try { localStorage.setItem(KEY + k, String(v)); } catch(e){} }
  function clear(k){ try { localStorage.removeItem(KEY + k); } catch(e){} }

  function setup(grid){
    if (grid.__misSplit) return;
    var key = grid.getAttribute('data-split'); if (!key) return;
    var bp = Number(grid.getAttribute('data-split-bp')) || 1000;
    var orig = grid.style.gridTemplateColumns || '';        // 화면이 인라인으로 준 비율(없으면 빈 값 = CSS 규칙)
    var bar = document.createElement('div'); bar.className = 'mis-split-bar'; bar.title = '끌어서 좌우 크기 조절 · 두 번 누르면 원래대로';
    bar.innerHTML = '<span class="tip">◀ ▶ 크기 조절</span>';
    grid.classList.add('mis-split-grid'); grid.appendChild(bar);
    grid.__misSplit = true;
    var ratio = load(key);

    function kids(){ return Array.prototype.filter.call(grid.children, function(c){ return c !== bar; }); }
    function narrow(){ return window.innerWidth < bp; }
    function gap(){ var g = parseFloat(getComputedStyle(grid).columnGap || getComputedStyle(grid).gap) || 0; return g; }
    function apply(){
      var ks = kids();
      if (narrow() || ks.length < 2) { grid.style.gridTemplateColumns = orig; bar.style.display = 'none'; return; }
      if (ratio) grid.style.gridTemplateColumns = ratio + 'fr ' + (1 - ratio) + 'fr'; else grid.style.gridTemplateColumns = orig;
      bar.style.display = '';
      place();
    }
    function place(){
      var ks = kids(); if (ks.length < 2) return;
      var gr = grid.getBoundingClientRect(), a = ks[0].getBoundingClientRect();
      bar.style.left = (a.right - gr.left + gap() / 2) + 'px';
    }
    bar.addEventListener('mousedown', function(e){
      if (e.button !== 0) return; e.preventDefault();
      var gr = grid.getBoundingClientRect(), g = gap();
      document.body.classList.add('mis-split-drag'); bar.classList.add('on');
      function mv(ev){
        var x = ev.clientX - gr.left, w = gr.width - g; if (w <= 0) return;
        var r = Math.min(0.85, Math.max(0.15, (x - g / 2) / w));
        ratio = Math.round(r * 1000) / 1000;
        grid.style.gridTemplateColumns = ratio + 'fr ' + (1 - ratio) + 'fr';
        place();
      }
      function up(){ document.removeEventListener('mousemove', mv); document.removeEventListener('mouseup', up); document.body.classList.remove('mis-split-drag'); bar.classList.remove('on'); if (ratio) save(key, ratio); try { window.dispatchEvent(new Event('resize')); } catch(err){} }
      document.addEventListener('mousemove', mv); document.addEventListener('mouseup', up);
    });
    bar.addEventListener('dblclick', function(){ ratio = null; clear(key); apply(); try { window.dispatchEvent(new Event('resize')); } catch(err){} });
    window.addEventListener('resize', apply);
    if (window.ResizeObserver) { var ro = new ResizeObserver(function(){ place(); }); kids().forEach(function(k){ ro.observe(k); }); }
    apply();
  }

  /* ── 위아래(세로) 막대 : data-vsplit="키" — 그 요소 바로 아래에 가로 막대를 두고, 끌면 요소의 높이(px, 안쪽 스크롤)가 바뀐다.
     두 번 누르면 원래(자동 높이). 내용보다 크게 끌면 자동 높이로 돌아간다(빈 칸이 생기지 않게). (2026-10-08 사용자 「표시부분 위아래 크기 조정 막대」) */
  var vcss = '.mis-vsplit-bar{position:relative;height:12px;margin:2px 0 0;cursor:row-resize;border-radius:6px;transition:background .15s}'
    + '.mis-vsplit-bar::after{content:"";position:absolute;top:5px;left:50%;width:56px;height:2px;margin-left:-28px;border-radius:2px;background:#c5d0d8}'
    + '.mis-vsplit-bar:hover,.mis-vsplit-bar.on{background:rgba(31,90,75,.10)} .mis-vsplit-bar:hover::after,.mis-vsplit-bar.on::after{background:#1f5a4b}'
    + '.mis-vsplit-bar .tip{position:absolute;left:50%;top:-22px;transform:translateX(-50%);background:#20303a;color:#fff;font-size:11px;padding:2px 7px;border-radius:6px;white-space:nowrap;display:none}'
    + '.mis-vsplit-bar:hover .tip{display:block} body.mis-vsplit-drag{cursor:row-resize;user-select:none} .mis-vsplit-box{overflow:auto}';
  var vst = document.createElement('style'); vst.textContent = vcss; document.head.appendChild(vst);
  function vsetup(el){
    if (el.__misVsplit) return;
    var key = el.getAttribute('data-vsplit'); if (!key) return;
    var min = Number(el.getAttribute('data-vsplit-min')) || 120;
    var bar = document.createElement('div'); bar.className = 'mis-vsplit-bar'; bar.title = '끌어서 위아래 크기 조절 · 두 번 누르면 원래대로';
    bar.innerHTML = '<span class="tip">▲ ▼ 크기 조절</span>';
    el.parentNode.insertBefore(bar, el.nextSibling);
    el.__misVsplit = true;
    var h = null; try { var v = parseInt(localStorage.getItem(KEY + 'v.' + key), 10); if (v >= min) h = v; } catch(e){}
    function natural(){ var old = el.style.height; el.style.height = ''; el.classList.remove('mis-vsplit-box'); var n = el.scrollHeight; if (old) { el.style.height = old; el.classList.add('mis-vsplit-box'); } return n; }
    function apply(){
      if (h && h < natural() - 4) { el.style.height = h + 'px'; el.classList.add('mis-vsplit-box'); }
      else { el.style.height = ''; el.classList.remove('mis-vsplit-box'); }
    }
    bar.addEventListener('mousedown', function(e){
      if (e.button !== 0) return; e.preventDefault();
      var top = el.getBoundingClientRect().top, nat = natural();
      document.body.classList.add('mis-vsplit-drag'); bar.classList.add('on');
      function mv(ev){ var y = ev.clientY - top; h = Math.max(min, Math.round(y)); if (h >= nat - 4) h = null; apply(); }
      function up(){ document.removeEventListener('mousemove', mv); document.removeEventListener('mouseup', up); document.body.classList.remove('mis-vsplit-drag'); bar.classList.remove('on');
        try { if (h) localStorage.setItem(KEY + 'v.' + key, String(h)); else localStorage.removeItem(KEY + 'v.' + key); } catch(err){} try { window.dispatchEvent(new Event('resize')); } catch(err){} }
      document.addEventListener('mousemove', mv); document.addEventListener('mouseup', up);
    });
    bar.addEventListener('dblclick', function(){ h = null; try { localStorage.removeItem(KEY + 'v.' + key); } catch(e){} apply(); try { window.dispatchEvent(new Event('resize')); } catch(err){} });
    apply();
    // 내용이 나중에 채워지면(ajax) 저장된 높이를 다시 맞춘다
    if (window.MutationObserver) { var mo = new MutationObserver(function(){ apply(); }); mo.observe(el, { childList:true, subtree:true }); }
  }

  function init(root){ Array.prototype.forEach.call((root || document).querySelectorAll('[data-split]'), setup); Array.prototype.forEach.call((root || document).querySelectorAll('[data-vsplit]'), vsetup); }
  window.misSplit = { init: init, setup: setup, vsetup: vsetup };
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', function(){ init(); }); else init();
})();
