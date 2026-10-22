<#
.SYNOPSIS
    Creates the Microsoft "fully managed basic security (level 1)" example for Android Enterprise
    as one compliance policy and one device restrictions profile. With -Assignment it also assigns both to a group.

.DESCRIPTION
    Values follow Microsoft Learn:
    https://learn.microsoft.com/intune/device-security/security-configurations/android-fully-managed

    Graph resources (beta):
    - androidDeviceOwnerCompliancePolicy
    - androidDeviceOwnerGeneralDeviceConfiguration

    The script only adds objects. If a policy with the same name exists, it is skipped.
    Lab script for MDDMI Lab 4.6 - Windows PowerShell 5.1 compatible.

.PARAMETER Assignment
    Assign both new policies to the group in -GroupName. Without this switch nothing is assigned.

.PARAMETER GroupName
    Display name of the Entra group used with -Assignment. Default: All Android Devices.

.EXAMPLE
    PowerShell.exe -ExecutionPolicy Bypass -File .\New-AndroidFMLevel1.ps1

.EXAMPLE
    PowerShell.exe -ExecutionPolicy Bypass -File .\New-AndroidFMLevel1.ps1 -Assignment -GroupName 'All Android Devices'
#>
[CmdletBinding()]
param(
    [switch]$Assignment,
    [string]$GroupName = 'All Android Devices'
)

$ErrorActionPreference = 'Stop'
$graph = 'https://graph.microsoft.com/beta'

$compliancePolicyName = 'AE COBO ZT Level 1 Compliance'
$restrictionsName     = 'AE COBO ZT Level 1 Device Restrictions'

# --- Module and sign-in -----------------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Authentication)) {
    Write-Host 'Installing Microsoft.Graph.Authentication for the current user...'
    Install-Module Microsoft.Graph.Authentication -Scope CurrentUser -Force
}
Import-Module Microsoft.Graph.Authentication

Connect-MgGraph -Scopes 'DeviceManagementConfiguration.ReadWrite.All', 'Group.Read.All' -NoWelcome

# --- Helper: find an existing object by display name ------------------------------------
function Get-ExistingByName {
    param([string]$Collection, [string]$Name)
    $escaped = $Name.Replace("'", "''")
    $uri = "$graph/deviceManagement/$Collection`?`$filter=displayName eq '$escaped'&`$select=id,displayName"
    $result = Invoke-MgGraphRequest -Method GET -Uri $uri
    return $result.value | Select-Object -First 1
}

# --- Compliance policy (Learn: Device compliance, level 1) -------------------------------
$complianceBody = @{
    '@odata.type'                                    = '#microsoft.graph.androidDeviceOwnerCompliancePolicy'
    displayName                                      = $compliancePolicyName
    description                                      = 'Fully managed basic security (level 1), Microsoft Learn example. Created by New-AndroidFMLevel1.ps1.'
    # Device Health - Play Integrity Verdict: Check basic integrity
    securityRequireSafetyNetAttestationBasicIntegrity = $true
    securityRequiredAndroidSafetyNetEvaluationType   = 'basic'
    # Device Properties - Minimum OS version
    osMinimumVersion                                 = '9.0'
    # System Security
    passwordRequired                                 = $true
    passwordRequiredType                             = 'numericComplex'
    passwordMinimumLength                            = 6
    passwordMinutesOfInactivityBeforeLock            = 5
    storageRequireEncryption                         = $true
    securityRequireIntuneAppIntegrity                = $true
    # Actions for noncompliance - mark noncompliant immediately (required when creating a policy)
    scheduledActionsForRule                          = @(
        @{
            ruleName                      = 'PasswordRequired'
            scheduledActionConfigurations = @(
                @{
                    actionType                = 'block'
                    gracePeriodHours          = 0
                    notificationTemplateId    = ''
                    notificationMessageCCList = @()
                }
            )
        }
    )
}

# --- Device restrictions (Learn: Device restrictions, level 1) ---------------------------
$restrictionsBody = @{
    '@odata.type'                                  = '#microsoft.graph.androidDeviceOwnerGeneralDeviceConfiguration'
    displayName                                    = $restrictionsName
    description                                    = 'Fully managed basic security (level 1), Microsoft Learn example. Created by New-AndroidFMLevel1.ps1.'
    # General
    appsDefaultPermissionPolicy                    = 'deviceDefault'
    storageBlockUsbFileTransfer                    = $true
    storageBlockExternalMedia                      = $true
    factoryResetBlocked                            = $true
    # System security - Threat scan on apps
    securityRequireVerifyApps                      = $true
    # Device experience - Enrollment profile type
    enrollmentProfile                              = 'fullyManaged'
    # Device password
    passwordRequiredType                           = 'numericComplex'
    passwordMinimumLength                          = 6
    passwordSignInFailureCountBeforeFactoryReset   = 10
    # Power settings - Time to lock screen
    passwordMinutesOfInactivityBeforeScreenTimeout = 5
    # Users and Accounts - User can configure credentials: Block
    certificateCredentialConfigurationDisabled     = $true
    # Applications - App auto-updates: Wi-Fi only
    appsAutoUpdatePolicy                           = 'wiFiOnly'
    # Work profile password
    workProfilePasswordRequiredType                = 'numericComplex'
    workProfilePasswordMinimumLength               = 6
    workProfilePasswordSignInFailureCountBeforeFactoryReset = 10
}

# --- Create ------------------------------------------------------------------------------
$created = @()

foreach ($item in @(
        @{ Collection = 'deviceCompliancePolicies'; Body = $complianceBody;   Type = 'Compliance policy' },
        @{ Collection = 'deviceConfigurations';     Body = $restrictionsBody; Type = 'Device restrictions' }
    )) {
    $name = $item.Body.displayName
    $existing = Get-ExistingByName -Collection $item.Collection -Name $name
    if ($existing) {
        Write-Host "Skipped: '$name' already exists." -ForegroundColor Yellow
        $created += [pscustomobject]@{ Type = $item.Type; Name = $name; Id = $existing.id; Status = 'Existed' }
        continue
    }
    $json = $item.Body | ConvertTo-Json -Depth 10
    $result = Invoke-MgGraphRequest -Method POST -Uri "$graph/deviceManagement/$($item.Collection)" -Body $json -ContentType 'application/json'
    Write-Host "Created: '$name'" -ForegroundColor Green
    $created += [pscustomobject]@{ Type = $item.Type; Name = $name; Id = $result.id; Status = 'Created' }
}

# --- Assign ------------------------------------------------------------------------------
if ($Assignment) {
    $escapedGroup = $GroupName.Replace("'", "''")
    $groups = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/v1.0/groups?`$filter=displayName eq '$escapedGroup'&`$select=id,displayName"
    $group = $groups.value | Select-Object -First 1
    if (-not $group) {
        Write-Warning "Group '$GroupName' not found - policies were created without assignment."
    }
    else {
        $assignBody = @{
            assignments = @(
                @{
                    target = @{
                        '@odata.type' = '#microsoft.graph.groupAssignmentTarget'
                        groupId       = $group.id
                    }
                }
            )
        } | ConvertTo-Json -Depth 10

        # Only new policies: /assign replaces all existing assignments of a policy.
        foreach ($entry in ($created | Where-Object { $_.Status -eq 'Created' })) {
            $collection = if ($entry.Type -eq 'Compliance policy') { 'deviceCompliancePolicies' } else { 'deviceConfigurations' }
            Invoke-MgGraphRequest -Method POST -Uri "$graph/deviceManagement/$collection/$($entry.Id)/assign" -Body $assignBody -ContentType 'application/json' | Out-Null
            Write-Host "Assigned: '$($entry.Name)' -> '$GroupName'" -ForegroundColor Green
        }
    }
}

# --- Summary -----------------------------------------------------------------------------
$created | Format-Table -AutoSize
Write-Host 'Check the result: Intune admin center -> Devices -> Compliance, and Devices -> Configuration.'
