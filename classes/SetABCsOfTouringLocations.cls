global with sharing class SetABCsOfTouringLocations {
	@future(callout=true)
	public static void updateRecords (List<ID> recordIds) {
		List<ABCs_Location__c> locations = new List<ABCs_Location__c>();
		GoogleMapInfo gmi;
		List<ABCs_Location__c> newList = new List<ABCs_Location__c>();

		for (ABCs_Location__c al: [SELECT Id, Letter__c, Street__c, City__c, State_Province__c, Zip_Postal_Code__c, Country__c, Location__c, Location__longitude__s, Location__latitude__s, Formatted_Address__c, Type__c FROM ABCs_Location__c WHERE Id IN :recordIds AND Override__c = false]) {
			if (String.isBlank(al.Formatted_Address__c)) {
				String address = al.Street__c;
				if (al.Location__c == null) {
					address += ' ' + al.City__c;
					address += ' ' + al.State_Province__c;
					address += ' ' + al.Zip_Postal_Code__c;
					address += ' ' + al.Country__c;
					address = address.replace(' ', '+');
					gmi = getMapInfoByAddress(address);
					al.Location__latitude__s = gmi.latitude;
					al.Location__longitude__s = gmi.longitude;
				} else {
					Map<String, String> gpsPoints = new Map<String, String>();
					gpsPoints.put('lat', String.valueOf(al.Location__latitude__s));
					gpsPoints.put('lng', String.valueOf(al.Location__longitude__s));
					gmi = getMapInfoByLatlng(gpsPoints);
				}
			} else {
				gmi = getMapInfoByAddress(al.Formatted_Address__c.replaceAll('\\s', '+'));
				al.Location__latitude__s = gmi.latitude;
				al.Location__longitude__s = gmi.longitude;
				if (gmi.addressInfo.streetNumber != null)
					al.Street__c = gmi.addressInfo.streetNumber + ' ' + gmi.addressInfo.street;
				else al.Street__c = gmi.addressInfo.street;
				al.City__c = gmi.addressInfo.city;
				al.Country__c = gmi.addressInfo.country;
				al.State_Province__c = gmi.addressInfo.state;
				al.Zip_Postal_Code__c = gmi.addressInfo.postalCode;
			}
			if (String.isNotBlank(al.Type__c) && String.isNotBlank(al.City__c)) {
				if (al.Type__c == 'City') {
					al.Letter__c = al.City__c.left(1);
				}
			}
			if (String.isNotBlank(al.Type__c) && String.isNotBlank(al.State_Province__c)) {
				if (al.Type__c == 'State') {
					al.Letter__c = al.State_Province__c.left(1);
				}
			}

			al.Formatted_Address__c = gmi.results.get(0).formatted_address;
			locations.add(al);
		}
		try {
			update locations;
			insert newList;
		} catch (Exception ex) { }
	}

	public static GoogleMapInfo getMapInfoByAddress(String addressString) {
		Map<String, GoogleItems__c> cs = GoogleItems__c.getAll();
		String url = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + addressString + '&key=' + cs.get('GoogleKey').Value__c;
		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint(url);
		req.setMethod('GET');
		HttpResponse res = h.send(req);
		GoogleMapInfo gmi = GoogleMapInfo.parse(res.getBody());
		return gmi;		
	}

	public static GoogleMapInfo getMapInfoByLatlng(Map<String, String> geoLocation) {
		Map<String, GoogleItems__c> cs = GoogleItems__c.getAll();
		String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=' + geoLocation.get('lat') + ',' + geoLocation.get('lng') + '&key=' + cs.get('GoogleKey').Value__c;
		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint(url);
		req.setMethod('GET');
		HttpResponse res = h.send(req);
		GoogleMapInfo gmi = GoogleMapInfo.parse(res.getBody());
		return gmi;		
	}
}