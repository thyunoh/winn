// 가짜 DOM 시뮬 전부 돌리기 — QPS 화면의 인라인 JS 를 소스 JSP 에서 그대로 꺼내 jsdom 으로 검사한다 (2026-09-02)
//   쓰는 법 : cd docs/tools/sim && npm i && node run_all.js     (jsdom 만 필요)
//   하나만  : node sim_qpsChk_ward.js
//   ★소스 JSP 를 고치면 여기부터 돌린다 — 화면을 열어 보기 전에 논리 회귀를 잡는다.
const { execFileSync } = require('child_process');
const fs = require('fs'), path = require('path');
const files = fs.readdirSync(__dirname).filter(f => /^sim_.*\.js$/.test(f)).sort();
let allPass = 0, allFail = 0, broken = 0;
for (const f of files) {
  let out = '', code = 0;
  try { out = execFileSync(process.execPath, [path.join(__dirname, f)], { encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] }); }
  catch (e) { out = (e.stdout || '') + (e.stderr || ''); code = e.status || 1; }
  const m = out.match(/통과 (\d+) · 실패 (\d+)/) || out.match(/(\d+) 통과.*?(\d+) 실패/);
  const p = m ? Number(m[1]) : 0, q = m ? Number(m[2]) : 0;
  allPass += p; allFail += q; if (!m || code) broken++;
  console.log((code || !m ? '❌' : (q ? '⚠' : '✅')) + ' ' + f.padEnd(26) + (m ? ('통과 ' + p + ' · 실패 ' + q) : '결과 못 읽음(스크립트 오류)'));
  if (code || q) console.log(out.split(/\r?\n/).filter(l => /❌|Error|오류/.test(l)).slice(0, 8).map(l => '     ' + l).join('\n'));
}
console.log('\n합계 통과 ' + allPass + ' · 실패 ' + allFail + (broken ? (' · 못 돈 파일 ' + broken) : ''));
process.exit(allFail || broken ? 1 : 0);
