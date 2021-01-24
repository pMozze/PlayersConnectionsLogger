public Plugin myinfo = {
	name = "Players Connections Logger",
	author = "Mozze",
	description = "",
	version = "1.2",
	url = "t.me/pMozze"
};

Database g_hDataBase;

public void OnPluginStart() {
	Database.Connect(onDataBaseConnect, "PlayersConnectionsLogger");
}

public void onDataBaseConnect(Database hDataBase, const char[] szError, any data) {
	if (hDataBase == null || szError[0]) {
		SetFailState("%s", szError);
	} else {
		SQL_LockDatabase(hDataBase);
		SQL_FastQuery(hDataBase, "CREATE TABLE IF NOT EXISTS `players_connections` ( `id` INT NOT NULL AUTO_INCREMENT , `name` VARCHAR(128) NOT NULL , `authid` VARCHAR(32) NOT NULL , `ip` VARCHAR(16) NOT NULL , `lastvisit` INT NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB");
		SQL_UnlockDatabase(hDataBase);
		g_hDataBase = hDataBase;
	}
}

public void OnClientPutInServer(int iClient) {
	char
		szQuery[512],
		szName[MAX_NAME_LENGTH],
		szAuthID[32],
		szIP[16];

	GetClientName(iClient, szName, sizeof(szName));
	GetClientAuthId(iClient, AuthId_Steam2, szAuthID, sizeof(szAuthID));
	GetClientIP(iClient, szIP, sizeof(szIP));

	SQL_LockDatabase(g_hDataBase);
	g_hDataBase.Format(szQuery, sizeof(szQuery), "INSERT INTO `players_connections` ( `name`, `authid`, `ip`, `lastvisit` ) VALUES ( '%s', '%s', '%s', %d )", szName, szAuthID, szIP, GetTime());
	SQL_FastQuery(g_hDataBase, szQuery);
	SQL_UnlockDatabase(g_hDataBase);
}
