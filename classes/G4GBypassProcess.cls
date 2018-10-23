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
 *	This class is to be used during the Fast-Start process. Any triggers calling this class
 *		will only be bypassing code if a the bypass custom setting is set to true
 *		AND the user saving the record has a username that is similar to the Pattern
 *		in the custom setting.
 *		@Author: Chris Reinke
 */
public with sharing class G4GBypassProcess {
	//	Get the value that is stored in th
	private Boolean bypassEnabled;
	private static String PATTERN;
	private static Integer START_NUM;
	private static Integer END_NUM;
	private static Integer NUMBER_OF_DIGITS;

    /*
    *	Construct the class. If the bypass enabled or bypass users are not populated they
    *		will return settings that will prevent the feature from working.
    */
	public G4GBypassProcess() {
        if (Feature_Manager__c.getInstance('TEAM TriggerBypass') != null &&
            Feature_Manager__c.getInstance('TEAM TriggerBypass').Active__c) {
                bypassEnabled = true;
        } else bypassEnabled = false;

		if (G4GTriggerBypassSettings__c.getInstance('Account Spark') != null) {
			PATTERN = G4GTriggerBypassSettings__c.getInstance('Account Spark').Username_Pattern__c;
			START_NUM = G4GTriggerBypassSettings__c.getInstance('Account Spark').Start_Number__c.intValue();
			END_NUM = G4GTriggerBypassSettings__c.getInstance('Account Spark').End_Number__c.intValue();
			NUMBER_OF_DIGITS = G4GTriggerBypassSettings__c.getInstance('Account Spark').Number_of_Digits__c.intValue();
		}
	}

    /*
    *	This will compare a Running User's ID with a pattern that the API Usernames should match
    */
	public Boolean isBypassUser() {
		if(UserInfo.getUserName().getLevenshteinDistance(PATTERN) == NUMBER_OF_DIGITS) {
			Integer startLocation = UserInfo.getUserName().indexOfDifference(PATTERN);
			if(UserInfo.getUserName().substring(startLocation, startLocation + NUMBER_OF_DIGITS).isNumeric()) {
				if (Integer.valueOf(UserInfo.getUserName().substring(startLocation, startLocation + NUMBER_OF_DIGITS)) >= START_NUM &&
					Integer.valueOf(UserInfo.getUserName().substring(startLocation, startLocation + NUMBER_OF_DIGITS)) <= END_NUM)
					return true;
				else return false;
			} else return false;
		} else return false;
	}

    /*
    *	Return true if the bypass is enabled
    */
	public Boolean isBypassEnabled() { return this.bypassEnabled; }
}