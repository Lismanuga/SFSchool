/**
 * Created by ADMIN on 25.10.2022.
 */

import { LightningElement, wire, api} from 'lwc';
import getRaceResultsList from '@salesforce/apex/wonRaceResultController.getRaceResultsList';

const columns = [
    { label: 'Race name', fieldName: 'Grand_Prix__r.Name' },
    { label: 'Race result name', fieldName: 'Name' },

];
export default class ApexDatatableExample extends LightningElement {
    error;
    columns = columns;

    @api recordId;

    @wire(getRaceResultsList, {recordId: '$recordId'})
        wiredRaceResults({
            error,
            data
        }) {
            if (data) {
                this.data = data;
            }
    }
}
