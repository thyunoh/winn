# 캡처 여러 장의 「제목 띠」만 잘라 한 장으로 붙인다.
# 남은 캡처에 무엇이 들어 있는지 먼저 알고 계획을 세우려는 것 — 한 장씩 여는 것보다 훨씬 싸다.
param(
  [Parameter(Mandatory=$true)][int]$From,
  [Parameter(Mandatory=$true)][int]$To,
  [int]$X = 530, [int]$Y = 35, [int]$W = 720, [int]$H = 110,
  [double]$Scale = 1.6,
  [Parameter(Mandatory=$true)][string]$Out
)
Add-Type -AssemblyName System.Drawing
$caps = 'C:\Users\SRC\AppData\Local\Temp\claude\D--egv\fc244a95-de7c-4562-a48e-ca8ee8a78070\scratchpad\caps'
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
  $x = $X; $y = $Y; $w = $W; $h = $H
  if ($x + $w -gt $b.Width)  { $w = $b.Width  - $x }
  if ($y + $h -gt $b.Height) { $h = $b.Height - $y }
  if ($w -gt 0 -and $h -gt 0) {
    $r    = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $crop = $b.Clone($r, $b.PixelFormat)
    $g.DrawImage($crop, $labelW, ($i * $rowH), [int]($w * $Scale), $rowH)
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
