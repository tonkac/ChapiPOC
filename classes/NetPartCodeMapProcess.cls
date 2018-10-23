public class NetPartCodeMapProcess {
	private List<Tech_Asset__c> recordsToUpdate;
	private Map<String, String> NetPartCodes;
	private List<String> partCodes;

	public NetPartCodeMapProcess(Tech_Asset__c[] techAssets){
		if(removeUnprocessedTechAssets(techAssets)){
			NetPartCodes = new Map<String, String>();
			getMapRecords();
		}
	}

	private Boolean removeUnprocessedTechAssets(Tech_Asset__c[] techAssets){
		this.recordsToUpdate = new List<Tech_Asset__c>();
		this.partCodes = new List<String>();
		Boolean results = false;
		
		for(Tech_Asset__c t: techAssets){
			if(t.Net_Part_Code__c != null){
				this.recordsToUpdate.add(t);
				this.partCodes.add(t.Net_Part_Code__c);
				results = true;
			}
		}
		return results;
	}

	private void getMapRecords(){
		
	}
}