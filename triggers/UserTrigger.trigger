trigger UserTrigger on User (before insert, before update, before delete, 
after insert, after update, after delete, after undelete) {
	if(trigger.isBefore){
		if(trigger.isDelete){
			WGUserBeforeDelete UBU = new WGUserBeforeDelete(trigger.old);
		}
	}
}