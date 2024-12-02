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
^h:: {
    if WinActive(chromeWindow)
    {
        Send("^1") ; Send Control + 1
    }
    return
}
^t:: {
    if WinActive(chromeWindow)
    {
        Send("^2") ; Send Control + 2
    }
    return
}
^n:: {
    if WinActive(chromeWindow)
    {
        Send("^3") ; Send Control + 3
    }
    return
}
^s:: {
    if WinActive(chromeWindow)
    {
        Send("^4") ; Send Control + 4
    }
    return
}
CapsLock::Ctrl
