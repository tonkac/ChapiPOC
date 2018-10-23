public class NetPartCodeUnique {
    Map<String, ID> pcList = new Map<String, ID>();
    public final String DUP_ERROR = 'Duplicate Net Part Code';

    public NetPartCodeUnique(){
        
    }

    public NetPartCodeUnique(Net_Part_Code_Map__c[] modifiedPartCodes){
        if(getExistingRecords()){
            generateErrors(modifiedPartCodes);
        }
    }

    private Boolean getExistingRecords(){
        Boolean results = false;
        for(Net_Part_Code_Map__c n : [Select Name, Id From Net_Part_Code_Map__c]){
            this.pcList.put(n.Name, n.Id);
        }
        if(this.pcList.size()>0){
            results = true;
        }
        return results;
    }

    private void generateErrors(Net_Part_Code_Map__c[] modifiedPartCodes){
        for(Net_Part_Code_Map__c p: modifiedPartCodes){
            if(this.pcList.containsKey(p.Name)){
                ID curId = this.pcList.get(p.Name);
                if(p.Id == null || p.Id != curId){
                    p.Name.addError(DUP_ERROR);
                }
            } else {
                this.pcList.put(p.Name, null);
            }
        }
    }

    public static testMethod void testUniqueName(){
        NetPartCodeUnique npcu = new NetPartCodeUnique();
        Net_Part_Code_Map__c pc1 = new Net_Part_Code_Map__c();
        Net_Part_Code_Map__c pc2 = new Net_Part_Code_Map__c();
        Net_Part_Code_Map__c existingPC = new Net_Part_Code_Map__c();
        List<Net_Part_Code_Map__c> newPcList = new List<Net_Part_Code_Map__c>();
        Map<String, ID> npcMap = new Map<String, ID>();
        
        for(Net_Part_Code_Map__c n : [Select Name, Id From Net_Part_Code_Map__c]){
            npcMap.put(n.Name, n.Id);
        }
        existingPC = [Select Name, Id From Net_Part_Code_Map__c LIMIT 1];
        
        String pcName = String.valueOf(Math.random());
        while(npcMap.containsKey(pcName)){
            pcName = String.valueOf(Math.random());
        }
        
        pc1.Name = pcName;
        pc2.Name = pcName;
        newPcList.add(pc1);
        newPcList.add(pc2);
        Database.SaveResult[] MySaveResult = Database.Insert(newPcList, false);
        System.assertEquals(MySaveResult[0].isSuccess(), true);
		System.assertEquals(MySaveResult[1].isSuccess(), false);
		System.debug('My Results: ' + MySaveResult[1]);
    }
}