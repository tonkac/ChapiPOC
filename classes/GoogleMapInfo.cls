public class GoogleMapInfo {
    public String fullAddress {
        get {
            if (fullAddress == null) {
                fullAddress = thisResults.formatted_address;
            }
            return fullAddress;
        }
        private set;
    }

    public Double latitude {
        get {
            if (latitude == null && thisResults != null && thisResults.geometry != null) {
                latitude = thisResults.geometry.location.lat;
            }
            return latitude;
        }
        private set;
    }

    public Double longitude {
        get {
            if (longitude == null && thisResults != null) {
                longitude = thisResults.geometry.location.lng;
            }
            return longitude;
        }
        private set;
    }

    public Results thisResults {
        get {
            if (thisResults == null) {
                thisResults = new Results();
                if (results.size() == 1) {
                    thisResults = results.get(0);
                }
            }
            return thisResults;
        }
        private set;
    }

    public AddressBreakdown addressInfo {
        get {
            if (addressInfo == null && thisResults != null) {
                addressInfo = new AddressBreakdown().parse(thisResults.address_components);
            }
            return addressInfo;
        }
        private set;
    }

    public class AddressBreakdown {
        public String streetNumber;
        public String street;
        public String city;
        public String county;
        public String state;
        public String state_long;
        public String country;
        public String country_long;
        public String postalCode;

        public AddressBreakdown parse(List<Address_components> aComponents) {
            AddressBreakdown ab = new AddressBreakdown();
            for (Address_components ac: aComponents) {
                if (ac.types.get(0) == 'street_number') {
                    ab.streetNumber = ac.long_name;
                }
                if (ac.types.get(0) == 'route') {
                    ab.street = ac.long_name;
                }
                if (ac.types.get(0) == 'locality') {
                    ab.city = ac.long_name;
                }
                if (ac.types.get(0) == 'administrative_area_level_2') {
                    ab.county = ac.long_name;
                }
                if (ac.types.get(0) == 'administrative_area_level_1') {
                    ab.state_long = ac.long_name;
                    ab.state = ac.short_name;
                }
                if (ac.types.get(0) == 'country') {
                    ab.country_long = ac.long_name;
                    ab.country = ac.short_name;
                }
                if (ac.types.get(0) == 'postal_code') {
                    ab.postalCode = ac.long_name;
                }
            }
            return ab;
        }
    }

    public class Address_components {
        public String long_name;
        public String short_name;
        public List<String> types;
    }

    public class Geometry {
        public Location location;
        public String location_type;
        public Viewport viewport;
    }

    public List<Results> results;
    public String status;

    public class Results {
        public List<Address_components> address_components;
        public String formatted_address;
        public Geometry geometry;
        public String place_id;
        public List<String> types;
    }

    public class Viewport {
        public Location northeast;
        public Location southwest;
    }

    public class Location {
        public Double lat;
        public Double lng;
    }

    public static GoogleMapInfo parse(String json) {
        System.debug('json info: ' + json);
        return (GoogleMapInfo) System.JSON.deserialize(json, GoogleMapInfo.class);
    }
}