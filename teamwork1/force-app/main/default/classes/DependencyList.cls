public inherited sharing class DependencyList {
     public String Country {get;set;}      //現在のCountry選択値
     public String City {get;set;}         //現在のCity選択値
     public List<selectOption> getCountries {
        get {
            List<selectOption>  options = new List<SelectOption>();
            options.add(new SelectOption('','-- Choose a Country --'));
            List<Schema.PicklistEntry> picklist = DepPicklist.getPicklist('Opportunity', 'Country__c');
            SelectOption sop;
            for(Schema.PicklistEntry pick : picklist){
                sop = new SelectOption(pick.getValue(), pick.getLabel());
                // 値と表示ラベルを追加（value,label） 
                options.add(sop);
            }
         return options;         
        }
        set;
    }
     public List<selectOption> getCities {
        get {
          List<DepPicklist.selectOptions> options2 = DepPicklist.getDependentPicklist('Opportunity','Country__c','City__c');
           List<selectOption>  options3 = new List<selectOption>();
            options3.add(new SelectOption('','-- Choose a Country --'));
            for(DepPicklist.selectOptions lagreList: options2){
            if(this.Country == lagreList.sel.Value){
                for(DepPicklist.SelectOption middleList: lagreList.depList){
                    options3.add(new Selectoption(middleList.Value, middleList.Label));
               }
              }
            }
            return options3;
        }  
        set;
    }
    public DependencyList(ApexPages.StandardController controller) {
    }

  }