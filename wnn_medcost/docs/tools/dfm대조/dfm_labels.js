/* Delphi .dfm/.pas → 글자 목록 추출 (2026-09-02, v2: 입력칸 Text · Memo Lines · .pas 한글 문자열까지) */
const fs = require('fs'), path = require('path');
function decodeDelphiStr(raw) {
  let out = '', i = 0;
  while (i < raw.length) {
    const ch = raw[i];
    if (ch === "'") { i++; while (i < raw.length) { if (raw[i] === "'") { if (raw[i + 1] === "'") { out += "'"; i += 2; continue; } i++; break; } out += raw[i++]; } }
    else if (ch === '#') { let j = i + 1, num = ''; while (j < raw.length && /[0-9]/.test(raw[j])) num += raw[j++]; if (num) { out += String.fromCharCode(Number(num)); i = j; } else i++; }
    else i++;
  }
  return out;
}
function extract(p) {
  const lines = fs.readFileSync(p, 'latin1').split(/\r?\n/);
  const objs = [], stack = []; let cur = null;
  for (let k = 0; k < lines.length; k++) {
    const ln = lines[k].trim(); let m;
    if ((m = ln.match(/^(?:object|inherited|inline)\s+(\w+)\s*:\s*(\w+)/))) { cur = { name: m[1], cls: m[2], parent: stack.length ? stack[stack.length - 1].name : '', props: {} }; objs.push(cur); stack.push(cur); continue; }
    if (ln === 'end') { stack.pop(); cur = stack.length ? stack[stack.length - 1] : null; continue; }
    if (!cur) continue;
    if ((m = ln.match(/^([\w.]+)\s*=\s*(.*)$/))) {
      let key = m[1], val = m[2];
      if (val === '(') { const arr = []; while (++k < lines.length) { const t = lines[k].trim(); if (t === ')') break; if (/^['#]/.test(t)) arr.push(decodeDelphiStr(t.replace(/\)$/, ''))); if (/\)$/.test(t)) break; } cur.props[key] = arr; continue; }
      while (/\+\s*$/.test(val) && k + 1 < lines.length) { k++; val += ' ' + lines[k].trim(); }
      if (/^['#]/.test(val)) val = decodeDelphiStr(val); else if (/^-?\d+$/.test(val)) val = Number(val);
      cur.props[key] = val;
    }
  }
  return objs;
}
const INPUT_RE = /^(TcxTextEdit|TcxMemo|TcxCheckBox|TcxDateEdit|TcxComboBox|TcxImage|TEdit|TMemo|TCheckBox|TComboBox|TDateTimePicker|TcxMaskEdit|TcxSpinEdit|TcxRadioButton|TRadioButton|TcxButtonEdit|TcxTimeEdit|TcxCurrencyEdit|TcxRichEdit|TRichEdit)$/;
function labels(objs) {
  return objs.filter(o => typeof o.props.Caption === 'string' && o.props.Caption.trim() !== '' && !/^(TForm|TfrmParent)/.test(o.cls))
    .map(o => ({ name: o.name, cls: o.cls, text: String(o.props.Caption).replace(/\s+/g, ' ').trim(), src: 'caption', tag: o.props.Tag || 0 }));
}
function inputs(objs) { return objs.filter(o => INPUT_RE.test(o.cls)).map(o => ({ name: o.name, cls: o.cls, tag: o.props.Tag || 0, hint: o.props.Hint || '', width: o.props.Width, text: o.props.Text || '' })); }
/* 입력칸에 미리 적힌 글자(Text · Lines.Strings · Properties.Items) */
function inputTexts(objs) {
  const out = [];
  objs.forEach(o => {
    if (!INPUT_RE.test(o.cls) && !/Grid|Label/.test(o.cls)) return;
    Object.keys(o.props).forEach(k => {
      if (!/(^|\.)(Text|Caption|Lines\.Strings|Items\.Strings|Properties\.Items\.Strings|EditValue)$/.test(k)) return;
      const v = o.props[k]; const arr = Array.isArray(v) ? v : [v];
      arr.forEach(t => { if (typeof t === 'string' && /[가-힣A-Za-z]/.test(t) && t.trim().length >= 2) out.push({ name: o.name, cls: o.cls, text: t.replace(/\s+/g, ' ').trim(), src: 'text' }); });
    });
  });
  return out;
}
/* .pas 안의 한글 문자열 리터럴 */
function pasStrings(dfmPath) {
  const pp = dfmPath.replace(/\.dfm$/i, '.pas'); if (!fs.existsSync(pp)) return [];
  let src = fs.readFileSync(pp, 'latin1');
  // UTF-8 로 저장된 .pas 도 있다 — 한글이 latin1 로 깨져 보이면 utf8 로 다시 읽는다
  if (!/[가-힣]/.test(src) && /[\xEA-\xED][\x80-\xBF]/.test(src)) src = fs.readFileSync(pp, 'utf8');
  src = src.replace(/\{[^}]*\}/g, '').replace(/\(\*[\s\S]*?\*\)/g, '').replace(/\/\/[^\n]*/g, '');
  const out = [], re = /('(?:[^'\n]|'')*'|#\d+)+/g; let m;
  while ((m = re.exec(src))) { const t = decodeDelphiStr(m[0]).replace(/\s+/g, ' ').trim(); if (/[가-힣]/.test(t) && t.length >= 2) out.push({ text: t, src: 'pas' }); }
  return out;
}
function allTexts(dfmPath) { const objs = extract(dfmPath); return { objs, texts: labels(objs).concat(inputTexts(objs), pasStrings(dfmPath)) }; }
module.exports = { extract, labels, inputs, inputTexts, pasStrings, allTexts, decodeDelphiStr };
if (require.main === module) { const r = allTexts(process.argv[2]); const by = r.texts.reduce((a, x) => (a[x.src] = (a[x.src] || 0) + 1, a), {}); console.log(JSON.stringify({ objects: r.objs.length, by, sample: r.texts.slice(0, 40).map(x => x.src[0] + ':' + x.text) }, null, 1)); }
