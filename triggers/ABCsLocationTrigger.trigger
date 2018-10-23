trigger ABCsLocationTrigger on ABCs_Location__c (after update, after insert) {
	if (trigger.isAfter) {
		if (!System.isFuture()) {
			if (trigger.isUpdate || trigger.isInsert) {
				List<ID> recIds = new List<ID>();
				for (ABCs_Location__c al: trigger.new) recIds.add(al.Id);
				SetABCsOfTouringLocations.updateRecords(recIds);
			}
		}
	}
}