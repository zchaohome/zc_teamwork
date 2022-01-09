import { LightningElement, track, wire } from 'lwc';

// getAccounts メソッドのインポート
import getAccounts from '@salesforce/apex/AccountMapController.getAccounts';
import getContacts from '@salesforce/apex/AccountMapController.getContacts';

export default class AccountMap extends LightningElement {
    // 表示するマーカーのリスト
    @track
    mapMarkers=[];

    // 選択しているマーカーの値
    @track
    selectedMarkerValue;
    @track
    center;

    
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
                markers.push({
                    location: {
                        Country : acc.BillingCountry,
                        State : acc.BillingState,
                        City: acc.BillingCity,
                        Street: acc.BillingStreet
                    },
    
                    icon : "standard:account",
                    mapIcon: {
                        path: 'M 125,5 155,90 245,90 175,145 200,230 125,180 50,230 75,145 5,90 95,90 z',            
                        fillColor: 'Red',
                        fillOpacity: .8,
                        strokeWeight: 0,
                        scale: .10,
                    },
                    value: acc.Id,
                    title: acc.Name,
                    description: acc.Description
                });
            }
            this.center = {
                location: {  
                    Country: '日本',
                    State: '東京都',
                City: '西葛西',
                Street: '3丁目'}
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

    // マーカー選択時のアクション
    handleMarkerSelect(event) {
        console.log(event.target.selectedMarkerValue);
    }
}