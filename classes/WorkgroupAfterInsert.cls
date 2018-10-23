public class WorkgroupAfterInsert {
	public List<String> 	memberIDList;
	private Map<ID, Workgroup_Member__c> workgroupMembers;

	public WorkgroupAfterInsert(Workgroup_Member__c[] membersToProcess){
		this.memberIDList = new List<ID>();
		setMembers(membersToProcess);
		createTimeTrackers();
	}

	private void setMembers(Workgroup_Member__c[] newMembers){
		this.workgroupMembers = new Map<ID, Workgroup_Member__c>();
		for(Workgroup_Member__c w: newMembers){
			this.memberIDList.add(w.Member_ID__c);
			this.workgroupMembers.put(w.Member_ID__c, w);
		}
	}

	private void createTimeTrackers(){
		List<Time_Tracker__c> newTrackers = new List<Time_Tracker__c>();
		Case[] caseList = [SELECT Id, OwnerId FROM Case WHERE IsClosed = FALSE AND OwnerId IN: this.memberIDList];
		for(Case c: caseList){
			Time_Tracker__c thisTracker = new Time_Tracker__c();
			thisTracker.Case__c = c.Id;
			thisTracker.Start_Time__c = Datetime.now();
			thisTracker.Member__c = this.workgroupMembers.get(c.OwnerId).Member_Name__c;
			thisTracker.Workgroup__c = this.workgroupMembers.get(c.OwnerId).Workgroup__c;
			newTrackers.add(thisTracker);
			System.debug('newTrackers size = ' + newTrackers.size());
		}
		if(newTrackers.size() > 0){
			System.debug('after the newtracker > 0 ' + newTrackers.size());
			insert newTrackers;
		}
	}
}