# 캡처 여러 장의 「제목 띠」만 잘라 한 장으로 붙인다.
# 남은 캡처에 무엇이 들어 있는지 먼저 알고 계획을 세우려는 것 — 한 장씩 여는 것보다 훨씬 싸다.
param(
  [Parameter(Mandatory=$true)][int]$From,
  [Parameter(Mandatory=$true)][int]$To,
  [int]$X = 530, [int]$Y = 35, [int]$W = 720, [int]$H = 110,
  [double]$Scale = 1.6,
  [Parameter(Mandatory=$true)][string]$Out,
  # ★캡처 폴더 — 부서마다 다르다(시설/간호병동…). 2026-08-13 에 인자로 뺐다 :
  #   고정해 두면 다음 부서에서 이 파일을 고쳐야 하고, 고치면 옛 부서를 다시 볼 때 또 고쳐야 한다.
  [string]$Dir = ''
)
Add-Type -AssemblyName System.Drawing
$caps = if ($Dir) { $Dir } else {
  'C:\Users\SRC\AppData\Local\Temp\claude\D--egv\fc244a95-de7c-4562-a48e-ca8ee8a78070\scratchpad\caps'
}
if (-not (Test-Path $caps)) { throw "캡처 폴더가 없다 : $caps" }
$labelW = 90
$rowH   = [int]($H * $Scale)
$n      = $To - $From + 1
$outW   = [int]($W * $Scale) + $labelW
$big    = New-Object System.Drawing.Bitmap($outW, ($rowH * $n))
$g      = [System.Drawing.Graphics]::FromImage($big)
$g.Clear([System.Drawing.Color]::White)
$g.InterpolationMode = 'HighQualityBicubic'
$font   = New-Object System.Drawing.Font('Consolas', 16, [System.Drawing.FontStyle]::Bold)
$brush  = [System.Drawing.Brushes]::Black
for ($i = 0; $i -lt $n; $i++) {
  $name = 'cap{0:D3}.png' -f ($From + $i)
  $path = Join-Path $caps $name
  if (-not (Test-Path $path)) { continue }
  $b = [System.Drawing.Bitmap]::FromFile($path)
  # ★★이름을 `$cx…` 로 쓴다 — ***PowerShell 은 변수 이름의 대소문자를 안 가린다.***
  #   `$w = $W` 는 같은 변수라 아래 clamp 가 **매개변수 `$W` 를 덮어쓴다.**
  #   좁은 캡처가 하나만 섞여도 `$W` 가 음수로 굳어 ***그 뒤 전부 안 그려진다***
  #   (2026-08-13 실제 발생 — 간호/병동 몽타주가 통째로 백지였다. 시설은 첫 장이 넓어 우연히 통과했다).
  $cx = $X; $cy = $Y; $cw = $W; $ch = $H
  if ($cx -ge $b.Width -or $cy -ge $b.Height) { $b.Dispose(); continue }   # 크롭 자리가 이미지 밖
  if ($cx + $cw -gt $b.Width)  { $cw = $b.Width  - $cx }
  if ($cy + $ch -gt $b.Height) { $ch = $b.Height - $cy }
  if ($cw -gt 0 -and $ch -gt 0) {
    $r    = New-Object System.Drawing.Rectangle($cx, $cy, $cw, $ch)
    $crop = $b.Clone($r, $b.PixelFormat)
    $g.DrawImage($crop, $labelW, ($i * $rowH), [int]($cw * $Scale), $rowH)
    $crop.Dispose()
  }
  $g.DrawString(('{0:D3}' -f ($From + $i)), $font, $brush, 4, ($i * $rowH + 8))
  $g.DrawLine([System.Drawing.Pens]::LightGray, 0, ($i * $rowH), $outW, ($i * $rowH))
  $b.Dispose()
}
$g.Dispose()
$big.Save($Out, [System.Drawing.Imaging.ImageFormat]::Png)
$big.Dispose()
"cap$From~$To 제목 띠 $n 줄 → $Out"
