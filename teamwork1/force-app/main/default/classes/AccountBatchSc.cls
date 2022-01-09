global class AccountBatchSc implements Schedulable{
    global void execute(System.SchedulableContext sc){
        AccountBatch aub = new AccountBatch ();
            database.executebatch(aub);
    }
}