# Manufacturer Updates (Dell/HP)

<p>This tool was developed to quickly apply unattended manufacturer updates with no package dependencies as a quick fix for out of date Dell or HP computers. The script detects the computer manufacturer, checks whether Dell Command Update (DCU) or HP Image Assistant (HPIA) is already installed, installs the appropriate utility when necessary, and then silently applies available (OEM drivers/firmware) updates.</p><br />

<h3><ins>Execution</ins></h3>
<p>Run this script from an elevated PowerShell session or deploy it through an endpoint-management platform using SYSTEM context. ManufacturerUpdates.ps1 can be used with non-standard system paths as it was purposely built to be drive agnostic. Automatic reboots are disabled and both tools are not set to any schedule by default.</p>

```mermaid
flowchart LR
    A[Detects if DCU/HPIA is installed] --> B[Install DCU/HPIA if needed]
    B --> C[Scans/Downloads] --> D[Updates]
```
<br />

The script detects the computer manufacturer by querying 'Get-CimInstance' and then confirms if Dell Command Update or HP Image Assistant is installed by testing the following paths:
- <ins>Dell Command Update:</ins> ~\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe
- <ins>HP Image Assistant</ins>: ~\SWSetup\HPIA\HPImageAssistant.exe
<br />

<p>If the script does not detect Dell Command Update or HP Image Assistant, it will then download the initial installer to the %TEMP% folder ("~\AppData\Local\Temp" or "~\Windows\Temp", depending on the context) before it installs to the above locations. Manufacturer updates are then silently applied after scanning the computer and downloading the updates.</p><br />

>[!CAUTION]
Updates usually apply if the script does not fail, but there is no error handling written for this process. Updates should be confirmed in either the <a href="https://www.dell.com/support/manuals/en-us/command-update/dcu_ug/activity-log?guid=guid-31fdd315-57c4-48d5-9847-a3f9f1dd86d7&lang=en-us" target="_blank">Dell</a> or <a href="https://ftp.hp.com/pub/caps-softpaq/cmit/whitepapers/HPIAUserGuide2.pdf" target="_blank">HP</a> logs or tool.
<br />

##Installer URLs
<p>Dell / HP periodically release new versions of Dell Command Update / HP Image Assistant and the download links are changed as a result. If installation suddenly stops working, verify the configured installer URLs first by copying them into a browser to confirm it downloads the tool. Follow the instructions below to confirm and update the URLs for these tools.</p><br />

1. If the installer URL needs to be updated, navigate to the links for Dell Command Update and/or HP Image Assistant to right-click on the download links for the respective tool and select the option to 'copy this link'.
   
- [Dell Command Update](https://www.dell.com/support/kbdoc/en-us/000177325/dell-command-update) (select the option for 'Windows Universal Application'):
<img width="1212" height="191" alt="image" src="https://github.com/user-attachments/assets/dbd5e9da-f8fe-4a2c-b4e7-17790e1ec01d" />

- Then right-click the option for 'Download .EXE' to "copy this link":
<img width="1242" height="570" alt="image" src="https://github.com/user-attachments/assets/7b8d7551-3afe-4587-ad8d-936bc7237e8b" />


- [HP Image Assistant](https://ftp.ext.hp.com/pub/caps-softpaq/cmit/HPIA.html) (right-click the option for 'SoftPaq' to "copy this link"):
<img width="1443" height="466" alt="image" src="https://github.com/user-attachments/assets/c80d1a85-b094-433b-9752-ab5b5308b4f7" />

2. Confirm that the direct download links work by pasting the URL into your browser (the link should end in .exe) and verifying that the links downloads the installer for Dell Command Update and/or HP Image Assistant.

3. With the links confirmed, edit the variables for Dell Command Update and/or HP Image Assistant:
   
- Dell Command Update:
       To update the URL for Dell, paste the direct download link into the variable called '$dellUrl' in <a href="https://github.com/Contoso-Administrator/" target="_blank">line 6</a> of "ManufacturerUpdates.ps1".
- HP Image Assistant:
	  To update the URL for Dell, paste the direct download link into the variable called '$hpUrl' in <a href="https://github.com/Contoso-Administrator/" target="_blank">line 7</a> of "ManufacturerUpdates.ps1".
<br />

>[!NOTE]
> If you use the 'Classic' option for Dell Command Update, you will also need to update the '$DCU' installer path in <a href="https://github.com/Contoso-Administrator/" target="_blank">line 10</a> to "$env:SYSTEMDRIVE\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe".
<br />

><h3>Requirements</h3>
>
>- ManufacturerUpdates.ps1 must run as **Administrator** or **SYSTEM** or it will fail.
>- Internet access is needed to download the installer and updates.
