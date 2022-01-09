public with sharing class MitsumoriSearch_CTRL {
    // 年
    public Integer selectYear { get; set; }
    // 月
    public Integer selectMonth { get; set; }
    // 企業名
    public string AccountName {  get;set; }  
    // 見積List
    public List<Mitsumori__c> mitsumoris;    
    // 見積List
    public List<Mitsumori__c> prds { get; set; }          
    // 見積  
    public Mitsumori__c mitsumori { get; set; }   
    /**
     * コンストラクタ
     */    
    public MitsumoriSearch_CTRL(){
        selectYear= Integer.valueOf(System.today().year());
        selectMonth= Integer.valueOf(System.Today().month());
        mitsumori = new Mitsumori__c();
        
    }
    
    /**
     * 年選択リスト値取得
     */
    public List<SelectOption> getSelectYearItem() {
    
        Integer startYear = System.today().year();
    
        List<SelectOption> options = new List<SelectOption>();
        for (Integer i = startYear - 5; i < startYear+2; i++) {
            options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
    
        return options;
    }
    
    /**
     * 月選択リスト値取得
     */
    public List<SelectOption> getSelectMonthItem() {
    
        List<SelectOption> options = new List<SelectOption>();
        for (Integer i = 1; i <= 12; i++) {
            options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
    
        return options;
    }
    
    /**
     * 見積List
     */
    public List<Mitsumori__c> getMitsumoris() {                    
       try {
           mitsumoris = [select Id, Account__c, Account__r.Name, Status__c, MitusmoriNenGetsu__c, MitsumoriYukokikan__c from Mitsumori__c limit 50];        
          return mitsumoris;
       } catch (Exception e) {
          ApexPages.addMessages(e);
          return null;
       }
    }    
    
    /**
     * 曖昧検索
     */    
    public void doSearch(){  
       String searchYear = String.valueOf(selectYear); 
       String searchMonth = String.valueOf(selectMonth);
        if(selectMonth<=9){
           searchMonth = '0' + searchMonth;
        }
       String searchYearMonth = searchYear + searchMonth;
       String accountName = '%' + AccountName + '%'; 
       system.debug('searchYearMonth= '+searchYearMonth);
       system.debug('accountName= '+accountName); 
       List<Mitsumori__c> mm = [select Id
                                       , Account__r.Name
                                       , Status__c
                                       , MitusmoriNenGetsu__c
                                       , MitsumoriYukokikan__c 
                                from Mitsumori__c 
                                where MitusmoriNenGetsu__c =: searchYearMonth 
                                      and Account__r.Name like :accountName
                                limit 100];        
        if(mm.size() != 0){
            prds = mm;
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, '検索条件に該当するデータがありません!'));           
        }
        
    } 
    
    /**
     * 見積作成
     */    
    public void createMitsumori(){  


        
    }   
    
    /**
     * 見積削除
     */      
    public void doDelete() {
        SavePoint sp = Database.setSavepoint();
        try {
            String sfid = ApexPages.currentPage().getParameters().get('id');
            List<Mitsumori__c> deleteList= [select Id from Mitsumori__c where Id=:sfid];
            if (deleteList.size() == 0) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'すでに削除されました。'));
            } else {
                delete deleteList;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, '削除しました。')); 
                mitsumoris = [select Id, Account__c, Account__r.Name, Status__c, MitusmoriNenGetsu__c, MitsumoriYukokikan__c from Mitsumori__c limit 50];    
            }
        } catch(exception ex) {
            system.debug('Error:'+ex.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ex.getMessage()));
            Database.rollback(sp);
        }
        
    }    
    
}