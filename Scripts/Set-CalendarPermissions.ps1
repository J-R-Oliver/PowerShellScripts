#Get Calendar permissions
$UserName = Read-Host -Prompt "Enter Username"
Get-MailboxFolderPermission -Identity "$($UserName):\Calendar"

#Set default calendar permissions
$UserName = Read-Host -Prompt "Enter Username"
Set-Mailbox -Identity $UserName -DetailLevel LimitedDetails  

#Set unique calendar permissions 
$User1 = Read-Host -Prompt "Enter username of the calendar you wish to ammend"
$User2 = Read-Host -Prompt "Enter Username of user who you wish to give access"
Add-MailboxFolderPermission -Identity “$($User1):\calendar” –User “$User2” -AccessRights Reviewer

<#

You can specify individual folder permissions or roles, which are combinations of permissions. You can specify multiple permissions and roles separated by commas.

The following individual permissions are available:

CreateItems: The user can create items within the specified folder.

CreateSubfolders: The user can create subfolders in the specified folder.

DeleteAllItems: The user can delete all items in the specified folder.

DeleteOwnedItems: The user can only delete items that they created from the specified folder.

EditAllItems: The user can edit all items in the specified folder.

EditOwnedItems: The user can only edit items that they created in the specified folder.

FolderContact: The user is the contact for the specified public folder.

FolderOwner: The user is the owner of the specified folder. The user can view the folder, move the folder and create subfolders. The user can't read items, edit items, delete items or create items.

FolderVisible: The user can view the specified folder, but can't read or edit items within the specified public folder.

ReadItems: The user can read items within the specified folder.

The roles that are available, along with the permissions that they assign, are described in the following list:

Author: CreateItems, DeleteOwnedItems, EditOwnedItems, FolderVisible, ReadItems

Contributor: CreateItems, FolderVisible

Editor: CreateItems, DeleteAllItems, DeleteOwnedItems, EditAllItems, EditOwnedItems, FolderVisible, ReadItems

None: FolderVisible

NonEditingAuthor: CreateItems, FolderVisible, ReadItems

Owner: CreateItems, CreateSubfolders, DeleteAllItems, DeleteOwnedItems, EditAllItems, EditOwnedItems, FolderContact, FolderOwner, FolderVisible, ReadItems

PublishingEditor: CreateItems, CreateSubfolders, DeleteAllItems, DeleteOwnedItems, EditAllItems, EditOwnedItems, FolderVisible, ReadItems

PublishingAuthor: CreateItems, CreateSubfolders, DeleteOwnedItems, EditOwnedItems, FolderVisible, ReadItems

Reviewer: FolderVisible, ReadItems

The following roles apply specifically to calendar folders:

AvailabilityOnly: View only availability data

LimitedDetails: View availability data with subject and location

#>