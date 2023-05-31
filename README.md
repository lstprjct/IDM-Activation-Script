# IDM Activation Script
_________________________________

###   Activation:
_________________________________

 - This script applies the registry lock method to activate the Internet Download Manager (IDM).

 - This method requires Internet at the time of activation.

 - IDM updates can be installed directly without having to activate again.

 - After the activation, if in some cases, the IDM starts to show an activation nag screen, 
   then just run the activation option again.

_________________________________

###   Reset IDM Activation / Trial:
_________________________________

 - The Internet Download Manager provides 30 days trial period, you can use this script to 
   reset this Activation / Trial period whenever you want.
 
 - This option also can be used to restore status if in case the IDM reports a fake serial
   key and other similar errors.

_________________________________

###   OS requirement: Windows 7, 8, 8.1, 10 & 11
_________________________________

##   How to use it?

###   PowerShell

On Windows 10/11, right-click on the windows start menu and select PowerShell or Terminal.

Copy-paste the below code and press enter

iwr -useb https://raw.githubusercontent.com/lstprjct/IDM-Activation-Script/main/IAS.ps1 | iex

You will see the activation options, and follow onscreen instructions.

That's all.
_________________________________

 - Project is supported only for Windows 7/8/8.1/10/11 and their Server equivalent.

_________________________________

### - Advanced Info:
_________________________________

   - To add a custom name in IDM license info, edit line number 5 in the script file.
   - For activation in unattended mode, run the script with /act parameter.
   - For reset in unattended mode, run the script with /res parameter.
   - To enable silent mode with the above two methods, run the script with /s parameter.

Possible accepted values,

"IAS_xxxxxxxx.cmd" /act
"IAS_xxxxxxxx.cmd" /res
"IAS_xxxxxxxx.cmd" /act /s
"IAS_xxxxxxxx.cmd" /res /s

_________________________________

### - Troubleshooting steps:
_________________________________

   - If any other activator was used to activate IDM previously then make sure to properly
     uninstall it with that same activator (if there is an option), this is especially important
     if any registry/firewall block method was used.

   - Uninstall the IDM from the control panel.

   - Make sure the latest original IDM setup is used for the installation,
     you can download it from https://www.internetdownloadmanager.com/download.html

   - Now install the IDM and use the activate option in this script if failed then,

     - Disable the windows firewall with the script option, this helps in case of leftover entries of
       previously used activator (some file patch method also creates firewall entries).

     - Some security programs may block this script, this is false-positive, as long as you 
       downloaded the file from the original post (mentioned below on this page), temporary suspend
       Antivirus real-time protection, or exclude the downloaded file/extracted folder from scanning.

     - If you are still facing any issues, please contact me (mentioned below on this page).

____________________________________________________________________________________________________

###   Credits:
____________________________________________________________________________________________________

   @Dukun Cabul        - Original researcher of this IDM trial reset and activation logic,
                         made an Autoit tool for these methods, IDM-AIO_2020_Final
                         nsaneforums.com/topic/371047--/?do=findComment&comment=1632062
                         
   @WindowsAddict	     - Ported the above Autoit tool to a batch script

   @AveYo aka @BAU     - Snippet to set registry ownership and permission recursively
                         pastebin.com/XTPt0JSC

   @abbodi1406         - Awesome batch script tricks and help

   @dbenham            - Set buffer height independently of window height
                         stackoverflow.com/a/13351373

   @ModByPiash (Me)	   - Add and fix some missing features.

   @vavavr00m          - Changed set name to prompt for a name
_________________________________

##   IDM Activation Script
 
 
###   Telegram:   https://t.me/ModByPiash

  Forum:   https://www.nsaneforums.com/topic/371047--/?do=findComment^&comment=1578647
____________________________________________________________________________________________________
