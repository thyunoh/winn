const fs=require('fs'); const D=JSON.parse(fs.readFileSync('compare_detail.json','utf8'));
const esc=s=>String(s).replace(/\|/g,'\|');
const all=D.filter(r=>r.seed!=null); const full=all.filter(r=>r.miss===0); const part=all.filter(r=>r.miss>0);
const suspect=part.filter(r=>r.hit===0 && r.dfmLabels>=8);     // 유닛 오매칭 의심 또는 항목 이름을 통째로 다르게 읽음
const partial=part.filter(r=>!(r.hit===0 && r.dfmLabels>=8));
let md=`# QPS 시드 ↔ SUNWOO dfm 자동 대조 (2026-09-02)

> 캡처를 눈으로 읽어 만든 점검표 시드(\`docs/sql/qps/seed/*.sql\`, 서식 173 · 항목 1,869)를 **델파이 원본 .dfm/.pas 의 글자**와
> 자동으로 맞춰 본 결과. 스크립트 = scratch \`dfm/{match_forms,dfm_labels,compare,report}.js\`
> (이름 매칭 → dfm 캡션·입력칸 Text·Memo 줄·.pas 한글 문자열 추출 → 항목별 2-gram 유사도 ≥0.75 또는 포함이면 일치).
> ⚠**자동 판정이다** — 「시드에만」은 오독일 수도, SUNWOO 가 DB 에서 채우는 병원 자료일 수도, 우리가 일부러 다르게 만든 것일 수도 있다.
> 아래 표는 사람이 볼 후보 목록이지 결론이 아니다.

## 0. 숫자

| | 서식 | 항목 |
|---|---|---|
| 대조한 것 (이름으로 dfm 을 찾은 것) | ${all.length} / 173 | ${all.reduce((a,r)=>a+r.seed,0)} |
| **시드 항목 전부 dfm 에서 확인** | **${full.length}** | ${full.reduce((a,r)=>a+r.seed,0)} |
| 일부 불일치 | ${partial.length} | 시드에만 ${partial.reduce((a,r)=>a+r.miss,0)} |
| ★**하나도 안 맞음(유닛 오매칭 또는 항목을 통째로 다르게 읽음)** | **${suspect.length}** | 시드에만 ${suspect.reduce((a,r)=>a+r.miss,0)} |
| dfm 을 못 찾음 | ${173-all.length} | |

일치 ${all.reduce((a,r)=>a+r.hit,0)} / ${all.reduce((a,r)=>a+r.seed,0)} = **${(100*all.reduce((a,r)=>a+r.hit,0)/all.reduce((a,r)=>a+r.seed,0)).toFixed(1)}%** — 캡처 판독이 대체로 정확했다는 뜻이고, 나머지는 아래에서 하나씩 본다.

## 1. ★하나도 안 맞는 서식 ${suspect.length}종 — 먼저 볼 것

유닛 이름은 닮았는데 항목이 하나도 안 맞는다. ①**다른 서식에 붙었거나**(SUNWOO 에 같은 이름 변형 폼 여럿) ②**SUNWOO 는 체크박스 격자 + 고정 라벨인데 우리는 항목 이름을 다르게 적었거나** ③항목이 DB 에서 온다.

| 코드 | 서식 | 축 | 붙은 유닛(점수) · 유닛 이름 | 다른 후보 | 시드 | dfm 체크/글자칸 | 시드에만 있는 항목 | dfm 에만 있는 글자 |
|---|---|---|---|---|---|---|---|---|
`;
suspect.sort((a,b)=>b.miss-a.miss).forEach(r=>{ md+=`| ${r.id} | ${esc(r.nm)} | ${r.axis} | ${r.unit} (${r.score}) ${esc(r.unitNm||'')} | ${esc(r.others||'')} | ${r.seed} | ${r.cb}/${r.te} | ${esc(r.missList.slice(0,8).map(x=>x.replace(/ ≈.*$/,'')).join(' · '))}${r.missList.length>8?' …+'+(r.missList.length-8):''} | ${esc(r.extraList.slice(0,10).join(' · '))}${r.extraList.length>10?' …+'+(r.extraList.length-10):''} |\n`; });
md+=`
## 2. 일부 불일치 ${partial.length}종

「시드에만」 옆의 \`≈글자(점수)\` 는 dfm 에서 가장 가까운 글자다 — **0.5~0.74 면 띄어쓰기·조사 차이일 가능성이 크고**(고칠 값어치 낮음), 0.3 이하면 다른 항목이다.

| 코드 | 서식 | 시드 | 일치 | 시드에만 있는 항목 (≈가장 가까운 dfm 글자) | dfm 에만 있는 글자(상위) |
|---|---|---|---|---|---|
`;
partial.sort((a,b)=>b.miss-a.miss).forEach(r=>{ md+=`| ${r.id} | ${esc(r.nm)} | ${r.seed} | ${r.hit} | ${esc(r.missList.slice(0,10).join(' · '))}${r.missList.length>10?' …+'+(r.missList.length-10):''} | ${esc(r.extraList.slice(0,8).join(' · '))}${r.extraList.length>8?' …+'+(r.extraList.length-8):''} |\n`; });
md+=`
## 3. 전부 확인된 서식 ${full.length}종

${full.map(r=>r.id).sort().join(' · ')}

## 4. 이름 1순위와 다른 dfm 을 고른 서식 ${all.filter(r=>r.unit!==r.nameFirst).length}종

이름만으로는 다른 유닛에 붙었을 것들 — **항목 일치 수로 바로잡았다.** 앞선 문서들이 SUNWOO 유닛을 인용할 때는 이 표의 오른쪽을 쓴다.

| 코드 | 서식 | 이름으로 고른 유닛 | → 항목으로 고른 유닛 (일치/시드) |
|---|---|---|---|
${all.filter(r=>r.unit!==r.nameFirst).sort((a,b)=>a.id<b.id?-1:1).map(r=>`| ${r.id} | ${esc(r.nm)} | ${r.nameFirst} | **${r.unit}** ${esc(r.unitNm||'')} (${r.hit}/${r.seed}) |`).join('\n')}

## 5. 사람이 볼 것 — 남은 ${partial.length}종 판독 (2026-09-02)

| 묶음 | 서식 | 무엇인가 | 할 일 |
|---|---|---|---|
| **A. 항목 대부분이 다른 서식(캡처가 다른 변형이었을 가능성)** | NUR003 낙상예방 시설환경 점검표 (4/18) · RNL019 낙상 시설,환경 관리일지(인공신장) (5/15) | SUNWOO 에 낙상 시설환경 점검표 변형이 넷(WARD_135·150·107·KIDNEY_002)인데 어느 것과도 반이 안 맞는다. 캡처가 **병원이 항목을 고쳐 쓴 문서**였거나 다른 변형이다 | 캡처(세션 기록 caps/)와 WARD_Chart_135 라벨을 사람이 나란히 본다. 병원 자료였다면 시드 항목을 **원본 라벨로 되돌린다** |
| **B. 병원이 채우는 내용을 항목으로 박은 의심** | ADM003 연간 활동계획 (16/24 — 「대상자 선정·접종 실시·2차검진」) · FAC032 방화 보안·순찰 일지 (27/32 — 「강당·현금입출금기·알람밸브실·탕비실」) | SUNWOO 에서 이 줄들은 라벨이 아니다(글자칸 값). 우리는 **캡처에 적혀 있던 그 병원의 순찰 지점·계획 내용**을 표준 항목으로 넣은 셈 — 「약품 이름은 서식에 넣지 않는다」와 같은 문제 | 병원 자료인 줄은 항목에서 빼고 LIST/자유행으로 돌리거나, 그대로 두되 병원이 고칠 수 있게(CARRY) 둔다 — **판단 필요** |
| **C. 묶음(그룹) 이름 표현 차이 — 고칠 것 없음** | FAC028 (소화설비·기구/자동화재경보설비/피난·방화설비/화기취급) · PHA009 (업무전/조제환경/업무후) | SUNWOO 는 묶음을 ⦿머리글·번호로 그렸고 우리는 GRP_NM 으로 세웠다. 뜻은 같다 | 없음 |
| **D. 한두 항목 표기 차이 — 5분짜리 확인** | NUT004 「냉장 & 냉동고」(전각 ＆) · 「1주 1일」↔「1주일」 · NUR066 「D-set·Can」 · ADM016 「정상동작 여부·제품의 수령 상태」 · FAC021 「8 맛」(?) · PHA023 「이중잠금」 · NUR027 「바닥 물팀 청소」(물때?) · REH001 「전원 결함 여부」(dfm 은 「결합」 — **SUNWOO 오타**) · RNL006 「침대 부속물(SIDE RAIL, 바퀴잠금장치)」 | 띄어쓰기·기호·오타 수준 | 시드가 맞는 쪽이면 그대로. 「8 맛」「물팀」은 시드 오타 의심 — 캡처 한 번 보고 고친다 |

## 6. 이 대조가 못 보는 것

- **입력 종류**(CHECK/NUM/TEXT)는 아직 안 맞춰 봤다 — dfm 의 TcxCheckBox 수 vs 시드 CHECK 수로 다음에 본다(표의 「dfm 체크/글자칸」이 그 재료).
- **DB 에서 채우는 항목**: \`f_get_BeforeDevice\`(33종 — 의료기기 목록 서식에서 장비 이름을 가져옴) · \`f_checkList/t_list\`(78종) 로 채우는 이름은 dfm 에 없다. 이런 서식은 「시드에만」이 곧 **우리가 병원 자료를 서식에 박은 것**일 수 있다(약품 이름을 서식에 안 넣은 원칙과 같은 문제).
- 이름이 같은 변형 폼(\`_A/_B/_1\`)이 여럿일 때 첫 것에 붙었다 — §1 의 오매칭 후보.
`;
fs.writeFileSync(require('path').join(__dirname,'../../proposals/QPS_시드_dfm_대조_2026-09-02.md'), md.replace(/\r?\n/g,'\r\n'));
console.log('보고서 저장 · 전부확인',full.length,'일부',partial.length,'의심',suspect.length);
console.log('--- 의심 서식 ---'); suspect.forEach(r=>console.log(r.id, r.nm, '| 유닛', r.unit, r.score, '| 시드에만', r.missList.slice(0,4).join(' · '), '| dfm:', r.extraList.slice(0,6).join(' · ')));
