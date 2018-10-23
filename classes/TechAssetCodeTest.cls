public class TechAssetCodeTest {
    public static testMethod void TestingTechAssetCodes(){
        String pcName;
        Tech_Asset__c testAssetOne = new Tech_Asset__c();
        Tech_Asset__c testAssetTwo = new Tech_Asset__c();
        Net_Part_Code_Map__c testPartCode = new Net_Part_Code_Map__c();
        Map<String, String> allCodes = new Map<String, String>();
        Map<String, String> RTMapNames;
        
        //  find IT Network record type and ID
        RTMapNames = new Map<String, String>();
        for(RecordType rt: [SELECT id, name FROM RecordType WHERE SobjectType = 'Tech_Asset__c' AND name = 'IT Network']){
            RTMapNames.put(rt.name,rt.id);
        }

        //  find a unique Net Part Code record
        for(Net_Part_Code_Map__c p: [Select Name, Description_Notes__c From Net_Part_Code_Map__c]){
            allCodes.put(p.Name, p.Description_Notes__c);
        }

        pcName = String.valueOf(Math.random());
        while(allCodes.containsKey(pcName)){
            pcName = String.valueOf(Math.random());
        }

        //  create test asset #1
        testAssetOne.Name = 'temp';
        testAssetOne.RecordTypeId = RTMapNames.get('IT Network');
        testAssetOne.Serial_Number__c = pcName;
        testAssetOne.Net_Part_Code__c = pcName;
        insert testAssetOne;
        System.assertNotEquals(testAssetOne.Id, null);
        testAssetOne = [Select MapNPC__c, Net_Part_Code__c, Id From Tech_Asset__c WHERE Net_Part_Code__c = :pcName LIMIT 1];
        testPartCode = [Select Name, Id From Net_Part_Code_Map__c WHERE Name = :pcName LIMIT 1];
        System.assertEquals(testAssetOne.MapNPC__c, testPartCode.Id);
        testAssetTwo.Name = 'temp';
        testAssetTwo.RecordTypeId = RTMapNames.get('IT Network');
        testAssetTwo.Serial_Number__c = pcName + '-2';
        testAssetTwo.Net_Part_Code__c = pcName;
        insert testAssetTwo;
        System.assertNotEquals(testAssetTwo.Id, null);
        testAssetTwo = [Select MapNPC__c, Net_Part_Code__c, Id From Tech_Asset__c WHERE Net_Part_Code__c = :pcName LIMIT 1];
        System.assertEquals(testAssetTwo.MapNPC__c, testPartCode.Id);

        testPartCode = [Select Name, Id From Net_Part_Code_Map__c WHERE Name != :pcName LIMIT 1];
        testAssetOne.Net_Part_Code__c = testPartCode.Name;
        update testAssetOne;
        testAssetOne = [Select MapNPC__c, Net_Part_Code__c, Id From Tech_Asset__c WHERE Id = :testAssetOne.Id LIMIT 1];
        System.assertEquals(testAssetOne.MapNPC__c, testPartCode.Id);

        for(Net_Part_Code_Map__c p: [Select Name, Description_Notes__c From Net_Part_Code_Map__c]){
            allCodes.put(p.Name, p.Description_Notes__c);
        }

        pcName = String.valueOf(Math.random());
        while(allCodes.containsKey(pcName)){
            pcName = String.valueOf(Math.random());
        }

        testAssetOne.Net_Part_Code__c = pcName;
        update testAssetOne;
        testAssetOne = [Select MapNPC__c, Net_Part_Code__c, Id From Tech_Asset__c WHERE Id = :testAssetOne.Id LIMIT 1];
        testPartCode = [Select Name, Id From Net_Part_Code_Map__c WHERE Name = :pcName LIMIT 1];
        System.assertEquals(testAssetOne.MapNPC__c, testPartCode.Id);
    }
}