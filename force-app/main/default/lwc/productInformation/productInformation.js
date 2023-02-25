import { LightningElement,api,wire, track } from 'lwc';
import getProductInformation from '@salesforce/apex/ProductInformationController.getProductInformation';

export default class ProductInformation extends LightningElement {

    @api recordId;
    @track product;
    error;

    @wire(getProductInformation,{ caseId: '$recordId'})
    wiredContacts({ error, data }) {
        if (data) {
            this.product = data;
        } else if (error) {
            this.error = error;
        }
    }

}