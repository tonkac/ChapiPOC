public class getRelatedAssets {
	private final BIA__c bia;
	private Boolean show = false;
	private Boolean showClear = false;
	private List<BIA_TA_Connector__c> connectors;
	private List<ID> techAssetIds;
	private List<Tech_Asset__c> assets;
	
	public getRelatedAssets(ApexPages.StandardController controller){
		this.bia = [SELECT id FROM BIA__c WHERE id = :System.currentPageReference().getParameters().get('id')];
		
		//initTechAssets();
	}

	public Boolean getShow(){
		return this.show;
	}
	
	public List<Tech_Asset__c> getAssets(){
		return this.assets;
	}
	
	public Boolean getClear(){
		return this.showClear;
	}

	public void initTechAssets(){
		this.connectors = [SELECT BIA__c, Tech_Asset__c FROM BIA_TA_Connector__c WHERE BIA__c = :this.bia.id];
		
		if(this.connectors.size() > 0){
			this.show = true;
			this.techAssetIds = new List<ID>();
			this.assets = new List<Tech_Asset__c>();
			for(BIA_TA_Connector__c b: this.connectors){
				this.techAssetIds.add(b.Tech_Asset__c);
			}
			
			this.assets = [SELECT id, Name FROM Tech_Asset__c WHERE Id IN : this.techAssetIds];
		}
	}

	public PageReference populateValues(){
		initTechAssets();
		this.showClear = true;
		return null; //this.assets;
	}

	public PageReference clearValues(){
		this.show = false;
		this.showClear = false;
		return null; //this.assets;
	}
}