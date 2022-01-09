public class MyController {

    Account account;

    public PageReference save() {
        update account;
        PageReference secondPage = Page.mySecondPage;
        secondPage.setRedirect(true);
        return secondPage; 
    }

    public String getName() {
        return 'MyController';
    }

    public Account getAccount() {
        if(account == null) 
            account = [select id, name, site from Account 
                       where id = :ApexPages.currentPage().getParameters().get('id')];
        return account; 
    } 
}