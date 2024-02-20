# IDM Activation Script
An open-source tool to activate and reset the trial of [Internet Download Manager](https://www.internetdownloadmanager.com/)

# Disclaimer
I want to clarify that I am not the original author of this script. When I initially published this script on GitHub, the primary author had not yet created an official GitHub repository. As a result, the only available option for users was to visit the [official forum](https://www.nsaneforums.com/topic/371047--/?do=findComment%5E&comment=1578647) to download and utilize the script, later they created the [Github](https://github.com/WindowsAddict/IDM-Activation-Script) repository. My main aim in creating this repository was to streamline the process for users. Furthermore, I ensured to credit the original creators of the script as a sign of respect for their work.

# Features
* IDM freeze trial and activation with registry key lock method
* Activation and trial persist even after installing IDM updates
* IDM trial reset
* Fully open source
* Based on the transparent batch script

# IAS Latest Release
Last Release - v1.2 (12-Feb-2024)
[GitHub](https://github.com/lstprjct/IDM-Activation-Script)

# Download / How to use it?
First fresh install [Internet Download Manager](https://www.internetdownloadmanager.com/). Make sure previous cracks/patches are removed/uninstalled if there are any.
After that follow the below steps to activate it.

# Note
* 📌 The activation option is currently not working in the script, use the Freeze trial option to lock the 30-day trial period for the lifetime.

# Method 1 - PowerShell
(Recommended)

* Right-click on the Windows start menu and select PowerShell or Terminal (Not CMD).
* Copy-paste the below code and press enter
*`iex(irm is.gd/idm_reset)`
* You will see the activation options, follow the on-screen instructions.
* That’s all.

# Method 2 - Traditional

* Download the file from [GitHub](https://github.com/lstprjct/IDM-Activation-Script/archive/refs/heads/main.zip)
* Right-click on the downloaded zip file and extract
* In the extracted folder, run the file named `IAS.cmd`
* You will see the activation options, and follow onscreen instructions.
* That’s all.

# Info
## Freeze Trial
* IDM provides a 30-day trial period, you can use this option in the script to lock this trial period for the lifetime so that you won’t have to reset the trial again and your trial won’t expire.
* This method requires the Internet at the time of applying this option.
* IDM updates can be installed directly without having to freeze it again.

## Activation
(***Currently not working**)

* This script applies the registry lock method to activate the Internet download manager (IDM).
* This method requires the Internet at the time of activation.
* IDM updates can be installed directly without having to activate it again.
* After the activation, if in some cases, IDM starts to show an activation nag screen, then just run the activation option again without using the reset option.

## Reset IDM Activation / Trial
* Internet download manager provides a 30-day trial period, you can use this script to reset this Activation / Trial period whenever you want.
* This option also can be used to restore status if in case IDM reports a fake serial key and other similar errors.

## OS requirement
* The project is supported for Windows 7/8/8.1/10/11 and their Server equivalent.
* The PowerShell method to run IAS is supported on Windows 8 and higher.

## Advanced Info
* To activate in unattended mode, run the script with the /act parameter.
* To freeze the trial in unattended mode, run the script with the /frz parameter.
* To reset in unattended mode, run the script with the /res parameter.

# How does it work?
* IDM stores the data related to trial and activation across various registry keys. Some of these keys are locked to protect them from tampering and data is stored in a pattern to track the fake serial issue and the remaining trial days. To activate it, the script here simply generates those registry keys by triggering a few downloads in IDM, identifies those registry keys, and locks them so IDM can’t edit and view them. That way IDM cannot show the warning that it’s activated with a fake serial key.

# Troubleshoot
* Browser Integration Fix: [Chrome](https://www.internetdownloadmanager.com/register/new_faq/bi9.html) - [Firefox](https://www.internetdownloadmanager.com/register/new_faq/bi4.html)
* Reach out to us on [Telegram](https://t.me/ModByPiash) with an error screenshot.
[![](https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Telegram_logo.svg/512px-Telegram_logo.svg.png)](https://t.me/ModByPiash)

# Changelog
## v1.2
* Added back activation option with a randomized name, email, and key in registration details along with a warning that it’s not working for some users, the recommended option is to use Freeze trial.
## v1.1
* IDM update 6.42b3 has started showing fake serial popups with IAS activation, due to this we have removed the activation option and replaced it with the Freeze trial option to lock the 30-day trial period for the lifetime.
* Now the script will disable quick-edit in CMD windows using Powershell instead of editing the registry, thanks to @abbodi1406 for the code and @awuctl for the idea.
* Code to relaunch script with conhost.exe to avoid terminal app is now merged in quick-edit disable code, thanks to @abbodi1406.
Updated full code from [WindowsAddict ](https://massgrave.dev/idm-activation-script)
## v1.0
* Added the code to relaunch the script with conhost.exe if the script is running from the terminal app.
* Fixed an issue in getting the current user account SID.
## v0.9
* Fixed an issue where the script can not activate and reset IDM in non-admin user accounts.
* Fixed an issue where the script incorrectly shows that IDM is activated.
* Fixed an issue where a fake serial pop-up may appear. The script will also show the info to run the activation option again without using the reset option.
* IDM registry scanning and locking code is now written in Powershell.
* The script update checker code is added to the script.
* The script will now disable quick edit mode temporarily because users often click inside the script window and it pauses the script.
* The script will back up the CLSISD registry keys before performing operations on them.
* Many error checks are added to better identify the issues.
## v0.8
* Move the project to [Github](https://github.com/lstprjct/IDM-Activation-Script)
* Minor bug fixes
* Add info to inform users that empty registry keys are being deleted when the script deletes a lot of them

# Screenshots
![IAS](https://github.com/lstprjct/IDM-Activation-Script/assets/88411318/fafdb481-c497-464f-b1e6-9a4254eaf880)

![IAS_Freeze_Trial](https://github.com/lstprjct/IDM-Activation-Script/assets/88411318/76b36582-8cf4-4d1e-870f-6e8e57c80a87)

# Credits

|                                             |                                                                                                                                                                                                                                        |
|-------------------|-----------------------------------------------------|
| Dukun Cabul                                 | Original researcher of this IDM trial reset and activation logic, made an Autoit tool for these methods, [IDM-AIO_2020_Final](https://nsaneforums.com/topic/371047-discussion-internet-download-manager-fixes/page/8/#comment-1632062) |
| AveYo aka BAU                               | [reg_own lean and mean snippet](https://pastebin.com/XTPt0JSC)                                                                                                                                                                         |
| [abbodi1406](https://github.com/abbodi1406) | Help in coding                                                                                                                                                                                                                         |
| WindowsAddict                               | Original [IAS](https://github.com/WindowsAddict/IDM-Activation-Script) Author                                                                                                                                                                                                                             |

And thanks to the IAS users for their interest, feedback, and assistance.

------------------------------------------------------------------------

Made with Love ❤️
