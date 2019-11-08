# PowerShell-Library
Library of PowerShell Scripts

## Style Guide Crib Sheet 

PowerShell uses PascalCase for all public identifiers: module names, function or cmdlet names, class, enum, and attribute names, public fields or properties, global variables and constants, and parameters (As they are properties of .Net classes).

A special case is made for two-letter acronyms in which both letters are capitalized, as in the variable $PSBoundParameters or the command Get-PSDrive. You should also not extend it to compound acronyms, such as when Azure's Resource Manager (RM) meets a Virtual Machine (VM) in Start-AzureRmVM...

PowerShell language keywords are written in lower case such foreach, dynamicparam, -eq and -match.

You may use camelCase for variables within your functions (or modules) to distinguish private variables from parameters, but this is a matter of taste. Shared variables should be distinguished by using their scope name, such as $Script:PSBoundParameters or $Global:DebugPreference. If you are using camelCase for a variable that starts with a two-letter acronym (where both letters are capitalized), both letters should be set to lowercase (such as adComputer).

Every braceable statement should have the opening brace on the end of a line, and the closing brace at the beginning of a line (Unless small script block).

Surround function and class definitions with two blank lines. Method definitions within a class are surrounded by a single blank line. End each file with a single blank line.
