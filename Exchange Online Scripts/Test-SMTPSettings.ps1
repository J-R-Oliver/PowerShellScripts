$UserName = "konica.copier@st-annes.org.uk"
$Password = ConvertTo-SecureString -String "k0n1cam1n0lta" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UserName, $Password

$MailMessageParams = @{
    From = "konica.copier@st-annes.org.uk"
    To = "james.oliver@st-annes.org.uk"
    Cc = "leon.carr-dixon@st-annes.org.uk"
    Attachment = "C:\Users\james.oliver\OneDrive - St Anne's Community Services\Desktop\Test.txt"
    Subject = "Test Email with Attachment"
    Body = "This is a test email to verify SMTP settings"
    SMTPServer = "smtp.office365.com"
    Port = "587"
    UseSsl = $true
    Credential = $Credential
    DeliveryNotificationOption = "OnSuccess"
}

Send-MailMessage @MailMessageParams

#https://docs.microsoft.com/en-us/exchange/mail-flow-best-practices/how-to-set-up-a-multifunction-device-or-application-to-send-email-using-office-3
