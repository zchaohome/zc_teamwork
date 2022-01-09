import  {  LightningElement,  api  }  from  'lwc';
import  {  NavigationMixin  }  from  'lightning/navigation';

export  default  class  LWC_AccountPage  extends  NavigationMixin(LightningElement)  {
 @api recordId;

        rowAction(event) {
                console.log(event.target.value);
                this[NavigationMixin.Navigate]({
                        type: 'standard__recordPage',
                        attributes: {
                                "recordId": this.recordId,
                                "objectApiName": "Account",
                                "actionName": "edit"
                        },
                });
        }
}