public without sharing class OpportunityTriggerHandler {

   /**
    * before insert
    */
   public void OnBeforeInsert( List<Opportunity> news ){
       for( Opportunity o : news ) {
       	o.Name = o.CloseDate + '_' + o.Type + '_' + o.AccountId ;
       }
   }

   /**
    * after insert
    */
   public void OnAfterInsert(List<Opportunity> news, Map<Id, Opportunity> newMap ){
       Account acc = new Account();
       for( Opportunity o : news) {
           acc.Name = o.Name;
       }
       insert acc;
   }    
}