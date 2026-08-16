# 캡처의 일부를 잘라 3~4배로 늘린다. 작은 글자는 늘리지 않으면 낱말이 달라진다.
param(
  [Parameter(Mandatory=$true)][string]$Src,
  [Parameter(Mandatory=$true)][int]$X,
  [Parameter(Mandatory=$true)][int]$Y,
  [Parameter(Mandatory=$true)][int]$W,
  [Parameter(Mandatory=$true)][int]$H,
  [int]$Scale = 3,
  [string]$Out = ''
)
Add-Type -AssemblyName System.Drawing
$capsDir = Split-Path $Src -Parent
if (-not $Out) { $Out = Join-Path $capsDir ('zoom_' + [IO.Path]::GetFileNameWithoutExtension($Src) + "_${X}_${Y}.png") }
$b = [System.Drawing.Bitmap]::FromFile($Src)
# 이미지 밖으로 나가지 않게 자른다
if ($X -lt 0) { $X = 0 }; if ($Y -lt 0) { $Y = 0 }
if ($X + $W -gt $b.Width)  { $W = $b.Width  - $X }
if ($Y + $H -gt $b.Height) { $H = $b.Height - $Y }
$r = New-Object System.Drawing.Rectangle($X, $Y, $W, $H)
$crop = $b.Clone($r, $b.PixelFormat)
$big = New-Object System.Drawing.Bitmap(($W * $Scale), ($H * $Scale))
$g = [System.Drawing.Graphics]::FromImage($big)
$g.InterpolationMode = 'HighQualityBicubic'
$g.DrawImage($crop, 0, 0, $big.Width, $big.Height)
$g.Dispose()
$big.Save($Out, [System.Drawing.Imaging.ImageFormat]::Png)
$big.Dispose(); $crop.Dispose(); $b.Dispose()
"원본 $([IO.Path]::GetFileName($Src)) / 자른 곳 ${X},${Y} ${W}x${H} → ${Scale}배 = $Out"
