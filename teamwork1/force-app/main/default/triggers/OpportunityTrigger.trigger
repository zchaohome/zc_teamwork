trigger OpportunityTrigger on Opportunity ( before insert, after insert, before update, after update, before delete ) {

   OpportunityTriggerHandler handler = new OpportunityTriggerHandler();
   system.debug('Trigger.isBefore>>>'+Trigger.isBefore);
   system.debug('Trigger.isAfter>>>'+Trigger.isAfter);
    System.debug(Logginglevel.DEBUG, 'debug');
    System.debug(Logginglevel.WARN, 'warn');
    System.debug(Logginglevel.ERROR, 'error');
   // before insert
   if(Trigger.isInsert && Trigger.isBefore){
       handler.OnBeforeInsert( Trigger.new );
   }
   
   // after insert
   if(Trigger.isInsert && Trigger.isAfter){
       handler.onAfterInsert(Trigger.new, Trigger.newMap);
       //handler.OnAfterInsert( Trigger.newMap );
   }
   /*
   // before update
   if(Trigger.isUpdate && Trigger.isBefore){
       handler.onBeforeUpdate(Trigger.old, Trigger.oldMap, Trigger.new, Trigger.newMap);
       //handler.OnBeforeUpdate( Trigger.new, Trigger.oldMap );
   }
   // after update
   if(Trigger.isUpdate && Trigger.isAfter){
       handler.onAfterUpdate(Trigger.old, Trigger.oldMap, Trigger.new, Trigger.newMap);
       //handler.OnAfterUpdate( Trigger.newMap, Trigger.oldMap );
   }
   // Before delete
   else if(Trigger.isDelete && Trigger.isBefore){
       handler.onBeforeDelete(Trigger.old, Trigger.oldMap);
       //handler.OnBeforeDelete(Trigger.old);
   }
   // After delete
   else if(Trigger.isDelete && Trigger.isAfter){
       handler.onAfterDelete(Trigger.old, Trigger.oldMap);
       //handler.OnAfterDelete(Trigger.old);
   }
   else if(Trigger.isUnDelete){
        handler.onUndelete(Trigger.new);
   }
*/
}