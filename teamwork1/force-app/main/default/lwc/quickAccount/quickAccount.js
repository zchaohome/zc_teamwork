import { api, wire, track, LightningElement } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import createAccount from '@salesforce/apex/QuickActionController.createAccount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import modal from "@salesforce/resourceUrl/custommodalcss";
import { loadStyle } from "lightning/platformResourceLoader";

import getAccount from '@salesforce/apex/QuickActionController.getAccount';
export default class QuickAccount extends LightningElement {

    @api recordId;

    name = '';
    phone = '';
    isSpinner = false;

    connectedCallback() {
        loadStyle(this, modal);
        this.name = '';
        this.phone = '';
    }

    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    @track value1 = '3%';
    @track value2 = '5%';

    get options1() {
        return [
                { label: '3%', value: '3%' },
                { label: '5%', value: '5%' },
                { label: '7%', value: '7%' },
            ];
    }
    get options2() {
        return [
                { label: '3%', value: '3%' },
                { label: '5%', value: '5%' },
                { label: '7%', value: '7%' },
            ];
    }

    handleChange1 = event => {
        this.value1 = event.detail.value;
        event.preventDefault();
        let name = event.target.name;
        let value = event.target.value;
        if(name === 'name'){
            this.name = value;
        }else{
            this.phone = value;
        }
    }
    handleChange2 = event => {
        this.value2 = event.detail.value;
        event.preventDefault();
        let name = event.target.name;
        let value = event.target.value;
        if(name === 'name'){
            this.name = value;
        }else{
            this.phone = value;
        }
    }    
/** 
    handleSave = event => {
        this.isSpinner = true;
        event.preventDefault();
        createAccount({
            name : this.name,
            phone : this.phone,
            parentRecordId : this.recordId
        })
        .then(result => {
            console.log('Result \n ', result);
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Account Created',
                variant: 'success'
            }));
            this.closeAction();
        })
        .catch(error => {
            console.error('Error: \n ', error);
        })
        .finally(()=>{
            this.isSpinner = false;
        })
    }
*/
    _errors;
    _accs;

    @wire(getAccount)
    wiredData({ error, data }) {
        if (data) {
            console.log('Data \n ', data);
            this._accs = JSON.parse( JSON.stringify(data) );
        } else if (error) {
            console.error('Error:', error);
        }
    }
}