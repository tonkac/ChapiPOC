trigger validateUsername on Customer_Login__c (before insert, before update) {
	
	Customer_Login__c[] usnList = [SELECT Id, Username__c, Sandbox_Login__c,Active__c FROM Customer_Login__c c WHERE Active__c = TRUE];
	UniqueUsernames.checkUsernames(usnList, Trigger.new);
}