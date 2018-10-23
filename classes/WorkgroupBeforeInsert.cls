public class WorkgroupBeforeInsert {
	private List<String> 	memberNames;
	private Map<String,ID> 	memberIDMap;
	public final String VALUE_NOT_FOUND		= 'Member Not User or Queue';

	public WorkgroupBeforeInsert(Workgroup_Member__c[] membersToProcess){
		storeNames(membersToProcess);
		getMemberIds();
		setMemberIds(membersToProcess);
	}

	public WorkgroupBeforeInsert(){
		
	}

	private void storeNames(Workgroup_Member__c[] membersToProcess){
		this.memberNames = new List<String>();
		for(Workgroup_Member__c w: membersToProcess){
			this.memberNames.add(w.Member_Name__c);
		}
	}

	private void getMemberIds(){
		this.memberIDMap = new Map<String, ID>();
		for(User u: [SELECT Name, Id FROM User WHERE Name IN: this.memberNames AND IsActive = TRUE]){
			this.memberIDMap.put(u.Name, u.Id);
		}
		for(Group g: [SELECT Type, Name, Id FROM Group WHERE Name IN: this.memberNames]){
			this.memberIDMap.put(g.Name, g.Id);
		}
	}

	private void setMemberIds(Workgroup_Member__c[] membersToProcess){
		ID thisId;
		for(Workgroup_Member__c wm : membersToProcess){
			thisId = this.memberIDMap.get(wm.Member_Name__c);
			if(thisId == null){
				wm.Member_Name__c.addError(VALUE_NOT_FOUND);
			} else {
				wm.Member_ID__c = thisId;
			}
		}
	}
}