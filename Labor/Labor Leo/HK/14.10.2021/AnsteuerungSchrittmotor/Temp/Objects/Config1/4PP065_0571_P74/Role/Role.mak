UnmarkedObjectFolder := D:/BHMBA17/AnsteuerungSchrittmotor/Physical/Config1/4PP065_0571_P74/AccessAndSecurity/UserRoleSystem
MarkedObjectFolder := D:/BHMBA17/AnsteuerungSchrittmotor/Physical/Config1/4PP065_0571_P74/AccessAndSecurity/UserRoleSystem

$(AS_CPU_PATH)/Role.br: \
	$(AS_PROJECT_CPU_PATH)/AccessAndSecurity/UserRoleSystem/Role.role
	@'$(AS_BIN_PATH)/BR.AS.SystemConfiguration.Builder.exe'   '$(AS_PROJECT_CPU_PATH)/AccessAndSecurity/UserRoleSystem/Role.role' -o '$(AS_CPU_PATH)/Role.br' -zip -B G4.34 -z n.d -P '$(AS_PROJECT_PATH)' -c '$(AS_CONFIGURATION)' -secret '$(AS_PROJECT_PATH)_br.as.systemconfiguration.builder.exe'

