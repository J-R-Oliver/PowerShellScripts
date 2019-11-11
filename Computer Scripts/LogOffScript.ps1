# Declare Variables
$Date = Get-Date -Format d
$Time = Get-Date -Format t
$Username = $env:USERNAME
$Domain = $env:USERDOMAIN
$Computer = $env:COMPUTERNAME
 
# Write logoff activity to database
    # Connect to SQL server
    $SQLSERVER = "GE-Files"
    $SQLDB = "WKS_SCS"
    $SQLCONNECTION = "Server=$SQLSERVER; Database=$SQLDB; Integrated Security = True"
    $SQLQUERY = "INSERT INTO dbo.WSLogoffs (Date,Time,Username,Domain,Computer) VALUES (@Date,@Time,@Username,@Domain,@Computer)"
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $SQLCONNECTION
    $connection.Open()
    # Log event
    $command = $connection.CreateCommand()
    $command.CommandText = $SQLQUERY
        $command.Parameters.AddWithValue("@Date", $Date) | Out-Null
        $command.Parameters.AddWithValue("@Time", $Time) | Out-Null
        $command.Parameters.AddWithValue("@Username", $Username) | Out-Null
        $command.Parameters.AddWithValue("@Domain", $Domain) | Out-Null
        $command.Parameters.AddWithValue("@Computer", $Computer) | Out-Null
    $command.ExecuteNonQuery()
    # Disconnect
    $connection.Close()