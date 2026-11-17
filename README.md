# Manufacturer Updates (Dell/DP)
<p>This tool was developed to quickly apply manufacturer updates with no package dependencies as a hot-fix for out of date Dell or HP computers. The script detects the computer manufacturer, checks whether Dell Command Update (DCU) or HP Image Assistant (HPIA) is already installed, installs the appropriate utility when necessary, and then silently applies available (OEM drivers/firmware) updates (automatic reboots are disabled).</p>
<br /> 

<h3>Execution</h3>
Run this script from an elevated PowerShell session or deploy it through an endpoint-management platform using SYSTEM context. ManufacturerUpdates.ps1 can be used with non-standard system paths as it was purposely built to be drive agnostic (by using the $env:SYSTEMDRIVE variable).
<br />

Script Workflow:
Detects if DCU/HPIA is installed → Install DCU/HPIA if needed → Scans/Downloads → Apply updates
<br />



- If you need to change the color matching to tune it to your environment, it can be edited in <a href="https://github.com/Contoso-Administrator/ADSearch/blob/cfed1e7b07852694d2667bc6c9b0468e93c24b2f/ADSearch.ps1#L201" target="_blank">lines 201-204</a>
- If you need to change the score range, it can be edited in <a href="https://github.com/Contoso-Administrator/ADSearch/blob/cfed1e7b07852694d2667bc6c9b0468e93c24b2f/ADSearch.ps1#L133" target="_blank">lines 133-137</a> (depending on similarity to the two forest (user/computer) structured domain).
<br />

# ADSearch_Excel

<p>ADSearch_Excel is the Excel version of the ADSearch lookup tool and can be an effective tool for auditing computer locations within Active Directory. It works by opening a workbook, finding each user listed in the 'Last Login' column (by searching the workbook for that header), and looks up the computer in that row's 'Hostname' column. The script then compares the computer and user OUs to estimate matching results in a new column. It is recommended to tune the matching of this tool and apply it to your environment(s) and workflow.
  
>[!NOTE]
>ADSearch_Excel is setup by default to work with ServiceNow CMDB (.xlsx) exports.
<br />

ADSearch_Excel works by placing the script in the same directory as the Excel workbook you are needing to add ADSearch results in and can be ran by starting the script with a domain account that can read user and computer objects in Active Directory. The script will fail if more than one Excel workbook is in the same directory as the script. ADSearch_Excel will import/install all required dependencies (Install-Module and ImportExcel) at start. The script will then add the columns 'OU Match Percentage', 'OU Match Reason', and 'AD_Name' to each row of the workbook for easy auditing. After the script is done, it will then add a worksheet called 'ADSearch_ErrorLog' with verbose logs of the results.
<br /><br />

<ins>OU Match Percentage</ins><br />
Returns the results of the fuzzy Levenshteinin matching in a percentage.

<ins>OU Match Reason</ins><br />
Returns match result along with the user and computer location or the  error result for that lookup (ex. ERROR: Computer Lookup)

<ins>AD_Name</ins><br />
Returns the username (SamAccountName) or error result for that lookup (ex. ERROR: Disabled).

<br />

>[!CAUTION]
>The variable <ins>$DomainSuffix</ins> must be set to the suffix of your domain in <a href="https://github.com/Contoso-Administrator/ADSearch/blob/799ea05bc4585e1c2df99075fa258756372e7a59/ADSearch_Excel.ps1#L7" target="_blank">line 7</a> of ADSearch_Excel.ps1. This is because this portion of the tool is designed to be able to work with multi-domain environments.
<br />

<h3>Tuning ADSearch_Excel.ps1</h3>
The headers used for matching can edited by changing the variables below, along with the score range:
<br /><br />

- Set the <ins>$FullNameHeader</ins> variable for the workbook header that has full user names (ex. John Doe) <a href="https://github.com/Contoso-Administrator/ADSearch/blob/02e4c6ef2dfc27e6df60bd4df423c6e0e4ce72fd/ADSearch_Excel.ps1#L2" target="_blank">line 2</a>.
- Set the <ins>$HostnameHeader</ins> variable for the workbook header that has the computer hostname (ex. DESKTOP-1234) <a href="https://github.com/Contoso-Administrator/ADSearch/blob/02e4c6ef2dfc27e6df60bd4df423c6e0e4ce72fd/ADSearch_Excel.ps1#L3" target="_blank">line 3</a>.
- Set the <ins>$DomainSuffix</ins> variable to the suffix of your domain <a href="https://github.com/Contoso-Administrator/ADSearch/blob/799ea05bc4585e1c2df99075fa258756372e7a59/ADSearch_Excel.ps1#L7" target="_blank">line 7</a>
- If you need to change the score range, it can be edited in <a href="https://github.com/Contoso-Administrator/ADSearch/blob/02e4c6ef2dfc27e6df60bd4df423c6e0e4ce72fd/ADSearch_Excel.ps1#L109" target="_blank">lines 109-112</a> (depending on complexity of the user/computer OU structure).
<br />

><h3>Requirements</h3>
>
>- A domain account that can read user and computer objects.
>- For ADSearch_Excel.ps1 to work, the $DomainSuffix variable needs to be edited to your domain <ins>line 7</ins>.
>- A domain-joined Windows machine with the 'RSAT: Active Directory module' installed.
>- Access to the PowerShell Gallery, as the script relies on Install-Module and ImportExcel as a dependency.
>- An Excel workbook (.xlsx) with 'Last Login' and 'Hostname' headers (if variables are left unconfigured) in row 1. 'Last Login' should contain users full names (John Doe) and the 'Hostname' column should contain computer hostnames.
>- This script will only add columns to your workbook, it will not otherwise delete or edit anything.
>- Windows PowerShell 5.1 or later.
