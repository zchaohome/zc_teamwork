// Lightning Web Componentから @wire, @api をインポート
import { LightningElement, track, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
// ShowToastEvent(ポップアップメッセージ)をインポート
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
// Apex Classの定義
import insertCsvData from '@salesforce/apex/ImportCsvController.insertCsvData';
import doInit from '@salesforce/apex/ImportCsvController.doInit';


export default class Importcsv extends LightningElement {

  // アップロードファイル
  @api file = null;
  // ファイル名(画面表示用)
  @api fileName;
  // 送信フラグ
  @api isSend = false;
  @api isLoaded = false;
  @api isUser = false;
  @api options;
  @api selectedValue
  // ファイルの中身
  data;
  // renderedCallback is call one time.
  renderedCallbackOnce = false;
  
  // Initialize
  renderedCallback() {
    // renderedCallback is call one time.
    if (this.renderedCallbackOnce) {
      return;
    }
    this.renderedCallbackOnce = true;
    this.init();
  }
  init(){
    doInit().then(result =>{ this.options = result;});
  }
  // 指定したオブジェクトを取得する
  handleChange(event) {
    this.selectedValue = event.detail.value;
    if (this.selectedValue == 'User') {
      this.isUser = true;
    } else {
      this.isUser = false;
    }
  }

  // ファイルを選択すると発火
  handleCsvUpload(event) {
    // 選択したアップロードファイルを取得
    this.file = event.detail.files;

    // ファイル名を取得
    this.fileName = this.file[0].name;
    let files = this.fileName.split('.');

    // CSV以外のファイルを選択された場合エラーになる
    if(files[files.length-1] !== 'csv' && files[files.length-1] !== 'CSV'){
      this.dispatchEvent(
        new ShowToastEvent({
          title: 'Error!!',
          message: 'CSVファイルのみ選択可能です',
          variant: 'error',
        }),
      );
      this.file = null;
      return;
    }
    // ファイルが選択されたらボタンをアクティブ化
    this.isSend = this.file;

    // FileReaderオブジェクトの生成
    const fileReader = new FileReader();

    // ファイルの読み込みが完了したら実行
    fileReader.onloadend = () => {
      // 読み込み結果を設定
      this.data = fileReader.result;
    }

    // ファイルを読み込み
    fileReader.readAsText(this.file[0]);
  }

  // csvアップロード処理
  handleUpload() {

    // アップロードファイルを選択していないと送信させない
    if (!this.file) {
      return
    }
    // ローディング表示をtrue
    this.isLoaded = true;
    this.sObjName = this.fileName.split('.')[0];

    Promise.resolve().then(() => {
      return new Promise((resolve, reject) => {

        // ファイルを改行で分割しフィールドごとに配列で取得
        const rows = this.data.split(/\r\n|\n/);
        console.log(rows);
        
        // Apexでインポート処理
        insertCsvData({
          sObj: this.selectedValue,
          csvRows: rows
        })
        .then(result => {
          this.data = result;
          resolve(this.data);
          // 成功ポップアップメッセージ表示
          this.dispatchEvent(
            new ShowToastEvent({
              title: 'Success!!',
              message: '一括登録が成功しました!!',
              variant: 'success',
            }),
          );
        })
        // 失敗ポップアップメッセージ表示
        .catch(error => {
          console.log('error-----'+error.body.message);
          this.dispatchEvent(
            new ShowToastEvent({
              title: 'Error!!',
              message: error.body.message,
              variant: 'error',
            }),
          );
          // 送信ボタンを非アクティブ化
          this.isLoaded = false;
        })
      });
    })
    .catch(error => {
      console.log(error)
    })
    // 最終処理
    .finally(() => {
      // input fileを初期化
      this.template.querySelectorAll('lightning-input').forEach(each => {
        each.value = "";
      });
      // アップロードファイルを初期化
      this.file = null;

      // 送信ボタンを非アクティブ化
      this.isLoaded = false;
    });
  }
}