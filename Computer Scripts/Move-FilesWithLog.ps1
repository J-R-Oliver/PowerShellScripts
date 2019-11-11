$TargetPath = Read-Host -Prompt 'Please enter the file path of the directory to copy'
$ArchivePath = Read-Host -Prompt 'Please enter the destination to copy to
'
$MovedFiles = "$home\Desktop\Successfully Moved.txt"
$ErrorLog = "$home\Desktop\Unsuccessfully Moved.txt"
Get-ChildItem $TargetPath | ForEach-Object { 
$FilePath = $_.fullname 
Try 
{ 
Move-Item $FilePath $ArchivePath 
$FilePath | Add-Content $MovedFiles 
} 
Catch 
{ 
"ERROR moving ${filename}: $_" | Add-Content $ErrorLog 
} 
}

# Target Path # \\ge-filesvr\f$\Drive-E archived\GE-FILESVR\2019-01-27_20-00-16\E$

# Archive Path # E:\Archive\GE-FILESVR\E$