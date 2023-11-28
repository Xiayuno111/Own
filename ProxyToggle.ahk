CheckProxyStatus() {
    RegRead, ProxyEnabled, HKCU, Software\Microsoft\Windows\CurrentVersion\Internet Settings, ProxyEnable
    Return ProxyEnabled
}

ToggleProxy() {
    ProxyStatus := CheckProxyStatus()
    
    if (ProxyStatus) {
        DisableProxy()
    } else {
        EnableProxy()
    }
}

EnableProxy() {
    RegWrite, REG_DWORD, HKCU, Software\Microsoft\Windows\CurrentVersion\Internet Settings, ProxyEnable, 1
    DllCall("wininet\InternetSetOptionW", "int", 0, "int", 39, "int", 0, "int", 0)
    DllCall("wininet\InternetSetOptionW", "int", 0, "int", 37, "int", 0, "int", 0)
    ToolTip, Proxy ON
    Sleep, 380
    ToolTip
    Return
}

DisableProxy() {
    RegWrite, REG_DWORD, HKCU, Software\Microsoft\Windows\CurrentVersion\Internet Settings, ProxyEnable, 0
    DllCall("wininet\InternetSetOptionW", "int", 0, "int", 39, "int", 0, "int", 0)
    DllCall("wininet\InternetSetOptionW", "int", 0, "int", 37, "int", 0, "int", 0)
    ToolTip, Proxy OFF
    Sleep, 380
    ToolTip
    Return
}

ToggleProxy()
ExitApp
