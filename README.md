# Physical-Network-Device-PnPCapabilities
Change PnPCapabilities (Engergysetting Wake on Lan) turn it on. 

Powershell code: Get-NetAdapter -Physical /*Adapters start here*/
Engerysettings on Windows 10 Changed for Wake On Lan for Lenovo T460s typs (for example)

RegKey: "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}"

The Value: PnPCapabilities in the Registry is set to 256 on the Physical Networkadapter Intel(R) Ethernet Connection I219-LM (for example)
