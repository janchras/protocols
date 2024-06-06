UnmarkedObjectFolder := D:/BHMBA17/AnsteuerungSchrittmotor/Logical/acp10etxde
MarkedObjectFolder := D:/BHMBA17/AnsteuerungSchrittmotor/Logical/acp10etxde

$(AS_CPU_PATH)/acp10etxde.br: \
	$(AS_PROJECT_PATH)/Logical/acp10etxde/acp10etxde.ett
	@'$(AS_BIN_PATH)/BR.MC.Builder.exe'   '$(AS_PROJECT_PATH)/Logical/acp10etxde/acp10etxde.ett' -o '$(AS_CPU_PATH)/acp10etxde.br' -T SG4  -B G4.34 -v V1.00.0 -s 'acp10etxde' -L 'Acp10_MC: V3.18.2, Acp10man: V3.18.2, Acp10par: V3.18.2, NcGlobal: V3.18.2' -P '$(AS_PROJECT_PATH)' -secret '$(AS_PROJECT_PATH)_br.mc.builder.exe'

