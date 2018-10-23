public with sharing class MergeAccounts {
	public MergeAccounts() {
		Account masterAccount = [SELECT Id, Name FROM Account WHERE Id = :System.Label.MasterAccountID LIMIT 1];
		Account mergeAccount = [SELECT Id, Name FROM Account WHERE Id = :System.Label.MergeAccountID LIMIT 1];
		try {
			merge masterAccount mergeAccount;
		} catch (DmlException ex) {
			system.debug('the error is: ' + ex.getDmlMessage(0));
		}
	}
}