// 권한 쿠키 가져오기
let s_insauth = getCookie("s_insauth");
let s_updauth = getCookie("s_updauth");
let s_delauth = getCookie("s_delauth");
let s_inqauth = getCookie("s_inqauth");

// 버튼 권한 제어 함수
function applyAuthControl() {
    // 입력 권한
    if (s_insauth === 'N' || s_insauth === '') {
        document.querySelectorAll('.btn-insert').forEach(btn => btn.style.display = 'none');
    }

    // 수정 권한
    if (s_updauth === 'N' || s_updauth === '') {
        document.querySelectorAll('.btn-update').forEach(btn => btn.style.display = 'none');
    }
    // 삭제 권한
    if (s_delauth === 'N' || s_delauth === '') {
        document.querySelectorAll('.btn-delete').forEach(btn => btn.style.display = 'none');
    }
}