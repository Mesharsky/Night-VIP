/**
 * Is it currently nighttime according to the settings in the Night VIP
 * config file.
 *
 * @return      True if it is night.
 */
bool NV_IsNight();

/**
 * Has a client been given Free VIP.
 * This should only be used after OnClientPostAdminCheck().
 *
 * @param client    Client index.
 * @return          True if client was given Free VIP.
 *
 * @error           Invalid client index.
 */
bool NV_ClientHasFreeVIP(int client);

/**
 * Do not edit below this.
 */
public SharedPlugin __pl_night_vip =
{
    name = "night_vip",
    file = "night_vip.smx",
#if defined REQUIRE_PLUGIN
    required = 1,
#else
    required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public void __pl_night_vip_SetNTVOptional()
{
    MarkNativeAsOptional("NV_IsNight");
    MarkNativeAsOptional("NV_ClientHasFreeVIP");
}
#endif