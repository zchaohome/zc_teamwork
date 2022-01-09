/*  Wire ServiceによるUserレコードの取得（プロパティ方式）*/

 //必ずインポートする
 import { LightningElement, wire } from 'lwc';

 //Apex メソッドの定義
 import retrieveUserInfo from '@salesforce/apex/lwc_UserInfoController.retrieveUserInfo';
 //ログインユーザーIDの取得
 import userid from '@salesforce/user/Id';

 export default class UserInfo extends LightningElement {

   //Wire ServiceによるUserレコードの取得（プロパティ方式）
   @wire(retrieveUserInfo, { 'userId': userid })
   record;

   /*
    * 初期化処理
    */
     connectedCallback() {
         console.log('userid->>'+userid);
         console.log('record->>'+this.record);
   }

 }