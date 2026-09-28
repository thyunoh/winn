// 보고서(safeRpt) ✨ 유형 추천 (TypeSafe Choice, 2026-09-28)
// ★확인할 것 : 열 때 사건경위를 미리 넣는다 · 빈 글은 알림 · 결과 칩 3개(이름·계열·%) · 칩을 누르면 srGb 가 바뀌고 srLoad 가 한 번 ·
//   NONE 1등/낮은 확률이면 「뚜렷한 유형 없음」 · ok=false(키 없음)면 이유를 회색 글로 · 통신 실패도 조용히 ·
//   같은 유형을 다시 누르면 srLoad 를 안 부른다 · 목록에 없는 코드는 막는다 · 두 번 눌러도 요청은 하나(SG_BUSY).
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');
function grab(s, re, name){ const m = s.match(re); if (!m) throw new Error('못 찾음: ' + name); return m[0]; }
const S = fs.readFileSync(path.resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/qpsmgr/qpsSafeRpt.jsp'), 'utf8')
            .replace(/\r\n/g, '\n').replace(/<c:url value="([^"]*)"\/>/g, '$1');

let pass = 0, fail = 0;
const ok = (n, c) => { if (c) { pass++; console.log('  ✅', n); } else { fail++; console.log('  ❌', n); } };

function build(){
  const dom = new JSDOM(
    '<div id="qpsSafeRpt"><select id="srGb"><option value="PTSAFE">환자안전사고 보고서</option><option value="EDURPT">직원 교육 결과 보고서</option><option value="FIRE">화재 안전 점검 보고</option></select>' +
    '<textarea id="f_summary"></textarea>' +
    '<div id="srSuggestBox" style="display:none"><textarea id="srSgText"></textarea><button id="srSgGo"></button><div id="srSgOut"></div></div></div>');
  const { window } = dom, { document } = window;
  const state = { posts: [], res: null, fail: false, loads: 0, alerts: [], toasts: [] };
  // jQuery 식 thenable — post().then(ok, fail).always(fn)
  function jq(p){ const t = { then(a, b){ return jq(p.then(a, b)); }, always(f){ p.then(f, f); return t; } }; return t; }
  const ctx = { window, document, state, Promise, Number, String, Math, Object, Array };
  const code =
    '\nfunction gel(id){ return document.getElementById(id); }' +
    '\nfunction esc(s){ return (s==null?"":String(s)).replace(/[&<>"]/g, function(c){ return ({"&":"&amp;","<":"&lt;",">":"&gt;","\\"":"&quot;"})[c]; }); }' +
    '\nfunction val(id){ var e = gel(id); return e ? String(e.value).trim() : ""; }' +
    '\nfunction gb(){ return gel("srGb").value || "PTSAFE"; }' +
    '\nvar GBS = [{subcode:"PTSAFE",subcodenm:"환자안전사고 보고서",sort:1},{subcode:"EDURPT",subcodenm:"직원 교육 결과 보고서",sort:21},{subcode:"FIRE",subcodenm:"화재 안전 점검 보고",sort:35}];' +
    '\nfunction gbNm(){ for (var i=0;i<GBS.length;i++) if (GBS[i].subcode === gb()) return GBS[i].subcodenm; return "사고 보고서"; }' +
    grab(S, /\n  var SR_BANDS = \[[\s\S]*?\]\];/, 'SR_BANDS') +
    grab(S, /\n  function srBandOf\(code\)\{[\s\S]*?\n  \}/, 'srBandOf') +
    '\nfunction _alertBox(m){ state.alerts.push(m); }' +
    '\nfunction _toast(m){ state.toasts.push(m); }' +
    '\nwindow.srLoad = function(){ state.loads++; };' +
    '\nfunction srLoad(){ window.srLoad(); }' +
    '\nfunction post(url, data){ state.posts.push({ url: url, data: data });' +
    '\n  return jq(state.fail ? Promise.reject(new Error("통신 실패")) : Promise.resolve(state.res)); }' +
    grab(S, /\n  var SG_MIN = [\s\S]*?\n  window\.srSuggestToggle = function\(\)\{[\s\S]*?\n  \};/, 'srSuggestToggle') +
    grab(S, /\n  function sgChip\(o\)\{[\s\S]*?\n  \}/, 'sgChip') +
    grab(S, /\n  window\.srSuggestGo = function\(\)\{[\s\S]*?\n  \};/, 'srSuggestGo') +
    grab(S, /\n  window\.srSuggestPick = function\(code\)\{[\s\S]*?\n  \};/, 'srSuggestPick') +
    '\nreturn { toggle: window.srSuggestToggle, go: window.srSuggestGo, pick: window.srSuggestPick };';
  const api = new Function(...Object.keys(ctx), 'jq', code)(...Object.values(ctx), jq);
  return { window, document, state, api };
}
const tick = () => new Promise(r => setTimeout(r, 5));

(async () => {
  // ① 열 때 사건경위를 미리 넣는다 · 다시 누르면 닫힌다
  { const t = build(); t.document.getElementById('f_summary').value = '환자가 침대에서 떨어졌다';
    t.api.toggle(); ok('열면 사건경위가 미리 들어간다', t.document.getElementById('srSgText').value === '환자가 침대에서 떨어졌다' && t.document.getElementById('srSuggestBox').style.display === '');
    t.document.getElementById('srSgText').value = '내가 친 글'; t.api.toggle(); t.api.toggle();
    ok('이미 친 글은 사건경위로 덮지 않는다 · 토글로 닫힌다', t.document.getElementById('srSgText').value === '내가 친 글'); }
  // ② 빈 글 → 알림, 요청 없음
  { const t = build(); t.api.go(); await tick();
    ok('빈 글은 알림만, 요청 없음', t.state.alerts.length === 1 && t.state.posts.length === 0); }
  // ③ 정상 결과 — 칩 3개(이름·계열·%), 1순위 뚜렷 안내
  { const t = build(); t.document.getElementById('srSgText').value = '밤에 환자가 넘어졌다';
    t.state.res = { ok:true, choice:'PTSAFE', confidence:0.8, none:0.01,
                    top:[{code:'PTSAFE',nm:'환자안전사고 보고서',p:0.83},{code:'FIRE',nm:'화재 안전 점검 보고',p:0.05},{code:'EDURPT',nm:'직원 교육 결과 보고서',p:0.03}] };
    t.api.go(); await tick();
    const out = t.document.getElementById('srSgOut'); const chips = out.querySelectorAll('button[data-sg]');
    ok('요청 본문에 글이 실린다', t.state.posts.length === 1 && t.state.posts[0].data.text === '밤에 환자가 넘어졌다' && /rptGbSuggest/.test(t.state.posts[0].url));
    ok('칩 3개 · 1순위 이름·계열·%', chips.length === 3 && /환자안전사고 보고서/.test(chips[0].textContent) && /사고 · 안전 보고서/.test(chips[0].textContent) && /83%/.test(chips[0].textContent));
    ok('1순위가 뚜렷하면 안내 한 줄', /1순위가 뚜렷/.test(out.textContent));
    ok('요청 끝나면 단추가 다시 눌린다', t.document.getElementById('srSgGo').disabled === false);
    // ④ 칩 클릭 → srGb 바뀌고 srLoad 한 번 · 토스트
    t.api.pick('FIRE');
    ok('칩을 누르면 유형이 바뀌고 srLoad 한 번', t.document.getElementById('srGb').value === 'FIRE' && t.state.loads === 1 && /화재 안전 점검 보고/.test(t.state.toasts[0]));
    t.api.pick('FIRE');
    ok('같은 유형을 다시 누르면 srLoad 를 안 부른다', t.state.loads === 1 && /이미 그 유형/.test(t.state.toasts[1]));
    t.api.pick('NOPE');
    ok('목록에 없는 코드는 막는다', t.document.getElementById('srGb').value === 'FIRE' && t.state.alerts.length === 1); }
  // ⑤ NONE 1등 → 추천 없음 문구(가장 가까운 것 표시)
  { const t = build(); t.document.getElementById('srSgText').value = '오늘 점심 뭐 먹지';
    t.state.res = { ok:true, choice:'NONE', confidence:0.9, none:0.9, top:[{code:'PTSAFE',nm:'환자안전사고 보고서',p:0.04}] };
    t.api.go(); await tick(); const out = t.document.getElementById('srSgOut');
    ok('NONE 1등이면 칩 없이 「뚜렷한 유형 없음」+가장 가까운 것', out.querySelectorAll('button[data-sg]').length === 0 && /뚜렷하게 맞는 유형이 없습니다/.test(out.textContent) && /4%/.test(out.textContent)); }
  // ⑥ 1등 확률이 문턱 아래(0.25) → 추천 없음
  { const t = build(); t.document.getElementById('srSgText').value = '뭔가 있었다';
    t.state.res = { ok:true, choice:'PTSAFE', confidence:0.1, none:0.2, top:[{code:'PTSAFE',nm:'환자안전사고 보고서',p:0.22},{code:'FIRE',nm:'화재',p:0.2}] };
    t.api.go(); await tick();
    ok('1등이 0.25 아래면 추천을 내지 않는다', t.document.getElementById('srSgOut').querySelectorAll('button[data-sg]').length === 0); }
  // ⑦ ok=false(키 없음) → 이유를 회색 글로, 알림창 없음
  { const t = build(); t.document.getElementById('srSgText').value = '환자가 넘어졌다';
    t.state.res = { ok:false, reason:'추천 기능이 설정되지 않았습니다(TYPESAFE_API_KEY).' };
    t.api.go(); await tick(); const out = t.document.getElementById('srSgOut');
    ok('ok=false 면 이유를 글로, 알림창 없음', /추천을 받지 못했습니다/.test(out.textContent) && /TYPESAFE_API_KEY/.test(out.textContent) && t.state.alerts.length === 0); }
  // ⑧ 통신 실패 → 조용히, 단추 복구
  { const t = build(); t.document.getElementById('srSgText').value = '환자가 넘어졌다'; t.state.fail = true;
    t.api.go(); await tick(); await tick();
    ok('통신 실패도 글로만 · 단추 복구', /닿지 못했습니다/.test(t.document.getElementById('srSgOut').textContent) && t.document.getElementById('srSgGo').disabled === false && t.state.alerts.length === 0); }
  // ⑨ 두 번 눌러도 요청은 하나(SG_BUSY)
  { const t = build(); t.document.getElementById('srSgText').value = '환자가 넘어졌다';
    t.state.res = { ok:true, choice:'PTSAFE', top:[{code:'PTSAFE',nm:'환자안전사고 보고서',p:0.9}] };
    t.api.go(); t.api.go(); await tick();
    ok('연타해도 요청은 하나', t.state.posts.length === 1); }

  console.log(`\n${pass} 통과 / ${fail} 실패`);
  process.exit(fail ? 1 : 0);
})().catch(e => { console.error(e); process.exit(1); });
