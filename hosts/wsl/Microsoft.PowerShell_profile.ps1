# cat /mnt/c/Users/dev-ia/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1
Import-Module PSReadLine

# Tab shows a menu of all completions (navigate with arrows/Tab)
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# Up/Down search history using what's already typed
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# Inline suggestions from history (requires PSReadLine 2.1+)
# (skipped silently in non-interactive/redirected sessions)
try {
    if ((Get-Module PSReadLine).Version -ge [version]'2.1.0') {
        Set-PSReadLineOption -PredictionSource History -ErrorAction Stop
        # Right arrow accepts the suggestion
        Set-PSReadLineKeyHandler -Key RightArrow -Function ForwardChar
    }
    if ((Get-Module PSReadLine).Version -ge [version]'2.2.0') {
        Set-PSReadLineOption -PredictionViewStyle ListView -ErrorAction Stop
    }
} catch {}
