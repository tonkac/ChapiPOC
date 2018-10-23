public class UniqueUsernames {
	public static void checkUsernames(Customer_Login__c[] usnList, Customer_Login__c[] trgList){
		for(Customer_Login__c x : trgList){
			if(x.Active__c){
				for(Customer_Login__c y : usnList){
					if((y.Username__c == x.Username__c && y.Sandbox_Login__c == x.Sandbox_Login__c) && x.Id != y.Id){
						x.Username__c.addError('Duplicate found');
					}
				}
			}
		}
	}
	
	public static testMethod void testUniqueUNames(){
		
		// Make sure there are not any records with these usernames in the system.
		
		Set<String> testUsernames = new Set<String>();
		testUsernames.add('test1@testcompany.com');
		testUsernames.add('test2@testcompany.com');
		testUsernames.add('test3@testcompany.com');
		testUsernames.add('test4@testcompany.com');
		System.assert([SELECT count() FROM Customer_Login__c WHERE Username__c IN : testUsernames] == 0);
		
		// Create three customer logins without error
		
		Customer_Login__c cLogin1 = new Customer_Login__c(Name = 'Company 1', Active__c = true, Username__c = 'test1@testcompany.com', PW2__c = 'A');
		Customer_Login__c cLogin2 = new Customer_Login__c(Name = 'Company 2', Active__c = true, Username__c = 'test2@testcompany.com', PW2__c = 'A');
		Customer_Login__c cLogin3 = new Customer_Login__c(Name = 'Company 3', Active__c = true, Username__c = 'test3@testcompany.com', PW2__c = 'A');
		Customer_Login__c[] nonDups = new Customer_Login__c[] {cLogin1, cLogin2, cLogin3};
		insert nonDups;
		
		// Update usernames without error
		
		cLogin2.Username__c = 'test2@testcompany.com';
		cLogin3.Username__c = 'test3@testcompany.com';
		update nonDups;
		
		// Change username to a duplicate and attempt to update
		
		cLogin3.Username__c = 'test2@testcompany.com';
		try {
			update cLogin3;
			System.assert(false);
		} catch (System.DmlException e) {
			System.assert(e.getNumDml() == 1);
			System.assert(e.getDmlIndex(0) == 0);
			System.assert(e.getDmlFields(0).size() == 1);
			System.assert(e.getDmlFields(0)[0] == 'Username__c');
			System.assert(e.getDmlMessage(0).indexOf('Duplicate found') > -1);
		}
		
		// Test the creation of a duplicate customer login
		
		Customer_Login__c cLogin4 = new Customer_Login__c(Name = 'Company 4', Active__c = true, Username__c = 'test3@testcompany.com', PW2__c = 'A');
		try {
			insert cLogin4;
			System.assert(false);
		} catch (System.DmlException e) {
			System.assert(e.getNumDml() == 1);
			System.assert(e.getDmlIndex(0) == 0);
			System.assert(e.getDmlFields(0).size() == 1);
			System.assert(e.getDmlFields(0)[0] == 'Username__c');
			System.assert(e.getDmlMessage(0).indexOf('Duplicate found') > -1);
		}
		
		
	}
}