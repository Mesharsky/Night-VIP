/**
 * The file is a part of Night-VIP.
 *
 * Copyright (C) Mesharsky
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#include <sourcemod>

#pragma newdecls required
#pragma semicolon 1

#define PLUGIN_VERSION "0.1"

bool g_FreeVip[MAXPLAYERS + 1];

int g_StartingHour;
int g_EndingHour;
int g_Flag;

public Plugin myinfo =
{
    name = "Night VIP",
    author = "Mesharsky",
    description = "Give free VIP flag on specific times",
    version = PLUGIN_VERSION,
    url = "https://github.com/Mesharsky/Night-VIP"
};

public void OnPluginStart()
{
    //LoadTranslations("night_vip.phrases.txt");
    LoadConfig();
}

public void OnClientPostAdminCheck(int client)
{
    if (IsNight())
    {
        AddFlagsToClient(client, g_Flag);
        g_FreeVip[client] = true;
        PrintToServer("Nadano flage graczowi %N, [%i]", client, g_Flag);
    }
}

public void OnClientDisconnect(int client)
{
    if (!IsFakeClient(client))
        g_FreeVip[client] = false;
}

void LoadConfig()
{
    char path[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, path, sizeof(path), "configs/night_vip.cfg");

    KeyValues kv = new KeyValues("Night VIP - Configuration");

    if (!kv.ImportFromFile(path))
        SetFailState("Cannot find config file: %s", path);

    if (!kv.JumpToKey("Settings"))
        SetFailState("Missing \"Settings\" section in config file");

    g_StartingHour = kv.GetNum("starting_hour");
    g_EndingHour = kv.GetNum("ending_hour");

    char buffer[32];
    kv.GetString("flag", buffer, sizeof(buffer));

    g_Flag = ReadFlagString(buffer);

    kv.Rewind();
    delete kv;
}

void AddFlagsToClient(int client, int adminFlags)
{
    SetUserFlagBits(client, adminFlags | GetUserFlagBits(client));
}

bool IsNight()
{
    char buffer[4];
    FormatTime(buffer, sizeof(buffer), "%H", GetTime());

    int hour = StringToInt(buffer);

    int max = g_StartingHour > g_EndingHour ? g_StartingHour : g_EndingHour;
    int min = g_StartingHour < g_EndingHour ? g_StartingHour : g_EndingHour;

    if (hour >= max || hour <= min)
        return true;

    return false;    
}