trigger maxNumberOfDepartments on Contact (before insert, before update) {
    for(Contact c: trigger.new) {
        if(c.Department__c.countMatches(';') > 2) c.Department__c.addError('Limit to three values');
    }
}