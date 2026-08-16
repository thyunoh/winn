# -*- coding: utf-8 -*-
"""JSP 가 성한지 본다 — ①잘린 태그 ②div 짝 ③script 짝 ④JSP 주석 짝 ⑤주입 조각 (2026-08-15 신설)

  쓰는 때 : ***여러 JSP 를 스크립트로 한꺼번에 고친 뒤.*** 실제로 두 번 크게 데였다 —
      ⓐ 탭 띠를 넣을 자리를 정규식으로 잡다가 **여는 태그 한복판을 잘라** 9개 파일이 한꺼번에 깨졌다
         (`<div class="qr-title">` → `v class="qr-title">`). ⇒ 줄 단위로 div 개수를 세어 넣을 것.
      ⓑ JS 주석에 `--` + `%>` 를 남겨 **JSP 가 거기서 주석을 닫았다.** 눈으로는 안 보인다.
  쓰는 법 : python docs/tools/JSP구조검사.py            (qpsmgr 전체)
            python docs/tools/JSP구조검사.py qpsRca.jsp (골라서)
  ⚠`</div>` 가 **JS 문자열 안**에 있는 화면은 짝이 안 맞는 것처럼 보인다(qpsIndex) — 오탐이다.
"""
import io, os, re, sys

# ⚠윈도 콘솔이 cp949 라 이모지·특수기호에서 죽는다 — 출력만 UTF-8 로 돌려놓는다
try:
    sys.stdout.reconfigure(encoding='utf-8')
except Exception:
    pass

D = r'C:\Users\HYUN\git\winn\wnn_medcost\src\main\webapp\WEB-INF\jsp\main\qpsmgr'
files = sys.argv[1:] or sorted(f for f in os.listdir(D) if f.endswith('.jsp'))
bad = 0
for f in files:
    p = os.path.join(D, f)
    s = io.open(p, encoding='utf-8').read()
    msg = []

    # ① 잘린 태그 — `<div` 없이 ` class="` 로 시작하는 줄, 또는 `>v class=` 같은 흔적
    for i, l in enumerate(s.split('\n'), 1):
        if re.search(r'>[a-z] class="', l) or re.match(r'^\s*[a-z] class="', l):
            msg.append('%d줄 태그 잘림 : %s' % (i, l.strip()[:60]))
    # ② div 짝
    o, c = len(re.findall(r'<div\b', s)), len(re.findall(r'</div>', s))
    if o != c: msg.append('div 짝 안 맞음 (여는 %d · 닫는 %d)' % (o, c))
    # ③ script 짝
    so, sc = len(re.findall(r'<script\b', s)), len(re.findall(r'</script>', s))
    if so != sc: msg.append('script 짝 안 맞음 (%d/%d)' % (so, sc))
    # ④ 주입 조각
    if 'zz-tabs' in s or 'plTabs' in s or 'srTabs' in s or 'ckTabs' in s:
        if s.count('id="zzTabs"') > 1: msg.append('탭 띠가 두 번 들어감')
        m = re.search(r'<div class="zz-tabs"[^>]*></div>(.{0,20})', s, re.S)
        if m and m.group(1).strip() and not m.group(1).lstrip().startswith(('<', '\n')):
            msg.append('탭 띠 뒤가 이상함 : ' + m.group(1)[:30])
    # ⑤ JSP 주석 짝
    if s.count('<%--') != s.count('--%>'): msg.append('JSP 주석 짝 안 맞음')

    if msg:
        bad += 1
        print('[문제] %s' % f)
        for x in msg: print('    ' + x)
print('\n검사 %d개 · 문제 %d개' % (len(files), bad))
sys.exit(1 if bad else 0)
