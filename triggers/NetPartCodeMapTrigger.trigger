trigger NetPartCodeMapTrigger on Net_Part_Code_Map__c (before insert, before update, before delete, 
after insert, after update, after delete, after undelete) {
	if(trigger.isBefore){
		if(trigger.isInsert || trigger.isUpdate){
			NetPartCodeUnique npcu = new NetPartCodeUnique(trigger.new);
		}
	}
}