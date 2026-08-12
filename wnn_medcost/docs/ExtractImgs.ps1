# 세션 기록(jsonl)에 박힌 캡처를 파일로 꺼낸다. 사용자가 이미 올린 것을 되찾는 것이다.
param(
  [string]$Jsonl = 'C:\Users\SRC\.claude\projects\D--egv\919e7786-52c2-4706-bdf1-84680c4e1643.jsonl',
  [string]$Out   = 'C:\Users\SRC\AppData\Local\Temp\claude\D--egv\fc244a95-de7c-4562-a48e-ca8ee8a78070\scratchpad\caps'
)
if (-not (Test-Path $Out)) { New-Item -ItemType Directory -Path $Out | Out-Null }
$rx = [regex]'"type":"image","source":\{"type":"base64","media_type":"image/png","data":"([^"]+)"'
$seen = @{}; $n = 0; $ln = 0
$log = New-Object System.Collections.Generic.List[string]
foreach ($line in [System.IO.File]::ReadLines($Jsonl)) {
  $ln++
  if ($line.IndexOf('"type":"image"') -lt 0) { continue }
  foreach ($mm in $rx.Matches($line)) {
    $b64 = $mm.Groups[1].Value
    $key = $b64.Length.ToString() + '_' + $b64.Substring(0, [Math]::Min(160, $b64.Length))
    if ($seen.ContainsKey($key)) { continue }      # 압축 요약에 다시 실린 것은 거른다
    $seen[$key] = $true; $n++
    $name = ('cap{0:D3}.png' -f $n)
    [IO.File]::WriteAllBytes((Join-Path $Out $name), [Convert]::FromBase64String($b64))
    $log.Add("$name`tline=$ln")
  }
}
$log | Set-Content (Join-Path $Out '_index.txt') -Encoding UTF8
"꺼낸 이미지 = $n 장"
