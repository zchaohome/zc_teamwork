global class AccountBatch implements Database.batchable<sObject> {
    global AccountBatch() {
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([select Id, Name from Account]);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Account> accountList = new List<Account>();
        Account acc = new Account();
        for (sObject s : scope) {
            acc = new Account();
            acc = (Account)s;
          //  acc.TorihikiFlg__c = true;
            accountList.add(acc);
        }
        if (accountList.size() > 0) update accountList; 
    }
    global void finish(Database.BatchableContext BC) {
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Apex Sharing Recalculation ' + a.Status);
        mail.setPlainTextBody
        ('The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }
}