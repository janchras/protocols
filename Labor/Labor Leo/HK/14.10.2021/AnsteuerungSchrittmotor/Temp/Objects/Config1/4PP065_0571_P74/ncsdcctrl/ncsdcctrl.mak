UnmarkedObjectFolder := D:/BHMBA17/AnsteuerungSchrittmotor/Logical/ncsdcctrl
MarkedObjectFolder := D:/BHMBA17/AnsteuerungSchrittmotor/Logical/ncsdcctrl

$(AS_CPU_PATH)/ncsdcctrl.br: \
	$(AS_PROJECT_CPU_PATH)/Cpu.per \
	$(AS_CPU_PATH)/ncsdcctrl/ncsdcctrl.ox
	@'$(AS_BIN_PATH)/BR.AS.TaskBuilder.exe' '$(AS_CPU_PATH)/ncsdcctrl/ncsdcctrl.ox' -o '$(AS_CPU_PATH)/ncsdcctrl.br' -v V1.00.0 -f '$(AS_CPU_PATH)/NT.ofs' -offsetLT '$(AS_BINARIES_PATH)/$(AS_CONFIGURATION)/$(AS_PLC)/LT.ofs' -T SG4  -M IA32  -B G4.34 -extConstants -d 'runtime: V* - V*,asieccon: V* - V*' -r Cyclic1 -p 2 -s 'ncsdcctrl' -L 'Acp10_MC: V3.18.2, Acp10man: V3.18.2, Acp10par: V3.18.2, Acp10sdc: V3.18.2, AsBrStr: V*, AsIecCon: V*, astime: V*, brsystem: V*, NcGlobal: V3.18.2, operator: V*, runtime: V*, sys_lib: V*' -P '$(AS_PROJECT_PATH)' -secret '$(AS_PROJECT_PATH)_br.as.taskbuilder.exe'

$(AS_CPU_PATH)/ncsdcctrl/ncsdcctrl.ox: \
	$(AS_CPU_PATH)/ncsdcctrl/a.out
	@'$(AS_BIN_PATH)/BR.AS.Backend.exe' '$(AS_CPU_PATH)/ncsdcctrl/a.out' -o '$(AS_CPU_PATH)/ncsdcctrl/ncsdcctrl.ox' -T SG4 -r Cyclic1   -G V4.1.2  -B G4.34 -secret '$(AS_PROJECT_PATH)_br.as.backend.exe'

$(AS_CPU_PATH)/ncsdcctrl/a.out: \
	$(AS_CPU_PATH)/ncsdcctrl/ncsdcctrlCyclic.st.o \
	$(AS_CPU_PATH)/ncsdcctrl/ncsdcctrlInit.st.o \
	$(AS_CPU_PATH)/ncsdcctrl/_bur_pvdef.st.o
	@'$(AS_BIN_PATH)/BR.AS.CCompiler.exe' -link '$(AS_CPU_PATH)/ncsdcctrl/ncsdcctrlCyclic.st.o' '$(AS_CPU_PATH)/ncsdcctrl/ncsdcctrlInit.st.o' '$(AS_CPU_PATH)/ncsdcctrl/_bur_pvdef.st.o'  -o '$(AS_CPU_PATH)/ncsdcctrl/a.out'  -G V4.1.2  -T SG4  -M IA32  '-Wl,$(AS_PROJECT_PATH)/Logical/Libraries/Acp10_MC/SG4/IA32/libacp10_mc.a' '-Wl,$(AS_PROJECT_PATH)/AS/System/G0434/SG4/IA32/libAsBrStr.a' '-Wl,$(AS_PROJECT_PATH)/AS/System/G0434/SG4/IA32/libsys_lib.a' '-Wl,$(AS_PROJECT_PATH)/AS/System/G0434/SG4/IA32/libbrsystem.a' '-Wl,$(AS_PROJECT_PATH)/Logical/Libraries/NcGlobal/SG4/IA32/libncglobal.a' '-Wl,$(AS_PROJECT_PATH)/AS/System/G0434/SG4/IA32/libAsIecCon.a' '-Wl,$(AS_PROJECT_PATH)/AS/System/G0434/SG4/IA32/libastime.a' '-Wl,$(AS_PROJECT_PATH)/AS/System/G0434/SG4/IA32/libruntime.a' '-Wl,$(AS_PROJECT_PATH)/AS/System/G0434/SG4/IA32/liboperator.a' -specs=I386specs_brelf -nostdlib -secret '$(AS_PROJECT_PATH)_br.as.ccompiler.exe'

$(AS_CPU_PATH)/ncsdcctrl/ncsdcctrlCyclic.st.o: \
	$(AS_PROJECT_PATH)/Logical/ncsdcctrl/ncsdcctrlCyclic.st \
	$(AS_PROJECT_PATH)/Logical/Libraries/AsBrStr/AsBrStr.fun \
	$(AS_PROJECT_PATH)/Logical/Global.var \
	$(AS_PROJECT_PATH)/Logical/Libraries/Acp10sdc/acp10sdc.typ \
	$(AS_PROJECT_PATH)/Logical/Libraries/Acp10sdc/acp10sdc.var \
	$(AS_PROJECT_PATH)/Logical/Libraries/Acp10man/Acp10man.typ \
	$(AS_PROJECT_PATH)/Logical/ncsdcctrl/ncsdcctrl.var
	@'$(AS_BIN_PATH)/BR.AS.IecCompiler.exe' '$(AS_PROJECT_PATH)/Logical/ncsdcctrl/ncsdcctrlCyclic.st' -o '$(AS_CPU_PATH)/ncsdcctrl/ncsdcctrlCyclic.st.o'  -O '$(AS_CPU_PATH)//ncsdcctrl/ncsdcctrlCyclic.st.o.opt' -secret '$(AS_PROJECT_PATH)_br.as.ieccompiler.exe'

$(AS_CPU_PATH)/ncsdcctrl/ncsdcctrlInit.st.o: \
	$(AS_PROJECT_PATH)/Logical/ncsdcctrl/ncsdcctrlInit.st \
	$(AS_PROJECT_PATH)/Logical/Libraries/AsBrStr/AsBrStr.fun \
	$(AS_PROJECT_PATH)/Logical/Global.var \
	$(AS_PROJECT_PATH)/Logical/Libraries/Acp10sdc/acp10sdc.typ \
	$(AS_PROJECT_PATH)/Logical/Libraries/Acp10sdc/acp10sdc.var \
	$(AS_PROJECT_PATH)/Logical/Libraries/Acp10man/Acp10man.typ \
	$(AS_PROJECT_PATH)/Logical/ncsdcctrl/ncsdcctrl.var
	@'$(AS_BIN_PATH)/BR.AS.IecCompiler.exe' '$(AS_PROJECT_PATH)/Logical/ncsdcctrl/ncsdcctrlInit.st' -o '$(AS_CPU_PATH)/ncsdcctrl/ncsdcctrlInit.st.o'  -O '$(AS_CPU_PATH)//ncsdcctrl/ncsdcctrlInit.st.o.opt' -secret '$(AS_PROJECT_PATH)_br.as.ieccompiler.exe'

$(AS_CPU_PATH)/ncsdcctrl/_bur_pvdef.st.o: \
	$(AS_PROJECT_PATH)/Logical/Libraries/AsBrStr/AsBrStr.fun \
	$(AS_PROJECT_PATH)/Logical/Global.var \
	$(AS_PROJECT_PATH)/Logical/Libraries/Acp10sdc/acp10sdc.typ \
	$(AS_PROJECT_PATH)/Logical/Libraries/Acp10sdc/acp10sdc.var \
	$(AS_PROJECT_PATH)/Logical/Libraries/Acp10man/Acp10man.typ \
	$(AS_PROJECT_PATH)/Logical/ncsdcctrl/ncsdcctrl.var
	@'$(AS_BIN_PATH)/BR.AS.IecCompiler.exe' '$(AS_PATH)/AS/GnuInst/V4.1.2/i386-elf/include/bur/_bur_pvdef.st' -o '$(AS_CPU_PATH)/ncsdcctrl/_bur_pvdef.st.o'  -O '$(AS_CPU_PATH)//ncsdcctrl/_bur_pvdef.st.opt' -secret '$(AS_PROJECT_PATH)_br.as.ieccompiler.exe'

-include $(AS_CPU_PATH)/Force.mak 

