import { LightningElement,track } from 'lwc';
import  {  toStringFromDate  }  from  'c/lwc_CommonUtils';


export default class Lwc2_Common extends LightningElement {

    @track msg;
    connectedCallback() {
        let today = new Date();
        let strToday = toStringFromDate(today);
        this.msg = strToday;
        console.log('strToday->>'+this.msg);
    }

}