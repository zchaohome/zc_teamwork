import { LightningElement, track, wire } from 'lwc';

// getAccounts メソッドのインポート
import getAccounts from '@salesforce/apex/AccountMapController.getAccounts';
import UpdateAcc from '@salesforce/apex/AccountMapController.UpdateAcc';

export default class LightningMap extends LightningElement {
    // 表示するマーカーのリスト
    @track
    mapMarkers=[];

    // 選択しているマーカーの値
    @track
    selectedMarkerValue;
    @track
    center;
    @track isShowModal = false;
    @track isShowModal2 = false;
    @track isShowModal3 = false;
    
    // 取引先を取得して表示するマーカーを作成
    //@wire(getAccounts, {})
    //accounts;
    //@wire(getContatcs, {})
    //contatcs;

    //@track
    //mergeList = [];
    //mergeList = [...this.mergeList, getAccounts.data];
    //mergeList = [...this.mergeList, getContatcs.data];
    @wire(getAccounts, {})
    wiredAccounts({ data }) {
        if (data) {
            var markers = [];
            for(var i = 0; i < data.length; i++){
                var acc = data[i];
                if(i===0){
                    //this.selectedMarkerValue = acc.objId;
                    markers.push({
                        location: {
                            Country : acc.objCountry,
                            State : acc.objState,
                            City: acc.objCity,
                            Street: acc.objStreet
                        },
                        
                        icon : "standard:account",
                        value: acc.objId,
                        title: acc.objName,
                        description: acc.objDescription
                    });
                }else{
                    markers.push({
                        location: {
                            Country : acc.objCountry,
                            State : acc.objState,
                            City: acc.objCity,
                            Street: acc.objStreet
                        },
        
                        icon : "standard:contact",
                        mapIcon: {
                            path: 'M 125,5 155,90 245,90 175,145 200,230 125,180 50,230 75,145 5,90 95,90 z',
                            fillColor: 'red',
                            fillOpacity: .8,
                            strokeWeight: 0,
                            scale: .10,
                        },
                        value: acc.objId,
                        title: acc.objName,
                        //description: acc.objDescription
                    });
                }
            }
            this.center = {
                location: {  
                    Country: data[0].objCountry,
                    State: data[0].objState,
                    City: data[0].objCity,
                    Street: data[0].objStreet,}
            };
            this.mapMarkers = markers;
            //this.mapMarkers.concat(markers);
            //this.mapMarkers = markers;
        }    
    }  

    // @wire(getContacts, {})
    // wiredContacts({ data }) {
    //     if (data) {
    //         var markerss = [];
    //         for(var i = 0; i < data.length; i++){
    //             var con = data[i];
    //             markerss.push({
    //                 location: {
    //                     Country : con.MailingCountry,
    //                     State : con.MailingState,
    //                     City: con.MailingCity,
    //                     Street: con.MailingStreet
    //                 },
    
    //                 icon : "standard:contact",
    //                 value: con.Id,
    //                 title: con.Name,
    //                 description: con.Description

    //             });

                
    //         }
    //         this.mapMarkers.concat(markerss);
    //         console.log('mapMarkers->'+this.mapMarkers.concat(markerss));
    //         //this.mapMarkers = markerss;
    //     }    
    // } 

    @wire(getAccounts, {})
    accounts;

    // マーカー選択時のアクション
    handleMarkerSelect(event) {
        console.log(event.target.selectedMarkerValue);
        console.log(this.isShowModal);
        this.selectedMarkerValue = event.target.selectedMarkerValue;
        console.log(this.accounts.data[0]);
        if(this.selectedMarkerValue == this.accounts.data[0].objId){
            this.showModalBox2();
            //alert('検針員を依頼してください。');
            this.hideModalBox();
        }else{
            this.showModalBox();
        }
            console.log(this.isShowModal);
    }
    
    showModalBox() {  
        this.isShowModal = true;
    }

    hideModalBox() {  
        this.isShowModal = false;
    }

    showModalBox2() {  
        this.isShowModal2 = true;
    }

    hideModalBox2() {  
        this.isShowModal2 = false;
    }   
    showModalBox3() {  
        this.isShowModal3 = true;
    }

    hideModalBox3() {  
        this.isShowModal3 = false;
    }

    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        UpdateAcc({ conId: this.selectedMarkerValue, accId : this.accounts.data[0].objId})
        .then((result) => {
            console.log(this.selectedMarkerValue);
            this.showModalBox3();
            // this.contacts = result;
            // this.error = undefined;
        })
        .catch((error) => {
            console.log(error);
            // this.error = error;
            // this.contacts = undefined;
        });
        

        //alert('依頼検針員ID->' + this.selectedMarkerValue);
        this.isShowModal = false;
    }
}