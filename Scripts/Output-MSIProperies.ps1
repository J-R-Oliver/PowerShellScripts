<#

Outputs login file cotaining properties.

Once the process has finished, you simply open up the logfile and note the lines beginning with Property(S):/Property(C):as Jon Heese mentioned.

Generally speaking, the parameters/properties that can be set for an install are logged in ALL CAPS; for example, ALLUSERS can be set ALLUSERS=1 so that the installation is for all users.

#>

msiexec /a 3CXPhoneforWindows16.msi 
/lp! "C:\Users\james.oliver\Desktop\install.txt" 
TARGETDIR="C:\Users\james.oliver\Desktop"