UnmarkedObjectFolder := D:/BHMBA17/AnsteuerungSchrittmotor/Logical/gAxis01obj/gAxis01i
MarkedObjectFolder := D:/BHMBA17/AnsteuerungSchrittmotor/Logical/gAxis01obj/gAxis01i

$(AS_CPU_PATH)/gAxis01i.br: \
	$(AS_PROJECT_PATH)/Logical/gAxis01obj/gAxis01i/gAxis01i.ax
	@'$(AS_BIN_PATH)/BR.MC.Builder.exe'   '$(AS_PROJECT_PATH)/Logical/gAxis01obj/gAxis01i/gAxis01i.ax' -o '$(AS_CPU_PATH)/gAxis01i.br' -T SG4  -B G4.34 -v V1.00.0 -s 'gAxis01obj.gAxis01i' -L 'Acp10_MC: V3.18.2, Acp10man: V3.18.2, Acp10par: V3.18.2, NcGlobal: V3.18.2' -warmRestart -P '$(AS_PROJECT_PATH)' -secret '$(AS_PROJECT_PATH)_br.mc.builder.exe'

