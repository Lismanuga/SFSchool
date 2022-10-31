import { LightningElement, api} from 'lwc';
import weatherCallout from '@salesforce/apex/WeatherController.weatherCallout';


export default class weatherBadge extends LightningElement {

    @api
    get tempAndMetric(){
        return weatherCallout().then((response) => {
        console.log("response from weatherCallout promise", response);
        return response;
        })
    }


//    const myPromise = new Promise()
//
//
//    temperature;
//    weatherCallout().then((value) => {
//        temperature = value;
//    });

}
