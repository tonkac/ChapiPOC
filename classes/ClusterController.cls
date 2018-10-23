public class ClusterController {
	private List<Tech_Asset__c> physicalAssets;
	private List<Tech_Asset__c> virtualAssets;
	private Tech_Asset__c currentAsset;
	private Boolean showPhysList = false;
	private Boolean showVirtList = false;
	private Boolean showButton = true;

    public ClusterController(ApexPages.StandardController controller) {
    	
	}

	public Boolean getShowButton(){
		return this.showButton;
	}

	public Boolean getShowPhysList(){
		return this.showPhysList;
	}

	public Boolean getShowVirtList(){
		return this.showVirtList;
	}

	public List<Tech_Asset__c> getPhysicalAssets(){
		return this.physicalAssets;
	}

	public List<Tech_Asset__c> getVirtualAssets(){
		return this.virtualAssets;
	}

	public void initPhysicalAssets(){
		String cluster = this.currentAsset.Cluster__c;
		this.physicalAssets = [SELECT Name, Cluster__c, RecordType.Name FROM Tech_Asset__c WHERE Cluster__c = :this.currentAsset.Cluster__c AND RecordType.Name = 'IT Physical System'];
		if(this.physicalAssets.size() > 0){
			this.showPhysList = true;
			this.showButton = false;
		}
	}

	public void initVirtualAssets(){
		String cluster = this.currentAsset.Cluster__c;
		this.virtualAssets = [SELECT Name, Cluster__c, RecordType.Name FROM Tech_Asset__c WHERE Cluster__c = :this.currentAsset.Cluster__c AND RecordType.Name = 'IT Virtual System'];
		if(this.virtualAssets.size() > 0){
			this.showVirtList = true;
			this.showButton = false;
		}
	}

	public PageReference showCluster(){
		this.currentAsset = [SELECT Id, Cluster__c FROM Tech_Asset__c WHERE Id = :System.currentPageReference().getParameters().get('id') LIMIT 1];
		initPhysicalAssets();
		initVirtualAssets();
		return null;
	}
}