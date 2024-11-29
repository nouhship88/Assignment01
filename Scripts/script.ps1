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
while ($true) {
    $files = Get-ChildItem -Path "../Data" -File
    foreach ($file in $files) {
        # Debugging output: Check the file path
        Write-Host "Processing file: $($file.FullName)"

        if ($file.LastWriteTime -lt (Get-Date).AddMinutes(-1)) {
            # Rename file before moving if the same name exists in the Archive
            $destination = "../Archive/$($file.Name)"
            if (Test-Path $destination) {
                # Adding timestamp to the file name if file already exists in Archive
                $destination = "../Archive/$($file.BaseName)_$((Get-Date).ToString('yyyyMMdd_HHmmss'))$($file.Extension)"
            }
            
            # Move the file to the Archive
            Move-Item -Path $file.FullName -Destination $destination
            Write-Host "$($file.Name) moved to Archive"
        }
    }
    
    # Wait for 60 seconds before checking again
    Start-Sleep -Seconds 60
}
