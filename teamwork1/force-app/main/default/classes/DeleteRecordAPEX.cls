public class DeleteRecordAPEX {

@AuraEnabled
    public Static boolean selectApex(Boolean selected, Id objectId) {
       // Activity_Report__c selectedO = [SELECT Id, publish__c FROM Activity_Report__c WHERE Id =: objectId];
        //if(selected){
           // Update new Activity_Report__c (Id = objectId,Publish__c = !selected);
           // return true;
        //}else{
          // Update new Activity_Report__c (Id = objectId,Publish__c = true) ;
           // return true;
        //}
        
       // selectedO.publish__c = ;
       // update selectedO;
        //return new Pagereference('/' + objectId);
        
      Activity_Report__c ar = [SELECT Id, name,publish__c FROM Activity_Report__c WHERE Id =: objectId];
     //if(ar.publish__c == true){
       //   ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, '削除できません。'));
     //}else{
         delete ar;
    // }
      
      //ar = [SELECT Id, publish__c FROM Activity_Report__c];
      return true;
    } 
}