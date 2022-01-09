public class RelatedOpportunityChildTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public RelatedOpportunityChildTriggerHandler (boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
     // 登録前処理
    public void onBeforeInsert(List<Opportunity> newObjs){
        for (Opportunity op : newObjs) {
            op.Parent_Account__c = GetParentAccountIdById(op.AccountId);
        }
    }
     // 登録後処理
    public void onAfterInsert(List<Opportunity> newObjs, Map<ID, Opportunity> newObjMap){}
    
     // 変更前処理
    public void onBeforeUpdate(List<Opportunity> oldObjs, Map<ID, Opportunity> oldObjMap, 
                               List<Opportunity> newObjs, Map<ID, Opportunity> newObjMap){
        for (Opportunity op : newObjs) {
            op.Parent_Account__c = GetParentAccountIdById(op.AccountId);
        }
    }
    // 更新後処理
    public void onAfterUpdate(List<Opportunity> oldObjs, Map<ID, Opportunity> oldObjMap, 
                              List<Opportunity> newObjs, Map<ID, Opportunity> newObjMap){}
    
      // 削除前処理
    public void onBeforeDelete(List<Opportunity> oldObjs, Map<ID, Opportunity> oldObjMap){
    }
    // 削除後処理
    public void onAfterDelete(List<Opportunity> oldObjs, Map<ID, Opportunity> oldObjMap){
    }
    // リカバリー
    public void onUndelete(List<Opportunity> newObjs){
    }
    
     // ParentAccount取得用の再帰処理
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