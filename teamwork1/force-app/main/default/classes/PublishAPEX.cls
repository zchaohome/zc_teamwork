public class PublishAPEX {
@AuraEnabled
    public Static boolean selectApex(Boolean selected, Boolean flag, Boolean flag2,Id objectId) {
       // Activity_Report__c selectedO = [SELECT Id, publish__c FROM Activity_Report__c WHERE Id =: objectId];
        //if(selected){
        system.debug('selected = '+selected);
        system.debug('flag = '+flag);
        system.debug('flag2 = '+flag2);

        Activity_Report__c ar = new Activity_Report__c (Id = objectId,Publish__c = !selected,flag__c = !flag,flag2__c = !flag2);
        //,flag__c = !flag
        //if(ar.flag__c && ar.Publish__c){
             Update ar;
        //}
           
        //system.debug('Publish__c = '+ar.Publish__c);
       // system.debug('flag__c = '+ar.flag__c);
            return true;
        //}else{
          // Update new Activity_Report__c (Id = objectId,Publish__c = true) ;
           // return true;
        //}
        
       // selectedO.publish__c = ;
       // update selectedO;
        //return new Pagereference('/' + objectId);
        
    } 
}