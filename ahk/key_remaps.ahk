#SingleInstance
chromeWindow := " ahk_exe " . "chrome.exe" ;
#b:: {
    if WinExist(chromeWindow)
        WinActivate
    else
        Run "chrome.exe"
}
#t:: {
    wezTermWindow := " ahk_exe " . "wezterm-gui.exe" ;
    if WinExist(wezTermWindow)
        WinActivate
    else
        Run "wezterm-gui.exe"
}
CapsLock::Ctrl

firefoxWindow := " ahk_exe " . "firefox.exe" ;
#HotIf WinActive(chromeWindow) || WinActive(firefoxWindow)
^h:: {
    Send("^1") ; Send Control + 1
}
^t:: {
    Send("^2") ; Send Control + 2
}
^n:: {
    Send("^3") ; Send Control + 3
}
^s:: {
    Send("^4") ; Send Control + 4
}
Ctrl & w:: {
    Send("^{Backspace}")
}
Enter:: {
    Send("{Esc}")
}
Shift & Enter:: {
    Send("{Enter}")
}

evernoteWindow := " ahk_exe " . "Evernote.exe" ;
#HotIf WinActive(evernoteWindow)
Ctrl & w:: {
    Send("^{Backspace}")
}

discordWindow := " ahk_exe " . "Discord.exe" ;
#HotIf WinActive(discordWindow)
Ctrl & w:: {
    Send("^{Backspace}")
}

