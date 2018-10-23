@IsTest
public class RetreivePassword_test{
	public static testMethod void RetreivePassword_test() {
		PasswordHolder__c ph = new PasswordHolder__c(Name = 'test01', Password__c = 'pwd');
		insert ph;
		RetreivePassword rp = new RetreivePassword();
		system.assertEquals(rp.getPassword('test01'), 'pwd');
	}
}