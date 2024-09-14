<#
.SYNOPSIS
    Extracts important Windows event logs and exports them to a CSV file.

.DESCRIPTION
    This script extracts event logs from System, Application, and Security sources,
    filters for events from the last 7 days with Error, Warning, and Critical levels,
    and exports them to a CSV file with a timestamp in the filename.

.PARAMETER Path
    Specifies the output path for the CSV file. If not specified, the file will be saved to the user's desktop.

.PARAMETER DaysToSearch
    Specifies the number of days to search for events. Default is 7 days.

.PARAMETER PassThru
    If specified, the script will output the exported events to the pipeline.

.EXAMPLE
    .\Export-WindowsEventLogs.ps1
    Runs the script with default settings, exporting logs to the current user's desktop.

.EXAMPLE
    .\Export-WindowsEventLogs.ps1 -Path "C:\Logs" -DaysToSearch 14 -PassThru
    Exports logs from the last 14 days to the C:\Logs directory and outputs the events to the pipeline.

.NOTES
    File Name      : Export-WindowsEventLogs.ps1
    Author         : Robert Maguire
    Prerequisite   : PowerShell 5.1 or later
#>

[CmdletBinding(DefaultParameterSetName='Path')]
param (
    [Parameter(Position=0, ParameterSetName='Path')]
    [string]$Path = [Environment]::GetFolderPath("Desktop"),

    [Parameter(Position=1)]
    [int]$DaysToSearch = 7,

    [Parameter()]
    [switch]$PassThru
)

begin {
    $ErrorActionPreference = 'Stop'
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $outputFile = Join-Path -Path $Path -ChildPath "EventLogs_$timestamp.csv"

    # Define event logs to extract
    $eventLogs = @("System", "Application", "Security")

    # Define levels to extract (1=Critical, 2=Error, 3=Warning)
    $levels = @(1, 2, 3)

    # Calculate start time
    $startTime = (Get-Date).AddDays(-$DaysToSearch)

    Write-Verbose "Extracting events from the last $DaysToSearch days..."
}

process {
    try {
        # Extract events using a single Get-WinEvent call for better performance
        $events = Get-WinEvent -FilterHashtable @{
            LogName = $eventLogs
            StartTime = $startTime
            Level = $levels
        } -ErrorAction SilentlyContinue

        if ($null -eq $events -or $events.Count -eq 0) {
            Write-Warning "No events found matching the criteria."
            return
        }

        Write-Verbose "Processing $($events.Count) events..."

        # Process events in batches to improve performance
        $batchSize = 1000
        $processedEvents = @()

        for ($i = 0; $i -lt $events.Count; $i += $batchSize) {
            $batch = $events | Select-Object -Skip $i -First $batchSize
            $processedEvents += $batch | Select-Object @{
                Name = 'TimeCreated'; Expression = { $_.TimeCreated.ToString('yyyy-MM-dd HH:mm:ss') }
            }, LogName, Id, LevelDisplayName, @{
                Name = 'Message'; Expression = { $_.Message -replace '\r\n', ' ' -replace ',', ';' }
            }
        }

        # Export to CSV
        $processedEvents | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8

        Write-Verbose "Events exported successfully to: $outputFile"

        if ($PassThru) {
            $processedEvents
        }
    }
    catch {
        Write-Error "An error occurred while processing events: $_"
    }
}

end {
    if (Test-Path $outputFile) {
        Write-Host "Events exported successfully to: $outputFile"
    }
}