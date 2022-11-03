#if defined _INC_y_zonenames
	#endinput
#endif
#define _INC_y_zonenames

/*  SA:MP Functions
 *
 *  ZONES Functions By ~Cueball~
 *  ZONES Functions Aided By Betamaster (locations), Mabako (locations), Simon (finetuning)
 *
 *  (c) Copyright 2005-2008, SA:MP Team
 *
 */

#include "..\..\YSI_Core\y_utils"
#include "..\..\YSI_Players\y_text"
#include "..\..\YSI_Visual\y_areas"

#define YSIM_U_DISABLE
#define MASTER 52
#include "..\..\YSI_Core\y_master"
#include "..\..\YSI_Coding\y_hooks"

loadtext core[ysi_zonenames];

static stock
	YSI_g_sZoneIDs[MAX_AREAS] = {-1, ...};

static stock const
	YSI_g_scZoneNames[][] =
		{
			!"The Big Ear",              !"Aldea Malvada",           !"Angel Pine",
			!"Arco del Oeste",           !"Avispa Country Club",     !"Back o Beyond",
			!"Battery Point",            !"Bayside",                 !"Bayside Marina",
			!"Beacon Hill",              !"Blackfield",              !"Blackfield Chapel",
			!"Blackfield Intersection",  !"Blueberry",               !"Blueberry Acres",
			!"Caligula's Palace",        !"Calton Heights",          !"Chinatown",
			!"City Hall",                !"Come-A-Lot",              !"Commerce",
			!"Conference Center",        !"Cranberry Station",       !"Creek",
			!"Dillimore",                !"Doherty",                 !"Downtown",
			!"Downtown Los Santos",      !"East Beach",
			!"East Los Santos",          !"Easter Basin",            !"Easter Bay Airport",
			!"Easter Bay Chemicals",     !"El Castillo del Diablo",
			!"El Corona",                !"El Quebrados",            !"Esplanade East",
			!"Esplanade North",          !"Fallen Tree",             !"Fallow Bridge",
			!"Fern Ridge",               !"Financial",               !"Fisher's Lagoon",
			!"Flint Intersection",       !"Flint Range",             !"Fort Carson",
			!"Foster Valley",            !"Frederick Bridge",        !"Gant Bridge",
			!"Ganton",
			!"Garcia",                   !"Garver Bridge",           !"Glen Park",
			!"Green Palms",              !"Greenglass College",      !"Hampton Barns",
			!"Hankypanky Point",         !"Harry Gold Parkway",      !"Hashbury",
			!"Hilltop Farm",             !"Hunter Quarry",           !"Idlewood",
			!"Jefferson",                !"Julius Thruway East",     !"Julius Thruway North",
			!"Julius Thruway South",     !"Julius Thruway West",     !"Juniper Hill",
			!"Juniper Hollow",           !"K.A.C.C. Military Fuels", !"Kincaid Bridge",
			!"King's",                   !"LVA Freight Depot",       !"Las Barrancas",
			!"Las Brujas",               !"Las Colinas",             !"Las Payasadas",
			!"Las Venturas Airport",     !"Last Dime Motel",         !"Leafy Hollow",
			!"Liberty City",             !"Lil' Probe Inn",          !"Linden Side",
			!"Linden Station",           !"Little Mexico",           !"Los Flores",
			!"Los Santos International", !"Marina",                  !"Market",
			!"Market Station",           !"Martin Bridge",           !"Missionary Hill",
			!"Montgomery",               !"Montgomery Intersection", !"Mulholland",
			!"Mulholland Intersection",  !"North Rock",              !"Ocean Docks",
			!"Ocean Flats",              !"Octane Springs",          !"Old Venturas Strip",
			!"Palisades",                !"Palomino Creek",          !"Paradiso",
			!"Pershing Square",          !"Pilgrim",
			!"Pilson Intersection",      !"Pirates in Men's Pants",  !"Playa del Seville",
			!"Prickle Pine",             !"Queens",                  !"Randolph Industrial Estate",
			!"Redsands East",            !"Redsands West",           !"Regular Tom",
			!"Richman",                  !"Robada Intersection",     !"Roca Escalante",
			!"Rockshore East",
			!"Rockshore West",           !"Rodeo",                   !"Royal Casino",
			!"San Andreas Sound",        !"Santa Flora",
			!"Santa Maria Beach",        !"Shady Cabin",             !"Shady Creeks",
			!"Sobell Rail Yards",        !"Spinybed",                !"Starfish Casino",
			!"Temple",                   !"The Camel's Toe",         !"The Clown's Pocket",
			!"The Emerald Isle",         !"The Farm",                !"The Four Dragons Casino",
			!"The High Roller",          !"The Mako Span",           !"The Panopticon",
			!"The Pink Swan",            !"The Sherman Dam",         !"The Strip",
			!"The Visage",               !"Unity Station",           !"Valle Ocultado",
			!"Verdant Bluffs",           !"Verdant Meadows",         !"Verona Beach",
			!"Vinewood",                 !"Whitewood Estates",       !"Willowfield",
			!"Yellow Bell Station",      !"Los Santos",              !"Las Venturas",
			!"Bone County",              !"Tierra Robada",           !"San Fierro",
			!"Red County",               !"Flint County",            !"Whetstone"
		};

static stock
	YSI_g_sZNShow[MAX_PLAYERS],
	YSI_g_sZNTD[MAX_PLAYERS] = {INVALID_TEXT_DRAW, ...},
	YSI_g_sZNCur[MAX_PLAYERS] = {cellmax, ...};

MASTER_HOOK__ OnPlayerDisconnect(playerid, reason)
{
	#pragma unused reason
	YSI_g_sZNShow[playerid] = 0,
	YSI_g_sZNCur[playerid] = cellmax,
	YSI_g_sZNTD[playerid] = INVALID_TEXT_DRAW;
	return 1;
}

MASTER_HOOK__ OnPlayerSpawn(playerid)
{
	YSI_g_sZNShow[playerid] = 1;
	return 1;
}

MASTER_HOOK__ OnPlayerDeath(playerid, killerid, reason)
{
	#pragma unused killerid, reason
	YSI_g_sZNShow[playerid] = 0;
	return 1;
}

forward ZoneNames_Hide(playerid);

public ZoneNames_Hide(playerid)
{
	new
		td = YSI_g_sZNTD[playerid];
	if (td != INVALID_TEXT_DRAW)
	{
		TD_HideForPlayer(playerid, Text:td);
		YSI_g_sZNTD[playerid] = INVALID_TEXT_DRAW;
	}
}

stock ZoneNames_Show(playerid, id)
{
	//TD_HideForPlayer(playerid, Text:YSI_g_sZNTD[playerid]);
	static
		name[32];
	ZoneNames_Hide(playerid);
	YSI_g_sZNCur[playerid] = id,
	strunpack(name, YSI_g_scZoneNames[id]),
	Text_Send(playerid, $YSI_ZONE_NAME, "", name);
	new
		td = Text_GetLastID();
	if (td != -1)
	{
		SetTimerEx("ZoneNames_Hide", 3000, 0, "i", playerid),
		YSI_g_sZNTD[playerid] = td;
	}
}

MASTER_HOOK__ OnPlayerEnterArea(playerid, areaid)
{
	if (YSI_g_sZNShow[playerid])
	{
		new
			id = YSI_g_sZoneIDs[areaid];
		if (id != -1 && id < YSI_g_sZNCur[playerid])
		{
			ZoneNames_Show(playerid, id);
		}
	}
	return 1;
}

MASTER_HOOK__ OnPlayerLeaveArea(playerid, areaid)
{
	if (areaid != YSI_g_sZNCur[playerid])
	{
		return 1;
	}
	YSI_g_sZNCur[playerid] = cellmax;
	if (YSI_g_sZNShow[playerid])
	{
		for (new idx = 0, id = 0; (id = Area_GetPlayerAreas(playerid, idx)) != NO_AREA; ++idx)
		{
			if ((id = YSI_g_sZoneIDs[id]) != -1)
			{
				if (id < YSI_g_sZNCur[playerid])
				{
					ZoneNames_Show(playerid, id);
				}
				return 1;
			}
		}
	}
	return 1;
}

MASTER_HOOK__ OnScriptInit()
{
	#define SAZ_AddCuboid(%0) (YSI_g_sZoneIDs[Area_AddCuboid(%0)] = idx++)
	#define SAZ_AddPoly(%0) (YSI_g_sZoneIDs[Area_AddPoly(%0)] = idx++)
	new
		idx = 0;
	
	SAZ_AddCuboid(-410.00, 1403.30, -3.00, -137.90, 1681.20, 200.00);
	
	SAZ_AddCuboid(-1372.10, 2498.50, 0.00, -1277.50, 2615.30, 200.00);
	
	SAZ_AddCuboid(-2324.90, -2584.20, -6.10, -1964.20, -2212.10, 200.00);
	
	SAZ_AddCuboid(-901.10, 2221.80, 0.00, -592.00, 2571.90, 200.00);
	
	SAZ_AddPoly(-2270.00, -222.50, -2831.80, -222.50, -2831.80, -430.20, -2646.40, -430.20, -2646.40, -355.40, -2361.50, -355.40, -2361.50, -417.10, -2270.00, -417.10, 200.0);
	
	SAZ_AddCuboid(-1166.90, -2641.10, 0.00, -321.70, -1856.00, 200.00);
	
	SAZ_AddCuboid(-2741.00, 1268.40, -4.50, -2533.00, 1490.40, 200.00);
	
	SAZ_AddCuboid(-2741.00, 2175.10, 0.00, -2353.10, 2722.70, 200.00);
	
	SAZ_AddCuboid(-2353.10, 2275.70, 0.00, -2153.10, 2475.70, 200.00);
	
	SAZ_AddCuboid(-399.60, -1075.50, -1.40, -319.00, -977.50, 198.50);
	
	SAZ_AddCuboid(964.30, 1203.20, -89.00, 1197.30, 1726.20, 110.90);
	
	SAZ_AddPoly(1325.60, 596.30, 1558.00, 596.30, 1558.00, 823.00, 1375.50, 823.00, 1375.50, 795.00, 1325.60, 795.00, 110.90);
	
	SAZ_AddPoly(1166.50,  759.00, 1375.60,  759.00, 1375.60,  823.20, 1457.30,  823.00, 1457.30,  919.40, 1375.60,  919.40, 1375.60, 1044.60, 1315.30, 1044.60, 1315.30, 1087.60, 1277.00, 1087.60, 1277.00, 1163.30, 1197.30, 1163.30, 1197.30, 1044.60, 1166.50, 1044.60, 110.90);
	
	SAZ_AddPoly( 19.60, -404.10,  19.60, -220.10, 104.50, -220.10, 104.50,  152.20, 349.60,  152.20, 349.60, -404.10, 200.0);
	
	SAZ_AddCuboid(-319.60, -220.10, 0.00, 104.50, 293.30, 200.00);
	
	SAZ_AddPoly(2087.30, 1543.20, 2087.30, 1703.20, 2137.40, 1703.20, 2137.40, 1783.20, 2437.30, 1783.20, 2437.30, 1543.20, 110.90);
	
	SAZ_AddCuboid(-2274.10, 744.10, -6.10, -1982.30, 1358.90, 200.00);
	
	SAZ_AddCuboid(-2274.10, 578.30, -7.60, -2078.60, 744.10, 200.00);
	
	SAZ_AddCuboid(-2867.80, 277.40, -9.10, -2593.40, 458.40, 200.00);
	
	SAZ_AddCuboid(2087.30, 943.20, -89.00, 2623.10, 1203.20, 110.90);
	
	// The "A" points are the same as we need to trace around a hole.
	SAZ_AddPoly(1323.90, -1842.20, 1323.90, -1577.50, 1370.80, -1577.50, 1370.80, -1384.90, 1463.90, -1384.90, 1463.90, -1577.50, 1440.90, -1577.50, 1440.90, -1722.20, 1583.50, -1722.20, 1583.50, -1577.50, 1463.90, -1577.50, 1463.90, -1430.80, 1812.60, -1430.80, 1812.60, -1577.50, 1758.90, -1577.50, 1758.90, -1722.20, 1701.90, -1722.20, 1701.90, -1842.20, 110.90);
	
	SAZ_AddPoly(1073.20, -1842.20, 1323.90, -1842.20, 1323.90, -1722.20, 1046.10, -1722.20, 1046.10, -1804.20, 1073.20, -1804.20, 110.90);
	
	SAZ_AddCuboid(-2007.80, 56.30, 0.00, -1922.00, 224.70, 100.00);
	
	SAZ_AddCuboid(2749.90, 1937.20, -89.00, 2921.60, 2669.70, 110.90);
	
	SAZ_AddCuboid(580.70, -674.80, -9.50, 861.00, -404.70, 200.00);
	
	SAZ_AddPoly(-2270.00, -324.10, -1794.90, -324.10, -1794.90,  265.20, -2173.00,  265.20, -2173.00, -222.50, -2270.00, -222.50, 200.0);
	
	SAZ_AddPoly(-2078.60,  744.10, -2078.60,  578.30, -1993.20,  578.30, -1993.20,  265.20, -1794.90,  265.20, -1794.90,  578.30, -1499.80,  578.30, -1499.80, 1025.90, -1580.00, 1025.90, -1580.00, 1176.40, -1620.30, 1176.40, -1620.30, 1274.20, -1982.30, 1274.20, -1982.30,  744.10, -1871.70,  744.10, -1871.70, 1176.40, -1700.00, 1176.40, -1700.00,  744.10, 200.0);
	
	SAZ_AddPoly(1812.60, -1430.80, 1812.60, -1150.80, 1463.90, -1150.80, 1463.90, - 926.90, 1391.00, - 926.90, 1391.00, -1026.30, 1378.30, -1026.30, 1378.30, -1130.80, 1370.80, -1130.80, 1370.80, -1384.90, 1463.90, -1384.90, 1463.90, -1430.80, 335.90);
	
	// =====
	// 60) East Beach
	// =====
	//  Height: 110.90
	//  Min X: 2632.80
	//  Max X: 2959.30
	//  Min Y: -1852.80
	//  Max Y: -1120.00
	SAZ_AddPoly( 2959.30, -1852.80,  2959.30, -1120.00,  2747.69, -1120.00,  2747.69, -1393.40,  2632.80, -1393.40,  2632.80, -1852.80, 110.90);
	// =====
	// 64) East Los Santos
	// =====
	//  Height: 110.90
	//  Min X: 2222.50
	//  Max X: 2632.80
	//  Min Y: -1628.50
	//  Max Y: -1135.00
	SAZ_AddPoly( 2632.80, -1454.30,  2581.69, -1454.30,  2581.69, -1135.00,  2281.39, -1135.00,  2281.39, -1372.00,  2266.19, -1372.00,  2266.19, -1494.00,  2222.50, -1494.00,  2222.50, -1628.50,  2632.80, -1628.50, 110.90);
	
	SAZ_AddPoly(-1794.90, -50.00, -1499.80, -50.00, -1499.80, 249.90, -1242.90, 249.90, -1242.90, 578.30, -1794.90, 578.30, 200.0);
	
	// =====
	// 73) Easter Bay Airport
	// =====
	//  Height: 200.00
	//  Min X: -1794.90
	//  Max X: -947.90
	//  Min Y: -730.09
	//  Max Y: 578.29
	SAZ_AddPoly(-1499.80,   249.89, -1242.90,   249.89, -1242.90,   578.29,  -947.90,   578.29,  -947.90,   -50.00, -1132.80,   -50.00, -1132.80,  -730.09, -1794.90,  -730.09, -1794.90,   -50.00, -1499.80,   -50.00, 200.00);
	// =====
	// 81) Easter Bay Chemicals
	// =====
	//  Height: 200.00
	//  Min X: -1132.80
	//  Max X: -956.40
	//  Min Y: -787.29
	//  Max Y: -578.09
	// SECRET BOX:
	SAZ_AddCuboid(1132.80,  -787.29, 0.0, -956.40,  -578.09, 200.00);
	// =====
	// 83) El Castillo del Diablo
	// =====
	//  Height: 200.00
	//  Min X: -464.50
	//  Max X: 114.00
	//  Min Y: 2123.00
	//  Max Y: 2580.30
	SAZ_AddPoly( -464.50,  2580.30,  -208.50,  2580.30,  -208.50,  2487.10, 	8.39,  2487.10, 	8.39,  2337.10,   114.00,  2337.10,   114.00,  2123.00,  -208.50,  2123.00,  -208.50,  2217.60,  -464.50,  2217.60, 200.00);
	// =====
	// 86) El Corona
	// =====
	//  Height: 110.90
	//  Min X: 1692.59
	//  Max X: 1970.59
	//  Min Y: -2179.19
	//  Max Y: -1842.19
	SAZ_AddPoly( 1970.59, -1852.80,  1970.59, -2179.19,  1692.59, -2179.19,  1692.59, -1842.19,  1812.59, -1842.19,  1812.59, -1852.80, 110.90);
	
	SAZ_AddCuboid(-1645.20, 2498.50, 0.00, -1372.10, 2777.80, 200.00);
	
	// =====
	// 89) Esplanade East
	// =====
	//  Height: 200.00
	//  Min X: -1620.30
	//  Max X: -1339.80
	//  Min Y: 578.29
	//  Max Y: 1274.19
	SAZ_AddPoly(-1620.30,  1274.19, -1339.80,  1274.19, -1339.80,   578.30, -1499.80,   578.30, -1499.80,  1025.90, -1580.00,  1025.90, -1580.00,  1176.50, -1620.30,  1176.50, 200.0);
	// =====
	// 92) Esplanade North
	// =====
	//  Height: 200.00
	//  Min X: -2533.00
	//  Max X: -1524.19
	//  Min Y: 1274.19
	//  Max Y: 1592.50
	SAZ_AddPoly(-2533.00,  1501.19, -1996.59,  1501.19, -1996.59,  1592.50, -1524.19,  1592.50, -1524.19,  1274.19, -1982.30,  1274.19, -1982.30,  1358.90, -2533.00,  1358.90, 200.0);
	
	SAZ_AddCuboid(-792.20, -698.50, -5.30, -452.40, -380.00, 200.00);
	
	SAZ_AddCuboid(434.30, 366.50, 0.00, 603.00, 555.60, 200.00);
	
	SAZ_AddCuboid(508.10, -139.20, 0.00, 1306.60, 119.50, 200.00);
	
	SAZ_AddCuboid(-1871.70, 744.10, -6.10, -1701.30, 1176.40, 300.00);
	
	SAZ_AddCuboid(1916.90, -233.30, -100.00, 2131.70, 13.80, 200.00);
	
	SAZ_AddCuboid(-187.70, -1596.70, -89.00, 17.00, -1276.60, 110.90);
	
	SAZ_AddCuboid(-594.10, -1648.50, 0.00, -187.70, -1276.60, 200.00);
	
	SAZ_AddCuboid(-376.20, 826.30, -3.00, 123.70, 1220.40, 200.00);
	
	// =====
	// 103) Foster Valley
	// =====
	//  Height: 200.00
	//  Min X: -2270.00
	//  Max X: -1794.90
	//  Min Y: -1250.90
	//  Max Y: -324.10
	SAZ_AddPoly(-2270.00,  -324.10, -1794.90,  -324.10, -1794.90, -1250.90, -2178.60, -1250.90, -2178.60,  -430.20, -2270.00,  -430.20, 200.0);
	
	SAZ_AddCuboid(2759.20, 296.50, 0.00, 2774.20, 594.70, 200.00);
	
	// =====
	// 108) Gant Bridge
	// =====
	//  Height: 200.00
	//  Min X: -2741.39
	//  Max X: -2616.39
	//  Min Y: 1490.40
	//  Max Y: 2175.10
	SAZ_AddPoly(-2741.39,  2175.10, -2616.39,  2175.10, -2616.39,  1490.40, -2741.00,  1490.40, -2741.00,  1659.59, -2741.39,  1659.59, 200.00);
	// =====
	// 110) Ganton
	// =====
	//  Height: 110.90
	//  Min X: 2222.50
	//  Max X: 2632.80
	//  Min Y: -1852.80
	//  Max Y: -1628.50
	// SECRET BOX:
	SAZ_AddCuboid(2222.50, -1852.80, -89.00, 2632.80, -1628.50, 110.90);
	// =====
	// 112) Garcia
	// =====
	//  Height: 200.00
	//  Min X: -2411.19
	//  Max X: -2173.00
	//  Min Y: -222.50
	//  Max Y: 265.20
	// SECRET BOX:
	SAZ_AddCuboid(-2411.20, -222.50, -5.30, -2173.00, 265.20, 200.00);
	// =====
	// 114) Garver Bridge
	// =====
	//  Height: 110.90
	//  Min X: -1499.80
	//  Max X: -1087.90
	//  Min Y: 696.40
	//  Max Y: 1178.90
	SAZ_AddPoly(-1339.80,  1057.00, -1213.90,  1057.00, -1213.90,  1178.90, -1087.90,  1178.90, -1087.90,   950.00, -1213.90,   950.00, -1213.90,   828.09, -1339.80,   828.09, -1339.80,   696.40, -1499.80,   696.40, -1499.80,   925.30, -1339.80,   925.30, 110.90);
	// =====
	// 117) Glen Park
	// =====
	//  Height: 110.90
	//  Min X: 1812.59
	//  Max X: 2056.80
	//  Min Y: -1449.59
	//  Max Y: -973.29
	SAZ_AddPoly( 1996.90, -1350.69,  2056.80, -1350.69,  2056.80, -1100.80,  1994.30, -1100.80,  1994.30,  -973.29,  1812.59,  -973.29,  1812.59, -1449.59,  1996.90, -1449.59, 110.90);
	
	SAZ_AddCuboid(176.50, 1305.40, -3.00, 338.60, 1520.70, 200.00);
	
	// =====
	// 121) Greenglass College
	// =====
	//  Height: 110.90
	//  Min X: 964.29
	//  Max X: 1197.30
	//  Min Y: 930.79
	//  Max Y: 1203.19
	SAZ_AddPoly( 1197.30,  1203.19,  1197.30,  1044.59,  1166.50,  1044.59,  1166.50,   930.79,   964.29,   930.79,   964.29,  1203.19, 110.90);
	
	SAZ_AddCuboid(603.00, 264.30, 0.00, 761.90, 366.50, 200.00);
	
	SAZ_AddCuboid(2576.90, 62.10, 0.00, 2759.20, 385.50, 200.00);
	
	SAZ_AddCuboid(1777.30, 863.20, -89.00, 1817.30, 2342.80, 110.90);
	
	SAZ_AddCuboid(-2593.40, -222.50, -0.00, -2411.20, 54.70, 200.00);
	
	SAZ_AddCuboid(967.30, -450.30, -3.00, 1176.70, -217.90, 200.00);
	
	SAZ_AddCuboid(337.20, 710.80, -115.20, 860.50, 1031.70, 203.70);
	
	// =====
	// 129) Idlewood
	// =====
	//  Height: 110.90
	//  Min X: 1812.59
	//  Max X: 2222.50
	//  Min Y: -1852.80
	//  Max Y: -1449.59
	SAZ_AddPoly( 2124.60, -1449.59,  2124.60, -1494.00,  2222.50, -1494.00,  2222.50, -1852.80,  1812.59, -1852.80,  1812.59, -1449.59, 110.90);
	// =====
	// 135) Jefferson
	// =====
	//  Height: 110.90
	//  Min X: 1996.90
	//  Max X: 2281.39
	//  Min Y: -1494.00
	//  Max Y: -1126.30
	SAZ_AddPoly( 1996.90, -1350.69,  2056.80, -1350.69,  2056.80, -1126.30,  2185.30, -1126.30,  2185.30, -1154.50,  2281.39, -1154.50,  2281.39, -1372.00,  2266.19, -1372.00,  2266.19, -1494.00,  2124.60, -1494.00,  2124.60, -1449.59,  1996.90, -1449.59, 110.90);
	// =====
	// 141) Julius Thruway East
	// =====
	//  Height: 110.90
	//  Min X: 2536.39
	//  Max X: 2749.89
	//  Min Y: 943.20
	//  Max Y: 2626.50
	SAZ_AddPoly( 2623.10,  1055.90,  2685.10,  1055.90,  2685.10,  2202.69,  2625.10,  2202.69,  2625.10,  2442.50,  2536.39,  2442.50,  2536.39,  2542.50,  2685.10,  2542.50,  2685.10,  2626.50,  2749.89,  2626.50,  2749.89,   943.20,  2623.10,   943.20, 110.90);
	// =====
	// 145) Julius Thruway North
	// =====
	//  Height: 110.90
	//  Min X: 1377.30
	//  Max X: 2685.10
	//  Min Y: 2342.80
	//  Max Y: 2663.10
	SAZ_AddPoly( 2685.10,  2626.50,  2685.10,  2542.50,  2237.39,  2542.50,  2237.39,  2508.19,  1938.80,  2508.19,  1938.80,  2478.39,  1848.40,  2478.39,  1848.40,  2342.80,  1704.50,  2342.80,  1704.50,  2433.19,  1377.30,  2433.19,  1377.30,  2507.19,  1534.50,  2507.19,  1534.50,  2583.19,  1848.40,  2583.19,  1848.40,  2553.39,  1938.80,  2553.39,  1938.80,  2624.19,  2121.39,  2624.19,  2121.39,  2663.10,  2498.19,  2663.10,  2498.19,  2626.50, 110.90);
	// =====
	// 153) Julius Thruway South
	// =====
	//  Height: 110.90
	//  Min X: 1457.30
	//  Max X: 2537.30
	//  Min Y: 788.79
	//  Max Y: 897.90
	SAZ_AddPoly( 1457.30,   863.20,  2377.30,   863.20,  2377.30,   897.90,  2537.30,   897.90,  2537.30,   788.79,  2377.30,   788.79,  2377.30,   823.20,  1457.30,   823.20, 110.90);
	// =====
	// 155) Julius Thruway West
	// =====
	//  Height: 110.90
	//  Min X: 1197.30
	//  Max X: 1297.40
	//  Min Y: 1163.30
	//  Max Y: 2243.19
	SAZ_AddPoly( 1197.30,  2243.19,  1297.40,  2243.19,  1297.40,  2142.80,  1236.59,  2142.80,  1236.59,  1163.30,  1197.30,  1163.30, 110.90);
	
	SAZ_AddCuboid(-2533.00, 578.30, -7.60, -2274.10, 968.30, 200.00);
	
	SAZ_AddCuboid(-2533.00, 968.30, -6.10, -2274.10, 1358.90, 200.00);
	
	SAZ_AddCuboid(2498.20, 2626.50, -89.00, 2749.90, 2861.50, 110.90);
	
	// =====
	// 160) Kincaid Bridge
	// =====
	//  Height: 110.90
	//  Min X: -1339.80
	//  Max X: -961.90
	//  Min Y: 599.20
	//  Max Y: 986.20
	SAZ_AddPoly(-1339.80,   828.09, -1213.90,   828.09, -1213.90,   950.00, -1087.90,   950.00, -1087.90,   986.20,  -961.90,   986.20,  -961.90,   855.29, -1087.90,   855.29, -1087.90,   721.09, -1213.90,   721.09, -1213.90,   599.20, -1339.80,   599.20, 110.90);
	// =====
	// 163) King's
	// =====
	//  Height: 200.00
	//  Min X: -2411.19
	//  Max X: -1993.19
	//  Min Y: 265.20
	//  Max Y: 578.29
	SAZ_AddPoly(-2329.30,   578.29, -1993.19,   578.29, -1993.19,   265.20, -2411.19,   265.20, -2411.19,   373.50, -2253.50,   373.50, -2253.50,   458.39, -2329.30,   458.39, 200.00);
	// =====
	// 166) LVA Freight Depot
	// =====
	//  Height: 110.90
	//  Min X: 1236.59
	//  Max X: 1777.40
	//  Min Y: 863.20
	//  Max Y: 1203.19
	SAZ_AddPoly( 1777.40,  1143.19,  1777.40,   863.20,  1457.30,   863.20,  1457.30,   919.40,  1375.59,   919.40,  1375.59,  1044.59,  1315.30,  1044.59,  1315.30,  1087.59,  1277.00,  1087.59,  1277.00,  1163.40,  1236.59,  1163.40,  1236.59,  1203.19,  1457.30,  1203.19,  1457.30,  1143.19, 110.90);
	
	SAZ_AddCuboid(-926.10, 1398.70, -3.00, -719.20, 1634.60, 200.00);
	
	SAZ_AddCuboid(-365.10, 2123.00, -3.00, -208.50, 2217.60, 200.00);
	
	// =====
	// 173) Las Colinas
	// =====
	//  Height: 110.90
	//  Min X: 1994.30
	//  Max X: 2959.30
	//  Min Y: -1154.50
	//  Max Y: -920.79
	SAZ_AddPoly( 1994.30,  -920.79,  2126.80,  -920.79,  2126.80,  -934.40,  2281.39,  -934.40,  2281.39,  -945.00,  2959.30,  -945.00,  2959.30, -1120.00,  2747.69, -1120.00,  2747.69, -1135.00,  2281.39, -1135.00,  2281.39, -1154.50,  2185.30, -1154.50,  2185.30, -1126.30,  2056.80, -1126.30,  2056.80, -1100.80,  1994.30, -1100.80, 110.90);
	
	SAZ_AddCuboid(-354.30, 2580.30, 2.00, -133.60, 2816.80, 200.00);
	
	// =====
	// 181) Las Venturas Airport
	// =====
	//  Height: 110.90
	//  Min X: 1236.59
	//  Max X: 1777.40
	//  Min Y: 1143.19
	//  Max Y: 1883.09
	SAZ_AddPoly( 1236.59,  1883.09,  1777.30,  1883.09,  1777.30,  1203.19,  1777.40,  1203.19,  1777.40,  1143.19,  1457.30,  1143.19,  1457.30,  1203.19,  1236.59,  1203.19, 110.90);
	
	SAZ_AddCuboid(1823.00, 596.30, -89.00, 1997.20, 823.20, 110.90);
	
	SAZ_AddCuboid(-1166.90, -1856.00, 0.00, -815.60, -1602.00, 200.00);
	
	SAZ_AddCuboid(-1000.00, 400.00, 1300.00, -700.00, 600.00, 1400.00);
	
	SAZ_AddCuboid(-90.20, 1286.80, -3.00, 153.80, 1554.10, 200.00);
	
	SAZ_AddCuboid(2749.90, 943.20, -89.00, 2923.30, 1198.90, 110.90);
	
	// =====
	// 190) Linden Station
	// =====
	//  Height: 110.90
	//  Min X: 2749.89
	//  Max X: 2923.30
	//  Min Y: 1198.90
	//  Max Y: 1548.90
	// SECRET BOX:
	SAZ_AddCuboid(2749.90, 1198.90, -89.00, 2923.30, 1548.90, 110.90);
	// =====
	// 192) Little Mexico
	// =====
	//  Height: 110.90
	//  Min X: 1701.90
	//  Max X: 1812.59
	//  Min Y: -1842.19
	//  Max Y: -1577.50
	SAZ_AddPoly( 1701.90, -1722.19,  1758.90, -1722.19,  1758.90, -1577.50,  1812.59, -1577.50,  1812.59, -1842.19,  1701.90, -1842.19, 110.90);
	// =====
	// 194) Los Flores
	// =====
	//  Height: 110.90
	//  Min X: 2581.69
	//  Max X: 2747.69
	//  Min Y: -1454.30
	//  Max Y: -1135.00
	SAZ_AddPoly( 2632.80, -1393.40,  2747.69, -1393.40,  2747.69, -1135.00,  2581.69, -1135.00,  2581.69, -1454.30,  2632.80, -1454.30, 110.90);
	// =====
	// 196) Los Santos International
	// =====
	//  Height: 110.90
	//  Min X: 1249.59
	//  Max X: 2201.80
	//  Min Y: -2730.80
	//  Max Y: -2179.19
	SAZ_AddPoly( 1249.59, -2179.19,  2089.00, -2179.19,  2089.00, -2394.30,  2201.80, -2394.30,  2201.80, -2730.80,  1382.69, -2730.80,  1382.69, -2394.30,  1249.59, -2394.30, 110.90);
	// =====
	// 202) Marina
	// =====
	//  Height: 110.90
	//  Min X: 647.70
	//  Max X: 926.90
	//  Min Y: -1804.19
	//  Max Y: -1416.19
	SAZ_AddPoly(  851.40, -1577.50,   926.90, -1577.50,   926.90, -1416.19,   647.70, -1416.19,   647.70, -1804.19,   851.40, -1804.19, 110.90);
	// =====
	// 205) Market
	// =====
	//  Height: 110.90
	//  Min X: 787.40
	//  Max X: 1370.80
	//  Min Y: -1577.50
	//  Max Y: -1130.80
	SAZ_AddPoly(  787.40, -1310.19,   952.59, -1310.19,   952.59, -1130.80,  1370.80, -1130.80,  1370.80, -1577.50,   926.90, -1577.50,   926.90, -1416.19,   787.40, -1416.19, 110.90);
	
	SAZ_AddCuboid(787.40, -1410.90, -34.10, 866.00, -1310.20, 65.80);
	
	SAZ_AddCuboid(-222.10, 293.30, 0.00, -122.10, 476.40, 200.00);
	
	SAZ_AddCuboid(-2994.40, -811.20, 0.00, -2178.60, -430.20, 200.00);
	
	// =====
	// 212) Montgomery
	// =====
	//  Height: 200.00
	//  Min X: 1119.50
	//  Max X: 1582.40
	//  Min Y: 119.50
	//  Max Y: 493.29
	SAZ_AddPoly( 1119.50,   493.29,  1451.40,   493.29,  1451.40,   420.79,  1582.40,   420.79,  1582.40,   347.39,  1451.40,   347.39,  1451.40,   119.50,  1119.50,   119.50, 200.00);
	// =====
	// 214) Montgomery Intersection
	// =====
	//  Height: 200.00
	//  Min X: 1546.59
	//  Max X: 1745.80
	//  Min Y: 208.10
	//  Max Y: 401.70
	SAZ_AddPoly( 1546.59,   347.39,  1582.40,   347.39,  1582.40,   401.70,  1664.59,   401.70,  1664.59,   347.39,  1745.80,   347.39,  1745.80,   208.10,  1546.59,   208.10, 200.00);
	
	YSI_g_sZoneIDs[Area_AddPoly(1463.90, -926.90, 1357.00, -926.90, 1357.00, -910.10, 1096.40, -910.10, 1096.40, -937.10,
		952.60, -937.10,  952.60, -954.60,  768.60, -954.60,  768.60, -860.60,  687.80, -860.60,  687.80,
		-768.00,  737.50, -768.00,  737.50, -674.80,  861.00, -674.80,  861.00, -600.80, 1156.50, -600.80,
		1156.50, -674.80, 1142.20, -674.80, 1142.20, -768.00, 1269.10, -768.00, 1269.10, -452.40, 1281.10,
		-452.40, 1281.10, -290.90, 1641.10, -290.90, 1641.10, -452.40, 1667.60, -452.40, 1667.60, -768.00,
		1463.90, -768.00, 110.90)] = idx++;
	
	SAZ_AddCuboid(1463.90, -1150.80, -89.00, 1812.60, -768.00, 110.90);
	
	SAZ_AddCuboid(2285.30, -768.00, 0.00, 2770.50, -269.70, 200.00);
	
	// =====
	// 231) Ocean Docks
	// =====
	//  Height: 110.90
	//  Min X: 2089.00
	//  Max X: 2959.30
	//  Min Y: -2730.80
	//  Max Y: -2059.19
	SAZ_AddPoly( 2324.00, -2730.80, 2373.69, -2697.00,  2373.69, -2330.39,  2809.19, -2330.39,  2809.19, -2697.00,  2373.69, -2697.00, 2324.00, -2730.80,  2201.80, -2730.80,  2201.80, -2394.30,  2089.00, 