$ErrorActionPreference = 'Stop'

$LOGFILE = "c:\logs\ibridges.log"
$GLOBAL_PIPX_HOME = "c:\pipx"
$GLOBAL_PIPX_BIN = "c:\pipx\bin"
$IBRIDGES_TEMPLATE_PLUGIN = "git+https://github.com/UtrechtUniversity/ibridges-servers-uu.git"

Function Write-Log([String] $logText) {
    '{0:u}: {1}' -f (Get-Date), $logText | Out-File $LOGFILE -Append
}

Function Create-Shortcut([String] $shortcutLocation, [String] $shortcutTarget) {
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($shortcutLocation)
    $Shortcut.TargetPath = $shortcutTarget
    $Shortcut.Save()
}

Function Install-Scoop-Package([String] $pkg) {
    Write-Log ("Installing {0} via scoop" -f $pkg)
    scoop install $pkg *>> $LOGFILE
}

Function Setup-Global-Pipx {
    New-Item -ItemType Directory -Force -Path "$GLOBAL_PIPX_HOME"
    New-Item -ItemType Directory -Force -Path "$GLOBAL_PIPX_BIN"
    Write-Log "Installing pipx"
    Install-Scoop-Package "pipx"
    [System.Environment]::SetEnvironmentVariable('PIPX_HOME', $GLOBAL_PIPX_HOME)
    [System.Environment]::SetEnvironmentVariable('PIPX_BIN_DIR', $GLOBAL_PIPX_BIN)
}

Function Main {
    Write-Log "Start iBridges installation"
    try {
        Install-Scoop-Package "git"
        Install-Scoop-Package "python"
        Setup-Global-Pipx
        $pkgs = "ibridges", "ibridgesgui"
        foreach ($pkg in $pkgs) {
            Write-Log "Installing $pkg"
            pipx install $pkg *>> $LOGFILE
            $targetVenv = JoinPath "$GLOBAL_PIPX_HOME" "venvs" "$pkg" "Lib" "site-packages"
            pip install --target "$targetVenv" "$IBRIDGES_TEMPLATE_PLUGIN"
        }
        Create-Shortcut(JoinPath -Path [Environment]::GetFolderPath('CommonDesktopDirectory') -ChildPath "iBridges", JoinPath -Path $GLOBAL_PIPX_BIN -ChildPath "ibridges-gui")
    }
    catch {
        Write-Log "$_"
        Throw $_
    }
    Write-Log "iBridges installation completed succesfully"
}

Main
