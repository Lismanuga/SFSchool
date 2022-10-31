import { LightningElement, api, track} from 'lwc';
import weatherCallout from '@salesforce/apex/WeatherController.weatherCallout';


export default class weatherBadge extends LightningElement {

    @track test
    constructor(){
        super();
        this.tempAndMetric();
    }

    @api
    async tempAndMetric(){
        await weatherCallout().then(somedata => this.test = somedata);
        console.log(weatherCallout().then(somedata => console.log(somedata)));
    }

    get geter(){
        return this.tempAndMetric();
    }

}
