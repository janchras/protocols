$(AS_CPU_PATH)/acp10map.br: \
	$(AS_PROJECT_CPU_PATH)/Motion/Acp10map.ncm \
	$(AS_PROJECT_PATH)/physical/config1/4pp065_0571_p74/motion/acp10map.ncm \
	$(AS_PROJECT_PATH)/physical/config1/hardware.hw
	@'$(AS_BIN_PATH)/BR.MC.Builder.exe' '$(AS_PROJECT_CPU_PATH)/Motion/Acp10map.ncm'  -v V1.00.0 -a '$(AS_PROJECT_CONFIG_PATH)/Hardware.hw' -L 'Acp10_MC: V3.18.2, Acp10man: V3.18.2, Acp10par: V3.18.2, NcGlobal: V3.18.2' -P '$(AS_PROJECT_PATH)' -Z 'Acp10Arnc0: 3.18.2, mapp: 1.62.1, UnitSystem: n.d, TextSystem: n.d, Connectivity: n.d, AAS: n.d' -o '$(AS_CPU_PATH)/Acp10map.br' -T SG4  -s 'Config1.4PP065_0571_P74.Motion' -secret '$(AS_PROJECT_PATH)_br.mc.builder.exe'

-include $(AS_CPU_PATH)/Force.mak 
