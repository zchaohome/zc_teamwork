public class LightningMapExampleController {
    @AuraEnabled
    public static List<Account> getAccounts(){
        return [SELECT Id, Name, BillingCountry, BillingState, BillingCity, BillingStreet, Description 
                FROM Account 
                WHERE BillingCity != NULL AND BillingStreet != NULL LIMIT 10];
    }
}