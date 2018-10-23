public class WorkgroupAfterDelete {
	private List<String> 	memberIDList;

	public WorkgroupAfterDelete(Workgroup_Member__c[] membersToProcess){
		this.memberIDList = new List<ID>();
		setMembersToClose(membersToProcess);
		closeTimeTrackers();
	}

	private void setMembersToClose(Workgroup_Member__c[] newMembers){
		for(Workgroup_Member__c w: newMembers){
			this.memberIDList.add(w.Member_ID__c);
		}
	}

	private void closeTimeTrackers(){
		List<Time_Tracker__c> oldTrackers = new List<Time_Tracker__c>();
		List<Time_Tracker__c> tt = [SELECT Id, End_Time__c FROM Time_Tracker__c WHERE End_Time__c = null AND OwnerId IN: memberIDList];
		for(Time_Tracker__c timeT: tt){
			timeT.End_Time__c = Datetime.now();
			oldTrackers.add(timeT);
		}
		if(oldTrackers.size() > 0){
			update oldTrackers;
		}
	}
}