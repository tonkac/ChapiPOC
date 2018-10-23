public with sharing class siteController {
        List<Motorcycle__c> allBikes = new List<Motorcycle__c>();
        public siteController() {
                this.allBikes = [SELECT Name, Model__c, Make__c, Year__c, Id FROM Motorcycle__c];
        }

        public List<Motorcycle__c> getAllBikes() {
                this.allBikes = [SELECT Name, Model__c, Make__c, Year__c, Id, ImageURL__c FROM Motorcycle__c];
                return this.allBikes;
        }
}