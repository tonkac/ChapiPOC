public class UserContactSync {
	List<Contact> syncRecords;
	public UserContactSync(Contact[] oldContacts, Contact[] newContacts){
		if(fieldsUpdated(oldContacts, newContacts)){
			
		}
	}

	private Boolean fieldsUpdated(Contact[] oldContacts, Contact[] newContacts){
		Boolean results = false;
		syncRecords = new List<Contact>();
		for(integer i=0;i<newContacts.size();i++){
			Boolean changed = false;
			if(oldContacts[i].Title != newContacts[i].Title) changed = true;
			if(oldContacts[i].SFDCDepartment__c != newContacts[i].SFDCDepartment__c) changed = true;
			if(oldContacts[i].ReportsToId != newContacts[i].ReportsToId) changed = true;
			if(oldContacts[i].Phone != newContacts[i].Phone) changed = true;
			if(oldContacts[i].MailingStreet != newContacts[i].MailingStreet) changed = true;
			if(oldContacts[i].MailingState != newContacts[i].MailingState) changed = true;
			if(oldContacts[i].MailingPostalCode != newContacts[i].MailingPostalCode) changed = true;
			if(oldContacts[i].MailingCountry != newContacts[i].MailingCountry) changed = true;
			if(oldContacts[i].MailingCity != newContacts[i].MailingCity) changed = true;
			if(oldContacts[i].Employee_ID__c != newContacts[i].Employee_ID__c) changed = true;
			if(oldContacts[i].Division__c != newContacts[i].Division__c) changed = true;
			if(oldContacts[i].AccountId != newContacts[i].AccountId) changed = true;
			
			if(changed){
				syncRecords.add(newContacts[i]);
			}
		}

		return results;
	}
}