public class MultiSelectController {
     public String Country {get;set;}      //現在のCountry選択値
     public String City {get;set;}         //現在のCity選択値

    public List<selectOption> Countries {
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
     public List<selectOption> Cities {
        get {
            List<selectOption> options = new List<selectOption>();
            List<Opportunity> opp = [select Id, Name,City__c from Opportunity where Country__c =:Country ];
            options.add(new SelectOption('','-- Choose a City --'));
            for(Opportunity o :opp){
                if(o.City__c != null){
                options.add(new SelectOption(o.Name,o.Name));
                    // break;
               }
            }
    

            return options;    
        }   
        set;
    }
        //コンストラクタ
     public MultiSelectController(ApexPages.StandardController controller){

    }    
}