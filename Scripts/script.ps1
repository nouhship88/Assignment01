# 1. Writing data to a CSV file
$data = @(
    @{name="hi"; description="don't settle"; system="sight"; redundant="dumb"}
    @{name="hello"; description="why not"; system="settle"; redundant="settle"}
    @{name="this"; description="just fails"; system="why?"; redundant="settle"}
)

# Exporting the data to 'data.csv' in the Data folder
$data | Export-Csv -Path "../Data/data.csv" -NoTypeInformation
Write-Host "Data written to data.csv"

# 2. Reading the CSV file and retrieving specific values
$csvData = Import-Csv "../Data/data.csv"
$filteredData = $csvData | Where-Object { $_.name -eq "hello" }

# Writing filtered data to a new CSV file
$filteredData | Export-Csv -Path "../Data/filtered.csv" -NoTypeInformation
Write-Host "Filtered data written to filtered.csv"

# 3. Moving older files to the Archive folder

# Rename file before moving it, so we don't have same name when more than one file being moved to folder

$destination = "../Archive/$($file.Name)"
if (Test-Path $destination) {
    $destination = "../Archive/$($file.BaseName)_$((Get-Date).ToString('yyyyMMdd_HHmmss'))$($file.Extension)"
}
Move-Item -Path $file.FullName -Destination $destination


while ($true) {
    $files = Get-ChildItem -Path "../data" -File
    foreach ($file in $files) {
        if ($file.LastWriteTime -lt (Get-Date).AddMinutes(-1)) {
            Move-Item -Path $file.FullName -Destination "../Archive/"
            Write-Host "$($file.Name) moved to Archive"
        }
    }
    Start-Sleep -Seconds 60  # wait 60 seconds before checking again
}
