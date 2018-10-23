global with sharing class locationController {
	public static String currentLongitude {
		get {
			if (currentLongitude == null) {
				currentLongitude = '0';
			}
			return currentLongitude;
		}
		set;
	}

	public static String currentLatitude {
		get {
			if (currentLatitude == null) {
				currentLatitude = '0';
			}
			return currentLatitude;
		}
		set;
	}

	public static String searchDistance {
		get {
			if (searchDistance == null) {
				searchDistance = '250';
			}
			return searchDistance;
		}
		set;
	}

	public static String searchLetter {
		get {
			if (searchLetter == null) {
				searchLetter = '';
			}
			return searchLetter;
		}
		set;
	}
	public static String searchType {
		get {
			if (searchType == null) {
				searchType = '';
			}
			return searchType;
		}
		set;
	}

	public static String searchState {
		get {
			if (searchState == null) {
				searchState = '';
			}
			return searchState;
		}
		set;
	}

	public static String searchLimit {
		get {
			if (searchLimit == null) {
				searchLimit = '25';
			}
			return searchLimit;
		}
		set;
	}

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
		//if (String.isBlank(filterDistance)) filterDistance = '250';
		String queryString = 'SELECT Name, Letter__c, Type__c, Id, Location__c, Street__c, City__c, State_Province__c, Zip_Postal_Code__c, Country__c, Formatted_Address__c, DISTANCE(Location__c, GEOLOCATION(' + lat + ',' + lng + '), \'mi\') FROM ABCs_Location__c ';
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