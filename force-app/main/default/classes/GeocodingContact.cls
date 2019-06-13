/**
* Update Coordinates from Google Geocode API on Contact using mailing Address.
*/

public with sharing class GeocodingContact {
    public HttpResponse requestREST(String endPoint) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        return response;
    }
    public void updateCoordinateContact(Contact contact1) {
        
        String requestEndpoint = 'https://maps.googleapis.com/maps/api/geocode/json?address=';
        requestEndpoint += contact1.MailingStreet;
        requestEndpoint += contact1.MailingCity;
        requestEndpoint += contact1.MailingCountry;
        requestEndpoint += '&key=AIzaSyADVcImRmVO35N-378IcgWHeX706FdPc0Y';
        requestEndpoint.replace(' ', '+');
        system.debug('requestEndpoint '+requestEndpoint);
        
        HttpResponse response = requestREST(requestEndpoint);
        
        if (response.getStatusCode() == 200) {
            GeoWrapper geo = GeoWrapper.parse(response.getBody());
            contact1.MailingLatitude = geo.results[0].geometry.location.lat;
            contact1.MailingLongitude = geo.results[0].geometry.location.lng;
            
            try {
                upsert contact1;
            } catch(DmlException e) {
                System.debug(e.getMessage());
            }
        } else {
            System.debug('GeoFailJSON');
        }
    }
}