# 0단계 — SUNWOO 델파이 소스 색인 (2026-09-02)
#   dfm_index.tsv : 유닛(파일 이름) → .dfm 전체 경로
#   t_unit.tsv    : sunwoo2026.txt 의 insert into t_unit → 유닛, 코드, 화면 이름
# 사용 : pwsh build_index.ps1 [-Src D:\sunwoo\sunwoo]
param([string]$Src = "D:\sunwoo\sunwoo")
$out = $PSScriptRoot
Get-ChildItem (Join-Path $Src "SmartChart\CHT") -Recurse -Filter "*.dfm" |
  ForEach-Object { "{0}`t{1}" -f $_.BaseName, $_.FullName } | Set-Content "$out\dfm_index.tsv" -Encoding UTF8
$re = [regex]"insert into t_unit values \('([^']*)',\s*'([^']*)',\s*'([^']*)'"
Get-Content (Join-Path $Src "sunwoo2026.txt") -Encoding UTF8 |
  ForEach-Object { $m = $re.Match($_); if ($m.Success) { "{0}`t{1}`t{2}" -f $m.Groups[1].Value, $m.Groups[2].Value, $m.Groups[3].Value.Trim() } } |
  Set-Content "$out\t_unit.tsv" -Encoding UTF8
"dfm: " + (Get-Content "$out\dfm_index.tsv").Count + " · t_unit: " + (Get-Content "$out\t_unit.tsv").Count
