function Test-PendingReboot {
    $pendingReboot = $false

    # Check CBS
    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending") {
        $pendingReboot = $true
        Write-Host "Pending reboot detected from CBS." -ForegroundColor Yellow
    }

    # Check Windows Update
    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired") {
        $pendingReboot = $true
        Write-Host "Pending reboot detected from Windows Update." -ForegroundColor Yellow
    }

    # Check Pending File Rename Operations
    $renameOps = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name "PendingFileRenameOperations" -ErrorAction SilentlyContinue
    if ($renameOps) {
        $pendingReboot = $true
        Write-Host "Pending file rename operations detected." -ForegroundColor Yellow
    }

    # Check Cluster Nodes
    if (Test-Path "HKLM:\Cluster\Nodes") {
        $pendingReboot = $true
        Write-Host "Pending reboot detected from cluster operations." -ForegroundColor Yellow
    }

    return $pendingReboot
}

if (Test-PendingReboot) {
    Write-Host "A reboot is pending on this system." -ForegroundColor Red
} else {
    Write-Host "No reboot is pending on this system." -ForegroundColor Green
}
