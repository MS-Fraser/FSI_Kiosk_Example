<#
Example Kiosk Configuration for FSI Customers for Microsoft Services

// Use Case - WIN10  Thin Terms / Kiosk for VDI
// Assumtpion - Citrix Workspace Application (Win32) and MSEdge (Chromium) is Installed
// Leveraging Assigned Access CSP - https://docs.microsoft.com/en-us/windows/client-management/mdm/assignedaccess-csp
// MS DOCS: https://docs.microsoft.com/en-us/windows/configuration/lock-down-windows-10-to-specific-apps
// Script must be excuated using SYSTEM Context 
// Script is provided AS IS without warranty of any kind
// Configuration is Applied on Reboot
#>

## Define HomePage for MS Edge
$HomePage = "https://www.microsoft.com"

# Create Shortcut for "Available Networks" to select Wi-Fi Connection // Required for Laptops to "Select" Wi-Fi Network
$AppLocation = "C:\Windows\explorer.exe"
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Available Networks.lnk")
$Shortcut.TargetPath = $AppLocation
$Shortcut.Arguments ="ms-availablenetworks:"
$Shortcut.IconLocation = "%SystemRoot%\System32\taskbarcpl.dll,3"
$Shortcut.Description ="Show's Available wiFi Networks"
$Shortcut.WorkingDirectory ="C:\Windows\"
$Shortcut.Save()

# Create Shortcut for MSEDGE.EXE // HomePage Configuration for MS Edge has a requirement for MDM / AD ONLY :(
$AppLocation1 = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$WshShell1 = New-Object -ComObject WScript.Shell
$Shortcut1 = $WshShell1.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\MSEdge_InPrivate.lnk")
$Shortcut1.TargetPath = $AppLocation1
$Shortcut1.Arguments ="--inprivate $HomePage"
$Shortcut1.IconLocation = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$Shortcut1.Description ="MS Edge"
$Shortcut1.WorkingDirectory ="C:\Program Files (x86)\Microsoft\Edge\Application\"
$Shortcut1.Save()

# Configure Edge Browser Policy // https://docs.microsoft.com/en-us/deployedge/microsoft-edge-policies
if ((Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge") -eq $false){New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Force}
New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Edge\" -Name "AutoImportAtFirstRun" -Value "4" -PropertyType "DWORD" -Force
New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Edge\" -Name "HideFirstRunExperience" -Value "1" -PropertyType "DWORD" -Force

# Edge Browser Block List
if ((Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\URLBlocklist") -eq $false){New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\URLBlocklist" -Force}
New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Edge\URLBlocklist" -Name "1" -Value "*" -PropertyType "String" -Force

# Edge Browser Allowed List
if ((Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\URLAllowlist") -eq $false){New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\URLAllowlist" -Force}
New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Edge\URLAllowlist" -Name "1" -Value "$HomePage" -PropertyType "String" -Force
#New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Edge\URLAllowlist" -Name "2" -Value "Edge://*" -PropertyType "String" -Force ## Enable Setting to view Edge Settings as Kiosk Account

# WMI to Desktop Bridge Script for Multi-App Kiosk
# // https://docs.microsoft.com/en-us/windows/configuration/kiosk-mdm-bridge
# // https://docs.microsoft.com/en-us/windows/configuration/kiosk-xml
$nameSpaceName="root\cimv2\mdm\dmmap"
$className="MDM_AssignedAccess"
$obj = Get-CimInstance -Namespace $namespaceName -ClassName $className
Add-Type -AssemblyName System.Web
$obj.Configuration = [System.Web.HttpUtility]::HtmlEncode(@"
<?xml version="1.0" encoding="utf-8" ?>
<AssignedAccessConfiguration
    xmlns="http://schemas.microsoft.com/AssignedAccess/2017/config"
    xmlns:r1809="http://schemas.microsoft.com/AssignedAccess/201810/config">
    <Profiles>
        <Profile Id="{5B328104-BD89-4863-AB27-4ED6EE355485}">
            <AllAppsList>
                <AllowedApps>
                    <App AppUserModelId="windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel"/>
                    <App DesktopAppPath="C:\Windows\system32\mstsc.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\CDViewer.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\concentr.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\cpviewer.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\Ctx64Injector64.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\CtxCFRUI.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\CtxTwnPA.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\FlashCacheHelper.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\HdxBrowser.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\HdxTeams.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\icaconf.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\migrateN.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\pcl2bmp.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\PdfPrintHelper.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\PseudoContainer.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\PseudoContainer2.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\RawPrintHelper.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\redirector.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\SetIntegrityLevel.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\WebHelper.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\wfcrun32.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\wfcwow64.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\wfica32.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\XPSPrintHelper.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\AuthManager\AuthManSvr.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\AuthManager\PrimaryAuthModule.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\AuthManager\storebrowse.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\Browser\Browser.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\Browser\CefSharp.BrowserSubprocess.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\Drivers64\usbinst.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\Receiver\Ceip.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\Receiver\PrefPanel.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\Receiver\Receiver.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\Receiver\SRProxy.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\Receiver\CitrixReceiverUpdater.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\Receiver\ConfigurationWizard.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\SelfServicePlugin\CleanUp.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\SelfServicePlugin\NPSPrompt.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\SelfServicePlugin\SelfService.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\SelfServicePlugin\SelfServicePlugin.exe"/>
                    <App DesktopAppPath="C:\Program Files (x86)\Citrix\ICA Client\SelfServicePlugin\SelfServiceUninstaller.exe"/>
                </AllowedApps>
            </AllAppsList>
            <r1809:FileExplorerNamespaceRestrictions>
              <r1809:AllowedNamespace Name="Downloads"/>
            </r1809:FileExplorerNamespaceRestrictions>
            <StartLayout>
            <![CDATA[<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
            <LayoutOptions StartTileGroupCellWidth="6" />
            <DefaultLayoutOverride>
              <StartLayoutCollection>
                <defaultlayout:StartLayout GroupCellWidth="6">
                  <start:Group Name="Bank - Thin Terminal">
                    <start:DesktopApplicationTile Size="2x2" Column="0" Row="2" DesktopApplicationID="Microsoft.AutoGenerated.{F0B8149C-2993-30B2-A6FF-111AED31518B}" />
                    <start:DesktopApplicationTile Size="2x2" Column="2" Row="0" DesktopApplicationID="Microsoft.Windows.RemoteDesktop" />
                    <start:DesktopApplicationTile Size="2x2" Column="0" Row="0" DesktopApplicationID="Microsoft.AutoGenerated.{CB37A99A-A61D-22B2-5FD9-2AE4AA302CEC}" />
                    <start:DesktopApplicationTile Size="2x2" Column="2" Row="2" DesktopApplicationID="Citrix.Workspace" />
                  </start:Group>
                </defaultlayout:StartLayout>
              </StartLayoutCollection>
            </DefaultLayoutOverride>
          </LayoutModificationTemplate>
                ]]>
            </StartLayout>
            <Taskbar ShowTaskbar="true"/>
        </Profile>
    </Profiles>
    <Configs>
        <Config>
            <AutoLogonAccount r1809:DisplayName="Bank Kiosk"/>
            <DefaultProfile Id="{5B328104-BD89-4863-AB27-4ED6EE355485}"/>
        </Config>
    </Configs>
</AssignedAccessConfiguration>
"@)
Set-CimInstance -CimInstance $obj