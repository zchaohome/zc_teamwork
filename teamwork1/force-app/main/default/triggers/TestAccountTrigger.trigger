trigger TestAccountTrigger on Account (after insert) {
    TestAccountTriggerHandler tath = new TestAccountTriggerHandler();
    if(trigger.isAfter && trigger.isInsert){
        tath.createContact(trigger.new);
    }
}