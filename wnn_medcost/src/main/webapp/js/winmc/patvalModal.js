// =====================================================================
// [2026-07-19] 환자평가표(TBL_PATVAL_MST) 조회 모달 - 공용 스크립트
//   assessment.jsp 인라인 블록에서 추출 (원본 로직 무변경 이동).
//   사용 화면: assessment.jsp(우측 viewTable 더블클릭/버튼), assesCheck.jsp(점검 그리드 더블클릭)
//   진입점: fn_ShowPatvalModal() - '#viewTable' selected 행 또는 전역 edit_Data 에서 대상 환자를 얻음
//   페이지 전제(전역): hospid, getCookie, fn_NameMask, jQuery, Swal / (선택) _errCheckData, edit_Data
// =====================================================================
// =====================================================================
// 환자평가표(TBL_PATVAL_MST) 조회 모달 (조회전용)
//   - 우측 그리드(viewTable) 행 선택 시 상단 버튼 활성화
//   - cath05 오류점검 데이터(_errCheckData)와 매칭되는 항목은 상단 배지로 강조
// =====================================================================

function _pvIsEmpty(v) {
    if (v === null || v === undefined || v === '') return true;
    // 전체적으로 '0' / '00' 은 '-' 로 (무의미 값)
    var s = String(v).trim();
    return s === '0' || s === '00';
}
function _pvEmptyMark() { return '<span class="pv-empty" style="color:#b0b6bf;">-</span>'; }

// 서버 응답 키가 UPPERCASE(AUTH_DOC) 또는 snake(auth_doc)로 와도 카멜(authDoc)로 접근 가능하게 정규화
function _pvNormalizeKeys(src) {
    if (!src || typeof src !== 'object') return src;
    var out = {};
    for (var k in src) {
        if (!src.hasOwnProperty(k)) continue;
        out[k] = src[k];
        // snake_case/UPPER_SNAKE → camelCase 보조키 추가
        if (k.indexOf('_') >= 0) {
            var camel = k.toLowerCase().replace(/_([a-z0-9])/g, function(_, c) { return c.toUpperCase(); });
            if (!(camel in out)) out[camel] = src[k];
        } else if (k === k.toUpperCase() && k !== k.toLowerCase()) {
            // 전부 대문자인 경우 소문자 키도 만들어 둠
            var lower = k.toLowerCase();
            if (!(lower in out)) out[lower] = src[k];
        }
    }
    return out;
}

function _pvYn(v) {
    if (_pvIsEmpty(v)) return _pvEmptyMark();
    if (v === '1' || v === 'Y') return '<span style="color:#28a745;font-weight:700;">✓</span>';
    if (v === '0' || v === 'N') return '<span style="color:#6c757d;">−</span>';
    return _pvTxt(v);
}

// 명세서서식(2024.7.1.~) 기준 코드표 — 값이 여러 개인 필드의 의미를 콤보식으로 표시
var _PV_CODES = {
    evalType: {
        '1':'입원 평가', '2':'계속 입원 중인 환자 평가', '3':'이전 환자평가표를 적용하는 경우'
    },
    lastPlace: {
        '1':'집에 거주(서비스 받음)', '2':'집에 거주(서비스 안받음)', '3':'요양시설/그룹홈',
        '4':'급성기병원', '5':'요양병원', '6':'정신병원/정신시설', '7':'기타'
    },
    eduLevel: {
        '1':'무학', '2':'초졸(퇴)', '3':'중졸(퇴)', '4':'고졸(퇴)', '5':'대졸(퇴) 이상', '6':'확인 불가'
    },
    ltcareGrdReq: {
        '1':'해당사항 없음', '2':'미신청', '3':'신청 중', '4':'신청하였으나 인정 못 받음',
        '5':'등급 내 자', '6':'등급 외 자'
    },
    ltcareGrade: {
        '1':'1등급', '2':'2등급', '3':'3등급', '4':'4~5등급', '5':'인지지원등급', '6':'확인 불가'
    },
    delirium: {
        '0':'없음', '1':'증상 있으나 7일 이전 발생', '2':'증상 있으며 7일 이내 발생/악화'
    },
    shortMem: { '0':'정상', '1':'이상 있음', '2':'확인 불가' },
    perception: {
        '0':'합리적 의사결정', '1':'새로운 상황만 어려움', '2':'다소 손상', '3':'심하게 손상'
    },
    comprehen: {
        '0':'이해시킴', '1':'대부분 이해시킴', '2':'가끔 이해시킴', '3':'거의/전혀 이해시키지 못함'
    },
    // BPSD 빈도 (delusion~wander) : 0 없음, 1 가끔, 2 자주, 3 매우 자주
    bpsd: { '0':'없음', '1':'가끔', '2':'자주', '3':'매우 자주' },
    // ADL (dressing~toiletUse) : 0 완전자립 … 8 행위 발생안함
    adl: {
        '0':'완전자립', '1':'감독필요', '2':'약간의 도움', '3':'상당한 도움', '4':'전적인 도움', '8':'행위 발생안함'
    },
    bowelCtl: { '0':'조절할 수 있음', '1':'가끔 실금함', '2':'자주 실금함', '3':'조절 못함' },
    urineCtl: { '0':'조절할 수 있음', '1':'가끔 실금함', '2':'자주 실금함', '3':'조절 못함' },
    painFreq: { '0':'통증 없음', '1':'통증 있으나 매일은 아님', '2':'매일 통증 있음' },
    fall: { '0':'아니오', '1':'예', '2':'확인 불가' },
    weigLoss: { '0':'아니오', '1':'예', '2':'확인 불가' },
    newUlcer: { '0':'없음', '1':'있음' },
    pastUlcer: { '0':'없음', '1':'있음', '2':'확인 불가' },
    insulin: {
        '0':'투여되지 않았거나 매일은 아님', '1':'매일 1회 투여됨', '2':'매일 2회 이상 투여됨'
    },
    medCount: {
        '0':'없음', '1':'5개 미만', '2':'5개 ~ 9개', '3':'10개 ~ 14개', '4':'15개 이상'
    },
    calories: {
        '0':'없음', '1':'1~25%', '2':'26~50%', '3':'51~75%', '4':'76~100%'
    },
    waterAmt: {
        '0':'없음', '1':'1~500㎖', '2':'501~1000㎖', '3':'1001~1500㎖', '4':'1501~2000㎖', '5':'2001㎖ 이상'
    }
};

// 코드값 → "코드 : 설명" 형태로 렌더 (매핑 없으면 _pvTxt 로 fallback)
function _pvCd(codeGroup, v) {
    if (_pvIsEmpty(v)) return _pvEmptyMark();
    var map = _PV_CODES[codeGroup];
    var desc = map ? map[String(v)] : null;
    if (!desc) return _pvTxt(v);
    var vHtml  = $('<div>').text(v).html();
    var dHtml  = $('<div>').text(desc).html();
    return '<span class="pv-cd"><span class="pv-cd-k">' + vHtml + '</span><span class="pv-cd-v">' + dHtml + '</span></span>';
}
function _pvTxt(v) {
    if (_pvIsEmpty(v)) return _pvEmptyMark();
    var s = String(v).trim();
    // 전체 값에서 '0' 또는 '00' 은 '-' 표시 (무의미 값)
    if (s === '0' || s === '00') return _pvEmptyMark();
    return $('<div>').text(v).html();
}
// _pvTxt 와 동일하나 '0' 점수를 유효값으로 그대로 표시 (예: K-MMSE 0점)
// 빈 값(null/undefined/'') 과 '00' 은 '0' 으로 노출 (그 외 값은 원본 유지)
function _pvTxt0(v) {
    if (v === null || v === undefined || String(v).trim() === '') return '0';
    var s = String(v).trim();
    if (s === '00') s = '0';   // '00' → '0' 케이스만 정규화
    return $('<div>').text(s).html();
}
function _pvDt(v) {
    if (_pvIsEmpty(v)) return _pvEmptyMark();
    var s = String(v).replace(/[^0-9]/g,'');
    if (s.length === 8) return s.substr(0,4) + '-' + s.substr(4,2) + '-' + s.substr(6,2);
    return _pvTxt(v);
}
// HbA1c — 마지막 자리가 소수점 (예: "083" → "8.3 %", "127" → "12.7 %", "100" → "10 %")
function _pvHbA1c(v) {
    if (_pvIsEmpty(v)) return _pvEmptyMark();
    var s = String(v).replace(/[^0-9]/g, '');
    if (s === '' || s === '0' || s === '00' || s === '000') return _pvEmptyMark();
    if (s.length < 2) return $('<div>').text(s + ' %').html();
    var intPart = String(parseInt(s.slice(0, -1), 10));
    var decDigit = s.slice(-1);
    var disp = (decDigit === '0') ? intPart : (intPart + '.' + decDigit);
    return $('<div>').text(disp + ' %').html();
}
// 체중/키 — 마지막 자리(4번째)가 소수점, 단위(unit) 뒤에 표시
// (예: "0610","kg" → "61 kg", "0615","kg" → "61.5 kg", "1680","cm" → "168 cm", "1685","cm" → "168.5 cm")
function _pvDecLast(v, unit) {
    if (_pvIsEmpty(v)) return _pvEmptyMark();
    var s = String(v).replace(/[^0-9]/g, '');
    if (s === '' || /^0+$/.test(s)) return _pvEmptyMark();
    var u = unit ? (' ' + unit) : '';
    if (s.length < 2) return $('<div>').text(s + u).html();
    var intPart = String(parseInt(s.slice(0, -1), 10));
    var decDigit = s.slice(-1);
    var disp = (decDigit === '0') ? intPart : (intPart + '.' + decDigit);
    return $('<div>').text(disp + u).html();
}
// 상단 환자ID 마스킹 (앞뒤 모두 * 처리: ******-*******)
function _pvMaskPatId(v) {
    if (_pvIsEmpty(v)) return _pvEmptyMark();
    var s = String(v).replace(/-/g,'').trim();
    if (s.length < 7) return $('<div>').text(new Array(s.length + 1).join('*')).html();
    return $('<div>').text('******-*******').html();
}

/* ============================================================
   환자평가표 전월 비교 — 적정성평가 관련 항목 변경 시 파란색 표시
   대상: D.신체기능(ADL), E·F 유치도뇨관 삽입/삽입기간,
         F.당뇨 HbA1c 검사여부, I.1~I.4 욕창(압박성궤양),
         I.5 피부문제 처치
   ============================================================ */
var _PV_PREV = null;
// 전월 대비 적정성평가 관련 항목 변경 환자 키셋 ("patId|admitDt|medStart")
var _PV_CHANGED_SET = {};

function _pvChangedKey(patId, admitDt, medStart) {
    // 그리드 SQL(select_CategoryListNN)이 LEFT(PAT_ID,6) 로 patId 를 6자리(생년월일)로
    // 잘라 반환하므로, 비교 키도 항상 첫 6자로 정규화한다
    var pid = String(patId || '').replace(/-/g,'').substring(0, 6);
    return pid + '|' +
           String(admitDt || '').replace(/-/g,'') + '|' +
           String(medStart || '').replace(/-/g,'');
}

// 워너넷 사용자 여부 — 사이드바/대시보드/total_Report 등과 동일한 컨벤션:
//   `s_wnn_yn` 쿠키 = 'Y'       → 위너넷 사용자(로그인 시 설정)
//   `s_winconect` 쿠키 = 'Y'    → 병원 검색 후 위너넷처럼 연결된 상태
// (전월 변경 ✔ 표시는 위너넷에게만 노출 — 병원 사용자에겐 의미 없는 정보이고 혼선 방지)
//
// 디버그: 콘솔에서 `_debugWinnerCheck()` 호출 → 쿠키 값/판별결과 출력.
function _isWinnerUser() {
    try {
        var w = (getCookie("s_wnn_yn")    || '').trim();
        var c = (getCookie("s_winconect") || '').trim();
        return w === 'Y' || c === 'Y';
    } catch (e) { return false; }
}
// 진단 — 브라우저 DevTools 콘솔에서 호출하여 현재 값 확인
window._debugWinnerCheck = function () {
    var w = '', c = '';
    try { w = getCookie("s_wnn_yn")    || ''; } catch (e) { w = '(err: ' + e.message + ')'; }
    try { c = getCookie("s_winconect") || ''; } catch (e) { c = '(err: ' + e.message + ')'; }
    var info = {
        cookie_s_wnn_yn:    w,
        cookie_s_winconect: c,
        isWinnerUser:       _isWinnerUser(),
        meaning: _isWinnerUser() ? '위너넷(체크표시 ✔ 노출)' : '병원 사용자(체크표시 숨김)'
    };
    console.table(info);
    return info;
};

// viewTable 의 c_Head_Set / columnsSet 맨 앞에 "변경(✔)" 컬럼 prepend
//   - 헤더는 공백, 폭 최소화 — 체크박스만 표시
//   - 전월 대비 적정성평가 5개 분류(D.ADL / E·F.유치도뇨관 / F.HbA1c / I.욕창 / I.피부처치) 변경 환자에 ✔
//   - c_Head_Set 이 1행 헤더(string[]) / 2행 헤더(object[][]) 모두 대응
//   - 워너넷 사용자가 아니면 ✔ 마크 렌더링 자체를 스킵 (컬럼 자리는 유지 — 헤더 폭 영향 최소화)
function fn_PrependPatvalChangedColumn() {
    if (typeof c_Head_Set === 'undefined' || typeof columnsSet === 'undefined') return;
    if (!Array.isArray(c_Head_Set) || !Array.isArray(columnsSet)) return;
    // 이미 변경 컬럼이 prepend 되어 있으면 skip (중복 방지)
    if (columnsSet.length > 0 && columnsSet[0] && columnsSet[0]._isPvChanged) return;

    // 헤더 prepend — 공백 라벨 + 좁은 폭
    if (c_Head_Set.length > 0 && Array.isArray(c_Head_Set[0])) {
        var rowSpan = c_Head_Set.length;
        c_Head_Set[0] = [{ label: '', rowspan: rowSpan, class: 'pv-chk-th' }].concat(c_Head_Set[0]);
    } else {
        c_Head_Set = [''].concat(c_Head_Set);
    }

    // 컬럼 정의 prepend — patId/admitDt/medStart 매칭 시 ✔ 렌더
    columnsSet = [{
        _isPvChanged: true,
        data: null,
        orderable: false,
        searchable: false,
        className: 'dt-body-center pv-chk-cell',
        width: '24px',
        render: function(data, type, row) {
            if (type !== 'display') return '';
            // 워너넷 사용자가 아니면 ✔ 표시 안함 (s_mainfg='3'/'4' = 병원 사용자)
            if (!_isWinnerUser()) return '';
            if (!row || !row.patId) return '';
            try {
                var key = _pvChangedKey(row.patId, row.admitDt, row.medStart);
                if (_PV_CHANGED_SET[key]) {
                    return '<span title="전월 대비 적정성평가 항목 변경" ' +
                           'style="color:#1565c0;font-weight:900;font-size:13px;">&#10004;</span>';
                }
            } catch (e) {}
            return '';
        }
    }].concat(columnsSet);
}

function fn_LoadPatvalChangedList() {
    _PV_CHANGED_SET = {};
    // 워너넷 사용자가 아니면 변경 ✔ 표시 안 하므로 AJAX 호출 자체 스킵 (서버 부하 절감)
    if (!_isWinnerUser()) return;
    var selYear  = document.getElementById('year_Select');
    var selMonth = document.getElementById('monthSelect');
    if (!selYear || !selMonth) return;
    var jobYymm = selYear.value + selMonth.value;
    if (!hospid || !jobYymm || jobYymm.length !== 6) return;
    $.ajax({
        url: '/main/select_PatvalChangedList.do',
        type: 'POST',
        data: { hospCd: hospid, jobYymm: jobYymm },
        dataType: 'json',
        success: function(res) {
            var rows = (res && res.data) ? res.data : [];
            var set = {};
            for (var i = 0; i < rows.length; i++) {
                var r = rows[i];
                set[_pvChangedKey(r.patId, r.admitDt, r.medStart)] = true;
            }
            _PV_CHANGED_SET = set;
            // viewTable 이 이미 그려져 있다면 즉시 재적용 (전역 tableName 은 fn_ViewData 종료 후 indicatorTable 로
            // 복원되므로 isDataTable 만으로 판정)
            try {
                if ($.fn.DataTable.isDataTable('#viewTable')) {
                    // 첫 컬럼(변경 ✔) 셀을 다시 그리도록 invalidate + 마커 재적용
                    $('#viewTable').DataTable().rows().invalidate('data').draw(false);
                    fn_ApplyPatvalChangedMark();
                }
            } catch (e) {}
        },
        error: function() { _PV_CHANGED_SET = {}; }
    });
}

// 변경 환자 표시는 첫 컬럼 ✔ 로만 처리 — 행 배경 강조 제거됨.
// 잔존 마커 클래스가 있으면 정리만 수행 (no-op 호출자 호환용)
function fn_ApplyPatvalChangedMark() {
    if (!$.fn.DataTable.isDataTable('#viewTable')) return;
    $('#viewTable tbody tr.pv-changed-row').removeClass('pv-changed-row');
}

function _pvNorm(v) {
    if (v === null || typeof v === 'undefined') return '';
    return String(v).trim();
}
function _pvIsDiff(curVal, prevVal) {
    // prev 데이터 자체가 없으면 비교 안함
    if (!_PV_PREV) return false;
    return _pvNorm(curVal) !== _pvNorm(prevVal);
}
// 변경된 값 표시 — html(현재값 렌더링 결과), prevDisp(전월 표시값), groupTitle(클릭 시 보여줄 분류명)
function _pvDiffWrap(html, prevDisp, groupTitle) {
    var pHtml  = $('<div>').text(_pvIsEmpty(prevDisp) ? '없음' : prevDisp).html();
    var gHtml  = $('<div>').text(groupTitle || '').html();
    return '<span class="pv-diff" title="전월 → ' + pHtml + ' (클릭: 이전 내용 보기)" ' +
           'data-prev="' + pHtml + '" data-group="' + gHtml + '">' + html + '</span>';
}
// Y/N 비교
function _pvDiffYn(cur, prev, groupTitle) {
    var html = _pvYn(cur);
    if (!_pvIsDiff(cur, prev)) return html;
    var prevTxt = (cur === prev) ? '' : (
        _pvIsEmpty(prev) ? '미입력' : ('값: ' + _pvNorm(prev))
    );
    return _pvDiffWrap(html, prevTxt, groupTitle);
}
// 코드 비교 (codeGroup → 매핑)
// hideCode=true 이면 전월값 팝오버에 코드 숫자 없이 설명 텍스트만 표시
function _pvDiffCd(codeGroup, cur, prev, groupTitle, hideCode) {
    var html = _pvCd(codeGroup, cur);
    if (!_pvIsDiff(cur, prev)) return html;
    var map = _PV_CODES[codeGroup] || {};
    var prevDesc;
    if (hideCode) {
        prevDesc = map[String(prev)] ? map[String(prev)] : (_pvIsEmpty(prev) ? '미입력' : _pvNorm(prev));
    } else {
        prevDesc = map[String(prev)] ? (_pvNorm(prev) + ' : ' + map[String(prev)]) : (_pvIsEmpty(prev) ? '미입력' : _pvNorm(prev));
    }
    return _pvDiffWrap(html, prevDesc, groupTitle);
}
// 일반 텍스트 비교
function _pvDiffTxt(cur, prev, groupTitle) {
    var html = _pvTxt(cur);
    if (!_pvIsDiff(cur, prev)) return html;
    var prevDisp = _pvIsEmpty(prev) ? '미입력' : _pvNorm(prev);
    return _pvDiffWrap(html, prevDisp, groupTitle);
}
// HbA1c 비교 (083 → 8.3 % 변환 후 비교)
function _pvDiffHbA1c(cur, prev, groupTitle) {
    var html = _pvHbA1c(cur);
    if (!_pvIsDiff(cur, prev)) return html;
    var prevDisp = _pvIsEmpty(prev) ? '미입력' : ($('<div>').html(_pvHbA1c(prev)).text() || _pvNorm(prev));
    return _pvDiffWrap(html, prevDisp, groupTitle);
}

// 변경 표시(.pv-diff) 클릭 시 전월값 팝오버
function _pvBindDiffClick() {
    $(document).off('click.pvDiff').on('click.pvDiff', '.pv-diff', function(e) {
        e.stopPropagation();
        var prev = $(this).data('prev') || '없음';
        var grp  = $(this).data('group') || '';
        // 기존 팝오버 제거
        $('.pv-diff-pop').remove();
        var $pop = $('<div class="pv-diff-pop"></div>')
            .css({
                position: 'absolute', zIndex: 99999,
                background: '#1e3c72', color: '#fff',
                padding: '8px 12px', borderRadius: '6px',
                fontSize: '12.5px', lineHeight: '1.5',
                boxShadow: '0 4px 12px rgba(0,0,0,0.25)',
                maxWidth: '320px', whiteSpace: 'normal'
            })
            .html('<div style="font-weight:700;font-size:11.5px;opacity:0.85;margin-bottom:3px;">' + $('<div>').text(grp).html() + ' — 전월</div>' +
                  '<div>' + $('<div>').text(prev).html() + '</div>');
        var off = $(this).offset();
        $pop.css({ top: (off.top + $(this).outerHeight() + 4) + 'px', left: off.left + 'px' });
        $('body').append($pop);
        // 다른 곳 클릭 시 닫기
        setTimeout(function() {
            $(document).one('click.pvDiffClose', function() { $('.pv-diff-pop').remove(); });
        }, 0);
    });
}

function fn_UpdatePatvalBtnState(row) {
    // 시각 피드백만 — 선택 없을 때 grayscale 처리
    var btn = document.getElementById('btnPatvalView');
    if (!btn) return;
    var ok = !!(row && row.patId && row.admitDt && row.medStart);
    if (ok) btn.classList.remove('is-disabled');
    else    btn.classList.add('is-disabled');
}

// viewTable .dt-buttons 영역으로 버튼 이동 (DataTable 초기화 후 호출)
//   DataTable destroy → 재초기화 시 .dt-buttons 컨테이너가 교체되어 버튼도 함께 사라지므로,
//   버튼 DOM이 없는 경우 동적으로 재생성한 뒤 부착한다.
//   cath05BtnZone(유치도뇨관 및 오류점검)도 동일 라인으로 이동.
function fn_AttachPatvalBtnToDt() {
    var $dtBtns = $('#viewTable_wrapper .dt-buttons');
    if ($dtBtns.length === 0) return;

    // (1) [2026-07-19] 환자평가표 조회 버튼 제거 — 행 더블클릭으로 열리므로 중복 UI 정리.
    //     잔존 버튼이 있으면 삭제만 수행 (fn_UpdatePatvalBtnState 는 버튼이 없으면 no-op)
    var pvBtn = document.getElementById('btnPatvalView');
    if (pvBtn && pvBtn.parentNode) pvBtn.parentNode.removeChild(pvBtn);

    // (2) 유치도뇨관 및 오류점검 버튼 — 05 카테고리에서만 .dt-buttons 영역으로 이동
    //     DataTable destroy 로 DOM이 사라진 경우 재생성한다.
    var cathZone = document.getElementById('cath05BtnZone');
    if (!cathZone) {
        cathZone = document.createElement('div');
        cathZone.id = 'cath05BtnZone';
        cathZone.style.whiteSpace = 'nowrap';
        cathZone.innerHTML =
            '<button type="button" id="btnCath05Check" class="cath05-btn">' +
                '<i class="fas fa-stethoscope cath05-icon"></i>' +
                '<span class="cath05-label">유치도뇨관&nbsp;&nbsp;및 오류점검</span>' +
                '<span class="cath05-badge" id="badgeCath05">0</span>' +
            '</button>';
        var _innerBtn = cathZone.querySelector('#btnCath05Check');
        if (_innerBtn) _innerBtn.onclick = function() { fn_ShowCath05Modal(); };
    }
    if (jobFlag === '05') {
        if (cathZone.parentNode !== $dtBtns[0]) {
            $dtBtns.append(cathZone);
            cathZone.style.marginLeft = '6px';
        }
        cathZone.style.display = 'inline-block';
    } else {
        cathZone.style.display = 'none';
    }
    if (typeof fn_UpdateCath05Buttons === 'function') fn_UpdateCath05Buttons();

    /* (3) 다빈도 상병순위별 버튼 — 07 카테고리에서만 자료검색(.dataTables_filter) 뒤쪽(우측 끝)으로 부착
           (향후 환자평가표 조회 버튼도 같은 우측 영역에 부착 예정) */
    var diagZone = document.getElementById('diagRank07BtnZone');
    if (!diagZone) {
        diagZone = document.createElement('div');
        diagZone.id = 'diagRank07BtnZone';
        diagZone.style.whiteSpace = 'nowrap';
        diagZone.style.display = 'inline-block';
        diagZone.innerHTML =
            '<button type="button" id="btnDiagRank07" class="cath05-btn">' +
                '<i class="fas fa-notes-medical cath05-icon"></i>' +
                '<span class="cath05-label">다빈도&nbsp;상병순위별</span>' +
            '</button>';
        var _dBtn = diagZone.querySelector('#btnDiagRank07');
        if (_dBtn) _dBtn.onclick = function() { fn_ShowDiagRank07Modal(); };
    }
    if (jobFlag === '07') {
        /* .dataTables_filter 의 형제(sibling)로 바로 뒤에 붙여 자료검색 입력 우측 끝에 표시 */
        var $filter = $('#viewTable_wrapper .dataTables_filter');
        if ($filter.length > 0) {
            $filter.after(diagZone);
        } else if ($dtBtns.length > 0) {
            $dtBtns.append(diagZone);
        }
        diagZone.style.cssText =
            'display:inline-block; white-space:nowrap;' +
            ' float:right; margin-left:10px; vertical-align:middle;';
    } else {
        diagZone.style.display = 'none';
    }
}

// 현재 viewTable에서 선택된 행 데이터 반환 (edit_Data가 비어도 .selected 행에서 복구)
function _pvGetSelectedRow() {
    try {
        var dt = $('#viewTable').DataTable();
        var sel = dt.row('.selected');
        if (sel && sel.data()) return sel.data();
    } catch (e) {}
    if (typeof edit_Data !== 'undefined' && edit_Data && edit_Data.patId) return edit_Data;
    return null;
}

function _pvErrorBadges(patId) {
    try {
        if (!patId || typeof _errCheckData === 'undefined' || !_errCheckData || _errCheckData.length === 0) return '';
        var hits = [];
        for (var i = 0; i < _errCheckData.length; i++) {
            if (_errCheckData[i].patId === patId) hits.push(_errCheckData[i]);
        }
        if (hits.length === 0) return '';
        var html = '<div class="pv-err-zone"><div class="pv-err-title"><i class="fas fa-exclamation-triangle"></i>&nbsp;평가표 오류점검 매칭 (' + hits.length + '건)</div><div class="pv-err-list">';
        for (var j = 0; j < hits.length; j++) {
            html += '<span class="pv-err-chip">[' + (hits[j].errType || '') + '] ' + $('<div>').text(hits[j].errName || '').html() + '</span>';
        }
        html += '</div></div>';
        return html;
    } catch (ex) { return ''; }
}

function fn_ShowPatvalModal() {
    var row = _pvGetSelectedRow();
    if (!row || !row.patId || !row.admitDt || !row.medStart) {
        Swal.fire({ icon: 'info', title: '환자 선택 필요', text: '우측 목록에서 환자(행)를 먼저 선택해 주세요.', timer: 1800, showConfirmButton: false });
        return;
    }
    // 직전 환자 비교 데이터 초기화
    _PV_PREV = null;
    if (!document.getElementById('patvalModalStyle')) {
        var st = document.createElement('style');
        st.id = 'patvalModalStyle';
        st.innerHTML =
            '.pv-head { display:flex; flex-wrap:wrap; gap:14px 24px; padding:14px 18px; margin-bottom:12px; border-radius:8px;' +
            '  background:linear-gradient(135deg,#1e3c72 0%,#2a5298 100%); color:#fff; box-shadow:0 3px 10px rgba(30,60,114,0.25); }' +
            '.pv-head-item { font-size:13px; line-height:1.5; display:flex; align-items:center; gap:8px; }' +
            '.pv-head-item .lbl { opacity:0.8; font-size:11.5px; letter-spacing:0.3px; text-transform:uppercase; }' +
            '.pv-head-item .val { font-weight:600; font-size:13.5px; background:rgba(255,255,255,0.15); padding:3px 10px; border-radius:4px; font-family:Consolas,monospace; }' +
            '.pv-tabs { display:flex; align-items:stretch; border-bottom:2px solid #e4e7ed; margin-bottom:14px; gap:2px; flex-wrap:wrap; }' +
            '.pv-tab  { cursor:pointer; padding:10px 18px; font-size:13px; font-weight:600; color:#6b7280; background:transparent;' +
            '  border:none; border-bottom:3px solid transparent; transition:all 0.18s ease; border-radius:4px 4px 0 0;' +
            '  line-height:1.4; text-align:left; white-space:normal; }' +
            '.pv-tab:hover { color:#2a5298; background:#f5f8fc; }' +
            '.pv-tab.active { color:#1e3c72; border-bottom-color:#2a5298; background:#f5f8fc; }' +
            '.pv-tab-break { flex-basis:100%; height:0; margin:0; padding:0; }' +
            /* E·F 탭처럼 라벨이 긴 탭은 같은 줄의 남은 가로 공간을 모두 채우도록 flex-grow */
            '.pv-tab-wide { flex:1 1 0; min-width:0; }' +
            '.pv-pane { display:none; padding:0 4px; }' +
            '.pv-pane.active { display:block; animation:pvFadeIn 0.18s ease; }' +
            '@keyframes pvFadeIn { from { opacity:0; transform:translateY(4px);} to { opacity:1; transform:none;} }' +
            '.pv-sec { margin-bottom:18px; border:1px solid #e4e7ed; border-radius:8px; overflow:hidden; }' +
            '.pv-sec-hd { padding:9px 14px; background:linear-gradient(135deg,#f7f9fc 0%,#eef2f7 100%); font-size:13px; font-weight:700; color:#2c3e50; border-bottom:1px solid #e4e7ed;' +
            '  display:flex; align-items:center; gap:6px; }' +
            '.pv-sec-hd i { color:#2a5298; font-size:12px; }' +
            '.pv-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(240px,1fr)); gap:0; }' +
            '.pv-cell { display:flex; align-items:center; padding:8px 12px; border-bottom:1px solid #f0f2f6; border-right:1px solid #f0f2f6; font-size:12.5px; min-height:34px; }' +
            '.pv-cell .k { flex:0 0 48%; color:#1e3c72; font-weight:500; letter-spacing:0.1px; }' +
            '.pv-cell .v { flex:1; color:#2c3e50; font-weight:500; text-align:right; padding-left:6px; word-break:break-all; font-family:Consolas,"맑은 고딕",sans-serif; }' +
            '.pv-cath-tbl { width:100%; border-collapse:collapse; font-size:12.5px; }' +
            '.pv-cath-tbl th, .pv-cath-tbl td { border:1px solid #e4e7ed; padding:6px 10px; text-align:center; }' +
            '.pv-cath-tbl thead th { background:linear-gradient(135deg,#2a5298,#1e3c72); color:#fff; font-weight:600; }' +
            '.pv-cath-tbl tbody td.dt { font-family:Consolas,monospace; color:#2c3e50; }' +
            '.pv-cath-tbl tbody tr:hover { background:#f0f7ff; }' +
            '.pv-err-zone { margin-bottom:14px; padding:12px 14px; border-radius:8px; background:#fff4f4; border:1px solid #f8c4c4; }' +
            '.pv-err-title { font-size:13px; font-weight:700; color:#c53030; margin-bottom:6px; }' +
            '.pv-err-list  { display:flex; flex-wrap:wrap; gap:6px; }' +
            '.pv-err-chip  { display:inline-block; padding:3px 10px; background:#fff; border:1px solid #f8c4c4; border-radius:14px; font-size:12px; color:#c53030; font-weight:600; }' +
            '.pv-cd { display:inline-flex; align-items:center; gap:6px; }' +
            '.pv-cd-k { display:inline-block; min-width:20px; padding:1px 7px; border-radius:3px; background:#eef3fb; color:#1e3c72; font-weight:700; font-family:Consolas,monospace; font-size:12px; text-align:center; }' +
            '.pv-cd-v { color:#2c3e50; font-weight:500; font-size:12.5px; }' +
            /* D. 신체기능(ADL) 섹션 — 코드 숫자 숨김 (변경 표시는 .pv-diff 가 텍스트 전체에 적용되므로 글자 앞에 ⚠ 표시) */
            '.pv-adl .pv-cd-k { display:none !important; }' +
            '.pv-adl .pv-cd { gap:0; }' +
            '.pv-diff { color:#d32f2f !important; font-weight:800 !important; cursor:pointer; border-bottom:2px solid #d32f2f; padding:1px 4px; background:#fff3f3; border-radius:3px; }' +
            '.pv-diff:hover { background:#ffebee; box-shadow:0 0 0 1px #d32f2f; }' +
            '.pv-diff .pv-cd-k, .pv-diff .pv-cd-v, .pv-diff .pv-empty { color:#d32f2f !important; }' +
            '.pv-diff::before { content:"\\26A0"; margin-right:4px; font-size:11px; color:#d32f2f; vertical-align:middle; }' +
            /* 변경 항목 포함 탭 — 빨간 글자 + 우측 상단 ⚠ 배지 */
            '.pv-tab.pv-tab-changed { color:#d32f2f !important; font-weight:800 !important; position:relative; }' +
            '.pv-tab.pv-tab-changed::after { content:"\\26A0"; position:absolute; top:4px; right:4px; font-size:10px; color:#d32f2f; }' +
            '.pv-tab.pv-tab-changed.active { color:#b71c1c !important; border-bottom-color:#d32f2f !important; background:#fff3f3 !important; }';
        document.head.appendChild(st);
    }

    var loadingHtml = '<div style="padding:40px 0; text-align:center; color:#6b7280;"><i class="fas fa-spinner fa-spin" style="font-size:22px;"></i><div style="margin-top:8px;">불러오는 중...</div></div>';

    Swal.fire({
        title: '<span style="font-size:17px;"><i class="fas fa-clipboard-list" style="color:#2a5298;margin-right:8px;"></i>환자평가표 조회</span>',
        html: loadingHtml,
        width: '1180px',
        showCloseButton: true,
        showConfirmButton: false,
        didOpen: function() {
            $.ajax({
                url: "/main/select_PatvalMst.do",
                type: "POST",
                data: {
                    hospCd:   hospid,
                    patId:    row.patId,
                    admitDt:  row.admitDt,
                    medStart: row.medStart
                },
                dataType: "json",
                success: function(res) {
                    var d = (res && res.data) ? res.data : null;
                    d = _pvNormalizeKeys(d);
                    // 전월 비교용 직전 행 (있으면 전역에 저장)
                    var p = (res && res.prev) ? res.prev : null;
                    _PV_PREV = _pvNormalizeKeys(p) || null;
                    Swal.update({ html: _pvBuildHtml(d, row) });
                    _pvBindTabs();
                    _pvBindDiffClick();
                },
                error: function() {
                    Swal.update({ html: '<div style="padding:30px;text-align:center;color:#c53030;">데이터를 불러오지 못했습니다.</div>' });
                }
            });
        }
    });
}

function _pvBindTabs() {
    $('.pv-tab').off('click.pv').on('click.pv', function() {
        var tgt = $(this).data('tab');
        $('.pv-tab').removeClass('active');
        $(this).addClass('active');
        $('.pv-pane').removeClass('active');
        $('.pv-pane[data-tab="' + tgt + '"]').addClass('active');
    });
    // 변경 항목 포함 탭에 빨간 표시 마킹
    _pvMarkChangedTabs();
}

// 각 탭 페인 안에 .pv-diff 엘리먼트가 있으면 해당 탭 버튼에 pv-tab-changed 클래스 부여
function _pvMarkChangedTabs() {
    $('.pv-tab').removeClass('pv-tab-changed');
    $('.pv-pane').each(function() {
        var tgt = $(this).data('tab');
        if ($(this).find('.pv-diff').length > 0) {
            $('.pv-tab[data-tab="' + tgt + '"]').addClass('pv-tab-changed');
        }
    });
}

function _pvBuildHtml(d, row) {
    d = d || {};
    var header = '' +
        '<div class="pv-head">' +
        '  <div class="pv-head-item"><span class="lbl">환자ID</span><span class="val">' + _pvMaskPatId(d.patId || row.patId) + '</span></div>' +
        '  <div class="pv-head-item"><span class="lbl">성명</span><span class="val">' + _pvTxt(fn_NameMask(d.patNm || row.patNm)) + '</span></div>' +
        '  <div class="pv-head-item"><span class="lbl">입원일</span><span class="val">' + _pvDt(d.admitDt || row.admitDt) + '</span></div>' +
        '  <div class="pv-head-item"><span class="lbl">요양개시일</span><span class="val">' + _pvDt(d.medStart || row.medStart) + '</span></div>' +
        '  <div class="pv-head-item"><span class="lbl">작성일</span><span class="val">' + _pvDt(d.docDt) + '</span></div>' +
        '  <div class="pv-head-item"><span class="lbl">평가구분</span><span class="val">' + (d.evalType ? $('<div>').text(d.evalType + (_PV_CODES.evalType[d.evalType] ? ' · ' + _PV_CODES.evalType[d.evalType] : '')).html() : '-') + '</span></div>' +
        '  <div class="pv-head-item"><span class="lbl">서식버전</span><span class="val">' + _pvTxt(d.clformVer) + '</span></div>' +
        '</div>';

    if (!d || !d.patId) {
        return header + '<div style="padding:30px 10px;text-align:center;color:#8891a3;">TBL_PATVAL_MST 데이터가 없습니다.</div>';
    }

    var errBadges = _pvErrorBadges(d.patId || row.patId);

    // 전월 비교 안내 (직전 행 있을 때만)
    var prevNotice = '';
    if (_PV_PREV && _PV_PREV.medStart) {
        prevNotice = '<div style="margin:8px 0; padding:8px 12px; background:#fff3f3; border-left:4px solid #d32f2f; border-radius:4px; font-size:12.5px; color:#b71c1c;">' +
                     '<i class="fas fa-exclamation-triangle" style="margin-right:6px;"></i>' +
                     '전월(' + _pvDt(_PV_PREV.medStart) + ') 대비 적정성평가 관련 항목 변경 시 <b style="color:#d32f2f;">빨간색 ⚠</b>으로 표시됩니다. (값 클릭 시 전월 내용 표시)' +
                     '</div>';
    }

    var tabs =
        '<div class="pv-tabs">' +
        '  <button class="pv-tab active" data-tab="t1">A. 일반사항</button>' +
        '  <button class="pv-tab"        data-tab="t2">B·C·D. 의식/인지/신체</button>' +
        '  <button class="pv-tab"        data-tab="t3">E·F. 배설기능/질병진단</button>' +
        '  <button class="pv-tab"        data-tab="t4">G·H·I. 건강/영양/피부</button>' +
        '  <button class="pv-tab"        data-tab="t5">J·K·L. 투약/특수처치</button>' +
        '</div>';

    return '<div style="text-align:left; max-height:70vh; overflow:auto; padding:2px 4px;">' +
           header + prevNotice + errBadges + tabs +
           _pvTab1(d) + _pvTab2(d) + _pvTab3(d) + _pvTab4(d) + _pvTab5(d) +
           '</div>';
}

function _pvSec(title, icon, items) {
    var cells = '';
    for (var i = 0; i < items.length; i++) {
        var vHtml = items[i][1];
        cells += '<div class="pv-cell"><span class="k">' + items[i][0] + '</span><span class="v">' + vHtml + '</span></div>';
    }
    var iconHtml = icon ? '<i class="fas ' + icon + '"></i>' : '';
    return '<div class="pv-sec"><div class="pv-sec-hd">' + iconHtml + title + '</div><div class="pv-grid">' + cells + '</div></div>';
}

function _pvTab1(d) {
    var s1 = _pvSec('A. 일반사항', 'fa-user', [
        ['환자성명', _pvTxt(fn_NameMask(d.patNm))], ['주민등록번호', _pvMaskPatId(d.patId)],
        ['입원일', _pvDt(d.admitDt)], ['요양개시일', _pvDt(d.medStart)],
        ['평가구분', _pvCd('evalType', d.evalType)], ['작성일', _pvDt(d.docDt)],
        ['입원 직전 있던 곳', _pvCd('lastPlace', d.lastPlace)], ['교육수준', _pvCd('eduLevel', d.eduLevel)]
    ]);
    var s2 = _pvSec('건강생활습관 / 혈압', 'fa-heartbeat', [
        ['수축기혈압', _pvTxt(d.sbp)], ['이완기혈압', _pvTxt(d.dbp)],
        ['담배', _pvYn(d.tobacco)], ['술', _pvYn(d.alcohol)],
        ['운동', _pvYn(d.exercise)], ['식사', _pvYn(d.diet)]
    ]);
    var s3 = _pvSec('장기요양등급 및 이용 서비스', 'fa-hands-helping', [
        ['장기요양등급 및 신청', _pvCd('ltcareGrdReq', d.ltcareGrdReq)], ['등급', _pvCd('ltcareGrade', d.ltcareGrade)],
        ['주·야간보호', _pvYn(d.wkdayCare)], ['방문요양', _pvYn(d.visitCare)],
        ['방문간호', _pvYn(d.visitNurse)], ['방문목욕', _pvYn(d.visitBath)],
        ['단기보호', _pvYn(d.shortStay)], ['복지용구 구입 및 대여', _pvYn(d.aidEquip)],
        ['시설입소', _pvYn(d.facStay)], ['기타', _pvYn(d.othService)],
        ['장기요양서비스 이용 의향', _pvYn(d.ltcareInt)]
    ]);
    var s4 = _pvSec('사회환경 선별 조사', 'fa-home', [
        ['응답거부', _pvYn(d.refResp)], ['식사준비, 간병 등', _pvYn(d.mealCare)],
        ['전기·수도 등', _pvYn(d.utilities)], ['거주지', _pvYn(d.residence)],
        ['병원비, 주거비 등', _pvYn(d.medHousing)], ['교통수단', _pvYn(d.transMthd)],
        ['긴급도움', _pvYn(d.emerHelp)]
    ]);
    return '<div class="pv-pane active" data-tab="t1">' + s1 + s2 + s3 + s4 + '</div>';
}

function _pvTab2(d) {
    var s1 = _pvSec('B. 의식상태 / C. 인지기능', 'fa-brain', [
        ['혼수', _pvYn(d.coma)], ['섬망', _pvCd('delirium', d.delirium)],
        ['단기기억력', _pvCd('shortMem', d.shortMem)], ['인식기술', _pvCd('perception', d.perception)],
        ['이해시키는 능력', _pvCd('comprehen', d.comprehen)], ['의사표현', _pvYn(d.express)]
    ]);
    var s2 = _pvSec('행동심리증상의 빈도 (0 없음·1 가끔·2 자주·3 매우 자주)', 'fa-comment-medical', [
        ['망상', _pvCd('bpsd', d.delusion)], ['환각', _pvCd('bpsd', d.hallucin)],
        ['초조/공격성', _pvCd('bpsd', d.agitation)], ['우울/낙담', _pvCd('bpsd', d.depress)],
        ['불안', _pvCd('bpsd', d.anxiety)], ['들뜬 기분/다행감', _pvCd('bpsd', d.euphoria)],
        ['무감동/무관심', _pvCd('bpsd', d.apathy)], ['탈억제', _pvCd('bpsd', d.disinhib)],
        ['과민/불안정', _pvCd('bpsd', d.irritable)], ['이상 운동증상 또는 반복적 행동', _pvCd('bpsd', d.dyskinesia)],
        ['수면/야간행동', _pvCd('bpsd', d.sleepBehav)], ['식욕/식습관의 변화', _pvCd('bpsd', d.appetite)],
        ['케어에 대한 저항', _pvCd('bpsd', d.careResist)], ['배회', _pvCd('bpsd', d.wander)]
    ]);
    var s3 = _pvSec('K-MMSE(또는 MMSE-K) / 치매 척도 검사 (CDR · GDS)', 'fa-notes-medical', [
        ['K-MMSE 실시여부', _pvYn(d.mmseYn)], ['K-MMSE 점수', _pvTxt0(d.mmseScore)], ['K-MMSE 검사일', _pvDt(d.mmseDt)],
        ['CDR 실시여부', _pvYn(d.cdrYn)],   ['CDR 점수',   _pvTxt(d.cdrScore)],  ['CDR 검사일',  _pvDt(d.cdrDt)],
        ['GDS 실시여부', _pvYn(d.gdsYn)],   ['GDS 점수',   _pvTxt(d.gdsScore)],  ['GDS 검사일',  _pvDt(d.gdsDt)]
    ]);
    var p = _PV_PREV || {};
    var gAdl = 'D. 신체기능(ADL)';
    var s4 = '<div class="pv-adl">' + _pvSec('D. 신체기능 척도(1 완전자립 · 2 감독필요 · 3 약간도움 · 4 상당도움 · 5 전적도움 · 5 행위 발생안함)', '', [
        ['옷벗고 입기', _pvDiffCd('adl', d.dressing, p.dressing, gAdl, true)], ['세수하기', _pvDiffCd('adl', d.washing, p.washing, gAdl, true)],
        ['양치질하기', _pvDiffCd('adl', d.brushing, p.brushing, gAdl, true)], ['목욕하기', _pvDiffCd('adl', d.bathing, p.bathing, gAdl, true)],
        ['식사하기', _pvDiffCd('adl', d.eating, p.eating, gAdl, true)], ['체위변경하기', _pvDiffCd('adl', d.movePos, p.movePos, gAdl, true)],
        ['일어나 앉기', _pvDiffCd('adl', d.sitUp, p.sitUp, gAdl, true)], ['옮겨앉기', _pvDiffCd('adl', d.transfer, p.transfer, gAdl, true)],
        ['방밖으로 나오기', _pvDiffCd('adl', d.exitRoom, p.exitRoom, gAdl, true)], ['화장실 사용하기', _pvDiffCd('adl', d.toiletUse, p.toiletUse, gAdl, true)],
        ['와상상태', _pvDiffYn(d.bedridden, p.bedridden, gAdl)]
    ]) + '</div>';
    return '<div class="pv-pane" data-tab="t2">' + s1 + s2 + s3 + s4 + '</div>';
}

function _pvTab3(d) {
    var p = _PV_PREV || {};
    var gCath = 'E·F. 유치도뇨관 삽입/삽입기간';
    var s1 = _pvSec('E. 배설기능 / 배변조절 기구 및 프로그램', 'fa-tint', [
        ['대변조절', _pvCd('bowelCtl', d.bowelCtl)], ['소변조절', _pvCd('urineCtl', d.urineCtl)],
        ['일정하게 짜여진 배뇨계획', _pvYn(d.urPlan)], ['방광 훈련 프로그램', _pvYn(d.bladTrain)],
        ['규칙적 도뇨', _pvYn(d.regCath)], ['외부(콘돔형) 카테터', _pvYn(d.extCath)],
        ['패드, 팬티형 기저귀', _pvYn(d.padDiaper)], ['인공루', _pvYn(d.artifUr)],
        ['유치도뇨관 삽입', _pvDiffYn(d.indwellCath, p.indwellCath, gCath)], ['해당사항 없음', _pvYn(d.catNoa)],
        ['배뇨일지 작성 여부', _pvYn(d.diaryCreated)], ['배뇨일지 작성일수', _pvTxt(d.diaryDays)],
        ['삽입기간(g-1~g-10 제외)', _pvDiffTxt(d.catDur, p.catDur, gCath)]
    ]);

    var cathRows = '';
    for (var i = 1; i <= 10; i++) {
        var ii = d['catIn' + i];
        var oo = d['catOut' + i];
        if (!ii && !oo) continue;
        cathRows += '<tr><td>' + i + '</td><td class="dt">' + _pvDt(ii) + '</td><td class="dt">' + _pvDt(oo) + '</td></tr>';
    }
    if (!cathRows) cathRows = '<tr><td colspan="3" style="color:#b0b6bf;padding:14px;">삽입/제거 기록 없음</td></tr>';
    var s2 =
        '<div class="pv-sec">' +
        '  <div class="pv-sec-hd"><i class="fas fa-syringe"></i>유치도뇨관 삽입 / 제거 이력</div>' +
        '  <table class="pv-cath-tbl"><thead><tr><th style="width:60px;">회차</th><th>삽입일자</th><th>제거일자</th></tr></thead>' +
        '  <tbody>' + cathRows + '</tbody></table>' +
        '</div>';

    var gDM = 'F.1.a 당뇨 — HbA1c 검사 실시여부';
    var s3 = _pvSec('F.1.a 당뇨 / 혈당 / HbA1c', 'fa-vial', [
        ['당뇨', _pvYn(d.diabetes)], ['혈당검사 실시여부', _pvYn(d.bldSugarTest)],
        ['공복시 혈당 (mg/dl)', _pvTxt(d.fastingSugar)], ['식후2시간 혈당 (mg/dl)', _pvTxt(d.post2hSugar)],
        ['HbA1c검사 실시여부', _pvDiffYn(d.hba1cTest, p.hba1cTest, gDM)], ['HbA1c (%)', _pvDiffHbA1c(d.hba1cValue, p.hba1cValue, gDM)],
        ['검사일', _pvDt(d.testDate)]
    ]);
    var s4 = _pvSec('F.1 질병', 'fa-disease', [
        ['고혈압', _pvYn(d.hyperten)], ['요로감염', _pvYn(d.uti)],
        ['말초혈관질환', _pvYn(d.vascDis)], ['하지마비', _pvYn(d.paralysis)],
        ['사지마비', _pvYn(d.allLimbs)], ['편마비', _pvYn(d.hemiplegia)],
        ['뇌성마비', _pvYn(d.cerebralP)], ['뇌혈관질환', _pvYn(d.stroke)],
        ['파킨슨병(G20)', _pvYn(d.parkinson)], ['척수손상', _pvYn(d.spinalInj)],
        ['중증근무력증 및 기타 근신경장애(G70)', _pvYn(d.myasthenia)],
        ['근육의 원발성 장애(G71)', _pvYn(d.muscDis)],
        ['다발경화증(G35)', _pvYn(d.ms)], ['헌팅톤병(G10)', _pvYn(d.huntington)],
        ['유전성 운동실조(G11)', _pvYn(d.heredAtax)],
        ['척수성 근위축 및 관련 증후군(G12)', _pvYn(d.spinalAtro)],
        ['계통성 위축(G13)', _pvYn(d.systemAtro)],
        ['진행성 핵상 안근마비(G23.1)', _pvYn(d.progSupra)],
        ['중추신경계통의 비정형바이러스 감염(A81)', _pvYn(d.viralInf)],
        ['아급성 괴사성 뇌병증[리이](G31.81)', _pvYn(d.subNecr)],
        ['후천성면역결핍증(B20~B24, Z21)', _pvYn(d.hiv)], ['치매', _pvYn(d.dementia)],
        ['고지혈증', _pvYn(d.lipidemia)], ['심부전', _pvYn(d.heartFail)],
        ['만성폐색성폐질환', _pvYn(d.copd)], ['천식', _pvYn(d.asthma)],
        ['해당사항 없음', _pvYn(d.diseNoa)]
    ]);
    return '<div class="pv-pane" data-tab="t3">' + s1 + s2 + s3 + s4 + '</div>';
}

function _pvTab4(d) {
    var p = _PV_PREV || {};
    var gUlcer = 'I.1~I.4 욕창(압박성 궤양)';
    var gSkin  = 'I.5 피부문제에 대한 처치';
    var s1 = _pvSec('F.2 영양관련 장애 / H. 구강 및 영양상태', 'fa-apple-alt', [
        ['콰시오르코르(E40)', _pvYn(d.kwashE40)], ['영양성 소모증(E41)', _pvYn(d.nutrE41)],
        ['소모성 콰시오르코르(E42)', _pvYn(d.wasteKwE42)],
        ['상세불명의 중증 단백질-에너지 영양실조(E43)', _pvYn(d.sevMalE43)],
        ['중등도 및 경도의 단백질-에너지 영양실조(E44)', _pvYn(d.modMalE44)],
        ['단백질-에너지 영양실조로 인한 발육지연(E45)', _pvYn(d.growthDE45)],
        ['상세불명의 단백질-에너지 영양실조(E46)', _pvYn(d.malUnkE46)],
        ['해당사항 없음', _pvYn(d.nutrNoa)],
        ['삼키기', _pvYn(d.swallow)],
        ['체중 측정여부', _pvYn(d.weigHeigYn)], ['체중(kg)', _pvDecLast(d.weig, 'kg')], ['체중 측정일', _pvDt(d.weigDt)],
        ['체중감소', _pvCd('weigLoss', d.weigLoss)], ['키 측정여부', _pvYn(d.heigYn)],
        ['키(cm)', _pvDecLast(d.heigSec, 'cm')], ['키 측정일', _pvDt(d.heigDt)],
        ['정맥영양', _pvYn(d.ivNutri)], ['경관영양 실시여부', _pvYn(d.ivNutYn)],
        ['경관영양 실시일수', _pvTxt(d.ivNutDy)],
        ['칼로리 (6일간 1일 평균)', _pvCd('calories', d.calories)],
        ['수분량 (6일간 1일 평균)',  _pvCd('waterAmt', d.waterAmt)]
    ]);
    var s2 = _pvSec('G.1 문제상황', 'fa-thermometer-half', [
        ['열', _pvYn(d.fever)], ['체온(℃)', _pvTxt(d.bodyTemp)],
        ['검사와 처치', _pvYn(d.testTreat)], ['발열 일수', _pvTxt(d.feverDays)],
        ['탈수', _pvYn(d.dehydr)], ['구토', _pvYn(d.vomit)],
        ['수술 3개월 이내 루 관리', _pvYn(d.surgInfec)],
        ['출혈·감염 등의 문제로 인한 루 관리', _pvYn(d.bloodInfec)],
        ['해당사항 없음', _pvYn(d.helthNoa)]
    ]);
    var s3 = _pvSec('G.2 통증 / G.3 낙상여부 / G.4 말기질환', 'fa-bolt', [
        ['통증 발생 빈도', _pvCd('painFreq', d.painFreq)], ['시각 통증 등급(VAS)', _pvTxt(d.painVisSc)],
        ['숫자 통증 등급(NRS)', _pvTxt(d.painNumSc)], ['얼굴 통증 등급(FPS)', _pvTxt(d.painFaceSc)],
        ['통증관련 치료', _pvYn(d.painTreatR)], ['암성통증 치료', _pvYn(d.painTreatC)],
        ['30일 이내 낙상', _pvCd('fall', d.fall30d)], ['31~180일 사이에 낙상', _pvCd('fall', d.fall31180d)],
        ['말기질환', _pvYn(d.termDisease)]
    ]);
    var s4 = _pvSec('I.1 피부궤양의 수 / I.2 새로 발생한 욕창 / I.3 과거력 / I.4 기타문제', 'fa-band-aid', [
        ['욕창(압박성 궤양) 1단계', _pvDiffTxt(d.prUlcer1, p.prUlcer1, gUlcer)], ['욕창(압박성 궤양) 2단계', _pvDiffTxt(d.prUlcer2, p.prUlcer2, gUlcer)],
        ['욕창(압박성 궤양) 3단계', _pvDiffTxt(d.prUlcer3, p.prUlcer3, gUlcer)], ['욕창(압박성 궤양) 4단계', _pvDiffTxt(d.prUlcer4, p.prUlcer4, gUlcer)],
        ['울혈/허혈성 궤양 1단계', _pvDiffTxt(d.ciUl1, p.ciUl1, gUlcer)], ['울혈/허혈성 궤양 2단계', _pvDiffTxt(d.ciUl2, p.ciUl2, gUlcer)],
        ['울혈/허혈성 궤양 3단계', _pvDiffTxt(d.ciUl3, p.ciUl3, gUlcer)], ['울혈/허혈성 궤양 4단계', _pvDiffTxt(d.ciUl4, p.ciUl4, gUlcer)],
        ['새로 발생한 욕창 유무', _pvDiffCd('newUlcer', d.newUlcer, p.newUlcer, gUlcer)], ['발생일', _pvDt(d.ulcerDt)],
        ['욕창(압박성 궤양) 과거력', _pvDiffCd('pastUlcer', d.pastUlcer, p.pastUlcer, gUlcer)],
        ['2도 이상의 화상', _pvDiffYn(d.skinProb, p.skinProb, gUlcer)],
        ['개방성 피부병변', _pvDiffYn(d.openSkinLes, p.openSkinLes, gUlcer)], ['수술 창상', _pvDiffYn(d.surgWound, p.surgWound, gUlcer)],
        ['발의 감염', _pvDiffYn(d.footInfec, p.footInfec, gUlcer)], ['해당사항 없음', _pvYn(d.skinNoa)]
    ]);
    var s5 = _pvSec('I.5 피부문제에 대한 처치', 'fa-hand-holding-medical', [
        ['압력을 줄여주는 도구 사용', _pvDiffYn(d.pressRelDev, p.pressRelDev, gSkin)], ['체위변경', _pvDiffYn(d.posChange, p.posChange, gSkin)],
        ['피부문제 해결을 위한 영양공급', _pvDiffYn(d.nutrSkin, p.nutrSkin, gSkin)],
        ['피부궤양 드레싱', _pvDiffYn(d.skinUlcDres, p.skinUlcDres, gSkin)],
        ['피부궤양 드레싱 부위 : 발', _pvDiffYn(d.footDres, p.footDres, gSkin)],
        ['피부궤양 드레싱 부위 : 발 이외', _pvDiffYn(d.nonFootDres, p.nonFootDres, gSkin)],
        ['피부궤양 이외의 드레싱', _pvDiffYn(d.nonUlcDres, p.nonUlcDres, gSkin)],
        ['드레싱 부위 : 발', _pvDiffYn(d.leg, p.leg, gSkin)],
        ['드레싱 부위 : 발 이외', _pvDiffYn(d.legOther, p.legOther, gSkin)],
        ['수술창상 치료', _pvDiffYn(d.surWndCare, p.surWndCare, gSkin)],
        ['화상관련 처치', _pvDiffYn(d.burnTreat, p.burnTreat, gSkin)], ['해당사항 없음', _pvYn(d.fskinNoa)]
    ]);
    return '<div class="pv-pane" data-tab="t4">' + s1 + s2 + s3 + s4 + s5 + '</div>';
}

function _pvTab5(d) {
    var s1 = _pvSec('J. 투약', 'fa-pills', [
        ['인슐린 주사제 투여 일수', _pvCd('insulin', d.insulin)],
        ['행동심리증상에 대한 약물 치료 여부', _pvYn(d.psychDrug)],
        ['치매관련 약제 투여 여부', _pvYn(d.demnDrug)],
        ['복용한 의약품 수', _pvCd('medCount', d.medCount)]
    ]);
    var s2 = _pvSec('K.1 특수처치', 'fa-lungs', [
        ['정맥주사에 의한 투약', _pvYn(d.ivMed)],
        ['정맥주사 투여일수', _pvTxt(d.ivDays)],
        ['배뇨관련 루 관리', _pvYn(d.urineMgmt)],
        ['배변관련 루 관리', _pvYn(d.bowelMgmt)],
        ['영양관련 루 관리', _pvYn(d.nutriMgmt)],
        ['산소요법', _pvYn(d.oxygen)],
        ['(산소투여 전) 산소포화도(%)', _pvTxt(d.oxySatBf)],
        ['산소투여일수', _pvTxt(d.oxyDays)],
        ['하기도 증기흡입치료', _pvYn(d.lowAirTh)],
        ['흡인', _pvYn(d.suction)],
        ['기관절개관 관리', _pvYn(d.trachCare)],
        ['인공호흡기', _pvYn(d.ventilator)],
        ['인공호흡기 개인용', _pvYn(d.perVent)],
        ['인공호흡기 병원용', _pvYn(d.hosVent)],
        ['중심정맥영양', _pvYn(d.cvNutr)],
        ['해당사항 없음', _pvYn(d.specNoa)]
    ]);
    var s3 = _pvSec('K.2 전문재활치료', 'fa-signature', [
        ['전문재활치료 실시일수', _pvTxt(d.vitalRehab)]
    ]);
    return '<div class="pv-pane" data-tab="t5">' + s1 + s2 + s3 + '</div>';
}
