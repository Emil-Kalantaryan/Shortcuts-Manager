# Constant Variables - Program Information
New-Variable -Name Author -Option Constant -Value "Emil Kalantaryan"
New-Variable -Name Name -Option Constant -Value "Shortcuts Manager"
New-Variable -Name Version -Option Constant -Value "1.1.0"
New-Variable -Name Date -Option Constant -Value "26/04/2022"
New-Variable -Name GitHubRepositoryURL -Option Constant -Value "https://github.com/Emil-Kalantaryan/Shortcuts-Manager"
New-Variable -Name GitHubReleasesURL -Option Constant -Value "$("$GitHubRepositoryURL"+"/releases")"

# Constant Variable - Origin of the Execution (first Parameter of the Program)
New-Variable -Name Origin -Option Constant -Value $Args[0]

# Constant Variable - Reserved Slots for 'System Options'
New-Variable -Name ReservedSlots -Option Constant -Value 4

# Constant Variable - Remote Desktop Address Regular Expression Pattern
New-Variable -Name RDPRegExPattern -Option Constant -Value "^rdp:.+$"

# Constant Variable - HTTP Protocol Address Regular Expression Pattern
New-Variable -Name HTTPRegExPattern -Option Constant -Value "^http:\/\/.+$"

# Constant Variable - HTTPS Protocol Address Regular Expression Pattern
New-Variable -Name HTTPSRegExPattern -Option Constant -Value "^https:\/\/.+$"

# Constant Variable - Email Regular Expression Pattern
New-Variable -Name EmailRegExPattern -Option Constant -Value "^mail:([a-zA-Z0-9.-]+)@([a-zA-Z0-9.-]+)\.([a-zA-Z]{2,})"

# Constant Variable - Profile Name Regular Expression Pattern
New-Variable -Name ProfileNameRegExPattern -Option Constant -Value "^([a-zA-Z0-9]+ )*[a-zA-Z0-9]+$"

# Constant Variable - Backup File Name Regular Expression Pattern
New-Variable -Name BackupFileNameRegExPattern -Option Constant -Value "^([1-9]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))_(([0-1][0-9])|([2][0-3]))-([0-5][0-9])-([0-5][0-9])_Backup.json$"

# Constant Variable - Available Colors List
New-Variable -Name Colors -Option Constant -Value @(
    "Blue",
    "Cyan",
    "DarkBlue",
    "DarkCyan",
    "DarkGray",
    "DarkGreen",
    "DarkMagenta",
    "DarkRed",
    "DarkYellow",
    "Gray",
    "Green",
    "Magenta",
    "Red",
    "Yellow"
)

# Constant Variable - Forbidden Profile Names
New-Variable -Name ForbiddenProfileNames -Option Constant -Value @(
    "CON",
    "PRN",
    "AUX",
    "NUL",
    "COM1",
    "COM2",
    "COM3",
    "COM4",
    "COM5",
    "COM6",
    "COM7",
    "COM8",
    "COM9",
    "LPT1",
    "LPT2",
    "LPT3",
    "LPT4",
    "LPT5",
    "LPT6",
    "LPT7",
    "LPT8",
    "LPT9"
)

# Constant Variables - Limits
New-Variable -Name ShortcutNameCharLimit -Option Constant -Value 128
New-Variable -Name CategoryNameCharLimit -Option Constant -Value 64
New-Variable -Name ProfileNameCharLimit -Option Constant -Value 32
New-Variable -Name ShortcutsLimit -Option Constant -Value $(999 - $ReservedSlots)
New-Variable -Name CategoriesLimit -Option Constant -Value 14
New-Variable -Name ProfilesLimit -Option Constant -Value 100
New-Variable -Name BackupsLimit -Option Constant -Value 100

# Constant Variables - Output Colors
New-Variable -Name ProcessColor -Option Constant -Value "Yellow"
New-Variable -Name WarningColor -Option Constant -Value "DarkRed"
New-Variable -Name DefaultColor -Option Constant -Value "White"
New-Variable -Name SuccessColor -Option Constant -Value "Green"
New-Variable -Name InputColor -Option Constant -Value "Cyan"
New-Variable -Name ErrorColor -Option Constant -Value "Red"
New-Variable -Name EmptyColor -Option Constant -Value "DarkGray"
New-Variable -Name InfoColor -Option Constant -Value "DarkYellow"
New-Variable -Name DataColor -Option Constant -Value "DarkCyan"

# Constant Variables - Output Strings
New-Variable -Name ColorSpace -Option Constant -Value "       "
New-Variable -Name StartupBorder -Option Constant -Value "--------------------------------------"
New-Variable -Name MenuBorder -Option Constant -Value "----------------------------------------------"
New-Variable -Name SelectedProfileIsTheCurrentActiveProfile -Option Constant -Value "`nERROR: The selected Profile is the current active Profile"
New-Variable -Name NoMoreProfilesThanTheCurrentOne -Option Constant -Value "ERROR: There are no more Profiles available than the current one"
New-Variable -Name PressEnterToRemainCurrentValue -Option Constant -Value "`nINFO: Press 'Enter' without typing anything in the fields that you want to remain with the current value"
New-Variable -Name NotMatchYN -Option Constant -Value "`nERROR: The indicated value does not match with the format: [Y/N]"
New-Variable -Name SelectMenuItem -Option Constant -Value "Select a Menu item: "

# Function - Converts a String passed as parameter to UTF-8 format
function StringToUTF8 {
    param (
        $String
    )
    return $([System.Text.Encoding]::UTF8.GetString([System.Text.Encoding]::GetEncoding(1252).GetBytes($String)))
}

# Function - Checks if a value is an Integer or not
function IsInteger {
    param (
        $Value
    )
    try {
        [int]$Value
        return $True
    }
    catch {
        return $False
    }
}

# Function - Checks if a String passed as parameter is considered Empty or not
function IsEmpty {
    param (
        $String
    )
    if ("$String" -eq "") {
        return $True
    }
    else {
        return $False
    }
}

# Function - Updates the Powershell Window Title including a Text passed as parameter
function UpdateWindowTitle {
    param (
        $Text
    )
    if ($Origin -eq "WT") {
        $Host.UI.RawUI.WindowTitle = "$Text  |  $Name"
    }
    else {
        $Host.UI.RawUI.WindowTitle = "$Name  |  $Text  |  Profile: $CurrentProfileName"
    }
}

# Function - Pauses the Program until the user presses any key
function PressAnyKeyToContinue {
    # $(Write-Host "Press Enter to continue...: " -ForegroundColor $DefaultColor -NoNewLine; Read-Host)
    Write-Host "Press any key to continue...: " -ForegroundColor $DefaultColor -NoNewLine
    [Console]::ReadKey($True) > $Null
}

# Function - Checks if there is only one Profile available
function OnlyOneProfile {
    if ($ProfilesDatabase.Profiles.Length -eq 1) {
        return $True
    }
    else {
        return $False
    }
}

# Function - Displays an error indicating that the provided value is empty
function ProvidedValueIsEmpty {
    param (
        $Params
    )

    # Parameters
    $BreakLineStart = $Params[0]
    $BreakLineEnd = $Params[1]

    if ($BreakLineStart) {
        Write-Host ""
    }

    Write-Host "ERROR: The provided value is empty" -ForegroundColor $ErrorColor

    if ($BreakLineEnd) {
        Write-Host ""
    }
}

# Function - Shows an error (Incorrect Data Format) in the Standard Output
function DataFormatNotCorrect {
    param (
        $Params
    )

    # Parameters
    $Item = "$($Params[0])"
    $Action = "$($Params[1])"
    $NextToNumber = $Params[2]
    $BreakLineStart = $Params[3]
    $BreakLineEnd = $Params[4]

    if ($NextToNumber) {
        $Text = "Enter the number next to the $Item you want to $Action"
    }
    else {
        $Text = "Enter the number of the $Item you want to $Action"
    }

    if ($BreakLineStart) {
        Write-Host ""
    }

    Write-Host "ERROR: The format of the data is not correct ($Text)" -ForegroundColor $ErrorColor

    if ($BreakLineEnd) {
        Write-Host ""
    }
}

# Function - Displays an error indicating that the selected menu item is not in the available menu items list
function ItemNotInMenu {
    param (
        $Params
    )

    # Parameters
    $Option = $Params[0]
    $MenuName = "$($Params[1])"

    if (IsEmpty($Option)) {
        ProvidedValueIsEmpty($False, $True)
    }
    elseif (IsInteger($Option)) {
        Write-Host "ERROR: The selected option is not in the $MenuName Menu`n" -ForegroundColor $ErrorColor
    }
    else {
        DataFormatNotCorrect("Option", "START", $True, $False, $True)
    }
}

# Function - Displays an error indicating that the selected item is not in the available items list
function ItemNotInList {
    param (
        $Params
    )

    # Parameters
    $ItemName = "$($Params[0])"
    $ListName = "$($Params[1])"

    Write-Host "`nERROR: The selected $ItemName is not available in the $ListName List" -ForegroundColor $ErrorColor
}

# Function - Displays an error indicating that no items has been created (type of the item passed as parameter)
function NoItemsCreated {
    param (
        $Params
    )

    # Parameters
    $ItemName = "$($Params[0])"
    $TextColor = "$($Params[1])"
    $ErrorText = $($Params[2])
    $BreakLineStart = $($Params[3])
    $BreakLineEnd = $($Params[4])

    if ($BreakLineStart) {
        Write-Host ""
    }

    if ($ErrorText) {
        Write-Host "ERROR: " -ForegroundColor $TextColor -NoNewLine
    }
    else {
        Write-Host "  " -NoNewLine
    }

    Write-Host "There are no $ItemName created" -ForegroundColor $TextColor

    if ($BreakLineEnd) {
        Write-Host ""
    }
}

# Function - Displays an informative message indicating that no values have been changed (Modification Forms)
function NoChangesDetected {
    param (
        $ItemName
    )
    Write-Host "`nINFO: No changes have been detected. The selected $ItemName will remain unchanged`n" -ForegroundColor $InfoColor
    PressAnyKeyToContinue
}

# Function - Checks if Colors are available or not
function NoColorsAvailable {
    if ($Database.Colors.Length -eq 0) {
        return $True
    }
    else {
        return $False
    }
}

# Function - Displays an error informing that no slots are available of an item passed as parameter
function NoSlotsAvailable {
    param (
        $ItemName
    )
    Write-Host "`nERROR: No slots available to create a new $ItemName (Delete an existing $ItemName to obtain a free slot)`n" -ForegroundColor $ErrorColor
}

# Function - Removes a Color (passed as parameter) from the Colors list
function RemoveColorFromColorsList {
    param (
        $ColorToRemove
    )
    if ($Database.Colors.Length -eq 1) {
        $Database.Colors = @()
    }
    elseif ($Database.Colors.Length -eq 2) {
        $RemainingColor = $Database.Colors | Where-Object { $_ -ne $ColorToRemove }
        $ModifiedList = @()
        $ModifiedList += $RemainingColor
        $Database.Colors = $ModifiedList
    }
    else {
        $ModifiedList = @()
        $ModifiedList = $Database.Colors | Where-Object { $_ -ne $ColorToRemove }
        $Database.Colors = $ModifiedList
    }
}

# Function - Adds a Color (passed as parameter) to the Colors list
function AddColorToColorsList {
    param (
        $ColorToAdd
    )
    if (NoColorsAvailable) {
        $ColorsList = @()
        $ColorsList += $ColorToAdd
        $Database.Colors = $ColorsList
    }
    else {
        $Database.Colors += $ColorToAdd
        
        # Sort Colors List
        $Database.Colors = $Database.Colors | Sort-Object
    }
}

# Function - Given a Shortcuts list, sorts it by category and returns the Sorted list
function SortShortcuts {
    param (
        $ShortcutsList
    )
    $SortedShortcutsList = @()
    foreach ($Category in $Database.Categories) {
        foreach ($Shortcut in $ShortcutsList) {
            if ($Shortcut.CategoryID -eq $Category.ID) {
                $SortedShortcut = @{}
                $SortedShortcut.Add("ID", $Shortcut.ID)
                $SortedShortcut.Add("Name", $Shortcut.Name)
                $SortedShortcut.Add("Path", $Shortcut.Path)
                $SortedShortcut.Add("CategoryID", $Shortcut.CategoryID)
                $SortedShortcutsList += $SortedShortcut
            }
        }
    }
    return $SortedShortcutsList
}

# Function - Given a category ID, returns its Index in the Categories list
function GetCategoryIndex {
    param (
        $CategoryID
    )
    $CategoryIndex = 0
    foreach ($Category in $Database.Categories) {
        if ($CategoryID -eq $Category.ID) {
            break
        }
        else {
            $CategoryIndex++
        }
    }
    return $CategoryIndex
}

# Function - Given a Profile ID, returns its Index in the Profiles list
function GetProfileIndex {
    param (
        $ProfileID
    )
    $ProfileIndex = 0
    foreach ($ProfileItem in $ProfilesDatabase.Profiles) {
        if ($ProfileItem.ID -eq $ProfileID) {
            break
        }
        else {
            $ProfileIndex++
        }
    }
    return $ProfileIndex
}

# Function - Returns the number of available backups of the current profile
function GetNumberOfBackups {
    $BackupsList = Get-ChildItem -Name -Path $CurrentProfileBackupsPath | Where-Object { $_ -match $BackupFileNameRegExPattern }

    try {
        if ($BackupsList.GetType().Name -eq "String") {
            return 1
        }
        else {
            return $BackupsList.Length
        }
    }
    catch {
        return 0
    }
}

# Function - Checks the Type of the Path passed by paramater
function CheckPathType {
    param (
        $Path
    )
    try {
        if ($Path.Substring(0, 4) -eq "rdp:") {
            return "RDP"
        }
        elseif ($Path.Substring(0, 5) -eq "mail:") {
            return "MAIL"
        }
        elseif ($Path.Substring(0, 5) -eq "http:") {
            return "HTTP"
        }
        elseif ($Path.Substring(0, 6) -eq "https:") {
            return "HTTPS"
        }
        else {
            return "PATH"
        }
    }
    catch {
        return "PATH"
    }
}

# Function - Checks if a Path passed as parameter is Valid or not (detects if the Path exists or not)
function PathValidation {
    param (
        $Path
    )
    if ($(CheckPathType($Path)) -eq "PATH") {
        Write-Host "`nValidating the Shortcut Path..." -ForegroundColor $ProcessColor

        $PathValidation = Test-Path -Path $Path 2> $Null

        if ($PathValidation) {
            Write-Host "The Shortcut Path is valid" -ForegroundColor $SuccessColor
            return $True
        }
        else {
            Write-Host "ERROR: The Shortcut Path is invalid or does not exist (If it's a Network Path, make sure you have access to the Network Drive)" -ForegroundColor $ErrorColor
            return $False
        }
    }
    else {
        Write-Host "`nValidating the format of the Shortcut Path..." -ForegroundColor $ProcessColor

        if ($Path -imatch $RDPRegExPattern) {
            $RDP = $True
        }

        if ($Path -imatch $EmailRegExPattern) {
            $MAIL = $True
        }

        if ($Path -imatch $HTTPRegExPattern) {
            $HTTP = $True
        }

        if ($Path -imatch $HTTPsRegExPattern) {
            $HTTPS = $True
        }

        if ($RDP -or $MAIL -or $HTTP -or $HTTPS) {
            Write-Host "The Shortcut Path format is valid" -ForegroundColor $SuccessColor
            return $True
        }
        else {
            Write-Host "ERROR: The Shortcut Path format is invalid" -ForegroundColor $ErrorColor
            return $False
        }
    }
}

# Function - Cheks if a limit (passed as parameter) is not exceeded in a specific string (passed as parameter)
function CharLimitNotExceeded {
    param (
        $Params
    )

    # Parameters
    $String = "$($Params[0])"
    $CharLimit = $($Params[1])
    $ItemName = "$($Params[2])"

    if ("$String".Length -le $CharLimit) {
        return $True
    }
    else {
        Write-Host "`nERROR: The $CharLimit character limit for the $ItemName has been exceeded" -ForegroundColor $ErrorColor
        return $False
    }
}

# Function - Checks if a Profile Name is valid or not (Looking for forbidden chars and names, chars limit and duplicated names)
function CheckProfileName {
    param (
        $ProfileName
    )
    # Cheking if the Profile Name has Forbidden Characters
    if ($ProfileName -match $ProfileNameRegExPattern) {
        # Cheking if the Profile Name has exceeded the Characters limit
        if (CharLimitNotExceeded($ProfileName, $ProfileNameCharLimit, "Profile Name")) {
            # Checking if the Profile Name is equal to a Reserved Name of the Operating System
            if ($ProfileName -in $ForbiddenProfileNames) {
                Write-Host "`nERROR: The provided Profile Name is reserved by the Operating System (Windows)" -ForegroundColor $ErrorColor
                return $False
            }
            else {
                # Cheking if the Profiles Directory exists
                if (Test-Path -Path $ProfilesPath) {
                    # Getting existent Profile Names
                    $LocalProfilesNames = Get-ChildItem -Path $ProfilesPath -Name
                }
                else {
                    $LocalProfilesNames = ""
                }

                # Checking if the Profile Name is equal to an existing Profile Name
                if ($ProfileName -in $LocalProfilesNames) {
                    Write-Host "`nERROR: The provided Profile Name is equal than an already existent Profile Name" -ForegroundColor $ErrorColor
                    return $False
                }
                else {
                    return $True
                }
            }
        }
        else {
            return $False
        }
    }
    else {
        Write-Host "`nERROR: The provided Profile Name has forbidden characters. Allowed characters: [A-Z] [a-z] [0-9]" -ForegroundColor $ErrorColor
        return $False
    }
}

# Function - Checks if there are Categories created (Can hide the error output by passing a "False" boolean value as parameter)
function CheckForCategories {
    param (
        $PrintError
    )
    if ($Database.Categories.Length -eq 0) {
        if ($PrintError) {
            NoItemsCreated("Categories", $ErrorColor, $True, $True, $True)
        }
        return $False
    }
    else {
        return $True
    }
}

# Function - Checks if there are Shortcuts created (Can hide the error output by passing a "False" boolean value as parameter)
function CheckForShortcuts {
    param (
        $PrintError
    )
    if ($Database.Shortcuts.Length -eq 0) {
        if ($PrintError) {
            NoItemsCreated("Shortcuts", $ErrorColor, $True, $True, $True)
        }
        return $False
    }
    else {
        return $True
    }
}

# Function - Counts how many Shortcuts are in a specific Category (Passing the ID of the desired Category as a parameter)
function CountShortcutsInCategory {
    param (
        $CategoryID
    )
    $Shortcuts = 0
    foreach ($Shortcut in $Database.Shortcuts) {
        if ($Shortcut.CategoryID -eq $CategoryID) {
            $Shortcuts++
        }
    }
    return $Shortcuts
}

# Function - Returns a number of spaces in a String (Number of spaces is indicated with a parameter)
function GenerateSpaces {
    param (
        $Spaces
    )
    $Result = ""
    for ($i = 0; $i -lt $Spaces; $i++) {
        $Result += " "
    }
    return $Result
}

# Function - Shows a Progress Bar. Parameters: Length of the Bar (Ticks), Time in Milliseconds of each Tick, Color of the Bar, Header, Color of the Header
function ShowProgressBar {
    param (
        $Params
    )

    # Parameters
    $Length = [int]$Params[0]
    $TimeInMilliseconds = [int]$Params[1]
    $Color = "$($Params[2])"
    $Header = "$($Params[3])"
    $HeaderColor = "$($Params[4])"

    # Boolean (the screen is clean or not)
    $ScreenIsClean = $True

    # Header Output
    Write-Host $Header -ForegroundColor $HeaderColor

    # Progress Bar Output
    for ($i = 0; $i -le $Length; $i++) {
        # Cheking if the Progress Bar Fits on the Screen
        if ($Host.UI.RawUI.WindowSize.Width -ge $Length + 11) {
            Write-Host "`r $(StringToUTF8("♦")) $ProgressBar$(GenerateSpaces($Length - $i)) $(StringToUTF8("♦")) $([Math]::Round($i * (100 / $Length)))% " -ForegroundColor $Color -NoNewLine
            $ScreenIsClean = $False
        }
        else {
            # Cheking if the screen is clean or not
            if (!($ScreenIsClean)) {
                Clear-Host
                Write-Host $Header -ForegroundColor $HeaderColor
                $ScreenIsClean = $True
            }
            Write-Host "`r $([Math]::Round($i * (100 / $Length)))% Complete " -ForegroundColor $Color -NoNewLine
        }
        $ProgressBar += StringToUTF8("▬")
        Start-Sleep -Milliseconds $TimeInMilliseconds
    }
    Write-Host "`n"
}

# Function - Shows in the Standard Output the Current Profile Name
function ShowCurrentProfileName {
    Write-Host "Current Profile: $CurrentProfileName" -ForegroundColor $ProcessColor
}

# Function - Shows the Stats of a Item Type specified as parameter (Stats: Number of Items, Items Limit & Available Slots of that Item)
function ShowItemStats {
    param (
        $ItemType
    )

    # Cheking Item Type
    if ("$ItemType" -eq "CATEGORY") {
        $NumberOfItems = $Database.Categories.Length
        $ItemLimit = $CategoriesLimit
        $ItemName = "Categories"
    }
    elseif ("$ItemType" -eq "SHORTCUT") {
        $NumberOfItems = $Database.Shortcuts.Length
        $ItemLimit = $ShortcutsLimit
        $ItemName = "Shortcuts"
    }
    elseif ("$ItemType" -eq "BACKUP") {
        $NumberOfItems = GetNumberOfBackups
        $ItemLimit = $BackupsLimit
        $ItemName = "Backups"
    }
    elseif ("$ItemType" -eq "PROFILE") {
        $NumberOfItems = $ProfilesDatabase.Profiles.Length
        $ItemLimit = $ProfilesLimit
        $ItemName = "Profiles"
    }

    Write-Host "  $($NumberOfItems) / $ItemLimit $ItemName" -ForegroundColor $DefaultColor -NoNewLine

    if ($NumberOfItems -eq $ItemLimit) {
        $SlotsColor = $ErrorColor
    }
    else {
        $SlotsColor = $SuccessColor
    }

    if ($ItemLimit - $NumberOfItems -eq 1) {
        $SlotsText = "Slot"
    }
    else {
        $SlotsText = "Slots"
    }

    Write-Host " ($($ItemLimit - $NumberOfItems) $SlotsText Available)" -ForegroundColor $SlotsColor
}

# Function - Shows in the Standard Output the confirmation of an action executed in a Category form (Create, Modify & Delete)
function CategoryFormActionExecuted {
    param (
        $Params
    )

    # Parameters
    $CategoryName = "$($Params[0])"
    $CategoryColor = "$($Params[1])"
    $Action = "$($Params[2])"

    # Action Executed Successfully (Output)
    Write-Host "`nThe Category " -ForegroundColor $DefaultColor -NoNewLine
    Write-Host $CategoryName -ForegroundColor $CategoryColor -NoNewLine
    Write-Host " has been " -ForegroundColor $DefaultColor -NoNewLine
    Write-Host $Action -ForegroundColor $SuccessColor -NoNewLine
    Write-Host " successfully`n" -ForegroundColor $DefaultColor
    PressAnyKeyToContinue
}

# Function - Shows in the Standard Output the confirmation of an action executed in a Shortcut form (Create, Modify & Delete)
function ShortcutFormActionExecuted {
    param (
        $Params
    )

    # Parameters
    $ShortcutName = "$($Params[0])"
    $CategoryColor = "$($Params[1])"
    $CategoryName = "$($Params[2])"
    $ShortcutPath = "$($Params[3])"
    $Action = "$($Params[4])"

    # Action Executed Successfully (Output)
    Write-Host "`nThe Shortcut " -ForegroundColor $DefaultColor -NoNewLine
    Write-Host $ShortcutName -ForegroundColor $CategoryColor -NoNewLine
    Write-Host " in Category " -ForegroundColor $DefaultColor -NoNewLine
    Write-Host $CategoryName -ForegroundColor $CategoryColor -NoNewLine
    Write-Host " with the Path " -ForegroundColor $DefaultColor -NoNewLine
    Write-Host $ShortcutPath -ForegroundColor $CategoryColor -NoNewLine
    Write-Host " has been " -ForegroundColor $DefaultColor -NoNewLine
    Write-Host $Action -ForegroundColor $SuccessColor -NoNewLine
    Write-Host " successfully`n" -ForegroundColor $DefaultColor
    PressAnyKeyToContinue
}

# Function - Shows in the Standard Output the confirmation of an action executed in a Backup form (Delete & Restore)
function BackupFormActionExecuted {
    param (
        $Params
    )

    # Parameters
    $BackupName = "$($Params[0])"
    $Action = "$($Params[1])"
    $BreakLineStart = $Params[2]

    if ($BreakLineStart) {
        Write-Host ""
    }

    # Action Executed Successfully (Output)
    Write-Host "The Backup" -ForegroundColor $DefaultColor -NoNewLine
    Write-Host " $BackupName" -ForegroundColor $SuccessColor -NoNewLine
    Write-Host " has been" -ForegroundColor $DefaultColor -NoNewLine
    Write-Host " $Action" -ForegroundColor $SuccessColor -NoNewLine
    Write-Host " successfully`n" -ForegroundColor $DefaultColor
}

# Function - Shows in the Standard Output the confirmation of an action executed in a Profile form (Create, Modify & Delete)
function ProfileFormActionExecuted {
    param (
        $Params
    )

    # Parameters
    $ProfileName = "$($Params[0])"
    $Action = "$($Params[1])"

    # Action Executed Successfully (Output)
    Write-Host "`nThe Profile" -ForegroundColor $DefaultColor -NoNewLine
    Write-Host " $ProfileName" -ForegroundColor $SuccessColor -NoNewLine
    Write-Host " has been" -ForegroundColor $DefaultColor -NoNewLine
    Write-Host " $Action" -ForegroundColor $SuccessColor -NoNewLine
    Write-Host " successfully`n" -ForegroundColor $DefaultColor
}

# Function - Displays a message to confirm an action (The action is indicated by parameter)
function ActionConfirmation {
    param (
        $Params
    )

    # Parameters
    $Action = "$($Params[0])"
    $ItemName = "$($Params[1])"
    $ExtraString = "$($Params[2])"

    Write-Host "`nWARNING: Are you sure you want to $Action the selected $($ItemName)? $ExtraString[Y/N]: " -ForegroundColor $WarningColor -NoNewLine
}

# Function - Displays a message indicating that an action has been cancelled (Supported Actions: Delete, Restore, Restart, Factory Reset)
function ActionCancelled {
    param (
        $Params
    )

    # Parameters
    $Action = "$($Params[0])"
    $ItemName = "$($Params[1])"
    $ProfileName = "$($Params[2])"

    $StillAvailable = "still available for use"

    # Cheking Action Type
    if ($Action -eq "DELETE") {
        if ($ProfileName -eq "") {
            $Text = "The selected $ItemName is $StillAvailable"
        }
        else {
            $Text = "The Profile '$PorfileName' is $StillAvailable"
        }
    }
    elseif (($Action -eq "RESTORE") -or ($Action -eq "ERASE")) {
        $Text = "The current Profile Database ($CurrentProfileName) remains unchanged"
    }
    elseif ($Action -eq "RESTART") {
        $Text = "The Profile in this Session remains: $CurrentProfileName"
    }
    elseif ($Action -eq "FACTORY RESET") {
        $Text = "All the Profiles and their respective Categories, Shortcuts and Backups are $StillAvailable"
    }

    # Cancelled Action Output
    Write-Host "`nThe $Action operation has been cancelled. $Text`n" -ForegroundColor $InfoColor

    PressAnyKeyToContinue
}

# Function - Shows in the Standard Output an item from the Settings Menu (the data of the item is indicated by parameters)
function SettingOption {
    param (
        $Params
    )

    # Parameters
    $Index = "$($Params[0])"
    $Color = "$($Params[1])"
    $Title = "$($Params[2])"

    # Setting Item Output
    Write-Host "  $Index.-`t" -ForegroundColor $DefaultColor -NoNewLine
    Write-Host " " -BackgroundColor $Color -NoNewLine
    Write-Host " $Title" -ForegroundColor $Color
}

# Function - Opens a Page passed as parameter and displays information in the Standard Output
function OpenPage {
    param (
        $Params
    )

    # Parameters
    $URL = "$($Params[0])"
    $PageName = "$($Params[1])"

    # URL Startup in the Default Browser of the OS + Information Output
    Write-Host "`nOpening the $PageName Page...`n" -ForegroundColor $ProcessColor
    Start-Process $URL
    Write-Host "$PageName Page" -ForegroundColor $DefaultColor -NoNewLine
    Write-Host " OPENED " -ForegroundColor $SuccessColor -NoNewLine
    Write-Host "in the default Browser of the Operating System" -ForegroundColor $DefaultColor -NoNewLine
    Write-Host "`n`nLink: " -ForegroundColor $DefaultColor -NoNewLine
    Write-Host $URL"`n" -ForegroundColor $SuccessColor
    PressAnyKeyToContinue
}

# Function - Shows in the Standard Output the list of Available Colors and the respective Index of each color
function ListColors {
    $Index = 1
    Write-Host "`nAvailable Colors List:`n" -ForegroundColor $DefaultColor
    foreach ($Color in $Database.Colors) {
        Write-Host " " -NoNewLine
        Write-Host $ColorSpace -BackgroundColor $Color -NoNewLine
        Write-Host "  $Index" -ForegroundColor $DefaultColor
        $Index++
    }
}

# Function - Shows in the Standard Output the list of Categories (Includes the number of Shortcuts of each Category and the total number of Categories)
function ListCategories {
    # Powershell Window Title - Update
    UpdateWindowTitle("Categories List")

    # Categories List Output
    ProfileHeader
    Write-Host "                  CATEGORIES`n" -ForegroundColor $DefaultColor

    # Cheking if Categories have been created or not
    if (!(CheckForCategories($False))) {
        NoItemsCreated("Categories", $EmptyColor, $False, $False, $True)
    }
    else {
        # Categories List Index
        $CategoriesIndex = 1

        # Listing all the Categories
        foreach ($Category in $Database.Categories) {
            Write-Host "  Category $($CategoriesIndex): " -ForegroundColor $DefaultColor -NoNewLine
            Write-Host $Category.Name -ForegroundColor $Category.Color

            $Shortcuts = CountShortcutsInCategory($Category.ID)
            $Color = $DefaultColor

            if ($Shortcuts -eq 0) {
                $Text = "No Shortcuts"
                $Color = $EmptyColor
            }
            elseif ($Shortcuts -eq 1) {
                $Text = "1 Shortcut"
            }
            else {
                $Text = "$Shortcuts Shortcuts"
            }

            Write-Host "   - $Text assigned`n" -ForegroundColor $Color

            $CategoriesIndex++
        }
    }

    ShowItemStats("CATEGORY")

    Write-Host "`n$MenuBorder`n" -ForegroundColor $DefaultColor
    PressAnyKeyToContinue
}

# Function - Shows in the Standard Output the list of Categories with the respective Index of each Category
function ListCategoriesWithIndex {
    $Index = 1
    Write-Host "`nCategories List:`n" -ForegroundColor $DefaultColor
    foreach ($Category in $Database.Categories) {
        Write-Host "  $Index.-`t" -ForegroundColor $DefaultColor -NoNewLine
        Write-Host $Category.Name -ForegroundColor $Category.Color
        $Index++
    }
}

# Function - Shows in the Standard Output the list of Shortcuts (For each shortcut are displayed: Name, Path, Category and Position in the Main Menu)
function ListShortcuts {
    # Powershell Window Title - Update
    UpdateWindowTitle("Shortcuts List")

    # Shortcuts List Output
    ProfileHeader
    Write-Host "                  SHORTCUTS" -ForegroundColor $DefaultColor

    # Cheking if Shortcuts have been created or not
    if (!(CheckForShortcuts($False))) {
        NoItemsCreated("Shortcuts", $EmptyColor, $False, $True, $True)
    }
    else {
        # Listing all the Shortcuts
        $Index = $ReservedSlots
        foreach ($Shortcut in $Database.Shortcuts) {
            $CategoryIndex = GetCategoryIndex($Shortcut.CategoryID)
            $ShortcutColor = $Database.Categories[$CategoryIndex].Color

            Write-Host "`n  Shortcut in Menu position -> " -ForegroundColor $DefaultColor -NoNewLine
            Write-Host $Index -ForegroundColor $ShortcutColor
            Write-Host "   - Name: " -ForegroundColor $DefaultColor -NoNewLine
            Write-Host $Shortcut.Name -ForegroundColor $ShortcutColor
            Write-Host "   - Path: " -ForegroundColor $DefaultColor -NoNewLine
            Write-Host $Shortcut.Path -ForegroundColor $ShortcutColor
            Write-Host "   - Category: " -ForegroundColor $DefaultColor -NoNewLine
            Write-Host $Database.Categories[$CategoryIndex].Name "" -ForegroundColor $ShortcutColor
            Write-Host "   - Type: " -ForegroundColor $DefaultColor -NoNewLine
            Write-Host $(CheckPathType($Shortcut.Path)) "" -ForegroundColor $ShortcutColor

            $Index++
        }
        Write-Host ""
    }

    ShowItemStats("SHORTCUT")

    Write-Host "`n$MenuBorder`n" -ForegroundColor $DefaultColor
    PressAnyKeyToContinue
}

# Function - Shows in the Standard Output the list of Shortcuts with the respective Index of each Category (You can indicate if you want the Index to start from the Reserved Slots or not)
function ListShortcutsWithIndex {
    param (
        $IndexPlusReservedSlots
    )

    if ($IndexPlusReservedSlots) {
        $Index = $ReservedSlots
    }
    else {
        $Index = 1
        Write-Host "`nShortcuts List:`n" -ForegroundColor $DefaultColor
    }

    foreach ($Shortcut in $Database.Shortcuts) {
        $CategoryIndex = GetCategoryIndex($Shortcut.CategoryID)
        Write-Host "  $Index.-`t$($Database.Categories[$CategoryIndex].Name): $($Shortcut.Name)" -ForegroundColor $Database.Categories[$CategoryIndex].Color
        $Index++
    }
}

# Function - Shows in the Standard Output the list of Shortcut Types (Marked in green the Path Formats)
function ListShortcutTypes {
    Write-Host "`nShortcut Types:" -ForegroundColor $DefaultColor
    Write-Host "  PATH: Files, Folders and Programs" -ForegroundColor $DefaultColor -NoNewLine
    Write-Host " (Absolute Path of the Resource)" -ForegroundColor $SuccessColor
    Write-Host "  HTTP/HTTPS: Web Pages" -ForegroundColor $DefaultColor -NoNewLine
    Write-Host " (http://`"URL or IP`" or https://`"URL or IP`")" -ForegroundColor $SuccessColor
    Write-Host "  RDP: Remote Desktop Connections" -ForegroundColor $DefaultColor -NoNewLine
    Write-Host " (rdp:`"Host Name or IP`")" -ForegroundColor $SuccessColor
    Write-Host "  MAIL: Email Addresses" -ForegroundColor $DefaultColor -NoNewLine
    Write-Host " (mail:`"Email Address`")" -ForegroundColor $SuccessColor
}

# Function - Shows in the Standard Output the list of Backups
function ListBackups {
    # Powershell Window Title - Update
    UpdateWindowTitle("Backups List")

    # Getting all the Backup File Names of the Current Profile
    $BackupsList = Get-ChildItem -Name -Path $CurrentProfileBackupsPath | Where-Object { $_ -match $BackupFileNameRegExPattern }

    # Backups List Output
    ProfileHeader
    Write-Host "                   BACKUPS`n" -ForegroundColor $DefaultColor

    # Cheking if Backups have been created or not
    if ($BackupsList.Length -eq 0) {
        NoItemsCreated("Backups", $EmptyColor, $False, $False, $True)
    }
    else {
        # Listing all the Backups
        foreach ($Backup in $BackupsList) {
            Write-Host " " $Backup.Substring(0, 26) -ForegroundColor $DefaultColor
        }
        Write-Host ""
    }

    ShowItemStats("BACKUP")

    Write-Host "`n$MenuBorder`n" -ForegroundColor $DefaultColor
    PressAnyKeyToContinue
}

# Function - Shows in the Standard Output the list of Backups with the respective Index of each Backup
function ListBackupsWithIndex {
    $BackupsList = Get-ChildItem -Name -Path $CurrentProfileBackupsPath | Where-Object { $_ -match $BackupFileNameRegExPattern }
    Write-Host "`nBackups List:" -ForegroundColor $DefaultColor
    $Index = 1
    foreach ($Backup in $BackupsList) {
        Write-Host "  $Index.-`t$($Backup.Substring(0, 26))" -ForegroundColor $DefaultColor
        $Index++
    }
}

# Function - Shows in the Standard Output the list of Profiles (The Current loaded Profile is marked as "Active" in color Green)
function ListProfiles {
    # Powershell Window Title - Update
    UpdateWindowTitle("Profiles List")

    # Profiles List Output
    ProfileHeader
    Write-Host "                   PROFILES" -ForegroundColor $DefaultColor
    foreach ($ProfileItem in $ProfilesDatabase.Profiles) {
        if ($ProfileItem.ID -eq $CurrentProfileID) {
            $Active = "(Active)"
            $Color = $SuccessColor
        }
        else {
            $Active = ""
            $Color = $DefaultColor
        }
        Write-Host "`n  Profile:" $ProfileItem.Name $Active -ForegroundColor $Color
        Write-Host "   - Path:" $ProfileItem.Path -ForegroundColor $Color
    }

    Write-Host ""
    ShowItemStats("PROFILE")

    Write-Host "`n$MenuBorder`n" -ForegroundColor $DefaultColor
    PressAnyKeyToContinue
}

# Function - Shows in the Standard Output the list of Profiles with the respective Index of each Profile
function ListProfilesWithIndex {
    Write-Host "`nProfiles List:`n" -ForegroundColor $DefaultColor
    $Index = 1
    foreach ($ProfileItem in $ProfilesDatabase.Profiles) {
        if ($ProfileItem.ID -eq $CurrentProfileID) {
            $Active = "(Active)"
            $Color = $SuccessColor
        }
        else {
            $Active = ""
            $Color = $DefaultColor
        }
        Write-Host "  $Index.-`t$($ProfileItem.Name)" $Active -ForegroundColor $Color
        $Index++
    }
}

# Function - Shows in the Standard Output a Header with the Current Active Profile Name
function ProfileHeader {
    Write-Host $MenuBorder -ForegroundColor $DefaultColor
    Write-Host " Profile: " -ForegroundColor $DefaultColor -NoNewLine
    Write-Host $CurrentProfileName -ForegroundColor $DataColor
    Write-Host $MenuBorder -ForegroundColor $DefaultColor
}

# Function - Shows in the Standard Output a Header with the Name of a Form (Provided via Parameter)
function FormHeader {
    param (
        $FormName
    )
    Write-Host "`nLaunched " -ForegroundColor $DefaultColor -NoNewLine
    Write-Host $FormName -ForegroundColor $SuccessColor -NoNewLine
    Write-Host " Form" -ForegroundColor $DefaultColor
    Write-Host "`nINFO: Write EXIT in any field to cancel the operation" -ForegroundColor $InfoColor
}

# Function - Collects the necessary data and creates a new Category if the information provided by the user is correct
function CreateCategory {
    # Powershell Window Title - Update
    UpdateWindowTitle("Create Category")

    # Checking if the categories limit has been exceeded or not
    if (NoColorsAvailable) {
        NoSlotsAvailable("Category")
        PressAnyKeyToContinue
        return
    }

    FormHeader("Create Category")

    # Loop for recolect the Category Name
    while ($True) {
        # Read User Input - Category Name
        $CategoryName = $(Write-Host "`nEnter a Name for the Category: " -ForegroundColor $InputColor -NoNewLine; Read-Host)

        # Cheking if the User Input is a Cancel instruction
        if ($CategoryName -eq "exit") {
            return
        }

        # Cheking if the User Input is empty or has been exceeded the Character limit
        if (IsEmpty($CategoryName)) {
            ProvidedValueIsEmpty($True, $False)
        }
        elseif (CharLimitNotExceeded($CategoryName, $CategoryNameCharLimit, "Category Name")) {
            break
        }
    }

    # Loop for recolect the Category Color
    while ($True) {
        # Show Colors List
        ListColors

        # Read User Input - Category Color Index
        $CategoryColorIndex = $(Write-Host "`nSelect a Color for the Category: " -ForegroundColor $InputColor -NoNewLine; Read-Host)

        # Cheking if the User Input is a Cancel instruction
        if ($CategoryColorIndex -eq "exit") {
            return
        }

        # Cheking if the User Input is empty
        if (IsEmpty($CategoryColorIndex)) {
            ProvidedValueIsEmpty($True, $False)
        }
        else {
            # Cheking if the User Input is an Integer (Correct Format)
            if (IsInteger($CategoryColorIndex)) {
                $CategoryColorIndex = [int]$CategoryColorIndex - 1

                # Cheking if the selected Color Index is inside of the range of available Colors
                if (($CategoryColorIndex -ge 0) -and ($CategoryColorIndex -lt $Database.Colors.Length)) {
                    $CategoryColor = $Database.Colors[$CategoryColorIndex]
                    break
                }
                else {
                    ItemNotInList("Color", "Colors")
                }
            }
            else {
                DataFormatNotCorrect("Color", "SELECT", $True, $True, $False)
            }
        }
    }

    # Assigning ID for the New Category
    $CategoryID = $Database.CategoryID_Index + 1

    # Creating the new 'Category Object'
    $NewCategory = @{}
    $NewCategory.Add("ID", $CategoryID)
    $NewCategory.Add("Name", $CategoryName)
    $NewCategory.Add("Color", $CategoryColor)

    # Adding the 'Category Object' to the Current Profile Database
    $Database.Categories += $NewCategory

    # Updating Category ID Index value in the Current Profile Database
    $Database.CategoryID_Index = $CategoryID

    # Remove the selected Color of the available Colors List
    RemoveColorFromColorsList($CategoryColor)

    # Commit Changes to the Current Profile Database
    $Database | ConvertTo-Json | Out-File $CurrentProfileDatabasePath
    $Database = Get-Content -Path $CurrentProfileDatabasePath | ConvertFrom-Json

    CategoryFormActionExecuted($CategoryName, $CategoryColor, "CREATED")
}

# Function - Collects the necessary data and modifies an existent Category if the information provided by the user is correct
function ModifyCategory {
    # Powershell Window Title - Update
    UpdateWindowTitle("Modify Category")

    # Checking if Categories exists
    if (!(CheckForCategories($True))) {
        PressAnyKeyToContinue
        return
    }

    FormHeader("Modify Category")

    # Loop for recolect the Category Index
    while ($True) {
        # Show Categories List
        ListCategoriesWithIndex

        # Read User Input - Category Index
        $CategoryIndex = $(Write-Host "`nSelect the Category you want to Modify: " -ForegroundColor $InputColor -NoNewLine; Read-Host)
            
        # Cheking if the User Input is a Cancel instruction
        if ($CategoryIndex -eq "exit") {
            return
        }

        # Cheking if the User Input is empty
        if (IsEmpty($CategoryIndex)) {
            ProvidedValueIsEmpty($True, $False)
        }
        else {
            # Cheking if the User Input is an Integer (Correct Format)
            if (IsInteger($CategoryIndex)) {
                $CategoryIndex = [int]$CategoryIndex - 1

                # Cheking if the selected Category Index is inside of the range of available Categories
                if (($CategoryIndex -ge 0) -and ($CategoryIndex -lt $Database.Categories.Length)) {
                    $Modified = $False

                    $OriginalCategoryName = $Database.Categories[$CategoryIndex].Name
                    $OriginalCategoryColor = $Database.Categories[$CategoryIndex].Color

                    Write-Host "`nSelected Category: " -ForegroundColor $DefaultColor -NoNewLine
                    Write-Host $OriginalCategoryName -ForegroundColor $OriginalCategoryColor
                    Write-Host $PressEnterToRemainCurrentValue -ForegroundColor $InfoColor
                    break
                }
                else {
                    ItemNotInList("Category", "Categories")
                }
            }
            else {
                DataFormatNotCorrect("Category", "SELECT", $False, $True, $False)
            }
        }
    }

    # Loop for recolect the New Category Name
    while ($True) {
        # Read User Input - New Category Name
        $NewCategoryName = $(Write-Host "`nEnter a New Name for the selected Category: " -ForegroundColor $InputColor -NoNewLine; Read-Host)

        # Cheking if the User Input is a Cancel instruction
        if ($NewCategoryName -eq "exit") {
            return
        }

        # Cheking if the New Name is equal to the previous Name
        if ($NewCategoryName -ceq $OriginalCategoryName) {
            Write-Host "`nThe 'New Name' field is equal to the current Name of the selected Category. The Category Name will remain the same: " -ForegroundColor $DefaultColor -NoNewLine
            Write-Host $OriginalCategoryName -ForegroundColor $OriginalCategoryColor
            $NewCategoryName = $OriginalCategoryName
            break
        }
        else {
            # Cheking if the User Input is empty or has been exceeded the Character limit
            if (IsEmpty($NewCategoryName)) {
                Write-Host "`nThe 'New Name' field is empty. The Category Name will remain the same: " -ForegroundColor $DefaultColor -NoNewLine
                Write-Host $OriginalCategoryName -ForegroundColor $OriginalCategoryColor
                $NewCategoryName = $OriginalCategoryName
                break
            }
            elseif (CharLimitNotExceeded($NewCategoryName, $CategoryNameCharLimit, "Category Name")) {
                $Modified = $True
                break
            }
        }
    }

    # Checking if colors are available
    if (!(NoColorsAvailable)) {
        # Loop for recolect the New Category Color
        while ($True) {
            # Show Colors List
            ListColors

            # Read User Input - New Category Color Index
            $NewCategoryColorIndex = $(Write-Host "`nSelect a New Color for the selected Category: " -ForegroundColor $InputColor -NoNewLine; Read-Host)

            # Cheking if the User Input is a Cancel instruction
            if ($NewCategoryColorIndex -eq "exit") {
                return
            }

            # Cheking if the User Input is empty
            if (IsEmpty($NewCategoryColorIndex)) {
                Write-Host "`nThe 'New Color' field is empty. The Category Color will remain the same: " -ForegroundColor $DefaultColor -NoNewLine
                Write-Host $ColorSpace -BackgroundColor $OriginalCategoryColor
                $NewCategoryColor = $OriginalCategoryColor

                # Cheking if any field has been modified
                if (!$Modified) {
                    NoChangesDetected("Category")
                    return
                }
                else {
                    break
                }
            }

            # Cheking if the User Input is an Integer (Correct Format)
            if (IsInteger($NewCategoryColorIndex)) {
                $NewCategoryColorIndex = [int]$NewCategoryColorIndex - 1

                # Cheking if the selected Color Index is inside of the range of available Colors
                if (($NewCategoryColorIndex -ge 0) -and ($NewCategoryColorIndex -lt $Database.Colors.Length)) {
                    $NewCategoryColor = $Database.Colors[$NewCategoryColorIndex]
                    $Modified = $True
                    break
                }
                else {
                    ItemNotInList("Color", "Colors")
                }
            }
            else {
                DataFormatNotCorrect("Color", "SELECT", $True, $True, $False)
            }
        }
    }
    else {
        Write-Host "`nNo Colors available in the Colors List. The Category Color will remain the same: " -ForegroundColor $DefaultColor -NonewLine
        Write-Host $ColorSpace -BackgroundColor $OriginalCategoryColor
        $NewCategoryColor = $OriginalCategoryColor

        # Cheking if any field has been modified
        if (!$Modified) {
            NoChangesDetected("Category")
            return
        }
    }

    # Updating Category Name
    $Database.Categories[$CategoryIndex].Name = $NewCategoryName

    # Checking if the color is modified
    if ($NewCategoryColor -ne $OriginalCategoryColor) {
        # Updating Category Color
        $Database.Categories[$CategoryIndex].Color = $NewCategoryColor

        # Remove the selected Color of the available Colors List
        RemoveColorFromColorsList($NewCategoryColor)

        # Return the Original Color to the Colors List
        AddColorToColorsList($OriginalCategoryColor)
    }

    # Commit Changes to the Current Profile Database
    $Database | ConvertTo-Json | Out-File $CurrentProfileDatabasePath
    $Database = Get-Content -Path $CurrentProfileDatabasePath | ConvertFrom-Json

    CategoryFormActionExecuted($NewCategoryName, $NewCategoryColor, "MODIFIED")
}

# Function - Collects the necessary data and deletes an existent Category if the information provided by the user is correct
function DeleteCategory {
    # Powershell Window Title - Update
    UpdateWindowTitle("Delete Category")

    # Checking if categories exist
    if (!(CheckForCategories($True))) {
        PressAnyKeyToContinue
        return
    }

    FormHeader("Delete Category")

    # Loop for recolect the Category Index
    while ($True) {
        # Show Categories List
        ListCategoriesWithIndex

        # Read User Input - Category Index
        $CategoryIndex = $(Write-Host "`nSelect the Category you want to Delete: " -ForegroundColor $InputColor -NoNewLine; Read-Host)

        # Cheking if the User Input is a Cancel instruction
        if ($CategoryIndex -eq "exit") {
            return
        }

        # Cheking if the User Input is empty
        if (IsEmpty($CategoryIndex)) {
            ProvidedValueIsEmpty($True, $False)
        }
        else {
            # Cheking if the User Input is an Integer (Correct Format)
            if (IsInteger($CategoryIndex)) {
                $CategoryIndex = [int]$CategoryIndex - 1

                # Cheking if the selected Category Index is inside of the range of available Categories
                if (($CategoryIndex -ge 0) -and ($CategoryIndex -lt $Database.Categories.Length)) {
                    # Cheking if the selected Category has Shortcuts assigned
                    $Shortcuts = CountShortcutsInCategory($Database.Categories[$CategoryIndex].ID)

                    if ($Shortcuts -eq 0) {
                        Write-Host "`nSelected Category: " -ForegroundColor $DefaultColor -NoNewLine
                        Write-Host $Database.Categories[$CategoryIndex].Name -ForegroundColor $Database.Categories[$CategoryIndex].Color
                        break
                    }
                    else {
                        if ($Shortcuts -eq 1) {
                            $ErrorText = "1 Shortcut"
                        }
                        else {
                            $ErrorText = "$Shortcuts Shortcuts"
                        }
                        Write-Host "`nERROR: The Selected Category has" $ErrorText "assigned to it. The Category to Delete must not have any Shortcut assigned to it`n" -ForegroundColor $ErrorColor
                        PressAnyKeyToContinue
                        return
                    }
                }
                else {
                    ItemNotInList("Category", "Categories")
                }
            }
            else {
                DataFormatNotCorrect("Category", "DELETE", $False, $True, $False)
            }
        }
    }

    # Loop for recolect the Delete Confirmation
    while ($True) {
        # Read User Input - Delete Confirmation
        $DeleteConfirmation = $(ActionConfirmation("DELETE", "Category", ""); Read-Host)

        # Cheking User Selected Option
        if ($DeleteConfirmation -eq "y") {
            # Saving the Category Information for later use in the Standard Output and Filtering in the Categories List
            $CategoryID = $Database.Categories[$CategoryIndex].ID
            $CategoryName = $Database.Categories[$CategoryIndex].Name
            $CategoryColor = $Database.Categories[$CategoryIndex].Color

            # Checking if there is only one category available / Deleting the selected Category
            if ($Database.Categories.Length -eq 1) {
                $Database.Categories = @()
                $Database.CategoryID_Index = -1
            }
            elseif ($Database.Categories.Length -eq 2) {
                $CategoriesList = @()
                $CategoriesList += $Database.Categories | Where-Object { $_.ID -ne $CategoryID }
                $Database.Categories = $CategoriesList
            }
            else {
                $Database.Categories = $Database.Categories | Where-Object { $_.ID -ne $CategoryID }
            }

            # Adding the Color of the Deleted Category to the Colors List
            AddColorToColorsList($CategoryColor)

            break
        }
        elseif ($DeleteConfirmation -eq "n") {
            ActionCancelled("DELETE", "Category", "")
            return
        }
        else {
            Write-Host $NotMatchYN -ForegroundColor $ErrorColor
        }
    }

    # Commit Changes to the Current Profile Database
    $Database | ConvertTo-Json | Out-File $CurrentProfileDatabasePath
    $Database = Get-Content -Path $CurrentProfileDatabasePath | ConvertFrom-Json

    CategoryFormActionExecuted($CategoryName, $CategoryColor, "DELETED")
}

# Function - Collects the necessary data and creates a new Shortcut if the information provided by the user is correct
function CreateShortcut {
    # Powershell Window Title - Update
    UpdateWindowTitle("Create Shortcut")

    # Checking if categories exists & Checking if the shortcuts limit has been exceeded or not
    if (!(CheckForCategories($True))) {
        PressAnyKeyToContinue
        return
    }
    elseif ($Database.Shortcuts.Length -ge $ShortcutsLimit) {
        NoSlotsAvailable("Shortcut")
        PressAnyKeyToContinue
        return
    }

    FormHeader("Create Shortcut")

    # Loop for recolect the Shortcut Name
    while ($True) {
        # Read User Input - Shortcut Name
        $ShortcutName = $(Write-Host "`nEnter a Name for the Shortcut: " -ForegroundColor $InputColor -NoNewLine; Read-Host)

        # Cheking if the User Input is a Cancel instruction
        if ($ShortcutName -eq "exit") {
            return
        }

        # Cheking if the User Input is empty or has been exceeded the Character limit
        if (IsEmpty($ShortcutName)) {
            ProvidedValueIsEmpty($True, $False)
        }
        elseif (CharLimitNotExceeded($ShortcutName, $ShortcutNameCharLimit, "Shortcut Name")) {
            break
        }
    }

    # Loop for recolect the Shortcut Path
    while ($True) {
        # Shortcut Types Output
        ListShortcutTypes

        # Read User Input - Shortcut Path
        $ShortcutPath = $(Write-Host "`nEnter the Shortcut Path: " -ForegroundColor $InputColor -NoNewLine; Read-Host)

        # Cheking if the User Input is a Cancel instruction
        if ($ShortcutPath -eq "exit") {
            return
        }

        # Cheking if the User Input is empty
        if (IsEmpty($ShortcutPath)) {
            ProvidedValueIsEmpty($True, $False)
        }
        else {
            $ShortcutType = CheckPathType($ShortcutPath)

            Write-Host "`nDetected Type: " -ForegroundColor $DefaultColor -NoNewLine
            Write-Host $ShortcutType -ForegroundColor $DataColor

            # Path Validation
            if (PathValidation($ShortcutPath)) {
                break
            }
        }
    }

    # Loop for recolect the Category Index
    while ($True) {
        # Show Categories List
        ListCategoriesWithIndex

        # Read User Input - Category Index
        $CategoryIndex = $(Write-Host "`nSelect the Category you want to Link the Shortcut to: " -ForegroundColor $InputColor -NoNewLine; Read-Host)

        # Cheking if the User Input is a Cancel instruction
        if ($CategoryIndex -eq "exit") {
            return
        }

        # Cheking if the User Input is empty
        if (IsEmpty($CategoryIndex)) {
            ProvidedValueIsEmpty($True, $False)
        }
        else {
            # Cheking if the User Input is an Integer (Correct Format)
            if (IsInteger($CategoryIndex)) {
                $CategoryIndex = [int]$CategoryIndex - 1

                # Cheking if the selected Category Index is inside of the range of available Categories
                if (($CategoryIndex -ge 0) -and ($CategoryIndex -lt $Database.Categories.Length)) {
                    $ShortcutCategoryID = $Database.Categories[$CategoryIndex].ID
                    break
                }
                else {
                    ItemNotInList("Category", "Categories")
                }
            }
            else {
                DataFormatNotCorrect("Category", "LINK the Shortcut to", $False, $True, $False)
            }
        }
    }

    # Assigning ID for the new Shortcut
    $ShortcutID = $Database.ShortcutID_Index + 1

    # Creating the new 'Shortcut Object'
    $NewShortcut = @{}
    $NewShortcut.Add("ID", $ShortcutID)
    $NewShortcut.Add("Name", $ShortcutName)
    $NewShortcut.Add("Path", $ShortcutPath)
    $NewShortcut.Add("CategoryID", $ShortcutCategoryID)

    # Updating Shortcut ID Index value in the Current Profile Database
    $Database.ShortcutID_Index = $ShortcutID

    # Adding the 'Shortcut Object' to the Current Profile Database
    $Database.Shortcuts += $NewShortcut

    # Sorting the Shortcuts in case there is more than 1 Shortcut in the Current Profile Database
    if ($Database.Shortcuts.Length -gt 1) {
        $Database.Shortcuts = SortShortcuts($Database.Shortcuts)
    }

    # Commit Changes to the Current Profile Database
    $Database | ConvertTo-Json | Out-File $CurrentProfileDatabasePath
    $Database = Get-Content -Path $CurrentProfileDatabasePath | ConvertFrom-Json

    $CategoryIndex = GetCategoryIndex($ShortcutCategoryID)

    ShortcutFormActionExecuted($ShortcutName, $Database.Categories[$CategoryIndex].Color, $Database.Categories[$CategoryIndex].Name, $ShortcutPath, "CREATED")
}

# Function - Collects the necessary data and modifies an existent Shortcut if the information provided by the user is correct
function ModifyShortcut {
    # Powershell Window Title - Update
    UpdateWindowTitle("Modify Shortcut")

    # Checking if shortcuts exist
    if (!(CheckForShortcuts($True))) {
        PressAnyKeyToContinue
        return
    }

    FormHeader("Modify Shortcut")

    # Loop for recolect the Shortcut Index
    while ($True) {
        # Show Shortcuts List
        ListShortcutsWithIndex($False)

        # Read User Input - Shortcut Index
        $ShortcutIndex = $(Write-Host "`nSelect the Shortcut you want to Modify: " -ForegroundColor $InputColor -NoNewLine; Read-Host)

        # Cheking if the User Input is a Cancel instruction
        if ($ShortcutIndex -eq "exit") {
            return
        }

        # Cheking if the User Input is empty
        if (IsEmpty($ShortcutIndex)) {
            ProvidedValueIsEmpty($True, $False)
        }
        else {
            # Cheking if the User Input is an Integer (Correct Format)
            if (IsInteger($ShortcutIndex)) {
                $ShortcutIndex = [int]$ShortcutIndex - 1

                # Cheking if the selected Shortcut Index is inside of the range of available Shortcuts
                if (($ShortcutIndex -ge 0) -and ($ShortcutIndex -lt $Database.Shortcuts.Length)) {
                    $Modified = $False
                    $OriginalShortcutName = $Database.Shortcuts[$ShortcutIndex].Name
                    $OriginalShortcutPath = $Database.Shortcuts[$ShortcutIndex].Path
                    $OriginalCategoryID = $Database.Shortcuts[$ShortcutIndex].CategoryID
                    $OriginalCategoryIndex = GetCategoryIndex($OriginalCategoryID)
                    $OriginalCategoryName = $Database.Categories[$OriginalCategoryIndex].Name
                    $OriginalCategoryColor = $Database.Categories[$OriginalCategoryIndex].Color

                    Write-Host "`nSelected Shortcut: " -ForegroundColor $DefaultColor -NoNewLine
                    Write-Host "$($OriginalCategoryName): $OriginalShortcutName" -ForegroundColor $OriginalCategoryColor -NoNewLine
                    Write-Host " | Path: " -ForegroundColor $DefaultColor -NoNewLine
                    Write-Host $OriginalShortcutPath -ForegroundColor $OriginalCategoryColor
                    Write-Host $PressEnterToRemainCurrentValue -ForegroundColor $InfoColor
                    break
                }
                else {
                    ItemNotInList("Shortcut", "Shortcuts")
                }
            }
            else {
                DataFormatNotCorrect("Shortcut", "SELECT", $False, $True, $False)
            }
        }
    }

    # Loop for recolect the New Shortcut Name
    while ($True) {
        # Read User Input - New Shortcut Name
        $NewShortcutName = $(Write-Host "`nEnter a New Name for the selected Shortcut: " -ForegroundColor $InputColor -NoNewLine; Read-Host)

        # Cheking if the User Input is a Cancel instruction
        if ($NewShortcutName -eq "exit") {
            return
        }

        # Cheking if the New Name is equal to the previous Name
        if ($NewShortcutName -ceq $OriginalShortcutName) {
            Write-Host "`nThe 'New Name' field is equal to the current Name of the selected Shortcut. The Shortcut Name will remain the same: " -ForegroundColor $DefaultColor -NoNewLine
            Write-Host $OriginalShortcutName -ForegroundColor $OriginalCategoryColor
            $NewShortcutName = $OriginalShortcutName
            break
        }
        else {
            # Cheking if the User Input is empty or has been exceeded the Character limit
            if (IsEmpty($NewShortcutName)) {
                Write-Host "`nThe 'New Name' field is empty. The Shortcut Name will remain the same: " -ForegroundColor $DefaultColor -NoNewLine
                Write-Host $OriginalShortcutName -ForegroundColor $OriginalCategoryColor
                $NewShortcutName = $OriginalShortcutName
                break
            }
            elseif (CharLimitNotExceeded($NewShortcutName, $ShortcutNameCharLimit, "Shortcut Name")) {
                $Modified = $True
                break
            }
        }
    }

    # Loop for recolect the New Shortcut Path
    while ($True) {
        # Shortcut Types Output
        ListShortcutTypes

        # Read User Input - New Shortcut Path
        $NewShortcutPath = $(Write-Host "`nEnter the New Shortcut Path: " -ForegroundColor $InputColor -NoNewLine; Read-Host)

        # Cheking if the User Input is a Cancel instruction
        if ($NewShortcutPath -eq "exit") {
            return
        }

        # Cheking if the New Path is equal to the previous Path
        if ($NewShortcutPath -ceq $OriginalShortcutPath) {
            Write-Host "`nThe 'New Path' field is equal to the current Path of the selected Shortcut. The Shortcut Path will remain the same: " -ForegroundColor $DefaultColor -NoNewLine
            Write-Host $OriginalShortcutPath -ForegroundColor $OriginalCategoryColor
            $NewShortcutPath = $OriginalShortcutPath
            break
        }
        else {
            # Cheking if the User Input is empty
            if (IsEmpty($NewShortcutPath)) {
                Write-Host "`nThe 'New Path' field is empty. The Shortcut Path will remain the same: " -ForegroundColor $DefaultColor -NoNewLine
                Write-Host $OriginalShortcutPath -ForegroundColor $OriginalCategoryColor
                $NewShortcutPath = $OriginalShortcutPath
                break
            }
            else {
                $NewShortcutType = CheckPathType($NewShortcutPath)

                Write-Host "`nDetected Type: " -ForegroundColor $DefaultColor -NoNewLine
                Write-Host $NewShortcutType -ForegroundColor $DataColor

                # Path Validation
                if (PathValidation($NewShortcutPath)) {
                    $Modified = $True
                    break
                }
            }
        }
    }

    # Loop for recolect the New Category Index
    while ($True) {
        # Show Categories List
        ListCategoriesWithIndex

        # Read User Input - New Category Index
        $NewCategoryIndex = $(Write-Host "`nSelect the New Category you want to Link the Shortcut to: " -ForegroundColor $InputColor -NoNewLine; Read-Host)

        # Cheking if the User Input is a Cancel instruction
        if ($NewCategoryIndex -eq "exit") {
            return
        }

        # Cheking if the User Input is empty
        if (IsEmpty($NewCategoryIndex)) {
            Write-Host "`nThe 'New Category' field is empty. The Shortcut Category will remain the same: " -ForegroundColor $DefaultColor -NoNewLine
            Write-Host $OriginalCategoryName -ForegroundColor $OriginalCategoryColor
            $NewCategoryID = $OriginalCategoryID
            $NewCategoryIndex = $OriginalCategoryIndex
            break
        }
        else {
            # Cheking if the User Input is an Integer (Correct Format)
            if (IsInteger($NewCategoryIndex)) {
                $NewCategoryIndex = [int]$NewCategoryIndex - 1

                # Cheking if the selected Category Index is inside of the range of available Categories
                if (($NewCategoryIndex -ge 0) -and ($NewCategoryIndex -lt $Database.Categories.Length)) {
                    if ($NewCategoryIndex -eq $OriginalCategoryIndex) {
                        Write-Host "`nThe Selected Category is already the current Category for the Selected Shortcut. The Shortcut Category will remain the same: " -ForegroundColor $DefaultColor -NoNewLine
                        Write-Host $OriginalCategoryName -ForegroundColor $OriginalCategoryColor
                        $NewCategoryID = $OriginalCategoryID
                        $NewCategoryIndex = $OriginalCategoryIndex
                        break
                    }
                    else {
                        $NewCategoryID = $Database.Categories[$NewCategoryIndex].ID
                        $Modified = $True
                        break
                    }
                }
                else {
                    ItemNotInList("Category", "Categories")
                }
            }
            else {
                DataFormatNotCorrect("Category", "LINK the Shortcut to", $False, $True, $False)
            }
        }
    }

    # Cheking if any field has been modified
    if (!$Modified) {
        NoChangesDetected("Shortcut")
        return
    }
    else {
        # Updating Shortcut Values
        $Database.Shortcuts[$ShortcutIndex].Name = $NewShortcutName
        $Database.Shortcuts[$ShortcutIndex].Path = $NewShortcutPath
        $Database.Shortcuts[$ShortcutIndex].CategoryID = $NewCategoryID

        # Checking if there is more than one shortcut available
        if ($Database.Shortcuts.Length -gt 1) {
            # Sorting the Shortcuts List
            $Database.Shortcuts = SortShortcuts($Database.Shortcuts)
        }

        # Commit Changes to the Current Profile Database
        $Database | ConvertTo-Json | Out-File $CurrentProfileDatabasePath
        $Database = Get-Content -Path $CurrentProfileDatabasePath | ConvertFrom-Json

        ShortcutFormActionExecuted($NewShortcutName, $Database.Categories[$NewCategoryIndex].Color, $Database.Categories[$NewCategoryIndex].Name, $NewShortcutPath, "MODIFIED")
    }
}

# Function - Collects the necessary data and deletes an existent Shortcut if the information provided by the user is correct
function DeleteShortcut {
    # Powershell Window Title - Update
    UpdateWindowTitle("Delete Shortcut")

    # Checking if shortcuts exists
    if (!(CheckForShortcuts($True))) {
        PressAnyKeyToContinue
        return
    }

    FormHeader("Delete Shortcut")

    # Loop for recolect the Shortcut Index
    while ($True) {
        # Show Shortcuts List
        ListShortcutsWithIndex($False)

        # Read User Input - Shortcut Index
        $ShortcutIndex = $(Write-Host "`nSelect the Shortcut you want to Delete: " -ForegroundColor $InputColor -NoNewLine; Read-Host)

        # Cheking if the User Input is a Cancel instruction
        if ($ShortcutIndex -eq "exit") {
            return
        }

        # Cheking if the User Input is empty
        if (IsEmpty($ShortcutIndex)) {
            ProvidedValueIsEmpty($True, $False)
        }
        else {
            # Cheking if the User Input is an Integer (Correct Format)
            if (IsInteger($ShortcutIndex)) {
                $ShortcutIndex = [int]$ShortcutIndex - 1

                # Cheking if the selected Shortcut Index is inside of the range of available Shortcuts
                if (($ShortcutIndex -ge 0) -and ($ShortcutIndex -lt $Database.Shortcuts.Length)) {
                    $CategoryIndex = GetCategoryIndex($Database.Shortcuts[$ShortcutIndex].CategoryID)
                    $CategoryName = $Database.Categories[$CategoryIndex].Name
                    $CategoryColor = $Database.Categories[$CategoryIndex].Color

                    Write-Host "`nSelected Shortcut: " -ForegroundColor $DefaultColor -NoNewLine
                    Write-Host $CategoryName -ForegroundColor $CategoryColor
                    break
                }
                else {
                    ItemNotInList("Shortcut", "Shortcuts")
                }
            }
            else {
                DataFormatNotCorrect("Shortcut", "DELETE", $False, $True, $False)
            }
        }
    }

    # Loop for recolect the Delete Confirmation
    while ($True) {
        # Read User Input - Delete Confirmation
        $DeleteConfirmation = $(ActionConfirmation("DELETE", "Shortcut", ""); Read-Host)

        # Cheking User Selected Option
        if ($DeleteConfirmation -eq "y") {
            # Saving the Shortcut Information for later use in the Standard Output and Filtering in the Shortcuts List
            $ShortcutID = $Database.Shortcuts[$ShortcutIndex].ID
            $ShortcutName = $Database.Shortcuts[$ShortcutIndex].Name
            $ShortcutPath = $Database.Shortcuts[$ShortcutIndex].Path

            # Checking if there is only one shortcut available
            if ($Database.Shortcuts.Length -eq 1) {
                $Database.Shortcuts = @()
                $Database.ShortcutID_Index = -1
            }
            elseif ($Database.Shortcuts.Length -eq 2) {
                $ShortcutsList = @()
                $ShortcutsList += $Database.Shortcuts | Where-Object { $_.ID -ne $ShortcutID }
                $Database.Shortcuts = $ShortcutsList
            }
            else {
                $Database.Shortcuts = $Database.Shortcuts | Where-Object { $_.ID -ne $ShortcutID }
            }
            break
        }
        elseif ($DeleteConfirmation -eq "n") {
            ActionCancelled("DELETE", "Shortcut", "")
            return
        }
        else {
            Write-Host $NotMatchYN -ForegroundColor $ErrorColor
        }
    }

    # Commit Changes to the Current Profile Database
    $Database | ConvertTo-Json | Out-File $CurrentProfileDatabasePath
    $Database = Get-Content -Path $CurrentProfileDatabasePath | ConvertFrom-Json

    ShortcutFormActionExecuted($ShortcutName, $CategoryColor, $CategoryName, $ShortcutPath, "DELETED")
}

# Function - Creates a Backup of the current state of the active Profile Database (Backups relative Path: ".\Profiles\'Profile Name'\Backups")
function CreateBackup {
    # Checking if the backups limit has been exceeded or not
    if ($(GetNumberOfBackups) -ge $BackupsLimit) {
        # Powershell Window Title - Update
        UpdateWindowTitle("Create Backup")

        NoSlotsAvailable("Backup")
        PressAnyKeyToContinue
        return
    }

    # Powershell Window Title - Update
    UpdateWindowTitle("Creating Backup...")

    # Backup Name & Timestamp
    $BackupName = Get-Date -Format "yyy-MM-dd_HH-mm-ss_Backup"
    $BackupDate = Get-Date -Format "yyy/MM/dd HH:mm:ss"

    # Backup (Creates a Copy of the current Database File)
    Copy-Item $CurrentProfileDatabasePath -Destination "$CurrentProfileBackupsPath\$BackupName.json"

    # Progress Bar (1 Second Timeout)
    ShowProgressBar("50", "20", "DarkCyan", "`nCreating Backup with Timestamp: $BackupDate...`n", $ProcessColor)

    UpdateWindowTitle("Backup Created")
    BackupFormActionExecuted($BackupName, "CREATED", $False)
    PressAnyKeyToContinue
}

# Function - Deletes a Backup selected by the user from the Available Backups List (Each Profile has its own backups)
function DeleteBackup {
    # Powershell Window Title - Update
    UpdateWindowTitle("Delete Backup")

    $NumberOfBackups = GetNumberOfBackups

    # Checking if backups exists
    if ($NumberOfBackups -eq 0) {
        NoItemsCreated("Backups", $ErrorColor, $True, $True, $True)
        PressAnyKeyToContinue
        return
    }

    FormHeader("Delete Backup")

    $BackupsList = Get-ChildItem -Name -Path $CurrentProfileBackupsPath | Where-Object { $_ -match $BackupFileNameRegExPattern }

    # Loop for recolect the Backup Index
    while ($True) {
        # Show Backups List
        ListBackupsWithIndex

        # Read User Input - Backup Index
        $BackupIndex = $(Write-Host "`nSelect the Backup you want to Delete: " -ForegroundColor $InputColor -NoNewLine; Read-Host)

        # Cheking if the User Input is a Cancel instruction
        if ($BackupIndex -eq "exit") {
            return
        }

        # Cheking if the User Input is empty
        if (IsEmpty($BackupIndex)) {
            ProvidedValueIsEmpty($True, $False)
        }
        else {
            # Cheking if the User Input is an Integer (Correct Format)
            if (IsInteger($BackupIndex)) {
                $BackupIndex = [int]$BackupIndex - 1

                # Cheking if the selected Backup Index is inside of the range of available Backups
                if (($BackupIndex -ge 0) -and ($BackupIndex -lt $NumberOfBackups)) {
                    break
                }
                else {
                    ItemNotInList("Backup", "Backups")
                }
            }
            else {
                DataFormatNotCorrect("Backup", "DELETE", $False, $True, $False)
            }
        }
    }

    # Loop for recolect the Delete Confirmation
    while ($True) {
        # Read User Input - Delete Confirmation
        $DeleteConfirmation = $(ActionConfirmation("DELETE", "Backup", ""); Read-Host)

        # Cheking User Selected Option
        if ($DeleteConfirmation -eq "y") {
            # Cheking if there is only one Backup available
            if ($BackupsList.GetType().Name -eq "String") {
                $BackupName = $BackupsList.Substring(0, 26)
                Remove-Item "$CurrentProfileBackupsPath\$BackupsList"
            }
            else {
                $BackupName = $BackupsList[$BackupIndex].Substring(0, 26)
                Remove-Item "$CurrentProfileBackupsPath\$($BackupsList[$BackupIndex])"
            }
            break
        }
        elseif ($DeleteConfirmation -eq "n") {
            ActionCancelled("DELETE", "Backup", "")
            return
        }
        else {
            Write-Host $NotMatchYN -ForegroundColor $ErrorColor
        }
    }

    BackupFormActionExecuted($BackupName, "DELETED", $True)
    PressAnyKeyToContinue
}

# Function - Restores a Backup selected by the user from the Available Backups List (Each Profile has its own backups)
function RestoreBackup {
    # Powershell Window Title - Update
    UpdateWindowTitle("Restore Backup")

    $NumberOfBackups = GetNumberOfBackups

    # Checking if backups exists
    if ($NumberOfBackups -eq 0) {
        NoItemsCreated("Backups", $ErrorColor, $True, $True, $True)
        PressAnyKeyToContinue
        return
    }

    FormHeader("Restore Backup")

    $BackupsList = Get-ChildItem -Name -Path $CurrentProfileBackupsPath | Where-Object { $_ -match $BackupFileNameRegExPattern }

    # Loop for recolect the Backup Index
    while ($True) {
        # Show Backups List
        ListBackupsWithIndex

        # Read User Input - Backup Index
        $BackupIndex = $(Write-Host "`nSelect the Backup you want to Restore: " -ForegroundColor $InputColor -NoNewLine; Read-Host)

        # Cheking if the User Input is a Cancel instruction
        if ($BackupIndex -eq "exit") {
            return
        }

        # Cheking if the User Input is empty
        if (IsEmpty($BackupIndex)) {
            ProvidedValueIsEmpty($True, $False)
        }
        else {
            # Cheking if the User Input is an Integer (Correct Format)
            if (IsInteger($BackupIndex)) {
                $BackupIndex = [int]$BackupIndex - 1

                # Cheking if the selected Backup Index is inside of the range of available Backups
                if (($BackupIndex -ge 0) -and ($BackupIndex -lt $NumberOfBackups)) {
                    break
                }
                else {
                    ItemNotInList("Backup", "Backups")
                }
            }
            else {
                DataFormatNotCorrect("Backup", "RESTORE", $False, $True, $False)
            }
        }
    }

    # Loop for recolect the Restore Confirmation
    while ($True) {
        # Read User Input - Restore Confirmation
        $RestoreConfirmation = $(ActionConfirmation("RESTORE", "Backup", ""); Read-Host)

        # Cheking User Selected Option
        if ($RestoreConfirmation -eq "y") {
            # Checking if there is only one backup available
            if ($BackupsList.GetType().Name -eq "String") {
                $BackupName = $BackupsList.Substring(0, 26)
                Copy-Item "$CurrentProfileBackupsPath\$BackupsList" -Destination $CurrentProfileDatabasePath
            }
            else {
                $BackupName = $BackupsList[$BackupIndex].Substring(0, 26)
                Copy-Item "$CurrentProfileBackupsPath\$($BackupsList[$BackupIndex])" -Destination $CurrentProfileDatabasePath
            }
            break
        }
        elseif ($RestoreConfirmation -eq "n") {
            ActionCancelled("RESTORE", "", "")
            return
        }
        else {
            Write-Host $NotMatchYN -ForegroundColor $ErrorColor
        }
    }
    BackupFormActionExecuted($BackupName, "RESTORED", $True)
    RestartAfterPressingAnyKey
}

# Function - Deletes the database of the active Profile (This action deletes all the Categories and Shortcuts of the active Profile)
function EraseDatabase {
    # Powershell Window Title - Update
    UpdateWindowTitle("Erase Database")

    Write-Host "`nINFO: This action will DELETE all the Categories and Shortcuts of the current Profile" -ForegroundColor $InfoColor

    # Loop for recolect the Erase Confirmation
    while ($True) {
        # Read User Input - Erase Confirmation
        $EraseConfirmation = $(Write-Host "`nWARNING: Are you sure you want to ERASE the current Profile Database? ($($CurrentProfileName)) [Y/N]: " -ForegroundColor $WarningColor -NoNewLine; Read-Host)

        # Cheking User Selected Option
        if ($EraseConfirmation -eq "y") {
            Remove-Item $CurrentProfileDatabasePath -Force -Recurse -Confirm:$False

            Write-Host "`nThe Database of the Profile " -ForegroundColor $DefaultColor -NoNewLine
            Write-Host $CurrentProfileName -ForegroundColor $SuccessColor -NoNewLine
            Write-Host " has been" -ForegroundColor $DefaultColor -NoNewLine
            Write-Host " ERASED" -ForegroundColor $SuccessColor -NoNewLine
            Write-Host " successfully`n" -ForegroundColor $DefaultColor
            RestartAfterPressingAnyKey
        }
        elseif ($EraseConfirmation -eq "n") {
            ActionCancelled("ERASE", "", "")
            break
        }
        else {
            Write-Host $NotMatchYN -ForegroundColor $ErrorColor
        }
    }
}

# Function - Deletes all the Program Generated Files (Profiles with their respective Categories, Shortcuts and Backups)
function FactoryReset {
    # Powershell Window Title - Update
    UpdateWindowTitle("Factory Reset")

    Write-Host "`nINFO: This action will DELETE all the Profiles with their respective Categories, Shortcuts and Backups" -ForegroundColor $InfoColor

    # Loop for recolect the Factory Reset Confirmation
    while ($True) {
        # Read User Input - Factory Reset Confirmation
        $FactoryResetConfirmation = $(Write-Host "`nWARNING: Are you sure you want to EXECUTE a FACTORY RESET instruction? [Y/N]: " -ForegroundColor $WarningColor -NoNewLine; Read-Host)

        # Cheking User Selected Option
        if ($FactoryResetConfirmation -eq "y") {
            # Deleting all the Program Generated Files (Profiles with their respective Categories, Shortcuts and Backups)
            Remove-Item $ProfilesPath -Force -Recurse -Confirm:$False
            Remove-Item $ProfilesDatabasePath -Force -Recurse -Confirm:$False

            Write-Host "`nFACTORY RESET" -ForegroundColor $SuccessColor -NoNewLine
            Write-Host " instruction" -ForegroundColor $DefaultColor -NoNewLine
            Write-Host " EXECUTED" -ForegroundColor $SuccessColor -NoNewLine
            Write-Host " successfully`n" -ForegroundColor $DefaultColor
            RestartAfterPressingAnyKey
        }
        elseif ($FactoryResetConfirmation -eq "n") {
            ActionCancelled("FACTORY RESET", "", "")
            break
        }
        else {
            Write-Host $NotMatchYN -ForegroundColor $ErrorColor
        }
    }
}

# Function - Opens the Default Browser of the Operating System with the GitHub Repository Page of this Program
function GitHubRepository {
    # Powershell Window Title - Update
    UpdateWindowTitle("GitHub Repository")

    OpenPage($GitHubRepositoryURL, "GitHub Repository")
}

# Function - Opens the Default Browser of the Operating System with the GitHub Repository Releases Page of this Program
function CheckNewUpdates {
    # Powershell Window Title - Update
    UpdateWindowTitle("Check New Updates")

    OpenPage($GitHubReleasesURL, "GitHub Releases")
}

# Function - Shows in the Standard Output the Credits and Program About Data + GitHub Links
function AboutAndCredits {
    # Powershell Window Title - Update
    UpdateWindowTitle("About & Credits")

    # Startup Information Output (Creadits & Program Related Data)
    Startup

    # GitHub Information Output (Links)
    Write-Host "`nGitHub Repository: " -ForegroundColor $DefaultColor -NoNewLine
    Write-Host $GitHubRepositoryURL -ForegroundColor $SuccessColor
    Write-Host "GitHub Releases: " -ForegroundColor $DefaultColor -NoNewLine
    Write-Host $GitHubReleasesURL"`n" -ForegroundColor $SuccessColor

    PressAnyKeyToContinue
}

# Function - Changes the active profile specified by the user
function ChangeProfile {
    # Powershell Window Title - Update
    UpdateWindowTitle("Change Profile")

    # Checking for more profiles than the current one
    if (OnlyOneProfile) {
        Write-Host "`n$NoMoreProfilesThanTheCurrentOne`n" -ForegroundColor $ErrorColor
        PressAnyKeyToContinue
        return
    }

    FormHeader("Change Profile")

    # Loop for recolect the Profile Index
    while ($True) {
        # Show Profiles List
        ListProfilesWithIndex

        # Read User Input - Profile Index
        $ProfileIndex = $(Write-Host "`nSelect the Profile you want to Change to: " -ForegroundColor $InputColor -NoNewLine; Read-Host)

        # Cheking if the User Input is a Cancel instruction
        if ($ProfileIndex -eq "exit") {
            return
        }

        # Cheking if the User Input is empty
        if (IsEmpty($ProfileIndex)) {
            ProvidedValueIsEmpty($True, $False)
        }
        else {
            # Cheking if the User Input is an Integer (Correct Format)
            if (IsInteger($ProfileIndex)) {
                $ProfileIndex = [int]$ProfileIndex - 1

                # Cheking if the selected Profile Index is inside of the range of available Profiles
                if (($ProfileIndex -ge 0) -and ($ProfileIndex -lt $ProfilesDatabase.Profiles.Length)) {
                    # Cheking if the selected Profile is equal than the current one
                    if ($ProfilesDatabase.Profiles[$ProfileIndex].ID -eq $CurrentProfileID) {
                        Write-Host $SelectedProfileIsTheCurrentActiveProfile -ForegroundColor $ErrorColor
                    }
                    else {
                        $ProfilesDatabase.LastUsedProfile_ID = $ProfilesDatabase.Profiles[$ProfileIndex].ID

                        # Commit Changes to the Profiles Database
                        $ProfilesDatabase | ConvertTo-Json | Out-File $ProfilesDatabasePath
                        $ProfilesDatabase = Get-Content -Path $ProfilesDatabasePath | ConvertFrom-Json

                        Write-Host "`nSelected Profile: " -ForegroundColor $DefaultColor -NoNewLine
                        Write-Host $ProfilesDatabase.Profiles[$ProfileIndex].Name -ForegroundColor $SuccessColor
                        Write-Host "`nINFO: The changes will only be effective after restarting $Name" -ForegroundColor $InfoColor

                        # Loop for recolect the Restart Confirmation
                        while ($True) {
                            # Read User Input - Restart Confirmation
                            $RestartConfirmation = $(Write-Host "`nDo you want to Restart $Name now? [Y/N]: " -ForegroundColor $ProcessColor -NoNewLine; Read-Host)

                            # Cheking User Selected Option
                            if ($RestartConfirmation -eq "y") {
                                Restart
                            }
                            elseif ($RestartConfirmation -eq "n") {
                                ActionCancelled("RESTART", "", "")
                                break
                            }
                            else {
                                Write-Host $NotMatchYN -ForegroundColor $ErrorColor
                            }
                        }
                        break
                    }
                }
                else {
                    ItemNotInList("Profile", "Profiles")
                }
            }
            else {
                DataFormatNotCorrect("Profile", "SELECT", $False, $True, $False)
            }
        }
    }
}

# Function - Creates a new Profile with the data provided by the user
function CreateProfile {
    # Powershell Window Title - Update
    UpdateWindowTitle("Create Profile")

    # Checking if the profiles limit has been exceeded or not
    if ($ProfilesDatabase.Profiles.Length -ge $ProfilesLimit) {
        NoSlotsAvailable("Profile")
        PressAnyKeyToContinue
        return
    }

    FormHeader("Create Profile")

    # Loop for recolect the Profile Name
    while ($True) {
        # Read User Input - Profile Name
        $ProfileName = $(Write-Host "`nEnter a Name for the Profile: " -ForegroundColor $InputColor -NoNewLine; Read-Host)

        # Cheking if the User Input is a Cancel instruction
        if ($ProfileName -eq "exit") {
            return
        }

        # Cheking if the User Input is empty
        if (IsEmpty($ProfileName)) {
            ProvidedValueIsEmpty($True, $False)
        }
        else {
            # Profile Name Validation
            if (CheckProfileName($ProfileName)) {
                # Assigning ID for the New Profile
                $ProfileID = $ProfilesDatabase.ProfileID_Index + 1

                # Assigning the Path for the New Profile
                $ProfilePath = "$ProfilesPath\$ProfileName"

                # Creating Profile Directory
                New-Item -Path $ProfilePath -ItemType "Directory" > $Null

                # Creating the New 'Profile Object'
                $NewProfile = @{}
                $NewProfile.add("ID", $ProfileID)
                $NewProfile.add("Name", $ProfileName)
                $NewProfile.add("Path", $ProfilePath)

                # Updating Profile ID Index value in the Profiles Database
                $ProfilesDatabase.ProfileID_Index = $ProfileID

                # Adding the 'Profile Object' to the Profiles Database
                $ProfilesDatabase.Profiles += $NewProfile

                # Commit Changes to the Profiles Database
                $ProfilesDatabase | ConvertTo-Json | Out-File $ProfilesDatabasePath
                $ProfilesDatabase = Get-Content -Path $ProfilesDatabasePath | ConvertFrom-Json

                ProfileFormActionExecuted($ProfileName, "CREATED")
                PressAnyKeyToContinue
                break
            }
        }
    }
}

# Function - Modifies an existing Profile with the data provided by the user
function ModifyProfile {
    # Powershell Window Title - Update
    UpdateWindowTitle("Modify Profile")

    FormHeader("Modify Profile")

    # Loop for recolect the Profile Index
    while ($True) {
        # Show Profiles List
        ListProfilesWithIndex

        # Read User Input - Profile Index
        $ProfileIndex = $(Write-Host "`nSelect the Profile you want to Modify: " -ForegroundColor $InputColor -NoNewLine; Read-Host)

        # Cheking if the User Input is a Cancel instruction
        if ($ProfileIndex -eq "exit") {
            return
        }

        # Cheking if the User Input is empty
        if (IsEmpty($ProfileIndex)) {
            ProvidedValueIsEmpty($True, $False)
        }
        else {
            # Cheking if the User Input is an Integer (Correct Format)
            if (IsInteger($ProfileIndex)) {
                $ProfileIndex = [int]$ProfileIndex - 1
                $OriginalProfileName = $ProfilesDatabase.Profiles[$ProfileIndex].Name

                # Cheking if the selected Profile Index is inside of the range of available Profiles
                if (($ProfileIndex -ge 0) -and ($ProfileIndex -lt $ProfilesDatabase.Profiles.Length)) {
                    Write-Host "`nSelected Profile: " -ForegroundColor $DefaultColor -NoNewLine
                    Write-Host $OriginalProfileName -ForegroundColor $SuccessColor
                    break
                }
                else {
                    ItemNotInList("Profile", "Profiles")
                }
            }
            else {
                DataFormatNotCorrect("Profile", "SELECT", $False, $True, $False)
            }
        }
    }

    # Loop for recolect the New Profile Name
    while ($True) {
        # Read User Input - New Profile Name
        $NewProfileName = $(Write-Host "`nEnter a New Name for the selected Profile: " -ForegroundColor $InputColor -NoNewLine; Read-Host)

        # Cheking if the User Input is a Cancel instruction
        if ($NewProfileName -eq "exit") {
            return
        }

        # Cheking if the User Input is empty
        if (IsEmpty($NewProfileName)) {
            Write-Host "`nThe 'New Name' field is empty. The Profile Name will remain the same: " -ForegroundColor $DefaultColor -NoNewLine
            Write-Host $OriginalProfileName -ForegroundColor $SuccessColor
            NoChangesDetected("Profile")
            return
        }
        # Cheking if the New Profile Name is equal than the Original Profile Name
        elseif ($NewProfileName -eq $OriginalProfileName) {
            Write-Host "`nThe 'New Name' field is equal to the current Name of the selected Profile. The Profile Name will remain the same: " -ForegroundColor $DefaultColor -NoNewLine
            Write-Host $OriginalProfileName -ForegroundColor $SuccessColor
            NoChangesDetected("Profile")
            return
        }
        else {
            # Profile Name Validation
            if (CheckProfileName($NewProfileName)) {
                # Changing the Name of the Directory of the modified Profile
                Rename-Item -Path $ProfilesDatabase.Profiles[$ProfileIndex].Path -NewName $NewProfileName

                # Updating the values of the selected Profile
                $ProfilesDatabase.Profiles[$ProfileIndex].Name = $NewProfileName
                $ProfilesDatabase.Profiles[$ProfileIndex].Path = "$ProfilesPath\$NewProfileName"

                # Commit Changes to the Profiles Database
                $ProfilesDatabase | ConvertTo-Json | Out-File $ProfilesDatabasePath
                $ProfilesDatabase = Get-Content -Path $ProfilesDatabasePath | ConvertFrom-Json

                ProfileFormActionExecuted($OriginalProfileName, "MODIFIED")

                Write-Host "New Profile name: " -ForegroundColor $DefaultColor -NoNewLine
                Write-Host "$NewProfileName`n" -ForegroundColor $SuccessColor

                # Cheking if the modified Profile is the Current Active Profile
                if ($ProfilesDatabase.Profiles[$ProfileIndex].ID -eq $CurrentProfileID) {
                    RestartAfterPressingAnyKey
                }
                else {
                    PressAnyKeyToContinue
                    break
                }
            }
        }
    }
}

# Function - Deletes a Profile selected by the user
function DeleteProfile {
    # Powershell Window Title - Update
    UpdateWindowTitle("Delete Profile")

    # Cheking if there is only one Profile available
    if (OnlyOneProfile) {
        Write-Host "`n$NoMoreProfilesThanTheCurrentOne. Create another Profile before DELETE the actual one`n" -ForegroundColor $ErrorColor
        PressAnyKeyToContinue
        return
    }

    FormHeader("Delete Profile")

    # Loop for recolect the Profile Index
    while ($True) {
        # Show Profiles List
        ListProfilesWithIndex

        # Read User Input - Profile Index
        $ProfileIndex = $(Write-Host "`nSelect the Profile you want to Delete: " -ForegroundColor $InputColor -NoNewLine; Read-Host)

        # Cheking if the User Input is a Cancel instruction
        if ($ProfileIndex -eq "exit") {
            return
        }

        # Cheking if the User Input is empty
        if (IsEmpty($ProfileIndex)) {
            ProvidedValueIsEmpty($True, $False)
        }
        else {
            # Cheking if the User Input is an Integer (Correct Format)
            if (IsInteger($ProfileIndex)) {
                $ProfileIndex = [int]$ProfileIndex - 1
                $ProfileID = $ProfilesDatabase.Profiles[$ProfileIndex].ID

                # Cheking if the selected Profile Index is inside of the range of available Profiles
                if (($ProfileIndex -ge 0) -and ($ProfileIndex -lt $ProfilesDatabase.Profiles.Length)) {
                    # Cheking if the selected Profile is the current active Profile
                    if ($ProfileID -eq $CurrentProfileID) {
                        Write-Host $SelectedProfileIsTheCurrentActiveProfile -ForegroundColor $ErrorColor
                    }
                    else {
                        $PorfileName = $ProfilesDatabase.Profiles[$ProfileIndex].Name

                        # Loop for recolect the Delete Confirmation
                        while ($True) {
                            # Read User Input - Delete Confirmation
                            $DeleteConfirmation = $(ActionConfirmation("DELETE", "Profile", "($($PorfileName)) "); Read-Host)

                            # Cheking User Selected Option
                            if ($DeleteConfirmation -eq "y") {
                                # Removing the selected Profile Directory
                                Remove-Item $ProfilesDatabase.Profiles[$ProfileIndex].Path -Force -Recurse -Confirm:$False

                                # Removing the selected Profile from the Profiles Database
                                if ($ProfilesDatabase.Profiles.Length -eq 2) {
                                    $ProfilesList = @()
                                    $ProfilesList += $ProfilesDatabase.Profiles | Where-Object { $_.ID -ne $ProfileID }
                                    $ProfilesDatabase.Profiles = $ProfilesList
                                }
                                else {
                                    $ProfilesDatabase.Profiles = $ProfilesDatabase.Profiles | Where-Object { $_.ID -ne $ProfileID }
                                }

                                # Commit Changes to the Profiles Database
                                $ProfilesDatabase | ConvertTo-Json | Out-File $ProfilesDatabasePath
                                $ProfilesDatabase = Get-Content -Path $ProfilesDatabasePath | ConvertFrom-Json

                                ProfileFormActionExecuted($PorfileName, "DELETED")
                                PressAnyKeyToContinue
                                break
                            }
                            elseif ($DeleteConfirmation -eq "n") {
                                ActionCancelled("DELETE", "", $PorfileName)
                                break
                            }
                            else {
                                Write-Host $NotMatchYN -ForegroundColor $ErrorColor
                            }
                        }
                        break
                    }
                }
                else {
                    ItemNotInList("Profile", "Profiles")
                }
            }
            else {
                DataFormatNotCorrect("Profile", "SELECT", $False, $True, $False)
            }
        }
    }
}

# Function - Restart Program (Closes the actual process and Opens a new one in the same Origin [CMD, PowerShell or Windows Terminal] )
function Restart {
    # Powershell Window Title - Update
    UpdateWindowTitle("Restarting...")

    ShowProgressBar(25, 20, $DefaultColor, "`n Restarting $Name $Version`n", $DefaultColor)

    if ($Origin -eq "WT") {
        if (Test-Path -Path ".\START Shortcuts Manager - Windows Terminal.bat") {
            Start-Process ".\START Shortcuts Manager - Windows Terminal.bat"
        }
        else {
            $LauncherFilesNotFound = $True
        }
    }
    elseif ($Origin -eq "CMD") {
        if (Test-Path -Path ".\START Shortcuts Manager - CMD.bat") {
            Start-Process ".\START Shortcuts Manager - CMD.bat"
        }
        else {
            $LauncherFilesNotFound = $True
        }
    }
    else {
        if (Test-Path -Path ".\START Shortcuts Manager - PowerShell.bat") {
            Start-Process ".\START Shortcuts Manager - PowerShell.bat"
        }
        else {
            $LauncherFilesNotFound = $True
        }
    }
    if ($LauncherFilesNotFound) {
        Write-Host "ERROR: The launcher files are not in the $Name directory. Please download the files again and put them in the main folder (where $Name is located)" -ForegroundColor $ErrorColor
        Write-Host "`nDownload Link: " -ForegroundColor $DefaultColor -NoNewLine
        Write-Host "$GitHubReleasesURL`n" -ForegroundColor $SuccessColor
        PressAnyKeyToContinue
    }
    exit
}

# Function - Restarts the program, indicating before that the Restart is necessary to apply the changes
function RestartAfterPressingAnyKey {
    Write-Host "INFO: After pressing any key, $Name will restart to apply the changes`n" -ForegroundColor $InfoColor
    PressAnyKeyToContinue
    Write-Host ""
    Restart
}

# Function - Shows in the Standard Output the next values: Author, Name, Version & Date. Also can show GitHub Repository & Releases URL
function Startup {
    # Program Information Output
    Write-Host "$StartupBorder`n" -ForegroundColor $DefaultColor
    Write-Host "  Author:   $Author" -ForegroundColor $DefaultColor
    Write-Host "  Name:     $Name" -ForegroundColor $DefaultColor
    Write-Host "  Version:  $Version" -ForegroundColor $DefaultColor
    Write-Host "  Date:     $Date`n" -ForegroundColor $DefaultColor
    Write-Host "$StartupBorder" -ForegroundColor $DefaultColor
}

# Function - Shows in the Standard Output the 'Main Menu' with all the user created Shrotcuts (The Launch of the Shortcuts is done in this function)
function MainMenu {
    # loop Execution
    while ($True) {
        # Powershell Window Title - Update
        UpdateWindowTitle("Main Menu")

        # Main Menu Output
        ProfileHeader
        Write-Host "                     MENU`n" -ForegroundColor $DefaultColor
        Write-Host "  System options:" -ForegroundColor $DefaultColor
        Write-Host "  0.-`tClose $Name" -ForegroundColor $DefaultColor
        Write-Host "  1.-`tOpen Profiles Menu" -ForegroundColor $DefaultColor
        Write-Host "  2.-`tOpen Settings Menu" -ForegroundColor $DefaultColor
        Write-Host "  3.-`tClear Screen`n" -ForegroundColor $DefaultColor
        Write-Host "  Shortcuts:" -ForegroundColor $DefaultColor

        # Cheking if Shortcuts have been created or not
        if (!(CheckForShortcuts($False))) {
            NoItemsCreated("Shortcuts", $EmptyColor, $False, $False, $False)
        }
        else {
            ListShortcutsWithIndex($True)
        }

        Write-Host "`n$MenuBorder`n" -ForegroundColor $DefaultColor

        # Errors Output (In case of Errors)
        if ($InvalidOption) {
            ItemNotInMenu($Option, "Main")
            $InvalidOption = $False
        }

        # Selected Shortcut Launch Process
        if ($Selected) {
            # Powershell Window Title - Update
            UpdateWindowTitle("Launching...")

            # Getting the selected Shortcut and Category requiered data
            $ShortcutPath = $Database.Shortcuts[$Option - $ReservedSlots].Path
            $ShortcutType = CheckPathType($ShortcutPath)
            $CategoryName = $Database.Categories[$(GetCategoryIndex($Database.Shortcuts[$Option - $ReservedSlots].CategoryID))].Name

            Start-Sleep -Milliseconds 20

            Write-Host "Cheking the selected Shortcut Type..." -ForegroundColor $ProcessColor
            Write-Host "Detected type: " -ForegroundColor $DefaultColor -NoNewLine
            Write-Host $ShortcutType -ForegroundColor $DataColor

            Start-Sleep -Milliseconds 20

            # Cheking Path Integrity
            if (PathValidation($ShortcutPath)) {
                Start-Sleep -Milliseconds 20

                Write-Host "`nLaunching $($CategoryName): $($Database.Shortcuts[$Option - $ReservedSlots].Name)" -ForegroundColor $ProcessColor

                # Checking the Type of Path and Launching the Shortcut according to its Type
                if ($ShortcutType -eq "RDP") {
                    Start-Process "$ENV:WinDir\System32\mstsc.exe" -ArgumentList "/V:$($ShortcutPath.Substring(4, $ShortcutPath.Length - 4))"
                }
                elseif ($ShortcutType -eq "MAIL") {
                    Start-Process "mailto:$($ShortcutPath.Substring(5, $ShortcutPath.Length - 5))"
                }
                else {
                    Start-Process "$ShortcutPath"
                }

                Write-Host "Shortcut launched successfully`n" -ForegroundColor $SuccessColor
            }
            else {
                Write-Host ""
            }

            # Powershell Window Title - Update
            UpdateWindowTitle("Main Menu")

            $Selected = $False
        }

        # Read User Input
        $Option = $(Write-Host $SelectMenuItem -ForegroundColor $InputColor -NoNewLine; Read-Host)

        # Option Check and Process Execution
        if ($Option -eq "0") {
            UpdateWindowTitle("Closing...")
            ShowProgressBar(25, 20, $DefaultColor, "`n Closing $Name $Version`n", $DefaultColor)
            break
        }
        elseif ($Option -eq "1") {
            ProfilesMenu
        }
        elseif ($Option -eq "2") {
            SettingsMenu
        }
        elseif ($Option -eq "3") {
            Clear-Host
        }
        elseif (IsEmpty($Option)) {
            $InvalidOption = $True
        }
        elseif (IsInteger($Option)) {
            if (([int]$Option -ge $ReservedSlots) -and ([int]$Option -lt $Database.Shortcuts.Length + $ReservedSlots)) {
                $Selected = $True
            }
            else {
                $InvalidOption = $True
            }
        }
        else {
            $InvalidOption = $True
        }
        Clear-Host
    }
}

# Function - Shows in the Standard Output the 'Settings Menu' (Includes all function calls for each Setting Option)
function SettingsMenu {
    Clear-Host

    # loop Execution
    while ($True) {
        # Powershell Window Title - Update
        UpdateWindowTitle("Settings Menu")

        # Settings Menu Output
        ProfileHeader
        Write-Host "                   SETTINGS`n" -ForegroundColor $DefaultColor
        SettingOption("0", $DefaultColor, "Close Settings")
        SettingOption("1", $SuccessColor, "List Categories")
        SettingOption("2", $SuccessColor, "Create Category")
        SettingOption("3", $SuccessColor, "Modify Category")
        SettingOption("4", $SuccessColor, "Delete Category")
        SettingOption("5", $DataColor, "List Shortcuts")
        SettingOption("6", $DataColor, "Create Shortcut")
        SettingOption("7", $DataColor, "Modify Shortcut")
        SettingOption("8", $DataColor, "Delete Shortcut")
        SettingOption("9", $InfoColor, "List Backups")
        SettingOption("10", $InfoColor, "Create Backup")
        SettingOption("11", $InfoColor, "Delete Backup")
        SettingOption("12", $InfoColor, "Restore Backup")
        SettingOption("13", $WarningColor, "Erase Database")
        SettingOption("14", $WarningColor, "Factory Reset")
        SettingOption("15", $InputColor, "Restart Program")
        SettingOption("16", $InputColor, "GitHub Repository")
        SettingOption("17", $InputColor, "Check New Updates")
        SettingOption("18", $InputColor, "About & Credits")
        Write-Host "`n$MenuBorder`n" -ForegroundColor $DefaultColor

        if ($InvalidOption) {
            ItemNotInMenu($Option, "Settings")
            $InvalidOption = $False
        }

        # Read User Input
        $Option = $(Write-Host $SelectMenuItem -ForegroundColor $InputColor -NoNewLine; Read-Host)

        if ($Option -eq "15") {
            Restart
        }
        else {
            Clear-Host
        }

        # Checking the option selected by the user and calling the corresponding function based on the selected option
        if ($Option -eq "0") {
            break
        }
        elseif ($Option -eq "1") {
            ListCategories
        }
        elseif ($Option -eq "2") {
            CreateCategory
        }
        elseif ($Option -eq "3") {
            ModifyCategory
        }
        elseif ($Option -eq "4") {
            DeleteCategory
        }
        elseif ($Option -eq "5") {
            ListShortcuts
        }
        elseif ($Option -eq "6") {
            CreateShortcut
        }
        elseif ($Option -eq "7") {
            ModifyShortcut
        }
        elseif ($Option -eq "8") {
            DeleteShortcut
        }
        elseif ($Option -eq "9") {
            ListBackups
        }
        elseif ($Option -eq "10") {
            CreateBackup
        }
        elseif ($Option -eq "11") {
            DeleteBackup
        }
        elseif ($Option -eq "12") {
            RestoreBackup
        }
        elseif ($Option -eq "13") {
            EraseDatabase
        }
        elseif ($Option -eq "14") {
            FactoryReset
        }
        elseif ($Option -eq "16") {
            GitHubRepository
        }
        elseif ($Option -eq "17") {
            CheckNewUpdates
        }
        elseif ($Option -eq "18") {
            AboutAndCredits
        }
        else {
            $InvalidOption = $True
        }
        Clear-Host
    }
}

# Function - Shows in the Standard Output the 'Profiles Menu' (Includes all function calls for each Profile Option)
function ProfilesMenu {
    # loop Execution
    while ($True) {
        Clear-Host

        # Powershell Window Title - Update
        UpdateWindowTitle("Profiles Menu")

        # Profile Settings Menu Output
        ProfileHeader
        Write-Host "                   PROFILES`n" -ForegroundColor $DefaultColor
        Write-Host "  0.-`tClose Settings" -ForegroundColor $DefaultColor
        Write-Host "  1.-`tList Profiles" -ForegroundColor $DefaultColor
        Write-Host "  2.-`tChange Profile" -ForegroundColor $DefaultColor
        Write-Host "  3.-`tCreate Profile" -ForegroundColor $DefaultColor
        Write-Host "  4.-`tModify Profile" -ForegroundColor $DefaultColor
        Write-Host "  5.-`tDelete Profile" -ForegroundColor $DefaultColor
        Write-Host "`n$MenuBorder`n" -ForegroundColor $DefaultColor

        if ($InvalidOption) {
            ItemNotInMenu($Option, "Profiles")
            $InvalidOption = $False
        }

        # Read User Input
        $Option = $(Write-Host $SelectMenuItem -ForegroundColor $InputColor -NoNewLine; Read-Host)

        Clear-Host

        # Checking the option selected by the user and calling the corresponding function based on the selected option
        if ($Option -eq "0") {
            break
        }
        elseif ($Option -eq "1") {
            ListProfiles
        }
        elseif ($Option -eq "2") {
            ChangeProfile
        }
        elseif ($Option -eq "3") {
            CreateProfile
        }
        elseif ($Option -eq "4") {
            ModifyProfile
        }
        elseif ($Option -eq "5") {
            DeleteProfile
        }
        else {
            $InvalidOption = $True
        }
        Clear-Host
    }
}

# Showing the Startup Output + Loading Progress Bar
Startup
UpdateWindowTitle("Loading...")
ShowProgressBar(26, 10, $DefaultColor, "`n Loading $Name $Version`n", $DefaultColor)

# Profiles Directory Path & Profiles Database Path
$ProfilesPath = ".\Profiles"
$ProfilesDatabasePath = ".\Profiles.json"

# Cheking if the file 'Profiles.json' and the Profiles Directory exists and creating it if it does not exist
if (!(Test-Path -Path $ProfilesDatabasePath)) {
    # Powershell Window Title - Update
    UpdateWindowTitle("Create Profile")

    Write-Host "No Profiles detected. Creating a new Profile..." -ForegroundColor $DefaultColor
    if (Test-Path -Path $ProfilesPath) {
        Remove-Item $ProfilesPath -Force -Recurse -Confirm:$False
    }

    # Creating Profiles Database
    $Profiles = New-Object System.Collections.ArrayList
    $ProfilesDatabase = @{}
    $ProfilesDatabase.add("Profiles", $Profiles)
    $ProfilesDatabase.add("ProfileID_Index", 0)
    $ProfilesDatabase.Add("LastUsedProfile_ID", 0)

    # Loop for recolect the Default Profile Name
    while ($True) {
        # Read User Input - Default Profile Name
        $DefaultProfileName = $(Write-Host "`nEnter a Name for your Profile: " -ForegroundColor $InputColor -NoNewLine; Read-Host)

        # Profile Name Validation
        if (CheckProfileName($DefaultProfileName)) {
            break
        }
    }

    # Creating the Default Profile Directory (Backups Directory included)
    Write-Host "`nCreating '$DefaultProfileName' Profile..." -ForegroundColor $InputColor
    New-Item -Path "$ProfilesPath\$DefaultProfileName\Backups" -ItemType "Directory" > $Null

    # Creating the 'Default Profile' Object
    $DefaultProfile = @{}
    $DefaultProfile.add("ID", 0)
    $DefaultProfile.add("Name", $DefaultProfileName)
    $DefaultProfile.add("Path", "$ProfilesPath\$DefaultProfileName")

    # Saving the Default Profile in the Profiles Database
    $ProfilesDatabase.Profiles += $DefaultProfile

    # Commit Changes to the Profiles Database
    $ProfilesDatabase | ConvertTo-Json | Out-File $ProfilesDatabasePath
    $ProfilesDatabase = Get-Content -Path $ProfilesDatabasePath | ConvertFrom-Json

    # Loading Current Profile
    $CurrentProfileID = $ProfilesDatabase.LastUsedProfile_ID
    $CurrentProfileName = $ProfilesDatabase.Profiles[$(GetProfileIndex($CurrentProfileID))].Name
    $CurrentProfilePath = $ProfilesDatabase.Profiles[$(GetProfileIndex($CurrentProfileID))].Path
    $CurrentProfileBackupsPath = "$CurrentProfilePath\Backups"

    Write-Host "Profile created successfully" -ForegroundColor $SuccessColor
    ShowCurrentProfileName
}
else {
    Write-Host "Loading Profiles..." -ForegroundColor $InputColor

    # Getting Profiles saved in the 'Profiles.json' file
    $ProfilesDatabase = Get-Content -Path $ProfilesDatabasePath | ConvertFrom-Json

    # Getting the Current Profile Data (Using Last Used Profile ID)
    $CurrentProfileID = $ProfilesDatabase.LastUsedProfile_ID
    $CurrentProfileName = $ProfilesDatabase.Profiles[$(GetProfileIndex($CurrentProfileID))].Name
    $CurrentProfilePath = $ProfilesDatabase.Profiles[$(GetProfileIndex($CurrentProfileID))].Path
    $CurrentProfileBackupsPath = "$CurrentProfilePath\Backups"

    # Cheking if the Current Profile Directory exists (and creating it if it does not exist)
    if (!(Test-Path $CurrentProfilePath)) {
        New-Item -Path $CurrentProfilePath -ItemType "Directory" > $Null
    }

    # Cheking if the Current Profile Backups Directory exists (and creating it if it does not exist)
    if (!(Test-Path $CurrentProfileBackupsPath)) {
        New-Item -Path $CurrentProfileBackupsPath -ItemType "Directory" > $Null
    }

    Write-Host "Profiles loaded successfully" -ForegroundColor $SuccessColor
    ShowCurrentProfileName
}

# Current Profile Database Path
$CurrentProfileDatabasePath = "$CurrentProfilePath\Database.json"

# Checking if the file 'Database.json' of the Current Active Profile exists and creating it if it does not exist
if (!(Test-Path -Path $CurrentProfileDatabasePath)) {
    Write-Host "`nCreating Database..." -ForegroundColor $InputColor

    # Categories & Shortcuts List
    $Categories = New-Object System.Collections.ArrayList
    $Shortcuts = New-Object System.Collections.ArrayList

    # Creating the Current Profile Database
    $Database = @{}
    $Database.Add("Categories", $Categories)
    $Database.Add("Shortcuts", $Shortcuts)
    $Database.Add("Colors", $Colors)
    $Database.Add("CategoryID_Index", -1)
    $Database.Add("ShortcutID_Index", -1)

    # Commit Changes to the Current Profile Database
    $Database | ConvertTo-Json | Out-File $CurrentProfileDatabasePath
    $Database = Get-Content -Path $CurrentProfileDatabasePath | ConvertFrom-Json

    Write-Host "Database created successfully`n" -ForegroundColor $SuccessColor
}
else {
    Write-Host "`nLoading Database..." -ForegroundColor $InputColor

    # Getting the Data of the Current Profile Database (From the file: 'Database.json' located in the Current Profile Directory)
    $Database = Get-Content -Path $CurrentProfileDatabasePath | ConvertFrom-Json

    Write-Host "Database loaded successfully`n" -ForegroundColor $SuccessColor
}

# Showing the Main Menu
MainMenu
