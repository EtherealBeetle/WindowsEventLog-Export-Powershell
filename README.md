# Windows Event Log Exporter for PowerShell

![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)


## 🚀 Features

- Extracts logs from System, Application, and Security sources
- Filters events from a customizable number of past days (default: 7 days)
- Includes Error, Warning, and Critical event levels
- Exports results to a CSV file with a timestamp in the filename
- Supports custom output paths
- Offers a PassThru parameter for pipeline processing

## 📋 Prerequisites

- Windows operating system
- PowerShell 5.1 or later
- Administrator privileges on the target Windows system

## 🛠️ Installation

1. Clone this repository or download the `Export-WindowsEventLogs.ps1` script.
2. Save the script to your desired location on the Windows machine.

## 🖥️ Usage

1. Open PowerShell as Administrator
2. Navigate to the script directory
3. Run the script with desired parameters

### Basic Usage

```powershell
.\Export-WindowsEventLogs.ps1

This will export the last 7 days of events to a CSV file on your desktop.

## Advanced Usage
.\Export-WindowsEventLogs.ps1 -Path "C:\Logs" -DaysToSearch 14 -PassThru

This command will:

Export logs from the last 14 days
Save the CSV file to the C:\Logs directory
Output the processed events to the pipeline for further processing 

## 📤 Output
The script generates a CSV file with a name format: EventLogs_YYYYMMDD_HHMMSS.csv

| TimeCreated | LogName | Id | Level | DisplayName | Message |
|---|---|---|---|---|---|
| 2023-09-14 15:30:22 | System | 1234 | Error | Description of the event... |  |
| 2023-09-14 16:45:33 | Application | 5678 | Warning | Another event description... |  | 

## ⚙️ Configuration Options
The script accepts the following parameters:

-Path: Specifies the output directory for the CSV file (default: user's desktop)
-DaysToSearch: Number of past days to search for events (default: 7)
-PassThru: Outputs the processed events to the pipeline

## 🔍 Troubleshooting
No events found
If the script reports no events found, try the following:

Increase the -DaysToSearch parameter value
Ensure you're running the script with Administrator privileges
Check if the event logs are enabled on the system

## Access Denied
Access Denied
If you encounter "Access Denied" errors:

Ensure you're running PowerShell as Administrator
Check your system's execution policy with Get-ExecutionPolicy
If necessary, set the execution policy to allow the script: Set-ExecutionPolicy RemoteSigned -Scope Process