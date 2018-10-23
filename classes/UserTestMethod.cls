public class UserTestMethod {
	public static testMethod void UserTestMethod(){
		WGUserBeforeDelete ubu = new WGUserBeforeDelete();
		Workgroup_Member__c testMember ;
		User u = [SELECT FirstName, LastName, Alias, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey FROM User WHERE IsActive = TRUE AND Id != :UserInfo.getUserId() LIMIT 1];
		User newTestUser = new User(FirstName = 'test', LastName = 'tester', username = 'test@test794613215487895623.com', email = 'test@test.com', Alias = u.Alias, TimeZoneSidKey = u.TimeZoneSidKey, LocaleSidKey = u.LocaleSidKey, EmailEncodingKey = u.EmailEncodingKey, ProfileId = u.ProfileId, LanguageLocaleKey = u.LanguageLocaleKey);
		insert newTestUser;
		System.assertNotEquals(null, newTestUser.id);
		Integer numWGMs = [SELECT count() FROM Workgroup_Member__c WHERE Member_ID__c = :newTestUser.Id];
		if(numWGMs == 0){
			//	Get workgroup names
			List<String> WorkgroupList	= new List<String>();
			List<Schema.PicklistEntry> f = Schema.sObjectType.Workgroup_Member__c.Fields.Workgroup__c.getPicklistValues();
	
			for(Integer i=0;i<f.size();i++){
				if(f[i].Active){
					WorkgroupList.add(f[i].Label);
				}
			}
			testMember = new Workgroup_Member__c(Member_Name__c = newTestUser.FirstName + ' ' + newTestUser.LastName, Workgroup__c = WorkgroupList[0]);
			insert testMember;
			System.assertNotEquals(testMember.Id, null);
		}

		newTestUser.IsActive = false;
		try{
			update newTestUser;
			System.assert(false);
		} catch (System.DmlException e) {
			System.debug('errors are these: ' + e);
			System.assert(e.getNumDml() == 1);
			System.assert(e.getDmlIndex(0) == 0);
			//System.assert(e.getDmlFields(0).size() == 1);
			//System.assert(e.getDmlFields(0)[0] == User.IsActive);
			System.assert(e.getDmlMessage(0).indexOf(ubu.ERROR_MEMBER_WORKGROUP) > -1);
		}
	}
}