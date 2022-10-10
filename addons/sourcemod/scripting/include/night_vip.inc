bool NV_IsNight();

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
}
#endif