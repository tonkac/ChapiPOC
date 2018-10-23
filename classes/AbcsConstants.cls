public virtual with sharing class AbcsConstants {
	public static List<locationTypes__c> LOCATION_TYPES {
		get {
			if (LOCATION_TYPES == null) {
				LOCATION_TYPES = AbcsDaoSettings.getLocationTypes().values();
			}
			return LOCATION_TYPES;
		}
		private set;
	}
}