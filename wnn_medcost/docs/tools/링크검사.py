# -*- coding: utf-8 -*-
"""docs 안 마크다운 링크가 **실제로 있는지** 훑는다 (2026-08-15 신설).

  쓰는 때 : 문서를 **옮기거나 폴더를 바꾼 뒤**. 옮기기만 하면 링크가 조용히 깨진다
            (2026-08-15 정리 때 proposals 260여 개 · sql 121개를 함께 고쳐야 했다).
  쓰는 법 : 저장소 뿌리에서  python docs/tools/링크검사.py
  결과    : 깨진 링크를 「파일 → 링크」로 늘어놓는다. 0 이면 아무것도 안 나온다.

  ⚠`.claude/CLAUDE.md` 는 **저장소 뿌리 기준**으로 링크를 적으므로 따로 본다(--claude).
  ⚠`[조사의 목표](서술)` 처럼 **링크가 아닌 괄호**가 섞여 있다 — 파일이 아닌 것은 걸러 읽을 것.
"""
import io, os, re, sys

SKIP = re.compile(r'https?:|#|mailto:')

def scan(root):
    bad = []
    for dp, dn, fn in os.walk(root):
        if '.git' in dp:
            continue
        for f in fn:
            if not f.endswith('.md'):
                continue
            t = os.path.join(dp, f)
            try:
                s = io.open(t, encoding='utf-8').read()
            except Exception:
                continue
            for m in re.finditer(r'\]\(([^)\s]+)\)', s):
                link = m.group(1)
                if SKIP.match(link):
                    continue
                p = os.path.normpath(os.path.join(dp, link.split('#')[0]))
                if not os.path.exists(p):
                    bad.append((t, link))
    return bad

def scan_claude():
    """CLAUDE.md 는 뿌리 기준 — 같은 잣대로 보면 전부 깨진 것처럼 보인다."""
    p = '.claude/CLAUDE.md'
    if not os.path.exists(p):
        return []
    s = io.open(p, encoding='utf-8').read()
    return [(p, l) for l in re.findall(r'\]\(([^)\s]+)\)', s)
            if not SKIP.match(l) and not os.path.exists(os.path.normpath(l.split('#')[0]))]

if __name__ == '__main__':
    bad = scan('docs') + scan_claude()
    for t, l in bad:
        print('%s -> %s' % (t, l))
    print('깨진 링크 %d건' % len(bad))
    sys.exit(1 if bad else 0)
