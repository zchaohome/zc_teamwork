trigger AccountTrigger11 on Account (before insert, after insert, 
                                                    before update, after update, 
                                                    before delete, after delete, 
                                                    after undelete) {
    AccountHandler handler = new AccountHandler(Trigger.isExecuting, Trigger.size);
    if(Trigger.isUpdate && Trigger.isBefore){
        //handler.onBeforeUpdate(Trigger.old, Trigger.oldMap, Trigger.new, Trigger.newMap);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        //handler.onAfterUpdate(Trigger.old, Trigger.oldMap, Trigger.new, Trigger.newMap);
    }

}