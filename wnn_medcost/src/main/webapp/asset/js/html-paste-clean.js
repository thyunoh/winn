/* 붙여넣은 HTML 정리 — GPT·웹 페이지에서 복사한 글의 포장 태그(section·data-*·class)를 벗기고 글·줄바꿈·굵게·색·형광펜·표만 남긴다.
   qnacd.jsp 의 qnaCleanNode 와 같은 규칙(2026-09-04 「GPT 를 보고 복사해서 올렸는데 이렇게 나온다」 — FAQ·문의 답변 summernote 도 같이 쓴다).
   쓰는 법 : summernote callbacks.onPaste 에서 wnnPasteClean(e, $editor)  /  표시할 때 wnnUnescapeHtml(body)  */
(function () {
  var KEEP = { B: 1, STRONG: 1, I: 1, EM: 1, U: 1, BR: 1, P: 1, DIV: 1, SPAN: 1, UL: 1, OL: 1, LI: 1, TABLE: 1, TR: 1, TD: 1, TH: 1, THEAD: 1, TBODY: 1, A: 1, FONT: 1, H1: 1, H2: 1, H3: 1, H4: 1 };
  function cleanNode(n) {
    var kids = Array.prototype.slice.call(n.childNodes), i, c;
    for (i = 0; i < kids.length; i++) {
      c = kids[i];
      if (c.nodeType === 8 || (c.nodeType === 1 && /^(SCRIPT|STYLE|META|LINK|BUTTON|SVG|IMG)$/.test(c.nodeName))) { n.removeChild(c); continue; }
      if (c.nodeType !== 1) continue;
      cleanNode(c);
      if (!KEEP[c.nodeName]) { while (c.firstChild) n.insertBefore(c.firstChild, c); n.removeChild(c); continue; }   /* section·article 등은 벗기고 안의 것만 */
      var at = Array.prototype.slice.call(c.attributes), j, nm, keep;
      for (j = 0; j < at.length; j++) {
        nm = at[j].name.toLowerCase();
        keep = (nm === 'style') || (nm === 'href' && c.nodeName === 'A') || (nm === 'color' && c.nodeName === 'FONT')
            || ((nm === 'colspan' || nm === 'rowspan') && (c.nodeName === 'TD' || c.nodeName === 'TH'));
        if (!keep) c.removeAttribute(at[j].name);
      }
      if (c.getAttribute && c.getAttribute('style')) {   /* 스타일도 색·형광펜·굵기·크기만 */
        var st = c.style, ok = ['color', 'background-color', 'font-weight', 'font-size', 'text-decoration', 'font-style'], cs = '', k;
        for (k = 0; k < ok.length; k++) if (st.getPropertyValue(ok[k])) cs += ok[k] + ':' + st.getPropertyValue(ok[k]) + ';';
        if (cs) c.setAttribute('style', cs); else c.removeAttribute('style');
      }
      if (c.nodeName === 'DIV' && !c.childNodes.length && c.parentNode) { c.parentNode.removeChild(c); continue; }   /* 빈 껍데기 */
      if (c.nodeName === 'SPAN' && !c.attributes.length) { while (c.firstChild) n.insertBefore(c.firstChild, c); n.removeChild(c); }
    }
  }
  function esc(s) { return String(s == null ? '' : s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;'); }

  /** HTML 문자열 정리 */
  window.wnnCleanHtml = function (html) {
    var box = document.createElement('div'); box.innerHTML = String(html == null ? '' : html);
    cleanNode(box);
    return box.innerHTML.replace(/(<div><br><\/div>\s*){2,}/g, '<div><br></div>');
  };

  /** summernote onPaste 콜백 — 서식 있는 클립보드면 정리해서 넣고, 글자만이면 줄바꿈만 살린다 */
  window.wnnPasteClean = function (e, $editor) {
    var ev = e && e.originalEvent ? e.originalEvent : e;
    var cd = ev && (ev.clipboardData || window.clipboardData); if (!cd) return;
    var html = cd.getData('text/html'), txt = cd.getData('text/plain');
    if (!html && !txt) return;
    if (ev.preventDefault) ev.preventDefault();
    var out = html ? window.wnnCleanHtml(html) : esc(txt).replace(/\r?\n/g, '<br>');
    $editor.summernote('pasteHTML', out);
  };

  /** web.xml 의 HTMLTagFilter 가 < > & " ' 를 글자로 바꿔 저장된 본문 — 태그가 하나도 없고 &lt; 만 있으면 되돌린다(qnacd 의 qnaFixEsc 와 같음) */
  window.wnnUnescapeHtml = function (b) {
    b = String(b == null ? '' : b);
    if (b.indexOf('<') >= 0 || b.indexOf('&lt;') < 0) return b;
    return b.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&apos;/g, "'").replace(/&amp;/g, '&');
  };
})();
