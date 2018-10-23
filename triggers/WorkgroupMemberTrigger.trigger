trigger WorkgroupMemberTrigger on Workgroup_Member__c (before insert, before update, before delete, 
after insert, after update, after delete, after undelete) {

	if(trigger.isBefore){
		if(trigger.isInsert){
			WorkgroupBeforeInsert newMembers = new WorkgroupBeforeInsert(trigger.new);
		}
	}

	if(trigger.isAfter){
		if(trigger.isInsert){
			//	create timeTrackers for all open cases
			WorkgroupAfterInsert newMembers = new WorkgroupAfterInsert(trigger.new);
		}

		if(trigger.isDelete){
			//	close timetrackers for all open cases
			WorkgroupAfterDelete oldMembers = new WorkgroupAfterDelete(trigger.old);
		}
	}
}