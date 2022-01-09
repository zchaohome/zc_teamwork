public class Example {
    private static String INITIAL_VALUE = '';
    // 選択リストで選択された値が格納される変数
    public Opportunity oppInstance {get; set;}
    public String Country {get;set;}      //現在のCountry選択値
    public String City {get;set;}         //現在のCity選択値

    public static List<selectOption> getCountries {
       get {
            List<selectOption> options = new List<selectOption>();
            Schema.DescribeFieldResult sdfr = Opportunity.Country__c.getDescribe();
            options.add(new SelectOption('','-- Choose a Country --'));
            for(Schema.PicklistEntry pe : sdfr.getPicklistValues()){
                options.add(new SelectOption(pe.getValue(), pe.getLabel()));
                 system.debug(pe.getValue());
                 system.debug(pe.getLabel());
            }
            return options;         
        }
        set;
    }
      public List<SelectOption> getCities{
        get{
            List<SelectOption> options = new List<SelectOption>();

            // 選択リストの一番上にデフォルトの選択値を設定
            options.add(new SelectOption(INITIAL_VALUE, '-- Choose a City --'));

            // 制御項目ctrlPicklistが選択されている時に連動項目depPicklistで選べる選択肢を取得する。
            if( this.oppInstance.Country__c != null || this.oppInstance.Country__c != INITIAL_VALUE ){
                 Map<String,List<DepPickListCtrl2.TPicklistEntry>>  tPicklistEntries = 
                    DepPickListCtrl2.GetDependentOptions('Opportunity','Country__c','City__c');
                 List<DepPickListCtrl2.TPicklistEntry> cityList = tPicklistEntries.get(Country);
                  system.debug('tPicklistEntries====='+cityList);
                for( DepPickListCtrl2.TPicklistEntry e : cityList ){
                    options.add(new SelectOption(e.value, e.label));
                }
            }
            return options;
        }
    }

    // コンストラクタ
    public Example(ApexPages.StandardController controllerz){
        this.oppInstance = new Opportunity();
        
    }     
}