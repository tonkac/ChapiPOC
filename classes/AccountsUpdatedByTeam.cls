public class AccountsUpdatedByTeam {
	public static Boolean hasRun = false;
	
	public AccountsUpdatedByTeam() { }
	
	public void processObjectRecords(Map<ID, Account> oldRecords, Map<ID, Account> newRecords) {
		if(!hasRun) {
			List<ID> modAccounts = new List<ID>();
			Account acc = new Account();
	        for(ID o: oldRecords.keySet()) {
	            if(oldRecords.get(o).getSObjectType() == acc.getsObjectType()) {
	                if((oldRecords.get(o).get('OwnerId') != newRecords.get(o).get('OwnerId')) ||
	                	(oldRecords.get(o).Data_Quality_Update__c != newRecords.get(o).Data_Quality_Update__c) ||
	                	(oldRecords.get(o).Named_Owner__c != newRecords.get(o).Named_Owner__c)) {
	                    modAccounts.add(newRecords.get(o).Id);
	                }
	            }
	        }
	        updateAccounts(modAccounts);
		}
		hasRun = true;
    }

	@future
    public static void updateAccounts(List<ID> accIDs) {
    	if(!hasRun) {
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
			hasRun = true;
    	}
    }
}