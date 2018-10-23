public with sharing class future_teamAssignedChange {
    public future_teamAssignedChange() { }

    @future
    public static void updateAccounts(List<ID> accIDs) {
		Account acc = new Account();
		List<Account> changedAccounts = new List<Account>();
		system.debug('accounts are: ' + accIDs.size());
		if(accIDs.size() > 0) {
			for(ID i: accIDs) {
				acc = new Account(Id = i);
				acc.Account_Updated__c = true;
				changedAccounts.add(acc);
			}
	        try {
	            update changedAccounts;
	        } catch (DmlException ex) {
	            system.debug('error is: ' + ex);
	        }
		}
    }

}