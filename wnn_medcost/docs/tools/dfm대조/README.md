# 시드 ↔ SUNWOO dfm 자동 대조 도구 (2026-09-02)

캡처를 눈으로 읽어 만든 점검표 시드(`docs/sql/qps/seed/*.sql`)가 델파이 원본 화면의 글자와 맞는지
**자동으로** 맞춰 본다. 결과 보고서 = `docs/proposals/QPS_시드_dfm_대조_2026-09-02.md`.

```
pwsh build_index.ps1 -Src D:\sunwoo\sunwoo      # 0. dfm_index.tsv · t_unit.tsv
node extract_seed.js                            # 1. forms.tsv · items.tsv   (시드 SQL 파싱)
node match_forms.js                             # 2. matches.tsv             (서식 이름 ↔ 유닛 이름·dfm 제목, 후보 10)
node compare.js                                 # 3. compare.tsv · compare_detail.json (후보마다 항목 대조 → 일치 수 최대인 dfm 채택)
node report.js                                  # 4. 보고서 .md
```

safeRpt(보고서·서식 79 유형)도 같은 파이프라인으로 본다 — 추출기만 다르고 세트 이름을 환경변수로 준다:

```
node extract_saferpt.js                         # forms_rpt.tsv · items_rpt.tsv (유형 이름 + SUB_NM/SUB_COLS/LBL_JSON 라벨/FOOT_TXT)
DFM_SET=rpt node match_forms.js && DFM_SET=rpt node compare.js && DFM_SET=rpt node report.js
                                                # → docs/proposals/QPS_safeRpt_dfm_대조_2026-09-02.md
```
⚠safeRpt 는 고정 23칸 엔진이라 라벨이 의역이다 — 「시드에만」의 대부분은 날짜 칸·정형문구·의역이고, 이 세트의 뜻은 **유형마다 원본 폼이 있는지** 확인하는 것이다.

- 작업 파일(*.tsv, *.json)은 이 폴더에 생기며 **커밋하지 않는다**(.gitignore).
- `dfm_labels.js` 가 핵심 — `.dfm` 의 `#NNNNN` 유니코드 이스케이프를 디코드하고, 라벨 Caption 뿐 아니라
  **입력칸 Text · Memo `Lines.Strings` · `.pas` 안 한글 문자열**까지 글자로 본다(SUNWOO 는 항목 이름을 입력칸 기본값이나 코드에 두는 폼이 많다).
- ⚠**Delphi 문자열 목록 `( … )` 의 닫는 괄호는 마지막 문자열 줄 끝에 붙는다**(`'…')`). 단독 `)` 만 찾으면 그 뒤 객체를 통째로 삼킨다 — 한 번 겪었다.
- ⚠**이름 매칭만으로 유닛을 고르면 틀린다** — 같은 제목의 변형 폼(`_A/_B/_1`)이 많고 t_unit 이름이 재활용된 유닛도 있다.
  그래서 이름 후보 10개를 **전부 항목 대조해 일치 수가 가장 많은 dfm** 을 고른다(25종이 이걸로 바로잡혔다).
  그래도 하나라도 안 맞으면 **dfm 1,367개 전수**를 항목 대조한다(`compare.tsv` SCORE=「전수」). 창 제목 ≠ 화면 제목인 폼
  (WARD_Chart_107 · Employee_Chart_020)이 이렇게 잡혔다. 전수 추출은 첫 번만 약 17초(텍스트 캐시).
  전수로도 안 맞으면 **시드가 지어 넣은 것**이다 — RNL019 가 그랬다(2026-09-02 원본 14항목으로 교체).
- 판정 기준 : 항목 이름 정규화(공백·구두점 제거) 뒤 **2-gram Dice ≥ 0.75 또는 포함**이면 일치.
  시간칸(`07:00~08:00`)은 SUNWOO 가 런타임에 만들어 dfm 에 없으므로 대조 밖으로 센다.
- 아직 안 보는 것 : 입력 종류(CHECK/NUM/TEXT) ↔ dfm 컨트롤 종류. `compare.tsv` 의 dfm체크/글자칸 열이 그 재료.
