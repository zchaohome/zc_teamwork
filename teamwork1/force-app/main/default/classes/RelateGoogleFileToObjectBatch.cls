public class RelateGoogleFileToObjectBatch implements Database.Batchable<googlefiles>,Database.AllowsCallouts, Database.Stateful{
    public RelateGoogleFileToObjectBatch(){
    }
    public List<googlefiles> start(Database.BatchableContext BC){
        List<googlefiles> gfList = new List<googlefiles>();
        DateTime startDate = DateTime.newInstance(2021, 9, 1, 0, 0, 0);
        for(items_ConnectGoogleDrive__x item : [select Id,Name__c,DownloadUrl__c,DisplayUrl from items_ConnectGoogleDrive__x where UpdateDate__c >= :startDate AND IsFolder__c = false])
        {
            googlefiles gf = new googlefiles();
            gf.name = item.Name__c;
            gf.downloadurl = item.DownloadUrl__c;
            gf.displayurl = item.DisplayUrl;
            gfList.add(gf);
        }
        return gfList;
    }
    public void execute(Database.BatchableContext BC, List<googlefiles> scope) {
        Set<String> Ids = new Set<String>();
        for(googlefiles item : scope){
            Ids.add(item.name.split('_')[0]);
        }
        Map<String,String> folderMap = new Map<String,String>();
        for(items_ConnectGoogleDrive__x item : [select Id,Name__c,DisplayUrl from items_ConnectGoogleDrive__x where Name__c= :Ids AND IsFolder__c = true]){
            folderMap.put(item.Name__c, item.DisplayUrl);
        }
        delete [select Id from GoogleFiles__c where AccountGoogle__c= :Ids];
        
        List<GoogleFiles__c> updList = new List<GoogleFiles__c>();
        for(googlefiles item : scope){
            GoogleFiles__c gf = new GoogleFiles__c();
            Id strId = item.name.split('_')[0];
            if(strId.getSobjectType() == Schema.Account.SObjectType){
                gf.name=item.name.split('_')[1];
                gf.AccountGoogle__c=strId;
                gf.Attachment_URL__c=item.downloadurl;
                gf.Display_URL__c=item.displayurl;
                gf.Folder_URL__c=folderMap.get(strId);
                updList.add(gf);
            }
        }
        if(updList.size() > 0) insert updList;
    }
    public void finish(Database.BatchableContext BC){
        
    }
    public class googlefiles{
        public String name { get; set; }
        public String downloadurl { get; set; }
        public String displayurl { get; set; }
        public String folderurl { get; set; }
    }
}