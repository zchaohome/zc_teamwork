public class AccountExtensionsController {
 
    /** 取引先 */
    public Account acct{get; set;}
    
    /** 標準コントローラー */
    private ApexPages.StandardController stdController;
    
    /**
     * コンストラクタ.
     * @param stdController 標準コントローラ
     */
    public AccountExtensionsController(ApexPages.StandardController stdController) {
        this.stdController = stdController;
        this.acct = (Account)stdController.getRecord();
    }
    
    /**
     * やり直しボタン押下時.
     * ※標準コントローラには無いActionの追加.
     */
    public void redo() {
        Account acct = [
            SELECT
            	 id, Name, Phone, Fax, Description
            FROM
            	Account
            WHERE
	            Id =: this.acct.Id
        ];
        this.acct.Name = acct.Name;
        this.acct.Phone = acct.Phone;
        this.acct.Fax = acct.Fax;
        this.acct.Description = acct.Description;
    }
    
    /**
     * 保存ボタン押下時.
     * ※標準コントローラに存在するAction.
     */
    public void quicksave() {
        if (String.isEmpty(this.acct.Description)) {
            this.acct.Description = '（自動入力）';
        }
        this.stdController.save();
    }
}