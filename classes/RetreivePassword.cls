public class RetreivePassword{
    public RetreivePassword() { }
    
    public String getPassword(String username) {
    	String pwd = '';
        Map<String, PasswordHolder__c> pwds = PasswordHolder__c.getAll();
        if(pwds.containsKey(username))
            pwd = pwds.get(username).Password__c;
        return pwd;
    }
}