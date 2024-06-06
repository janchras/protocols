SHELL := cmd.exe
CYGWIN=nontsec
export PATH := C:\Program Files (x86)\Intel\Intel(R) Management Engine Components\iCLS\;C:\Program Files\Intel\Intel(R) Management Engine Components\iCLS\;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\Program Files (x86)\Intel\Intel(R) Management Engine Components\DAL;C:\Program Files\Intel\Intel(R) Management Engine Components\DAL;C:\Program Files\dotnet\;C:\Program Files (x86)\dotnet\;C:\Program Files (x86)\IVI Foundation\VISA\WinNT\Bin\;C:\Program Files\IVI Foundation\VISA\Win64\Bin\;C:\Program Files (x86)\IVI Foundation\VISA\WinNT\Bin;C:\Program Files (x86)\National Instruments\Shared\LabVIEW CLI;C:\Users\Messlabor_Kustos\AppData\Local\Microsoft\WindowsApps;C:\Program Files (x86)\Common Files\Hilscher GmbH\TLRDecode;C:\Users\Messlabor_Kustos\AppData\Local\Microsoft\WindowsApps;C:\Program Files (x86)\Common Files\Hilscher GmbH\TLRDecode
export AS_BUILD_MODE := Build
export AS_VERSION := 4.3.7.46 SP
export AS_COMPANY_NAME :=  
export AS_USER_NAME := Messlabor_Kustos
export AS_PATH := D:/BR/AS43
export AS_BIN_PATH := D:/BR/AS43/bin-en
export AS_PROJECT_PATH := D:/BHMBA17/AnsteuerungSchrittmotor
export AS_PROJECT_NAME := AnsteuerungSchrittmotor
export AS_SYSTEM_PATH := D:/BR/AS/System
export AS_VC_PATH := D:/BR/AS43/AS/VC
export AS_TEMP_PATH := D:/BHMBA17/AnsteuerungSchrittmotor/Temp
export AS_CONFIGURATION := Config1
export AS_BINARIES_PATH := D:/BHMBA17/AnsteuerungSchrittmotor/Binaries
export AS_GNU_INST_PATH := D:/BR/AS43/AS/GnuInst/V4.1.2
export AS_GNU_BIN_PATH := $(AS_GNU_INST_PATH)/bin
export AS_GNU_INST_PATH_SUB_MAKE := D:/BR/AS43/AS/GnuInst/V4.1.2
export AS_GNU_BIN_PATH_SUB_MAKE := $(AS_GNU_INST_PATH_SUB_MAKE)/bin
export AS_INSTALL_PATH := D:/BR/AS43
export WIN32_AS_PATH := "D:\BR\AS43"
export WIN32_AS_BIN_PATH := "D:\BR\AS43\bin-en"
export WIN32_AS_PROJECT_PATH := "D:\BHMBA17\AnsteuerungSchrittmotor"
export WIN32_AS_SYSTEM_PATH := "D:\BR\AS\System"
export WIN32_AS_VC_PATH := "D:\BR\AS43\AS\VC"
export WIN32_AS_TEMP_PATH := "D:\BHMBA17\AnsteuerungSchrittmotor\Temp"
export WIN32_AS_BINARIES_PATH := "D:\BHMBA17\AnsteuerungSchrittmotor\Binaries"
export WIN32_AS_GNU_INST_PATH := "D:\BR\AS43\AS\GnuInst\V4.1.2"
export WIN32_AS_GNU_BIN_PATH := "$(WIN32_AS_GNU_INST_PATH)\\bin" 
export WIN32_AS_INSTALL_PATH := "D:\BR\AS43"

.suffixes:

ProjectMakeFile:

	@'$(AS_BIN_PATH)/BR.AS.AnalyseProject.exe' '$(AS_PROJECT_PATH)/AnsteuerungSchrittmotor.apj' -t '$(AS_TEMP_PATH)' -c '$(AS_CONFIGURATION)' -o '$(AS_BINARIES_PATH)'   -sfas -buildMode 'Build'   

	@$(AS_GNU_BIN_PATH)/mingw32-make.exe -r -f 'D:/BHMBA17/AnsteuerungSchrittmotor/Temp/Objects/$(AS_CONFIGURATION)/4PP065_0571_P74/#cpu.mak' -k 

