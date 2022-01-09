trigger BatchApexErrorTrigger on BatchApexErrorEvent (after insert) {

    public List<BatchLeadConvertErrors__c> errList = new List<BatchLeadConvertErrors__c>();

    for(BatchApexErrorEvent errEvent : (List<BatchApexErrorEvent>)Trigger.new){
        BatchLeadConvertErrors__c err = new BatchLeadConvertErrors__c();
        err.AsyncApexJobId__c = errEvent.AsyncApexJobId;
        err.Records__c = errEvent.JobScope;
        err.StackTrace__c = errEvent.StackTrace;
        errList.add(err);
    }
    insert errList;
}