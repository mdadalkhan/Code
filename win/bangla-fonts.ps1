# =========================================
# Bangla Fonts Auto Installer for Windows
# =========================================

# List of font families available from CDN
$fonts = @(
    "solaiman-lipi",
    "mukti",
    "kalpurush",
    "siyamrupali",
    "nikosh",
    "vrinda",
    "adorsho-lipi"
)

# Temporary download folder
$tempDir = Join-Path $env:TEMP "bangla-fonts"
if (-not (Test-Path $tempDir)) { New-Item -ItemType Directory -Path $tempDir | Out-Null }

# Windows Fonts folder for current user
$fontsDir = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
if (-not (Test-Path $fontsDir)) { New-Item -ItemType Directory -Path $fontsDir | Out-Null }

# Function to download and install a single font file
function Install-FontFromUrl {
    param($fontUrl)

    $fileName = Split-Path $fontUrl -Leaf
    $localPath = Join-Path $tempDir $fileName

    if (-not (Test-Path $localPath)) {
        Write-Host "Downloading $fileName ..."
        try {
            Invoke-WebRequest -Uri $fontUrl -OutFile $localPath -ErrorAction Stop
        } catch {
            Write-Warning "Failed to download $fileName: $_"
            return
        }
    } else {
        Write-Host "$fileName already downloaded."
    }

    # Copy to Fonts folder
    $destPath = Join-Path $fontsDir $fileName
    if (-not (Test-Path $destPath)) {
        Copy-Item $localPath -Destination $destPath -Force
        # Register in Windows registry for current user
        New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" `
            -Name $fileName -Value $fileName -Force | Out-Null
        Write-Host "$fileName installed."
    } else {
        Write-Host "$fileName already installed."
    }
}

# Main loop: iterate font families
foreach ($font in $fonts) {
    $cssUrl = "https://fonts.maateen.me/$font/font.css"
    Write-Host "`nFetching font CSS for $font ..."
    try {
        $cssContent = Invoke-WebRequest -Uri $cssUrl -UseBasicParsing -ErrorAction Stop
    } catch {
        Write-Warning "Failed to fetch CSS for $font: $_"
        continue
    }

    # Extract font URLs (.ttf, .woff, .woff2)
    $matches = [regex]::Matches($cssContent.Content, "url\(['""]?(?<u>[^'""\)]+?\.(?:ttf|woff2?|otf))['""]?\)")
    foreach ($m in $matches) {
        $fontUrl = $m.Groups["u"].Value
        Install-FontFromUrl $fontUrl
    }
}

Write-Host "`nAll fonts processed!"
Read-Host "Press Enter to exit"
