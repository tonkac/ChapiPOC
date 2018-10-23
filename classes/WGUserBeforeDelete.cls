public class WGUserBeforeDelete {
	private List<ID> userIds;
	public final String ERROR_MEMBER_WORKGROUP = 'User is a member of a Workgroup. Delete Workgroup Member before deactivating user.';

	public WGUserBeforeDelete(User[] userList){
		if(userToDeactivated(userList)){
			if(getWorkgroupMembers()){
				setErrors(userList);
			}
		}
	}

	public WGUserBeforeDelete(){

	}

	private boolean userToDeactivated(User[] userList){
		boolean results = false;
		this.userIds = new List<ID>();
		
		for(User u: userList){
			if(!u.IsActive){
				this.userIds.add(u.Id);
			}
		}
		
		if(userIds.size() > 0){
			results = true;
		}
		
		return results;
	}

	private boolean getWorkgroupMembers(){
		List<ID> tempList = new List<ID>();
		boolean results = false;
		for(Workgroup_Member__c w: [SELECT Member_ID__c FROM Workgroup_Member__c WHERE Member_ID__c IN : this.userIds]){
			tempList.add(w.Member_ID__c);
		}
		if(tempList.size() > 0){
			this.userIds = tempList;
			results = true;
		} else {
			this.userIds.clear();
		}
		return results;
	}

	private void setErrors(User[] userList){
		for(User u: userList){
			for(Integer i = 0;i < this.userIds.size();i++){
				if(u.Id == this.userIds[i]){
					u.IsActive.addError(ERROR_MEMBER_WORKGROUP);
				}
			}
		}
	}
}