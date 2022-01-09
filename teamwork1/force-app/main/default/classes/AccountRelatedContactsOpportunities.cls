public class AccountRelatedContactsOpportunities {
      public string accId {get;set;}
   public AccountRelatedContactsOpportunities(ApexPages.StandardController controller){
         accId = controller.getRecord().id;
    }
public List<Contact> getContacts() {
List<Contact> conresults = [Select Id, FirstName, LastName,Title,Email from Contact where accountid =: accId];
return conresults;
}
public List<Opportunity> getOpportunities() {
List<Opportunity> oppresults = [Select Id,CloseDate,Amount,StageName,Name from Opportunity where accountid =: accId];
return oppresults;
}

}