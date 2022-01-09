public class AccountController {
	@auraEnabled
    public static String insertAccount(Account objA){
        try{
            insert objA;
            	return objA.id;
        }catch(Exception e){
            return 'error';
        }
    }
    
    @auraEnabled
    public static List<Account> getAccounts(){
        return [SELECT Id,Name,Phone,Industry FROM Account order by createddate desc limit 20];
    }
}