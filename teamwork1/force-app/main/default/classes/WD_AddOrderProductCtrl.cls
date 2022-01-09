public with sharing class WD_AddOrderProductCtrl {

    private Integer DEFAULT_PAGE_SIZE = 10;

    public WD_AddOrderProductCtrl(){
    }

     public List<Account> getRecords(){
        List<Account> accList = new List<Account>();
        for(Account a : (List<Account>)setCtrl.getRecords() )    accList.add(a);
        return accList;
    }

    public ApexPages.StandardSetController setCtrl {
        get{
            if(setCtrl == null){
                size = DEFAULT_PAGE_SIZE;
                setCtrl = new ApexPages.StandardSetController(Database.getQueryLocator(getSoqlStr()));
                setCtrl.setPageSize(size);
                noOfRecords = setCtrl.getResultSize();
            }
            return setCtrl;
        }set;
    }

    private String getSoqlStr(){
        String queryString = 'Select Name FROM Account order by Name';
        return queryString;
    }

    public pageReference refresh() {
        setCtrl = null;
        getRecords();
        setCtrl.setPageNumber(1);
        return null;
    }

    public Boolean hasNext {
        get {
            return setCtrl.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            return setCtrl.getHasPrevious();
        }
        set;
    }

    public Integer pageNumber {
        get {
            return setCtrl.getPageNumber();
        }
        set;
    }

    public void first() {
        setCtrl.first();
    }

    public void last() {
        setCtrl.last();
    }

    public void previous() {
        setCtrl.previous();
    }

    public void next() {
        setCtrl.next();
    }

    public Integer noOfRecords{get; set;}
    public Integer size{get;set;}
}