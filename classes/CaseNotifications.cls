/*
 * RelEng Perforce/RCS Header - Do not remove!
 *
 * $Author: gmalik $
 * $Change: 2792563 $
 * $DateTime: 2012/08/14 15:24:38 $
 * $File: //it/applications/supportforce/prod/src/classes/LifeCycle_projectCode.cls $
 * $Id: //it/applications/supportforce/prod/src/classes/LifeCycle_projectCode.cls#3 $
 * $Revision: #3 $
 */

	/*
	*	Feature is designed to send notifications to the contacts and users
	*		that are associated with a specific case.
	*/
public class CaseNotifications {
	private final String BASE_URL = 'www.salesforce.com';//System.label.Base_URL;

	/*
	*	Send emails to both Contacts and Owners of Cases. Can be called using either of the
	*		public functions: sendEmailMessage() and sendOwnerNotification().
	*/
	public CaseNotifications() {
		//if(System.label.Base_URL == null) BASE_URL = 'https://na5.salesforce.com/';
		System.debug('before the call');
		innerClass i = new innerClass();
		System.debug('inner class is passed');
	}

	/*
	*	This is used when sending an email to the Contact associated with Case
	*		@param: whatId - ID of the Case and populates the merge fields
	*		@param: targetId - ID of the related Contact for this instance
	*		@param: templateId - ID of the email template to be used
	*/
	public Boolean sendEmailMessage(ID targetId, ID templateId, ID whatId){
		Boolean errorOccurred = false;
		Messaging.SingleEmailMessage  mail = new Messaging.SingleEmailMessage();
		if(targetId != null) mail.setTargetObjectId(targetId);
		if(whatId != null) mail.setWhatId(whatId);
		if(templateId != null) mail.setTemplateId(templateId);
		mail.setUseSignature(true);
		mail.setSaveAsActivity(true);
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail } );
		return errorOccurred;
	}

	/*
	*	Send an email to the Owner of a Case. Requires the following:
	*		@param: emailAddresses - List of email addresses to be sent to
	*		@param: currentCase - The Case that is being updated and notified
	*/
	public boolean sendOwnerNotification(List<String> emailAddresses, Case currentCase){
		Boolean errorOccurred = false;
		Messaging.SingleEmailMessage  mail = new Messaging.SingleEmailMessage();
		if(emailAddresses.size() > 0) mail.setToAddresses(emailAddresses);
		mail.setSubject('Case: ' + currentCase.CaseNumber + ' has been assigned to you.');
		String subject = 'You have been assigned the following Case: <br><br>';
		subject += 'Case: ' + currentCase.CaseNumber + '<br>';
		subject += 'Subject: ' + currentCase.Subject + '<br>';
		subject += 'Description: ' + currentCase.Description + '<br>';
		//subject += 'Case Link: <a href="'+ BASE_URL + '/' + currentCase.Id + '">' + BASE_URL + '/' + currentCase.Id + '</a>';
		mail.setHtmlBody(subject);
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		return errorOccurred;
	}

	public without sharing class innerClass {

		public innerClass() {
			System.debug('I am in the inner class!');
		}
	}
}