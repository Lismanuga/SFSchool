import { LightningElement, api, track} from 'lwc';
import weatherCallout from '@salesforce/apex/WeatherController.weatherCallout';


export default class weatherBadge extends LightningElement {

    @track test;
    connectedCallback(){
        this.tempAndMetric();
    }


    tempAndMetric(){
        weatherCallout().then(somedata => this.test = somedata);
    }

}
