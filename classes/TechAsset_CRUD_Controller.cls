public class TechAsset_CRUD_Controller {
	public final String USER_ERROR = 'User not authorized to modify record';
	Map<ID, Custom_User_Perms__c> userPerms;
	List<ID> users;
	
	public TechAsset_CRUD_Controller(Tech_Asset__c[] modifiedAssets){
		StoreUserIDs(modifiedAssets);
		if(this.users.size() > 0){
			
		}
	}	

	private Boolean StoreUserIDs(Tech_Asset__c[] modifiedAssets){
		Boolean results = false;
		this.users = new List<ID>();
		for(Tech_Asset__c t: modifiedAssets){
			this.users.add(t.OwnerId);
			results = true;
		}
		return results;
	}
}