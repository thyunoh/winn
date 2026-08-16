// JSP 안의 인라인 JS — **부르는데 정의가 없는 함수**를 잡는다 (2026-08-15 신설).
//
//   쓰는 때 : JSP 의 스크립트를 크게 들어낸 뒤.
//   왜      : 편집 중 함수 정의가 통째로 잘려도 **화면은 조용히 죽는다.**
//             실제 증상은 「제목은 바뀌는데 그 아래는 안 바뀜」이었다(udCopyMsg).
//   쓰는 법 : node docs/tools/JSP함수검사.js <파일…>
//   ⚠`window.f = function` 은 전역이라 맨이름 호출이 된다 — 그것까지 정의로 센다.
const fs = require('fs');
const files = process.argv.slice(2);
let bad = 0;
files.forEach(f => {
  const s = fs.readFileSync(f, 'utf8');
  // 정의 : function 이름( · window.이름 = function · var 이름 = function
  const def = new Set();
  [...s.matchAll(/function\s+([A-Za-z_$][\w$]*)\s*\(/g)].forEach(m => def.add(m[1]));
  [...s.matchAll(/window\.([A-Za-z_$][\w$]*)\s*=\s*function/g)].forEach(m => def.add(m[1]));
  [...s.matchAll(/(?:var|let|const)\s+([A-Za-z_$][\w$]*)\s*=\s*function/g)].forEach(m => def.add(m[1]));
  // 호출 : 이름( — 우리 규약상 ud/ck/sr 로 시작하는 것만 본다(브라우저·jQuery 내장 제외)
  const called = new Set();
  [...s.matchAll(/\b((?:ud|ck|sr)[A-Za-z_$][\w$]*)\s*\(/g)].forEach(m => called.add(m[1]));
  const miss = [...called].filter(n => !def.has(n)).sort();
  console.log(f.split('/').pop() + ' : 정의 ' + def.size + ' · 호출 ' + called.size +
              (miss.length ? '  ⛔없는 정의 → ' + miss.join(', ') : '  ✅모두 정의됨'));
  bad += miss.length;
});
process.exit(bad ? 1 : 0);
