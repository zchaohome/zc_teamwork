public class TestAccountTriggerHandler {

    public void createContact(List<Account> accList){
        List<Contact> conList = new List<Contact>();
        for(Account acc : accList){
            Contact con = new Contact();
            con.AccountId = acc.Id;
            con.LastName = acc.Name + ' Related Contact';
            conList.add(con);
        }
        if(conList.size()>0){
            insert conList;
        }
    }
}