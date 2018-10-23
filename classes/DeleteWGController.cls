public class DeleteWGController {

	public Workgroup_Member__c member;

    public DeleteWGController(ApexPages.StandardController controller) {
    	populateMember();
	}

	public Workgroup_Member__c getMember() {
			return member;
	}

	public void populateMember(){
		member = [SELECT Workgroup__c, Member_Name__c, Member_ID__c, Id FROM Workgroup_Member__c WHERE id = :System.currentPageReference().getParameters().get('id')];
	}

	public PageReference newDelete(){
		delete member;
		Schema.DescribeSObjectResult c = Workgroup_Member__c.sObjectType.getDescribe();
		String prefix = c.getKeyPrefix();
		PageReference returnPage= new PageReference('/' + prefix + '/o?');
		returnPage.setRedirect(true);
		return returnPage;
	}
	
	public PageReference edit(){
		PageReference returnPage= new PageReference('/' + member.Id + '/e?');
		returnPage.setRedirect(true);
		return returnPage;
	}
}