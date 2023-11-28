DisableProxy() {
  RegWrite, REG_DWORD, HKCU, Software\Microsoft\Windows\CurrentVersion\Internet Settings, ProxyEnable, 0
  DllCall("wininet\InternetSetOptionW", "int", 0, "int", 39, "int", 0, "int", 0) 
  DllCall("wininet\InternetSetOptionW", "int", 0, "int", 37, "int", 0, "int", 0)
  ToolTip, Proxy OFF
  Sleep, 380
  ToolTip
}

DisableProxy()