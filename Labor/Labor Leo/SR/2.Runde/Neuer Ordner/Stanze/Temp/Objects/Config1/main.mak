SHELL := cmd.exe
CYGWIN=nontsec
export PATH := C:\Program Files\AdoptOpenJDK\jdk-16.0.0.36-hotspot\bin;C:\Python39\Scripts\;C:\Python39\;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\ProgramData\chocolatey\bin;C:\ProgramData\chocolatey\lib\gsudo\bin\;C:\ProgramData\chocolatey\lib\mpv.install\tools;C:\Program Files\VSCodium\bin;C:\Program Files\NVIDIA Corporation\NVIDIA NvDLISR;C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common;C:\Program Files\Git\cmd;C:\Program Files\nodejs\;C:\Users\leoch\AppData\Local\Microsoft\WindowsApps;C:\Program Files\Oracle\VirtualBox;C:\Users\leoch\AppData\Roaming\npm;C:\Users\leoch\AppData\Local\Microsoft\WindowsApps;C:\Program Files\Oracle\VirtualBox;C:\Users\leoch\AppData\Roaming\npm;C:\BrAutomation\AS49\bin-en\4.9;C:\BrAutomation\AS49\bin-en\4.8;C:\BrAutomation\AS49\bin-en\4.7;C:\BrAutomation\AS49\bin-en\4.6;C:\BrAutomation\AS49\bin-en\4.5;C:\BrAutomation\AS49\bin-en\4.4;C:\BrAutomation\AS49\bin-en\4.3;C:\BrAutomation\AS49\bin-en\4.2;C:\BrAutomation\AS49\bin-en\4.1;C:\BrAutomation\AS49\bin-en\4.0;C:\BrAutomation\AS49\bin-en
export AS_BUILD_MODE := Build
export AS_VERSION := 4.9.2.46
export AS_WORKINGVERSION := 4.9
export AS_COMPANY_NAME :=  
export AS_USER_NAME := leoch
export AS_PATH := C:/BrAutomation/AS49
export AS_BIN_PATH := C:/BrAutomation/AS49/bin-en
export AS_PROJECT_PATH := C:/Users/leoch/OneDrive\ -\ HTBLA\ Kaindorf/4.Klasse/Labor/SR/2.Runde/Neuer\ Ordner/Stanze
export AS_PROJECT_NAME := Stanze
export AS_SYSTEM_PATH := C:/BrAutomation/AS/System
export AS_VC_PATH := C:/BrAutomation/AS49/AS/VC
export AS_TEMP_PATH := C:/Users/leoch/OneDrive\ -\ HTBLA\ Kaindorf/4.Klasse/Labor/SR/2.Runde/Neuer\ Ordner/Stanze/Temp
export AS_CONFIGURATION := Config1
export AS_BINARIES_PATH := C:/Users/leoch/OneDrive\ -\ HTBLA\ Kaindorf/4.Klasse/Labor/SR/2.Runde/Neuer\ Ordner/Stanze/Binaries
export AS_GNU_INST_PATH := C:/BrAutomation/AS49/AS/GnuInst/V4.1.2
export AS_GNU_BIN_PATH := C:/BrAutomation/AS49/AS/GnuInst/V4.1.2/4.9/bin
export AS_GNU_INST_PATH_SUB_MAKE := C:/BrAutomation/AS49/AS/GnuInst/V4.1.2
export AS_GNU_BIN_PATH_SUB_MAKE := C:/BrAutomation/AS49/AS/GnuInst/V4.1.2/4.9/bin
export AS_INSTALL_PATH := C:/BrAutomation/AS49
export WIN32_AS_PATH := "C:\BrAutomation\AS49"
export WIN32_AS_BIN_PATH := "C:\BrAutomation\AS49\bin-en"
export WIN32_AS_PROJECT_PATH := "C:\Users\leoch\OneDrive - HTBLA Kaindorf\4.Klasse\Labor\SR\2.Runde\Neuer Ordner\Stanze"
export WIN32_AS_SYSTEM_PATH := "C:\BrAutomation\AS\System"
export WIN32_AS_VC_PATH := "C:\BrAutomation\AS49\AS\VC"
export WIN32_AS_TEMP_PATH := "C:\Users\leoch\OneDrive - HTBLA Kaindorf\4.Klasse\Labor\SR\2.Runde\Neuer Ordner\Stanze\Temp"
export WIN32_AS_BINARIES_PATH := "C:\Users\leoch\OneDrive - HTBLA Kaindorf\4.Klasse\Labor\SR\2.Runde\Neuer Ordner\Stanze\Binaries"
export WIN32_AS_GNU_INST_PATH := "C:\BrAutomation\AS49\AS\GnuInst\V4.1.2"
export WIN32_AS_GNU_BIN_PATH := "$(WIN32_AS_GNU_INST_PATH)\\bin" 
export WIN32_AS_INSTALL_PATH := "C:\BrAutomation\AS49"

.suffixes:

ProjectMakeFile:

	@'$(AS_BIN_PATH)/4.9/BR.AS.AnalyseProject.exe' '$(AS_PROJECT_PATH)/Stanze.apj' -t '$(AS_TEMP_PATH)' -c '$(AS_CONFIGURATION)' -o '$(AS_BINARIES_PATH)'   -sfas -buildMode 'Build'   

