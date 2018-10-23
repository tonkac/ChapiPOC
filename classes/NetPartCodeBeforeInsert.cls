public class NetPartCodeBeforeInsert {
	private List<Tech_Asset__c> recordsToUpdate;
	private Map<String, Net_Part_Code_Map__c> NetPartCodes;
	private List<String> partCodes;
	private List<Net_Part_Code_Map__c> newMapRecords;

	public NetPartCodeBeforeInsert(Tech_Asset__c[] techAssets){
		if(removeUnprocessedTechAssets(techAssets)){
			this.NetPartCodes = new Map<String, Net_Part_Code_Map__c>();
			getMapRecords();
			Boolean newMapRecords = true;
			while(newMapRecords){
				newMapRecords = populateMapPartCodes();
				if(newMapRecords){
					addNewMapRecords();
				}
			}
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

	private void addNewMapRecords(){
		insert this.newMapRecords;
		for(Net_Part_Code_Map__c n: this.newMapRecords){
			this.NetPartCodes.put(n.Name, n);
		}
	}

	private void getMapRecords(){

		for(Net_Part_Code_Map__c e: [Select Id, Name From Net_Part_Code_Map__c WHERE Name IN: this.partCodes]){
			this.NetPartCodes.put(e.Name, e);
		}
	}

	private Boolean populateMapPartCodes(){
		Boolean results = false;
		for(Tech_Asset__c t: this.recordsToUpdate){
			this.newMapRecords = new List<Net_Part_Code_Map__c>();
			if(this.NetPartCodes.containsKey(t.Net_Part_Code__c)){
				Net_Part_Code_Map__c n = this.NetPartCodes.get(t.Net_Part_Code__c);
				t.MapNPC__c = n.Id;
			} else {
				Net_Part_Code_Map__c pcm = new Net_Part_Code_Map__c();
				pcm.Name = t.Net_Part_Code__c;
				this.newMapRecords.add(pcm);
				results = true;
			}
		}
		return results;
	}
}