const fs=require('fs'), path=require('path');
const S = process.env.DFM_SET ? '_' + process.env.DFM_SET : '';   // 세트 — 비면 점검표, 'rpt' 면 safeRpt
const D=JSON.parse(fs.readFileSync(path.join(__dirname,'compare_detail'+S+'.json'),'utf8'));
const TITLE = S ? 'safeRpt 유형(보고서·서식)' : '점검표 시드';
const esc=s=>String(s).replace(/\|/g,'\|');
const all=D.filter(r=>r.seed!=null); const full=all.filter(r=>r.miss===0); const part=all.filter(r=>r.miss>0);
const suspect=part.filter(r=>r.hit===0 && r.dfmLabels>=8);     // 유닛 오매칭 의심 또는 항목 이름을 통째로 다르게 읽음
const partial=part.filter(r=>!(r.hit===0 && r.dfmLabels>=8));
let md=`# QPS ${TITLE} ↔ SUNWOO dfm 자동 대조 (2026-09-02)

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
| **A. 항목 대부분이 다른 서식** | NUR003 낙상예방 시설환경 점검표 · RNL019 낙상 시설,환경 관리일지(인공신장) | ✅**판정 끝(같은 날)** — **NUR003** 은 WARD_Chart_107(창 제목이 「낙상시설,환경 관리일지」라 이름 후보에서 빠졌던 폼)의 입력칸 기본글자와 **24항목 글자 그대로 일치**. 오타 둘만(「홀 파인 곳」→「홈」, 「이동볼대」→「이동폴대」). **RNL019** 는 KIDNEY_Chart_003 의 14항목(침대바퀴,잠금장치,siderail 작동 확인 …)과 **문장이 전부 달랐다** — 08-14 에 캡처 없이 지어 넣은 것 | NUR003 오타 2건 보정 · RNL019 는 원본 14항목으로 **통째로 교체**(묶음 「시설 점검」, 사인 행 켬). 시드 파일 + [운영 보정 SQL](../sql/qps/seed/QPS_SEED_FIX_DFM_2026-09-02.sql) |
| **B. 병원이 채우는 내용을 항목으로 박은 의심** | ADM003 연간 활동계획 · FAC032 방화 보안·순찰 일지 | ✅**판정 끝(같은 날)** — **ADM003** 은 병원 자료가 아니었다: Employee_Chart_020(「직원활동연간계획서」)의 라벨과 **17항목·7묶음 전부 일치**(자동 대조가 이름 닮은 018 에 붙였을 뿐). **FAC032** 는 FAC_Chart_037 을 Top 좌표로 세어 보니 **17줄 고정 + 층마다 빈 줄 6개** — 캡처의 강당·현금입출금기·알람밸브실·탕비실·누수 5줄은 그 병원이 빈 줄에 적은 **병원 자료** | ADM003 손댈 것 없음 · FAC032 는 5줄을 공통 서식에서 뺌(SORT 유지, 병원은 전용 사본에서 제 줄을 더한다). 같은 SQL |
| **C. 묶음(그룹) 이름 표현 차이 — 고칠 것 없음** | FAC028 (소화설비·기구/자동화재경보설비/피난·방화설비/화기취급) · PHA009 (업무전/조제환경/업무후) | SUNWOO 는 묶음을 ⦿머리글·번호로 그렸고 우리는 GRP_NM 으로 세웠다. 뜻은 같다 | 없음 |
| **D. 한두 항목 표기 차이** | NUT004 · ADM016 · FAC021 · PHA023 · NUR027 · REH001 · RNL006 · NUR066 | ✅**판정 끝(같은 날 저녁)** — 원본 글자를 grep 해 **9건 보정** : 「냉장 & 냉동고」→「냉장 ＆ 냉동고」(전각) · 묶음 「1주 1일」→「1주일」 · 「정상동작」→「정상작동」 · 「수령 상태」→「수평 상태」 · 묶음 「8 맛」→「맛」 · 「이중잠금」→「이중금고」 · 「물팀」→「물튐」 · 「전원 결함」→「전원 결합」(원본 오타 보존 규칙) · RNL006 「침대 부속물 점검 (SIDE RAIL 작동여부, 바퀴잠금장치 작동여부)」. **NUR066 「D-set·Can」만 보류** — 원본 112·112_A 어디에도 없어 캡처의 문서 값으로 보임(병원 확인) | 시드 파일 + [운영 보정 SQL](../sql/qps/seed/QPS_SEED_FIX_DFM_2026-09-02.sql) §4 |

## 6. 이 대조가 못 보는 것

- **입력 종류**(CHECK/NUM/TEXT)는 아직 안 맞춰 봤다 — dfm 의 TcxCheckBox 수 vs 시드 CHECK 수로 다음에 본다(표의 「dfm 체크/글자칸」이 그 재료).
- **DB 에서 채우는 항목**: \`f_get_BeforeDevice\`(33종 — 의료기기 목록 서식에서 장비 이름을 가져옴) · \`f_checkList/t_list\`(78종) 로 채우는 이름은 dfm 에 없다. 이런 서식은 「시드에만」이 곧 **우리가 병원 자료를 서식에 박은 것**일 수 있다(약품 이름을 서식에 안 넣은 원칙과 같은 문제).
- 이름이 같은 변형 폼(\`_A/_B/_1\`)이 여럿일 때 첫 것에 붙었다 — §1 의 오매칭 후보.
`;
if (S) md = md.replace(/## 5\. 사람이 볼 것[\s\S]*?(?=## 6\.)/, `## 5. 판독 (2026-09-02 저녁)

safeRpt 는 점검표와 달리 **고정 23칸(LBL_JSON 으로 이름만 바꿈) + 반복행 표** 엔진이라 원본 라벨을 1:1 로 옮길 수 없다.
그래서 「시드에만」은 대부분 **①날짜 칸**(신청일·작성일·보고일·시각 — SUNWOO 는 날짜 피커라 글자가 없다) ②**정형문구 문장** ③**엔진 칸에 맞춘 의역**(원본 「환자 본인 › 성 명·주 소」 → 우리 「환자 성명·환자 주소」)이다. 지어낸 유형은 없다.

| 묶음 | 유형 | 무엇인가 | 할 일 |
|---|---|---|---|
| 유형이 엉뚱한 폼에 붙음(도구 한계) | MDDISP·MDAS·MRAGREE·MRPROXY·SELFDIS | 진짜 폼(Employee_033/034 · HEALTH_013/001 · Employee_027)이 dfm 에 있는데 라벨이 의역이라 일치 수가 적어 일반어가 많은 다른 폼이 앞섰다 | 없음 — 이름으로 원본 존재는 확인됨 |
| **확인 후보** | **MDDISP 의료기기 폐기 확인서** | 원본 Employee_Chart_033 은 **식약처 서식**(폐기의뢰자 업소명·허가번호·품목명·형명·제조번호·폐기량·폐기물처리 업소…)이고 우리 것은 병원 내부용(설치장소·의료기기명·사용부서·구입일자·폐기 사유)으로 **단순화한 판**이다. 08-14 원무총무 판독의 결정인지, 원본대로 바꿀지 | 병원확인 목록에 한 줄 |
| 원본 없음 | INFONOTI 직원정보 변경 공고문 | dfm 에 「공고」 제목 폼이 없다 — 원무총무 캡처 w16 이 Employee_Chart_013(제출서)의 한 쪽이었을 가능성 | 없음(제출서 INFOCHG 는 확인됨) |
| 날짜·정형문구만 다른 것 | 나머지 30여 종 | ①②③ | 없음 |

`);   // §5 의 판독 표는 점검표 것
fs.writeFileSync(path.join(__dirname, S ? '../../proposals/QPS_safeRpt_dfm_대조_2026-09-02.md' : '../../proposals/QPS_시드_dfm_대조_2026-09-02.md'), md.replace(/\r?\n/g,'\r\n'));
console.log('보고서 저장 · 전부확인',full.length,'일부',partial.length,'의심',suspect.length);
console.log('--- 의심 서식 ---'); suspect.forEach(r=>console.log(r.id, r.nm, '| 유닛', r.unit, r.score, '| 시드에만', r.missList.slice(0,4).join(' · '), '| dfm:', r.extraList.slice(0,6).join(' · ')));
