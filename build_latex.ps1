# Build all .tex files in the current directory to PDF
# and delete auxiliary files afterwards.

Write-Host "=== Building all .tex files in the current directory ===" -ForegroundColor Cyan

# Check if latexmk is available (preferred)
$useLatexmk = Get-Command latexmk -ErrorAction SilentlyContinue
if ($useLatexmk) {
    Write-Host "Using latexmk for compilation" -ForegroundColor Green
} else {
    Write-Host "latexmk not found, falling back to pdflatex" -ForegroundColor Yellow
}

# Get all .tex files in current directory
$texFiles = Get-ChildItem -Path . -Filter *.tex

if ($texFiles.Count -eq 0) {
    Write-Host "No .tex files found in the current directory." -ForegroundColor Red
    exit 1
}

foreach ($file in $texFiles) {
    Write-Host "`n=== Building $($file.Name) ===" -ForegroundColor Cyan

    if ($useLatexmk) {
        latexmk -pdf -interaction=nonstopmode $file.FullName
        $exitCode = $LASTEXITCODE
    } else {
        # Run pdflatex twice to resolve references
        pdflatex -interaction=nonstopmode $file.FullName
        pdflatex -interaction=nonstopmode $file.FullName
        $exitCode = $LASTEXITCODE
    }

    if ($exitCode -eq 0) {
        Write-Host "Successfully built $($file.BaseName).pdf" -ForegroundColor Green
    } else {
        Write-Host "Error building $($file.Name)" -ForegroundColor Red
    }
}

# Define typical junk/auxiliary file extensions to delete
$junkExts = @(
    "*.aux", "*.bbl", "*.blg", "*.fdb_latexmk", "*.fls",
    "*.log", "*.nav", "*.out", "*.snm", "*.synctex*", "*.toc",
    "*.vrb", "*.xdv", "*.lof", "*.lot"
)

Write-Host "`n=== Cleaning up auxiliary files ===" -ForegroundColor Cyan
foreach ($pattern in $junkExts) {
    Get-ChildItem -Path . -Filter $pattern -Recurse -ErrorAction SilentlyContinue |
        Remove-Item -Force -ErrorAction SilentlyContinue
}

Write-Host "`n=== Done ===" -ForegroundColor Cyan
