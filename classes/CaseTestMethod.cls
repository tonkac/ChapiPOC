public class CaseTestMethod {
	public static testMethod void testCaseProcess(){
		List<String> WorkgroupList	= new List<String>();

		//	Query a user and a queue from the Workgroup Member object
		//
		//		REQUIRED:	An 'User' workgroup member
		//						A 'Queue' workgroup member
		
		//	Get workgroup names
		List<Schema.PicklistEntry> f = Schema.sObjectType.Workgroup_Member__c.Fields.Workgroup__c.getPicklistValues();

		for(Integer i=0;i<f.size();i++){
			if(f[i].Active){
				WorkgroupList.add(f[i].Label);
			}
		}

		//	Create user member
		Workgroup_Member__c userMember = [SELECT Workgroup__c,
								Member_Name__c,
								Member_ID__c
								FROM Workgroup_Member__c WHERE Member_ID__c LIKE '005%' LIMIT 1];

		//	Create a queue member
		QueueSobject queueFind = [SELECT SobjectType, QueueId FROM QueueSobject WHERE SobjectType = 'Case' LIMIT 1];
		Group getQueue = [SELECT Name, Id FROM Group WHERE Id = :queueFind.QueueId];

		Workgroup_Member__c queueMember = new Workgroup_Member__c(Member_Name__c = getQueue.Name, Workgroup__c = WorkgroupList[0]);
		insert queueMember;
		System.assertNotEquals(null, queueMember.Id);
		System.debug('Output information: ' + queueMember.Id);
		//Workgroup_Member__c getMember = [SELECT Member_ID__c FROM Workgroup_Member__c WHERE Id = :queueMember.Id];
		//System.assertEquals(getMember.Member_ID__c, queueFind.QueueId);

		//	Create a new 'User' from user processing test. User processing the test
		//		cannot be a workgroup member at the time of testing.
		User origUser = [SELECT Username,
								LastName,
								FirstName,
								Email,
								ProfileId,
								UserRoleId,
								TimeZoneSidKey,
								LocaleSidKey,
								EmailEncodingKey,
								LanguageLocaleKey 
								FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1]; 
		User userNonMember = new User(LanguageLocaleKey = origUser.LanguageLocaleKey,
								EmailEncodingKey = origUser.EmailEncodingKey,
								LocaleSidKey = origUser.LocaleSidKey,
								TimeZoneSidKey = origUser.TimeZoneSidKey,
								FirstName = origUser.FirstName,
								LastName = origUser.LastName + '.test',
								Alias = 'testAlias',
								Username = origUser.Username + '.test',
								Email = origUser.Email,
								ProfileId = origUser.ProfileId,
								UserRoleId = origUser.UserRoleId,
								IsActive = true);
		insert userNonMember;

System.debug('Member ID: ' + userMember.Member_ID__c);
		//	Create a new case that is owned by an existing workgroup member
		Case testCase = new Case(OwnerId = userMember.Member_ID__c, Status = 'New', Subject = 'Testing', Description = 'Testing');
		insert testCase;
		System.assertNotEquals(testCase.Id, null);

		//	Find out how many time trackers are created for the new case
		//
		//		EXPECTED:	to have one time tracker attached to the case associated
		//					with the user assigned case
		Time_Tracker__c[] allTrackers = [SELECT Workgroup__c, Status__c, End_Time__c, Case__c From Time_Tracker__c WHERE Case__c = :testCase.Id ORDER BY Status__c DESC];
		System.assertEquals(allTrackers.size(), 1);
		System.assertEquals(allTrackers[0].Workgroup__c, userMember.Workgroup__c);
		System.assertEquals(allTrackers[0].Status__c, 'Open');
		System.assertEquals(allTrackers[0].Case__c, testCase.Id);
		
		//	Test transferring the case to a Non-Member
		//
		//		EXPECTED:	to close any open time trackers associated with the case
		System.assertNotEquals(userNonMember.Id, null);
		testCase.OwnerId = userNonMember.Id;
		update testCase;
		System.assertEquals(testCase.OwnerId, userNonMember.Id);
		
		allTrackers = [SELECT Workgroup__c, Status__c, End_Time__c, Case__c From Time_Tracker__c WHERE Case__c = :testCase.Id ORDER BY Status__c DESC];
		System.assertEquals(allTrackers.size(), 1);
		System.assertEquals(allTrackers[0].Workgroup__c, userMember.Workgroup__c);
		System.assertEquals(allTrackers[0].Status__c, 'Closed');
		System.assertEquals(allTrackers[0].Case__c, testCase.Id);
		
		//	Reopen case that does not belong to a case owner
		testCase.Status = 'New';
		update testCase;
		Case getCase = [SELECT Id, Status, IsClosed FROM Case WHERE Id = :testCase.Id];
		System.assertEquals(getCase.IsClosed, false);
		allTrackers = [SELECT Workgroup__c, Status__c, End_Time__c, Case__c From Time_Tracker__c WHERE Case__c = :testCase.Id ORDER BY Status__c DESC];
		System.assertEquals(1, allTrackers.size());

		//	Transfer open case to a workgroup member
		testCase.OwnerId = userMember.Member_ID__c;
		update testCase;
		allTrackers = [SELECT Workgroup__c, Status__c, End_Time__c, Case__c From Time_Tracker__c WHERE Case__c = :testCase.Id ORDER BY Status__c DESC];
		System.assertEquals(2, allTrackers.size());
		System.assertEquals(userMember.Workgroup__c, allTrackers[0].Workgroup__c);
		System.assertEquals('Open', allTrackers[0].Status__c);
		System.assertEquals(testCase.Id, allTrackers[0].Case__c);
		
		//	Test closing case owned by member
		testCase.Status = 'Closed';
		update testCase;
		
		allTrackers = [SELECT Workgroup__c, Status__c, End_Time__c, Case__c From Time_Tracker__c WHERE Case__c = :testCase.Id ORDER BY Status__c DESC];
		System.assertEquals(allTrackers.size(), 2);
		System.assertEquals(allTrackers[0].Workgroup__c, userMember.Workgroup__c);
		System.assertEquals(allTrackers[0].Status__c, 'Closed');
		System.assertNotEquals(allTrackers[0].End_Time__c, null);
		System.assertEquals(allTrackers[0].Case__c, testCase.Id);
		
		//	Test reopening case owned by member
		testCase.Status = 'New';
		testCase.OwnerId = userMember.Member_ID__c;
		update testCase;
		getCase = [SELECT Id, Status, IsClosed, OwnerId FROM Case WHERE Id = :testCase.Id];
		System.assertEquals(getCase.IsClosed, false);
		System.assertEquals(userMember.Member_ID__c, getCase.OwnerId);

		allTrackers = [SELECT Workgroup__c, Status__c, End_Time__c, Case__c From Time_Tracker__c WHERE Case__c = :getCase.Id ORDER BY Status__c DESC];
		System.assertEquals(allTrackers.size(), 3);
		System.assertEquals(allTrackers[0].Workgroup__c, userMember.Workgroup__c);
		System.assertEquals(allTrackers[0].Status__c, 'Open');
		System.assertEquals(allTrackers[0].Case__c, testCase.Id);

		//	Test deletion of a case
		delete testCase;

		allTrackers = [SELECT Workgroup__c, Status__c, End_Time__c, Case__c From Time_Tracker__c WHERE Case__c = null ORDER BY Status__c DESC];
		System.assertEquals(allTrackers[0].Workgroup__c, userMember.Workgroup__c);
		System.assertNotEquals(allTrackers[0].End_Time__c, Datetime.now());
		for(Time_Tracker__c t: allTrackers){
			System.assertEquals(t.Status__c, 'Closed');
			System.assertNotEquals(t.End_Time__c, null);
			System.assertEquals(t.Case__c, null);
		}
	}
}