trigger AccountTrigger on Account (after update) {
	public static Boolean runOnce = false;
	AccountsUpdatedByTeam u = new AccountsUpdatedByTeam();
	if(!runOnce) {
		u.processObjectRecords(trigger.oldMap, trigger.newMap);
	}
}