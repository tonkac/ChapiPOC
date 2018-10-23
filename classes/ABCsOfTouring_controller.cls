global without sharing class ABCsOfTouring_controller {
    public List<locationTypes__c> locationTypes {
        get {
            if (locationTypes == null) {
                locationTypes = AbcsConstants.LOCATION_TYPES;
            }
            return locationTypes;
        }
        private set;
   }

    public String attachmentId {
        get {
            if (attachmentId == null) {
                attachmentId = '00PQ0000004rQz7';
            }
            return attachmentId;
        }
        set;
    }

    public void setAttachment () { }

    Map<String, GoogleItems__c> cs = GoogleItems__c.getAll();
    public void quickSave() {}
    public String apiKey {
        get {
            if (apiKey == null) {
                apiKey = cs.get('GoogleKey').Value__c;
            }
            return apiKey;
        }
        private set;
    }

    @RemoteAction
    global static List<ABCs_Location__c> getRemoteLocations(String filterLetter, String lat, String lng, String filterDistance, String filterState, String filterLimit, String filterType) {
        Boolean addedState = false;
        Boolean addedLetter = false;
        List<ABCs_Location__c> locations = new List<ABCs_Location__c>();
        String queryString = 'SELECT    Id, ' +
                                        'Name, ' + 
                                        'Description__c, ' +
                                        'Letter__c, ' + 
                                        'Type__c, ' +
                                        'Location__c, ' +
                                        'Street__c, ' +
                                        'City__c, ' +
                                        'State_Province__c, ' +
                                        'Zip_Postal_Code__c, ' +
                                        'Country__c, ' +
                                        'Formatted_Address__c, ' +
                                        'Location__latitude__s, ' +
                                        'Location__longitude__s, ' +
                                        '(SELECT Id FROM Attachments), ' +
                                        'DISTANCE(Location__c, GEOLOCATION(' + lat + ',' + lng + '), \'mi\') FROM ABCs_Location__c ';
        queryString +=  ' WHERE DISTANCE(Location__c, GEOLOCATION(' + lat + ',' + lng + '), \'mi\') < ' + Integer.valueOf(filterDistance);

        if (String.isNotBlank(filterState)) {
            queryString += ' AND State_Province__c = \'' + filterState + '\'';
        }

        if (String.isNotBlank(filterLetter)) {
            queryString += ' AND Letter__c = \'' + filterLetter + '\'';
        }

        if (String.isNotBlank(filterType)) {
            queryString += ' AND Type__c = \'' + filterType + '\'';
        }

        queryString += ' ORDER BY DISTANCE(Location__c, GEOLOCATION(' + lat + ',' + lng + '), \'mi\') ASC';
        System.debug('query: ' + queryString);

        if (String.isNotBlank(filterLimit)) {
            queryString += ' LIMIT ' + filterLimit;
        }

        try {
            locations = Database.query(queryString);
        } catch (Exception ex) {
            System.debug('issue on query: ' + ex.getMessage());
        }

        return locations;
    }
}