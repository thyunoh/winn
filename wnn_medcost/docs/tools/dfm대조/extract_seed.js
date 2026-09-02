/* 1단계 — 점검표 시드 SQL(docs/sql/qps/seed/*.sql)에서 서식·항목을 뽑아 forms.tsv / items.tsv 로 (2026-09-02)
   사용 : node extract_seed.js <seed 폴더>   → 이 스크립트 옆에 forms.tsv, items.tsv 를 쓴다
   - 같은 FORM_ID 를 여러 파일이 다시 시드하면(파일 이름 날짜순) **뒤 것이 이긴다**
   - SQL 주석(--)은 지우고 읽는다 */
const fs = require('fs'), path = require('path');
const SEED = process.argv[2] || path.join(__dirname, '../../sql/qps/seed'), OUT = __dirname;
const files = fs.readdirSync(SEED).filter(f => /\.sql$/i.test(f)).map(f => ({ f, d: (f.match(/(\d{4}-\d{2}-\d{2})/) || ['', ''])[1] })).sort((a, b) => a.d < b.d ? -1 : a.d > b.d ? 1 : a.f < b.f ? -1 : 1);
const forms = {}, items = {}, order = [];
files.forEach(o => {
  const s = fs.readFileSync(path.join(SEED, o.f), 'utf8').replace(/--[^\n]*/g, '');
  const re = /INSERT INTO TBL_QPS_CHK_FORM\s*\([^)]*\)\s*VALUES\s*\(\s*'([A-Z0-9_]+)'\s*,\s*'\*'\s*,\s*'([^']*)'\s*,\s*'([^']*)'\s*,\s*'([^']*)'\s*,\s*'([^']*)'\s*,\s*'([^']*)'/gi; let m;
  while ((m = re.exec(s))) { if (!forms[m[1]]) order.push(m[1]); forms[m[1]] = { id: m[1], nm: m[2], cate: m[3], dept: m[4], axis: m[5], prd: m[6], file: o.f }; items[m[1]] = []; }
  const ri = /INSERT INTO TBL_QPS_CHK_ITEM\s*\(([^)]*)\)\s*VALUES\s*([\s\S]*?);/gi;
  while ((m = ri.exec(s))) {
    const cols = m[1].split(',').map(c => c.trim().toUpperCase()), body = m[2];
    const rr = /\(([^()]*(?:\([^()]*\)[^()]*)*)\)/g; let row;
    while ((row = rr.exec(body))) {
      const vals = []; let cur = '', q = false; const str = row[1];
      for (let i = 0; i < str.length; i++) { const ch = str[i]; if (ch === "'") { if (q && str[i + 1] === "'") { cur += "'"; i++; } else q = !q; } else if (ch === ',' && !q) { vals.push(cur.trim()); cur = ''; } else cur += ch; }
      vals.push(cur.trim());
      const o2 = {}; cols.forEach((c, k) => o2[c] = (vals[k] == null ? '' : vals[k]).replace(/^'|'$/g, ''));
      if (o2.FORM_ID && items[o2.FORM_ID]) items[o2.FORM_ID].push(o2);
    }
  }
});
fs.writeFileSync(path.join(OUT, 'forms.tsv'), order.map(id => { const f = forms[id]; return [f.id, f.nm, f.cate, f.dept, f.axis, f.prd, (items[id] || []).length, f.file].join('\t'); }).join('\n'));
const lines = []; order.forEach(id => (items[id] || []).forEach(it => lines.push([id, it.SORT || '', it.ITEM_NM || '', it.GRP_NM || '', it.INPUT_GB || '', it.UNIT_NM || ''].join('\t'))));
fs.writeFileSync(path.join(OUT, 'items.tsv'), lines.join('\n'));
console.log('서식', order.length, '· 항목', lines.length, '· 항목 0개 서식', order.filter(id => !(items[id] || []).length).length);
