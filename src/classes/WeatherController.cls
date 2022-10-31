/**
 * Created by ADMIN on 30.10.2022.
 */

public with sharing class WeatherController {
    @AuraEnabled
    public static String weatherCallout(){
        HttpRequest req = new HttpRequest();

        req.setMethod('GET');

        req.setHeader('trackName', 'test');

        req.setEndpoint('https://avenga-school.herokuapp.com/weather');

        Http http = new Http();

        HttpResponse res = http.send(req);

        Temperature temperature = new Temperature();

        if (res.getStatusCode()==200) {
            temperature = (Temperature) JSON.deserialize(res.getBody(), Temperature.class);
        }

        String result = temperature.metric  + ' ' + temperature.temp;
        System.debug(result);
        return result;
    }
}