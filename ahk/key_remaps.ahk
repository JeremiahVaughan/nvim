#SingleInstance
chromeWindow := " ahk_exe " . "chrome.exe" ;
wezTermWindow := " ahk_exe " . "wezterm-gui.exe" ;
#t:: {
    if WinExist(wezTermWindow)
        if WinActive(wezTermWindow)
            OpenChrome()
        else
            WinActivate
    else
        if WinActive(wezTermWindow)
            OpenChrome()
        else
            Run "wezterm-gui.exe"
}
#b:: {
    if WinExist(chromeWindow)
        if WinActive(chromeWindow)
            OpenWezterm()
        else
            WinActivate
    else
        if WinActive(chromeWindow)
            OpenWezterm()
        else
            Run "chrome.exe"
}
OpenChrome() {
    if WinExist(chromeWindow)
        WinActivate
    else
        Run "chrome.exe"
}
OpenWezterm() {
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
^w:: {
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
^w:: {
    Send("^{Backspace}")
}

discordWindow := " ahk_exe " . "Discord.exe" ;
#HotIf WinActive(discordWindow)
^w:: {
    Send("^{Backspace}")
}

chatGptWindow := " ahk_exe " . "ChatGPT.exe" ;
#HotIf WinActive(chatGptWindow)
^w:: {
    Send("^{Backspace}")
}

