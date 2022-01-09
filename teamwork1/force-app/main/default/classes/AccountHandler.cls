public with sharing class AccountHandler {
 private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public AccountHandler (boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    
    
   public void onBeforeUpdate(List<Account> oldObjs, Map<ID, Account> oldObjMap,   
                               List<Account> newObjs, Map<ID, Account> newObjMap){
      
           //for (Account acc :oldObjs) {
            // 既存Eventの取得
              //List<Opportunity> opps = 
                //[SELECT Id, Name ,AccountId,Parent_Account__c
                //FROM Opportunity 
                //Where Parent_Account__c =: acc.Id ];                          
               //system.debug('1111==='+opps);    
               //for (Opportunity op : opps) {
                 //op.Parent_Account__c = acc.ParentId;
                //system.debug('2222==='+op.Parent_Account__c);   
                //system.debug('3333==='+op.Name);  
               //}   
          // } 
                  
                        for (Account acc :newObjs) {
            // 既存Eventの取得
             List<Opportunity> opps = 
                [SELECT Id, Name ,AccountId,Parent_Account__c
                FROM Opportunity 
                Where Parent_Account__c =: acc.Id ];                          
               system.debug('1111==='+opps);    
               for (Opportunity op : opps) {
                  system.debug('op.AccountIdd==='+op.AccountId);    

                 op.Parent_Account__c = GetParentAccountIdById(acc.ParentId);//acc.ParentId;
                system.debug('op.Parent_Account__c==='+op.Parent_Account__c);   
                system.debug('op.Name==='+op.Name);  
               }   
           }                       
                                   

    }

    // 更新後処理
    public void onAfterUpdate(List<Account> oldObjs, Map<ID, Account> oldObjMap, 
                              List<Account> newObjs, Map<ID, Account> newObjMap){
         
           for (Account acc :oldObjs) {
            // 既存Eventの取得
             List<Opportunity> opps = 
                [SELECT Id, Name ,AccountId,Parent_Account__c
                FROM Opportunity 
                Where Parent_Account__c =: acc.Id ];                          
               system.debug('1111==='+opps);    
               for (Opportunity op : opps) {
                  system.debug('op.AccountIdd==='+op.AccountId);    

                 op.Parent_Account__c = GetParentAccountIdById(acc.ParentId);//acc.ParentId;
                system.debug('op.Parent_Account__c==='+op.Parent_Account__c);   
                system.debug('op.Name==='+op.Name);  
               }   
           } 
                             
    }  
    
    private String GetParentAccountIdById(String accountId) {
        String parentId = accountId;
        List<Account> accList = new List<Account>();
        accList = [select Id
                          ,Name
                          ,ParentId
                     from 
                          Account
                    where Id =: accountId
                  ];
        if (accList.size() == 1) {
            if (String.isNotBlank(accList[0].ParentId)) {
                parentId = GetParentAccountIdById(accList[0].ParentId);
            }      
        }
        return parentId;
    }
   
     
}