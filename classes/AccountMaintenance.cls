public with sharing class AccountMaintenance {
	private final Integer BATCH_SIZE = 5;
	public AccountMaintenance() {
		// for update: to update
		Async_Queue__c asq = [SELECT	Id,
										Username__c,
										Account_ID__c,
										Complete__c,
										New_Owner__c,
										Old_Owner__c
									FROM Async_Queue__c
									WHERE (Username__c = :UserInfo.getUserName()
									OR Username__c = null)
									AND Complete__c = false
									ORDER BY Id, Username__c
									NULLS LAST
									LIMIT 1];
		asq.Username__c = UserInfo.getUserName();
		update asq;	// unlock
		if(asq != null) {
			if(asq.Username__c == UserInfo.getUserName()) { // fall out after update above
				List<Contact> toModify = [SELECT Id,
										OwnerId
									FROM Contact
									WHERE AccountId = :asq.Account_ID__c
									AND OwnerId != :asq.New_Owner__c
									LIMIT :BATCH_SIZE];
				if(toModify.size() > 0) {
					for(Contact c: toModify) {
						c.OwnerId = asq.New_Owner__c;
					}
					update toModify;
				} else {
					asq.Complete__c = true;
					update asq;
				}
			}
		}
	}
}