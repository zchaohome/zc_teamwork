public class ReadAR {
    @AuraEnabled
    public Static Boolean selectApex(String name,Id objectId,boolean flag) {
        List<Read_AR__c> rar = null;
        system.debug('name'+name);
        //if(name != null){
        rar = [select id,Name,Activity_Report__c from Read_AR__c where Activity_Report__c=:objectId limit 1];  
         system.debug('rar'+rar);
        //        }
        if(rar.size()>0){
            //rar.addError('This Attendee is Existed');
            Activity_Report__c ar = [select id,Name,flag__c from Activity_Report__c where id=:objectId ]; 
           // system.debug('ar'+ar);
            ar.flag__c = !flag;
            update ar;
             //rar = [select id,Name, from Read_AR__c where id=:objectId ];
            if(flag){
                delete rar;
            }
            
           system.debug('5555555555');
            return false ;
        }else{
            system.debug('44444444444');
            Activity_Report__c ar = [select id,Name,flag__c from Activity_Report__c where id=:objectId ];    
            Read_AR__c readar = new Read_AR__c();
            readar.Name = name;
            //readar.Title__c = title;
            //readar.Country__c = country;
            readar.Activity_Report__c = objectId;
            //readar.Flag__c = true;
            insert readar;
            ar.flag__c = true;
            //system.debug('Flag__c'+ar.Flag__c);
            update ar;
            return true;
        }
    }
}