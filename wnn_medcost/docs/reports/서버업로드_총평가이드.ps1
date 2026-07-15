# 월간보고서 총평 작성가이드 → 파일서버 공통 경로 업로드
#   경로 규칙 = 월보고서 PDF 첨부와 동일 인프라(SftpService), 병원별이 아닌 공통(COMMON):
#   /home/winner/upload/COMMON/GUIDE/EVALRPT/월간보고서_총평_작성가이드.pdf
#   전제: 로컬 톰캣(wnn_medcost) 기동 중 — 톰캣의 SFTP 서비스가 114.108.153.178 로 올림.
#   다운로드(프로그램에서): /sftp/download.do?filePath=COMMON/GUIDE/EVALRPT/월간보고서_총평_작성가이드.pdf

$f = Join-Path $PSScriptRoot '월간보고서_총평_작성가이드.pdf'
if (-not (Test-Path $f)) { Write-Host "파일 없음: $f"; exit 1 }

foreach ($base in @('http://localhost:8080/wnn_medcost', 'http://localhost:8080')) {
    try {
        $ping = Invoke-WebRequest -Uri "$base/" -Method Head -TimeoutSec 3 -ErrorAction Stop
    } catch { continue }
    Write-Host "업로드 시도: $base/sftp/fileupload.do"
    curl.exe -s -X POST "$base/sftp/fileupload.do" `
        -F "file=@$f" `
        -F "hospCd=COMMON" `
        -F "fileGb=EVALRPT" `
        -F "notiSeq=GUIDE" `
        -F "regUser=winnernet" `
        -F "regIp=127.0.0.1"
    exit $LASTEXITCODE
}
Write-Host "로컬 톰캣(8080)이 꺼져 있습니다. 이클립스에서 서버 기동 후 다시 실행하세요."
exit 1
