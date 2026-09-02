/* 원본 dfm 의 체크 묶음 중 우리 DEF 에 없는 묶음을 시드로 생성 (2026-09-02)
   규칙 : ① 우리 묶음과 항목이 반 이상 겹치면 「이미 있음」 ② 하나라도 겹치면 그 묶음에 빠진 항목만 보탬(유형 전용 묶음일 때만)
          ③ 안 겹치면 새 묶음(ORGn) — 이름은 RENAME, 체크 묶음이 아닌 것(점수 칸 라벨·약물별 반복 열)은 SKIP
   산출 = ../../sql/qps/seed/QPS_SAFERPT_SEED_CHK2_2026-09-02.sql (머리에 1차 ORG 묶음 정리 DELETE 포함) */
const fs = require('fs'), path = require('path'), L = require('./dfm_labels.js');
const idx = new Map(fs.readFileSync(path.join(__dirname, 'dfm_index.tsv'), 'utf8').split(/\r?\n/).filter(Boolean).map(l => l.split('\t')));
function tuples(body) {
  const out = []; let depth = 0, q = false, cur = '', row = null;
  for (let i = 0; i < body.length; i++) {
    const ch = body[i];
    if (q) { if (ch === "'") { if (body[i + 1] === "'") { cur += "'"; i++; } else q = false; } else cur += ch; continue; }
    if (ch === "'") { q = true; continue; }
    if (ch === '(') { if (depth === 0) { row = []; cur = ''; } depth++; continue; }
    if (ch === ')') { depth--; if (depth === 0 && row) { row.push(cur.trim()); out.push(row); row = null; cur = ''; } continue; }
    if (ch === ',' && depth === 1) { row.push(cur.trim()); cur = ''; continue; }
    if (depth >= 1) cur += ch;
  }
  return out;
}
const DEF = {}, USE = {};
['../../sql/qps/ddl', '../../sql/qps/seed'].forEach(d => fs.readdirSync(path.join(__dirname, d)).filter(f => /\.sql$/i.test(f) && !/CHK2/.test(f)).sort().forEach(f => {
  const s = fs.readFileSync(path.join(__dirname, d, f), 'utf8').replace(/--[^\n]*/g, ''); let m;
  const re = /INSERT INTO TBL_QPS_SAFERPT_DEF\s*\([^)]*\)\s*VALUES([\s\S]*?)(?:ON DUPLICATE[\s\S]*?)?;/gi;
  while ((m = re.exec(s))) tuples(m[1]).forEach(v => { if (v.length < 8) return; const [gb, grp, gnm, item] = v; ((DEF[gb] = DEF[gb] || {})[grp] = DEF[gb][grp] || { nm: gnm, items: [] }).items.push(item); });
  const ru = /INSERT INTO TBL_QPS_SAFERPT_USE\s*\([^)]*\)\s*VALUES([\s\S]*?)(?:ON DUPLICATE[\s\S]*?)?;/gi;
  while ((m = ru.exec(s))) tuples(m[1]).forEach(v => { (USE[v[0]] = USE[v[0]] || []).push(v[1]); });
}));
const norm = s => String(s).toLowerCase().replace(/[\s()（）·.,:/\-]/g, '');
const q = s => "'" + String(s).replace(/'/g, "''") + "'";
// 대상 유형 ↔ 원본 폼(변형 판단 끝난 것)
const T = { PTSAFE: 'RPT_Chart_001', BEDSORE: 'RPT_Chart_002_A', INFEXP: 'RPT_Chart_004', STAFF: 'RPT_Chart_003', HAZMAT: 'RPT_Chart_006',
  SWINTAKE: 'WEL_Chart_007', NUTREC: 'Meal_Chart_041', SWVULN: 'WEL_Chart_014', MRFIX: 'HEALTH_Chart_025', SYSAUTH: 'HEALTH_Chart_028',
  SELFDIS: 'Employee_Chart_027', ABUSE: 'RPT_Chart_009', PRIVACY: 'Employee_Chart_026', INFDIS: 'RPT_Chart_005', DRUGADRE: 'Pharm_Chart_039' };
const SKIP = { PTSAFE: ['의식상태'], BEDSORE: ['욕창 위험 사정 감수', '욕창 발생 부위', '단계'], INFEXP: ['임신여부', '환자에 대한 정보(노출대상)'], DRUGADRE: ['E', 'F'], INFDIS: ['의식상태'] };
const RENAME = { SELFDIS: { '보고부서': '대리인 서명사유' }, PRIVACY: { '보고부서': '요청 항목', '요청': '요청 여부' }, DRUGADRE: { 'D': '부작용 경과' },
  BEDSORE: { '욕창 발생 후 보고': '발생 후 보고', '가로': '크기 - 가로', '세로': '크기 - 세로', '깊이': '크기 - 깊이' },
  PTSAFE: { '낙상위험요인': '환경 위험요인', '진단명': '관련 진단', '투약전발견': '투약오류 (투약 전 발견)', '투약후발견': '투약오류 (투약 후 발견)' },
  MRFIX: { '정 정 요 구': '정정 요구 처리' }, SYSAUTH: { '신청구분': '신청 구분', '요청사항': '요청 권한' } };
const sqlDef = [], sqlUse = [], md = [];
Object.keys(T).forEach(id => {
  const u = T[id], o = L.extract(idx.get(u)); const pas = fs.readFileSync(idx.get(u).replace(/dfm$/, 'pas'), 'utf8'); const excl = /Hint = TcxCheckBox\((S|s)ender\)\.Hint/.test(pas);
  const cbs = o.filter(x => /TcxCheckBox/.test(x.cls) && typeof x.props.Top === 'number' && x.props.Caption && !/Check ALL|사진사이즈/i.test(x.props.Caption)).sort((a, b) => (a.props.Top - b.props.Top) || (a.props.Left - b.props.Left));
  const labs = o.filter(x => /TLabel|TcxLabel/.test(x.cls) && x.props.Caption && typeof x.props.Top === 'number');
  const groups = [], byKey = {};
  cbs.forEach(c => {
    const hint = String(c.props.Hint || '').trim();
    const near = labs.filter(l => Math.abs(l.props.Top - c.props.Top) <= 28 && l.props.Left < c.props.Left).sort((a, b) => (c.props.Left - a.props.Left) - (c.props.Left - b.props.Left))[0];
    const key = hint || (near ? near.props.Caption.trim() : '?');
    if (!byKey[key]) { byKey[key] = { key, hint: !!hint, items: [] }; groups.push(byKey[key]); }
    byKey[key].items.push(c.props.Caption.trim());
  });
  const oursG = (USE[id] || []).map(g => ({ cd: g, def: (DEF[id] && DEF[id][g]) || (DEF['*'] && DEF['*'][g]) })).filter(x => x.def);
  let n = 0; const added = [], same = [], merged = [];
  groups.forEach(g => {
    // 「신 규」「연 장」「기 타」처럼 두 글자를 벌려 쓴 원본 캡션은 붙인다(글자 사이 한 칸, 두 글자짜리만)
    const items0 = [...new Set(g.items.map(t => t.replace(/\s+/g, ' ').replace(/\s*[:：,]\s*$/, '').replace(/^([가-힣]) ([가-힣])$/, '$1$2').replace(/^기타\s*\(\s*\)$/, '기타').trim()).filter(t => norm(t).length > 1 && !/^\(\s*\)$/.test(t)))];
    // 「기타」 계열은 맨 뒤로 — 1차 시드(CHK)와 같은 차례(원본은 화면 배치 순이라 앞에 오기도 한다)
    const isEtc = it => /기타|알 수 없음|알수없음/.test(it);
    const items = items0.filter(it => !isEtc(it)).concat(items0.filter(isEtc));
    if (items.length < 2) return;
    if ((SKIP[id] || []).indexOf(g.key) >= 0) return;
    // ★겹침은 「기타·없음·모름」 같은 범용 항목을 빼고 센다 — 안 빼면 「기타」 하나로 전혀 다른 묶음이 합쳐진다(1차에서 겪음)
    const GEN = /^(기타|없음|모름|해당없음|알수없음|알 수 없음)$/;
    const real = items.filter(it => !GEN.test(it.replace(/\s/g, '')));
    const dice = (a, b) => { const A = norm(a), B = norm(b); if (!A || !B) return 0; const bg = s => { const o = []; for (let i = 0; i < s.length - 1; i++) o.push(s.slice(i, i + 2)); return o; }; const x = bg(A), y = bg(B); const m = new Map(); x.forEach(t => m.set(t, (m.get(t) || 0) + 1)); let h = 0; y.forEach(t => { const c = m.get(t); if (c) { h++; m.set(t, c - 1); } }); return x.length + y.length ? 2 * h / (x.length + y.length) : 0; };
    let best = null;
    const curated = !!(RENAME[id] || {})[g.key];   // 이름을 손질하기로 한 묶음은 새 묶음으로만(기존에 합치지 않는다)
    // 항목 일치 = 같거나 **앞부분 포함**(「대리인」 ↔ 「대리인(환자의 관계」) — 원본 라벨이 괄호를 달고 끝나는 경우가 많다
    const hit = (set, it) => { const n = norm(it); return set.has(n) || [...set].some(x => x.length >= 2 && n.length >= 2 && (x.startsWith(n) || n.startsWith(x))); };
    if (!curated) oursG.forEach(x => { const set = new Set(x.def.items.map(norm)); const ov = real.filter(it => hit(set, it)).length; const nmSim = dice(x.def.nm, g.key);
      if ((ov >= 2 || (ov >= 1 && (nmSim >= 0.5 || real.length <= 2))) && (!best || ov > best.ov)) best = { x, ov }; });
    if (best && best.ov >= Math.ceil(real.length / 2)) { same.push(g.key + '(' + items.length + ')'); return; }
    const etcOf = it => isEtc(it) ? 'Y' : 'N';
    if (best) {
      if (!(DEF[id] && DEF[id][best.x.cd])) { same.push(g.key + '(공유묶음 ' + best.x.cd + ')'); return; }
      const set = new Set(best.x.def.items.map(norm)); let k = best.x.def.items.length; const add = items.filter(it => !hit(set, it));
      add.forEach(it => sqlDef.push('(' + [q(id), q(best.x.cd), q(best.x.def.nm), q(it), q(g.hint && excl ? 'N' : 'Y'), q(etcOf(it)), ++k, q('Y')].join(',') + ')'));
      merged.push(best.x.def.nm + '+' + add.length); return;
    }
    n++; const code = 'ORG' + n; const nm = ((RENAME[id] || {})[g.key] || (g.key === '?' ? ('묶음' + n) : g.key)).replace(/\s*[:：]\s*$/, '');
    const multi = (g.hint && excl) ? 'N' : 'Y';
    items.forEach((it, i) => sqlDef.push('(' + [q(id), q(code), q(nm), q(it), q(multi), q(etcOf(it)), i + 1, q('Y')].join(',') + ')'));
    sqlUse.push('(' + [q(id), q(code), (USE[id] || []).length + n, q('Y')].join(',') + ')');
    added.push(nm + '(' + items.length + ', ' + (multi === 'N' ? '하나만' : '여럿') + ')');
  });
  md.push('| ' + id + ' | ' + u + ' | ' + (same.join(' · ') || '—') + ' | ' + (merged.join(' · ') || '—') + ' | ' + (added.join(' · ') || '—') + ' |');
});
const types = Object.keys(T).map(q).join(',');
const head = `-- ═══════════════════════════════════════════════════════════════════════════
-- safeRpt 체크 묶음 보강 2차 — 원본에 있는데 우리 DEF 에 없는 묶음 (2026-09-02, 자동 생성 + 손질)
--   생성 = docs/tools/dfm대조/gen_saferpt_def.js : 원본 dfm 의 TcxCheckBox 를 Hint/라벨로 묶고,
--   ① 우리 묶음과 항목이 반 이상 겹치면 「이미 있음」 ② 하나라도 겹치면 그 묶음에 빠진 항목만 보탬 ③ 안 겹치면 새 묶음(ORGn).
--   MULTI_YN = 원본 .pas 가 Hint 배타면 N(라디오), 아니면 Y. ETC_YN = 「기타」 항목. 점수 칸 라벨·약물별 반복 열은 뺐다.
--   ⚠기존 묶음·항목은 손대지 않는다(작성분의 체크가 그 글자로 저장돼 있다). 재실행 안전.
-- ═══════════════════════════════════════════════════════════════════════════
-- ★1차 자동생성본(09-02 오후, 이름 손질 전 — SELFDIS 「보고부서」·DRUGADRE 「D/E/F」 등)을 먼저 지운다.
--   ORG 묶음은 이 파일만 만들고, 작성분이 쓰기 전에 돌렸으므로 안전하다.
DELETE FROM TBL_QPS_SAFERPT_USE WHERE RPT_GB IN (${types}) AND GRP_CD LIKE 'ORG%';
DELETE FROM TBL_QPS_SAFERPT_DEF WHERE RPT_GB IN (${types}) AND GRP_CD LIKE 'ORG%';

`;
const out = head +
  'INSERT INTO TBL_QPS_SAFERPT_DEF (RPT_GB,GRP_CD,GRP_NM,ITEM_NM,MULTI_YN,ETC_YN,SORT,USE_YN) VALUES\n ' + sqlDef.join(',\n ') +
  "\nON DUPLICATE KEY UPDATE GRP_NM=VALUES(GRP_NM), MULTI_YN=VALUES(MULTI_YN), ETC_YN=VALUES(ETC_YN), SORT=VALUES(SORT), USE_YN='Y';\n\n" +
  'INSERT INTO TBL_QPS_SAFERPT_USE (RPT_GB,GRP_CD,SORT,USE_YN) VALUES\n ' + sqlUse.join(',\n ') + "\nON DUPLICATE KEY UPDATE SORT=VALUES(SORT), USE_YN='Y';\n\n" +
  '-- 확인\nSELECT RPT_GB, GRP_CD, GRP_NM, COUNT(*) n FROM TBL_QPS_SAFERPT_DEF WHERE RPT_GB IN (' + types + ") AND USE_YN='Y' GROUP BY RPT_GB, GRP_CD, GRP_NM ORDER BY RPT_GB, GRP_CD;\n";
fs.writeFileSync(path.join(__dirname, '../../sql/qps/seed/QPS_SAFERPT_SEED_CHK2_2026-09-02.sql'), out.replace(/\r?\n/g, '\r\n'));
console.log('DEF 행', sqlDef.length, '· 새 묶음', sqlUse.length);
console.log('| 유형 | 원본 폼 | 이미 있음 | 기존 묶음에 보탬(+항목수) | 새 묶음(항목수, 선택) |\n|---|---|---|---|---|\n' + md.join('\n'));
