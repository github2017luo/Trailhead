public class GeoWrapper {
    
    public List<Results> results;
    
    public class Results {
        public Geometry geometry;
    }
    
    public class Geometry {
        public Location location;
    }
    
    public class Location {
        public Decimal lat;
        public Decimal lng;
    }
    
    public static GeoWrapper parse(String json) {
        return (GeoWrapper) System.JSON.deserialize(json, GeoWrapper.class);
    }
}