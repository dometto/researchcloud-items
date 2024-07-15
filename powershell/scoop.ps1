$LOGFILE = "c:\logs\scoop.log"

Function Write-Log([String] $logText) {
    '{0:u}: {1}' -f (Get-Date), $logText | Out-File $LOGFILE -Append
}

Function Main {
    Write-Log "Start scoop installation"
    try {
        if (Get-Command "scoop" -errorAction SilentlyContinue) {
            Write-Log "Scoop already installed"
        }
        Else {
            Write-Log "Installing scoop"
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
            Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression *>> $LOGFILE
        }
    }
    catch {
        Write-Log "$_"
        Throw $_
    }
    finally {
        Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser # Reset the execution policy
    }
    Write-Log "scoop installation completed succesfully"
}

Main
