public with sharing class HierarchyTesting {
	public static testMethod void testHierarchy() {
		List<Hierarchy_Object__c> hList = new List<Hierarchy_Object__c>();
		hList.add(new Hierarchy_Object__c(Name = 'A-level.0'));										//	0
		hList.add(new Hierarchy_Object__c(Name = 'B-level.0'));										//	1
		hList.add(new Hierarchy_Object__c(Name = 'A-Level.1', Current_Parent__c = hList.get(0).Id));	//	2
		hList.add(new Hierarchy_Object__c(Name = 'B-level.1', Current_Parent__c = hList.get(1).Id));	//	3
		hList.add(new Hierarchy_Object__c(Name = 'A-level.2', Current_Parent__c = hList.get(2).Id));	//	4
		hList.add(new Hierarchy_Object__c(Name = 'A-Level.3', Current_Parent__c = hList.get(4).Id));	//	5

		insert hList;
		for(Hierarchy_Object__c h: hList) {
			System.assertNotEquals(null, h.Id);
		}
	}
}