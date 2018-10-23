public class ClustomerPageController {
	Tech_Asset__c techAsset;
	public static final String RECORD_TYPE_01 = 'IT Physical System';
	public static final String RECORD_TYPE_02 = 'IT Virtual System';
	public List<Tech_Asset__c> physicalAssets = new List<Tech_Asset__c>();
	public List<Tech_Asset__c> virtualAssets = new List<Tech_Asset__c>();
	public boolean isPhysValues = false;
	public boolean isVirtValues = false;

    public ClustomerPageController(ApexPages.StandardController controller) {
    	
	}

	public Tech_Asset__c getAsset(){
		if(System.currentPageReference().getParameters().get('id') != null){
			this.techAsset = [Select Cluster__c FROM Tech_Asset__c Where Id = :System.currentPageReference().getParameters().get('id')];
		} else {
			this.techAsset = new Tech_Asset__c();
		}
		return this.techAsset;
	}

	public void newShowList(){
		this.isPhysValues = true;
		this.isVirtValues = true;
	}

	public List<Tech_Asset__c> getPhysicalAssets(){
		for(Tech_Asset__c t: [Select Name, Id, Host_Name__c, Cluster__c, RecordType.Name From Tech_Asset__c WHERE Cluster__c = :this.techAsset.Cluster__c AND RecordType.Name = :RECORD_TYPE_01]){
			this.physicalAssets.add(t);
		}
		if(this.physicalAssets.size() > 0){
			this.isPhysValues = true;
		}
		return physicalAssets;
	}

	public List<Tech_Asset__c> getVirtualAssets(){
		for(Tech_Asset__c t: [Select Name, Id, Host_Name__c, Cluster__c, RecordType.Name From Tech_Asset__c WHERE Cluster__c = :this.techAsset.Cluster__c AND RecordType.Name = :RECORD_TYPE_02]){
			this.virtualAssets.add(t);
		}
		if(this.virtualAssets.size() > 0){
			this.isVirtValues = true;
		}
		return virtualAssets;
	}

	public Boolean getIsPhysical(){
		Boolean results = false;
		Integer cnt = [Select Count() From Tech_Asset__c WHERE Cluster__c = :this.techAsset.Cluster__c AND RecordType.Name = :RECORD_TYPE_01];
		if(cnt > 0 && cnt != null){
			results = true;
		}
		return results;
	}

	public Boolean getIsVirtual(){
		Boolean results = false;
		Integer cnt = [Select Count() From Tech_Asset__c WHERE Cluster__c = :techAsset.Cluster__c AND RecordType.Name = :RECORD_TYPE_02];
		if(cnt > 0 && cnt != null){
			results = true;
		}
		return results;
	}
}