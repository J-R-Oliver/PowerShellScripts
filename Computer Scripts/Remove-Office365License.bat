REM Commands to remote license from Microsoft Office 365 installation
cd ‘C:\Program Files (x86)\Microsoft Office\Office16’
cscript ospp.vbs /dstatus
REM Enter the last five characters of porduct key after the : 
cscript ospp.vbs /unpkey:
