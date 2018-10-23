public with sharing class AbcsDaoSettings {
	public static Map<String,locationTypes__c> getLocationTypes () {
		return locationTypes__c.getAll();
	}
}