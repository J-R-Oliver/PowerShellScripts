function New-StAnnesuser {
    <# Add Script #>
}

function Disable-User {
    <# Add Script #>
}

function Enable-User {
    <# Add Script #>
}

function Disable-Users {
    <# Add Script #>
}

function Enable-Users {
    <# Add Script #>
}

function Get-UserTeamManagement {
    <# Add Script #>
}

do{
    Write-Host "================ St Anne's User Tool ================"
    Write-Host "1: Press '1' to create a new St Anne's user."
    Write-Host "2: Press '2' to disable a user."
    Write-Host "3: Press '3' to re-enable user."
    Write-Host "4: Press '4' to disable users on leavers spreadsheet."
    Write-Host "5: Press '5' to re-enble users on disabled users spreadsheet."
    Write-Host "6: Press '6' to re-enble users on disabled users spreadsheet."
    Write-Host "Q: Press 'Q' to quit."
     
    $input = Read-Host "Please make a selection..."
     switch ($input)
     {
           '1' {
                Clear-Host
                Write-Host "================ St Anne's New Tool ================"
                New-StAnnesuser
           } 
           '2' {
                Clear-Host
                Write-Host "================ St Anne's Disable User Tool ================"
                Disable-User
           } 
           '3' {
                Clear-Host
                Write-Host "================ St Anne's Enable User Tool ================"
                Enable-User 
           } 
           '4' {
                Clear-Host
                Write-Host "================ St Anne's Disable Leaving Users Tool ================"
                Disable-Users
            }
            '5' {
                Clear-Host
                Write-Host "================ St Anne's Re-Enable Disabled Users Tool ================"
                Enable-Users
           }  
           '6' {
            Clear-Host
            Write-Host "================ St Anne's User's Team Membership Tool ================"
            Get-UserTeamManagement
       } 
           'q' {
                return
           }
     }
     pause
}
until ($input -eq 'q')