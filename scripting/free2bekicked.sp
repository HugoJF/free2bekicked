#pragma semicolon 1

#include <sourcemod>
#include <SteamWorks>

#define PLUGIN_VERSION "1.0.0"

public Plugin myinfo = {
    name        = "Free2BeKicked - CS:GO",
    author      = "Asher \"asherkin\" Baker, psychonic",
    description = "Automatically kicks non-premium players.",
    version     = PLUGIN_VERSION,
    url         = "http://limetech.org/"
};

public OnPluginStart()
{
    CreateConVar("anti_f2p_version", PLUGIN_VERSION, "Free2BeKicked", FCVAR_DONTRECORD|FCVAR_NOTIFY);
}

// https://github.com/ThatOneHomelessGuy/togsclantags/blob/master/scripting/togsclantags.sp#L1044
stock void Log(const char[] sMsg, any ...)    //TOG logging function - path is relative to logs folder.
{
    char sLogFilePath[PLATFORM_MAX_PATH], sFormattedMsg[512];
    BuildPath(Path_SM, sLogFilePath, sizeof(sLogFilePath), "logs/prime-kicks.log");
    VFormat(sFormattedMsg, sizeof(sFormattedMsg), sMsg, 2);
    LogToFileEx(sLogFilePath, "%s", sFormattedMsg);
}

public void OnClientPostAdminCheck(int client)
{
    if (CheckCommandAccess(client, "BypassPremiumCheck", ADMFLAG_ROOT, true))
    {
        return;
    }
    
    if (k_EUserHasLicenseResultDoesNotHaveLicense == SteamWorks_HasLicenseForApp(client, 624820))
    {
        Log("User %L kicked for not having prime", client);
        KickClient(client, "You need a paid CS:GO account to play on this server");

        return;
    }
    
    return;
}
