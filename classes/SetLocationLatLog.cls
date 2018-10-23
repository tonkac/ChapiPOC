public with sharing class SetLocationLatLog {
	private Map<String, Decimal> geoLocation {
		get {
			if (geoLocation == null) {
				geoLocation = new Map<String, Decimal>();
			}
			return geoLocation;
		}
		set;
	}

	public SetLocationLatLog() { }

	public Map<String, Decimal> getLocationInfo(String addressString) {
		Map<String, GoogleItems__c> cs = GoogleItems__c.getAll();
		String url = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + addressString + '&key=' + cs.get('GoogleKey').Value__c;
		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint(url);
		req.setMethod('GET');

		HttpResponse res = h.send(req);
		JSONParser parser = JSON.createParser(res.getBody());
		Boolean lat = false;
		Boolean lng = false;
		while (parser.nextToken() != null && !(lat && lng)) {
			if (parser.getText() == 'lat') {
				parser.nextToken();
				geoLocation.put('lat', Decimal.valueOf(parser.getText()));
				System.debug('lat: ' + parser.getText());
				lat = true;
			}
			if (parser.getText() == 'lng') {
				parser.nextToken();
				geoLocation.put('lng', Decimal.valueOf(parser.getText()));
				lng = true;
			}
		}
		return geoLocation;		
	}
}