import { LightningElement, api, wire, track } from 'lwc';
import getRaceResultsList from '@salesforce/apex/wonRaceResultController.getRaceResultsList';

const columns = [
    { label: 'Race name', fieldName: 'GrandPrix',
    type: 'text',
    sortable: true },
    { label: 'Race result name', fieldName: 'Name' ,
    type: 'text',
    sortable: true}

];

export default class WonRaceResult extends LightningElement {

    @api recordId;
    @track data = [];
    @track error;
    @track columns = columns;

    @wire(getRaceResultsList, {recordId: '$recordId'})
    wiredRaceResults
    
    
}