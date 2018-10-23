public with sharing class Cal_day {
	private Date day = null;
	private List<Release_Event__c> releases = new List<Release_Event__c>();
	private Integer numEvents = 0;
	private Integer currEvent = 0;
	
	public Cal_day(Date day) {
		this.day = day;
	}
	
	public Boolean addRelease(Release_Event__c event) {
		Integer cnt = releases.size();
		if(event.Release_Date__c == day) {
			if(releases.size() == 0) {
				releases.add(event);
			} else {
				for(Integer i=0;i<releases.size();i++) {
					if(releases.get(i).Release_Date__c > event.Release_Date__c) {
						releases.add(i,event);
					}
				}
			}
		}
		if(releases.size() > cnt) return true;
		else return false;
	}

	public String getDate() {
		if(day != null) return day.format();
		else return null;
	}
}