public class WorkgroupTestMethod {
	public static testMethod void testingWorkgroupMembers(){
		WorkgroupBeforeInsert wbi	= new WorkgroupBeforeInsert();
		String userName 			= UserInfo.getName();
		ID userID 					= UserInfo.getUserId();
		List<String> WorkgroupList	= new List<String>();

		//	Get workgroup names
		List<Schema.PicklistEntry> f = Schema.sObjectType.Workgroup_Member__c.Fields.Workgroup__c.getPicklistValues();

		for(Integer i=0;i<f.size();i++){
			if(f[i].Active){
				WorkgroupList.add(f[i].Label);
			}
		}

		//	Member rejected due to name not found
		Workgroup_Member__c newMember = new Workgroup_Member__c(Member_Name__c = userName + 'x', Workgroup__c = WorkgroupList.get(0));
		try{
			insert newMember;
			System.assert(false);
		} catch (System.DmlException e) {
			System.assertEquals(newMember.id, null);
			System.assert(e.getNumDml() == 1);
			System.assert(e.getDmlIndex(0) == 0);
			System.assert(e.getDmlFields(0).size() == 1);
			System.assert(e.getDmlFields(0)[0] == Workgroup_Member__c.Member_Name__c);
			System.assert(e.getDmlMessage(0).indexOf(wbi.VALUE_NOT_FOUND) > -1);
		}

		//	Correct name and create them without error
		newMember.Member_Name__c = userName;
		insert newMember;
		System.assertNotEquals(null, newMember.Id);
		
		Integer numCases = [SELECT count() FROM Case WHERE OwnerId = :userID AND isClosed = FALSE];
		Integer numTrackers = [SELECT count() FROM Time_Tracker__c WHERE Member__c = :userName AND End_Time__c = null];
		System.assertEquals(numCases, numTrackers);

		delete newMember;
		numTrackers = [SELECT count() FROM Time_Tracker__c WHERE Member__c = :userName AND End_Time__c = null];
		System.assertEquals(0, numTrackers);
		
		Workgroup_Member__c[] queueMembers = [SELECT Member_Id__c FROM Workgroup_Member__c WHERE Member_Id__c LIKE '00G%'];
		List<String> queueIds = new List<String>();
		for(Workgroup_Member__c q: queueMembers){
			queueIds.add(q.Member_Id__c);
		}
		QueueSobject caseQueue = [SELECT SobjectType, QueueId FROM QueueSobject WHERE SobjectType = 'Case' AND QueueId NOT IN: queueIds LIMIT 1];
		Group gp = [SELECT Name, Id FROM Group WHERE Id = :caseQueue.QueueId];
		Workgroup_Member__c qMember = new Workgroup_Member__c(Member_Name__c = gp.Name , Workgroup__c = WorkgroupList.get(0));
		insert qMember;
		numCases = [SELECT count() FROM Case WHERE OwnerId = :caseQueue.Id AND isClosed = FALSE];
		numTrackers = [SELECT count() FROM Time_Tracker__c WHERE Member__c = :caseQueue.Id AND End_Time__c = null];
		
		System.debug('num cases: num trackers' + caseQueue.QueueId);
	}
}