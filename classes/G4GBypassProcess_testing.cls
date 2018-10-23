/*
 * RelEng Perforce/RCS Header - Do not remove!
 *
 * $Author: asudhir $
 * $Change: 1765754 $
 * $DateTime: 2011/05/10 11:22:15 $
 * $File: //it/applications/supportforce/prod/src/classes/Batch_closeTimeTrackers.cls $
 * $Id: //it/applications/supportforce/prod/src/classes/Batch_closeTimeTrackers.cls#2 $
 * $Revision: #2 $
 */

	/*
	*	Class processes the tests for the G4G (Fast-Start) bypass feature. If the bypass enabled
	*		and the user saving the record is an associated bypass member, it will bypass normal code.
	*		This should not be used when running day to day processes as this is build to
	*		make the ownership of records quicker than currently seen.
	*		@Author: Chris Reinke
	*
	*		@System.Label.G4G_enableBypass - should be FALSE
	*		@G4G_usersForBypass__c (custom setting) - should not include the current user
	*/

public with sharing class G4GBypassProcess_testing {

	public static testMethod void G4GBypassProcess_testing() {
		Integer startNum;
		Integer endNum;
		Integer numDigits;
		String pattern;

		//	Test will not run unless the Custom Setting has the values it needs
		if(G4GTriggerBypassSettings__c.getInstance('Account Spark') != null) {
			//	Get custom setting with fields
			G4GTriggerBypassSettings__c settings = G4GTriggerBypassSettings__c.getInstance('Account Spark');

			//	Setup the values to use during test
			startNum = Integer.valueOf(settings.Start_Number__c);
			endNum = Integer.valueOf(settings.End_Number__c);
			numDigits = Integer.valueOf(settings.Number_of_Digits__c);
			pattern = settings.Username_Pattern__c;

			//	Use the custom setting's information to setup an email that will match it
			Integer startPoint = pattern.indexOf('X');
			String prefix = pattern.substring(0,startPoint);
			String postfix = pattern.substring((startPoint + numDigits), pattern.length());
			system.assert(startNum + 5 <= endNum);
			String testNumber = String.valueOf(startNum + 5);
			for(Integer i=testNumber.length();i<numDigits;i++) {
				testNumber = '0' + testNumber;
			}

			//	Create the email to be used by test user
			String testEmail = prefix + testNumber + postfix;
			User testUser = new User(
							Username = testEmail,
							IsActive = true,
							Email = testEmail,
							LastName = 'lName',
							FirstName = 'fName',
							Alias = 'alias',
							TimeZoneSidKey = 'America/Los_Angeles',
							LocaleSidKey = 'en_US',
							EmailEncodingKey = 'ISO-8859-1',
							ProfileId = UserInfo.getProfileId(),
							LanguageLocaleKey = 'en_US');

			//	Create the bypass process object to control if code is processed
			G4GBypassProcess g = new G4GBypassProcess();

			//	Run through the default setting of the Custom Label and Custom Settings. This will only pass
			//		if the Custom Label is set to FALSE and the current user is NOT in the custom settings.
			system.assertEquals(g.isBypassEnabled(),Feature_Manager__c.getInstance('TEAM TriggerBypass').Active__c);
			system.assert(!g.isBypassUser());

			system.runAs(testUser) {
				//	This method will setup the object to simulate a bypass situation. This is done only if the
				//		current call to it is ran in a test mode. If the call is from a standard call there will
				//		be no changes to the class. This will prevent the code from going in to simulation mode
				//		during the normal day.
				system.assertEquals(g.isBypassEnabled(), Feature_Manager__c.getInstance('TEAM TriggerBypass').Active__c);
				system.assert(g.isBypassUser());
			}
		}
	}
}