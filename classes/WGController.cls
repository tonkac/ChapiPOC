public class WGController {

	Workgroup_Member__c member;
	private List<String> errorMessageList = new List<String>();
	
    public WGController(ApexPages.StandardController controller) {
    	
	}

	public void setErrorMessage(String msg){
		this.errorMessageList.add(msg);
	}

	public Workgroup_Member__c getMember(){
		if(System.currentPageReference().getParameters().get('id') != null){
			member = [SELECT Workgroup__c, Member_Name__c, Member_ID__c, Id FROM Workgroup_Member__c WHERE id = :System.currentPageReference().getParameters().get('id')];
		} else {
			member = new Workgroup_Member__c();
		}
		return member;
	}

	public String getErrorMessage(){
		String message = '';
		for(Integer i=0;i < errorMessageList.size();i++){
			message += (errorMessageList[i] + '<br>');
		}
		return message;
	}

	public PageReference newSave(){
		try{
			insert member;
			PageReference returnPage= new PageReference('/' + member.Id);
			returnPage.setRedirect(true);
			return returnPage;
		} catch (DmlException e){
			setErrorMessage(e.getMessage());
			return null;
		}
	}

	public PageReference newSaveAndNew(){
		try{
			insert member;
			Schema.DescribeSObjectResult c = Workgroup_Member__c.sObjectType.getDescribe();
			String prefix = c.getKeyPrefix();
			PageReference returnPage= new PageReference('/' + prefix + '/e?');
			returnPage.setRedirect(true);
			return returnPage;
		} catch (DmlException e){
			setErrorMessage(e.getMessage());
			return null;
		}
	}

	public PageReference newDelete(){
		delete member;
		Schema.DescribeSObjectResult c = Workgroup_Member__c.sObjectType.getDescribe();
		String prefix = c.getKeyPrefix();
		PageReference returnPage= new PageReference('/' + prefix + '/o?');
		returnPage.setRedirect(true);
		return returnPage;
	}
}