/*
   *  Lightnig  Webコンポーネントサンプル
   *    Paging  イベントのみを送る
   */
 import  {  LightningElement  }  from  'lwc';

 export  default  class  lwc_paging  extends  LightningElement  {
         /*
           *  初期化処理
           */
         connectedCallback()  {
         }

         /*
           *  「前へ」ボタン  クリック
           */
         previousHandler()  {
                 //イベント名  previous  を発行する
                 this.dispatchEvent(new  CustomEvent('previous'));
         }

         /*
           *  「次へ」ボタン  クリック
           */
         nextHandler()  {
                 //イベント名  next  を発行する
                 this.dispatchEvent(new  CustomEvent('next'));
         }
 }