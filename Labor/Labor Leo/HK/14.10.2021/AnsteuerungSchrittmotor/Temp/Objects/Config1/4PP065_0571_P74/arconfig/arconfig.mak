$(AS_CPU_PATH)/arconfig.br: \
	$(AS_PROJECT_CONFIG_PATH)/Hardware.hw \
	$(AS_PROJECT_CPU_PATH)/IoMap.iom \
	$(AS_PROJECT_PATH)/Physical/$(AS_CONFIGURATION)/Hardware.hw
	@'$(AS_BIN_PATH)/BR.AS.ConfigurationBuilder.exe' '$(AS_PROJECT_CONFIG_PATH)/Hardware.hw' '$(AS_PROJECT_CPU_PATH)/IoMap.iom'  -arconfig -L 'Acp10_MC: V3.18.2, Acp10man: V3.18.2, Acp10par: V3.18.2, NcGlobal: V3.18.2' -c Config1 -v V1.00.0 -S '4PP065_0571_P74' -Z 'Acp10Arnc0: 3.18.2, mapp: 1.62.1, UnitSystem: n.d, TextSystem: n.d, Connectivity: n.d, AAS: n.d' -o '$(AS_CPU_PATH)/arconfig.br' '$(AS_CPU_PATH)/ChannelConfiguration.xml' '$(AS_CPU_PATH)/HardwareConfiguration.xml' '$(AS_CPU_PATH)/ReActionTechnologyConfiguration.xml' -T SG4  -B G4.34 -P '$(AS_PROJECT_PATH)' -s 'Config1' -secret '$(AS_PROJECT_PATH)_br.as.configurationbuilder.exe'

-include $(AS_CPU_PATH)/Force.mak 
