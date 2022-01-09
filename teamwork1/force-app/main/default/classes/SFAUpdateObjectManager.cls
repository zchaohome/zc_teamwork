@RestResource(urlMapping='/UpdateObject1/*')
global with sharing class SFAUpdateObjectManager { 
    //レコードを参照または取得しする 参照
    @HttpGet
    global static String getAccountById() {
        RestRequest request = RestContext.request;
        // URLの末尾からrikoraIdを取得する
        String rikoraId = request.requestURI.substring(
          request.requestURI.lastIndexOf('/')+1);
        //パラメータ複数指定
        //@RestResource(urlMapping='/UpdateAccObject/*/UpdateDestObject/*/UpdateClaimObject/*/UpdateServiceObject')
        //String rikoraId = request.requestURI.substringBetween('UpdateAccObject/','/UpdateDestObject/','/UpdateClaimObject/','/UpdateServiceObject');
        //String requestParams = request.params.get('AccountId');
        //String requestParams = request.params.get('DestinationInfoId');、
        //String requestParams = request.params.get('ClaimGroupId');
        //String requestParams = request.params.get('ServiceId');
       
        Account accresult =  [SELECT Id,Name
                        FROM Account
                        WHERE Id = :rikoraId];
        DestinationInfo__c destresult =  [SELECT id,Name,Accountid__c
                        FROM DestinationInfo__c
                        WHERE Accountid__c = :accresult.Id limit 1];
        ClaimGroup__c claimresult =  [SELECT id,Name,Accountid__c
                        FROM ClaimGroup__c
                        WHERE Accountid__c = :accresult.Id limit 1];
        Service__c serviceresult =  [SELECT id,Name,Accountid__c
                        FROM Service__c
                        WHERE Accountid__c = :accresult.Id limit 1];
        //List形式
        List<Object> lists = new List<Object>();
        lists.add(accresult);
        lists.add(destresult);
        lists.add(claimresult);
        lists.add(serviceresult);
         //JSON変換
         String jsonList = JSON.serialize(lists); 
         //System.debug('json：：'+json);
        
        //Map形式
        Map<String,Object> maps = new Map<String,Object>();
            maps.put('accresult', accresult);
            maps.put('destresult', destresult);
            maps.put('claimresult', claimresult);
            maps.put('serviceresult', serviceresult);
          //JSON変換
          String jsonMap = System.JSON.serialize(maps);            
          //System.debug('json2：：'+json2);
      
        return jsonList;
    }
    /**********仕様通り調整
     @HttpGet
    global static Object doCycleTest() {
        Object1 def1 = new Object1();
        Object2 def2 = new Object2();
        Object3 def3 = new Object3();
        Object4 def4 = new Object4();
        return def1;
    }
 
    global class Object1 {
        Object1 testdef1;
    }    
 
    global class Object2 {
        Object1 testdef2;
    }
    xxxxx
    *********/
    //レコードを作成する 作成
    @HttpPost
    global static ID createAccount(String name, String accountNumber) {
        Account thisAccount = null;
       try{
         thisAccount = new Account(
            Name=name,
            AccountNumber=accountNumber);

        DestinationInfo__c thisDestinationInfo = new DestinationInfo__c(
            Name = name+' DestinationInfo',
           Accountid__c = thisAccount.Id);
       insert thisDestinationInfo;
        ClaimGroup__c thisClaimGroup = new ClaimGroup__c(
            Name=name+' ClaimGroup',
           Accountid__c = thisAccount.Id);
        insert thisClaimGroup;
        Service__c thisService = new Service__c(
            Name=name+' Service',
           Accountid__c = thisAccount.Id);
        insert thisService;   
        
        insert thisAccount;
           
          RestContext.response.responseBody = Blob.valueOf('成功：作成されたレコードのIDは '+ thisAccount.Id);
        }catch(Exception e){
          RestContext.response.responseBody = Blob.valueOf('失敗：'+ e.getMessage());    
        }        
        return thisAccount.Id;
    } 
    //レコードを削除する 削除
    @HttpDelete
    global static void deleteAccount() {
        RestRequest request = RestContext.request;
        String rikoraId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Account accresult = null;
       try{
        accresult = [SELECT Id FROM Account WHERE Id = :rikoraId];
        //一レコード削除処理
         DestinationInfo__c destresult =  [SELECT id,Name,Accountid__c
                        FROM DestinationInfo__c
                        WHERE Accountid__c = :accresult.Id limit 1];
         delete destresult;
        ClaimGroup__c claimresult =  [SELECT id,Name,Accountid__c
                        FROM ClaimGroup__c
                        WHERE Accountid__c = :accresult.Id limit 1];
         delete claimresult;
        Service__c serviceresult =  [SELECT id,Name,Accountid__c
                        FROM Service__c
                        WHERE Accountid__c = :accresult.Id limit 1];
         delete serviceresult;
        
        //複数レコード削除処理
        /*********
        List<DestinationInfo__c> destresult =  [SELECT id,Name,Accountid__c
                        FROM DestinationInfo__c
                        WHERE Accountid__c = :accresult.Id];
         delete destresult;
        List<ClaimGroup__c> claimresult =  [SELECT id,Name,Accountid__c
                        FROM ClaimGroup__c
                        WHERE Accountid__c = :accresult.Id];
         delete claimresult;
        List<Service__c> serviceresult =  [SELECT id,Name,Accountid__c
                        FROM Service__c
                        WHERE Accountid__c = :accresult.Id];
         delete serviceresult;
        *********/
           
         RestContext.response.responseBody = Blob.valueOf('成功：レコードが削除されました.');
        }catch(Exception e){
          RestContext.response.responseBody = Blob.valueOf('失敗：'+ e.getMessage());    
        }        
        delete accresult;
    }
    //通常、既存のレコードを更新したり、レコードを作成したりするために使用する 更新/挿入
    @HttpPut
    global static ID upsertAccount(String name, String accountNumber, String rikoraid) {
       Account thisAccount = null;  
      try{  
       thisAccount = new Account(
                Id=rikoraid,
                Name=name,
                AccountNumber=accountNumber);
        
        // 存在する場合は、IDでAccountを照合する
        // それ以外の場合は、新しいAccountを作成する
        upsert thisAccount;
        
        DestinationInfo__c destresult =  [SELECT id,Name,Accountid__c
                        FROM DestinationInfo__c
                        WHERE Accountid__c = :thisAccount.Id limit 1];
         upsert destresult;
        ClaimGroup__c claimresult =  [SELECT id,Name,Accountid__c
                        FROM ClaimGroup__c
                        WHERE Accountid__c = :thisAccount.Id limit 1];
         upsert claimresult;
        Service__c serviceresult =  [SELECT id,Name,Accountid__c
                        FROM Service__c
                        WHERE Accountid__c = :thisAccount.Id limit 1];
         upsert serviceresult;
          
         RestContext.response.responseBody = Blob.valueOf('成功：レコードを更新されました.');
        }catch(Exception e){
          RestContext.response.responseBody = Blob.valueOf('失敗：'+ e.getMessage());    
        }       
        // AccountIDを返す
        return thisAccount.Id;
    }
    //通常、既存のレコードの項目を更新するために使用する 更新
    @HttpPatch
    global static ID updateAccountFields() {
        RestRequest request = RestContext.request;
        String rikoraId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
      Account thisAccount = null;  
      try{  
        thisAccount = [SELECT Id FROM Account WHERE Id = :rikoraId];
/********
{
  "name" : "test0000",
  "AccountNumber" : "12345678",
  "says__c" : "1111111",
  "eats__c" : "2222222"
}
********/
        // JSON文字列を名前と値に逆シリアル化する
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // 各パラメータ項目と値を繰り返し処理する
        for(String fieldName : params.keySet()) {
            // Accountに項目と値を設定する
            thisAccount.put(fieldName, params.get(fieldName));
        }
        update thisAccount;
        
        DestinationInfo__c destresult =  [SELECT id,Name,Accountid__c
                        FROM DestinationInfo__c
                        WHERE Accountid__c = :thisAccount.Id limit 1];
        destresult.Name = 'DestinationInfo';
        update destresult;
        ClaimGroup__c claimresult =  [SELECT id,Name,Accountid__c
                        FROM ClaimGroup__c
                        WHERE Accountid__c = :thisAccount.Id limit 1];
        claimresult.Name = 'ClaimGroup';
        update claimresult;
        Service__c serviceresult =  [SELECT id,Name,Accountid__c
                        FROM Service__c
                        WHERE Accountid__c = :thisAccount.Id limit 1];
        serviceresult.Name = 'Service';
        update serviceresult;
          RestContext.response.responseBody = Blob.valueOf('成功：レコードを更新されました.');
        }catch(Exception e){
          RestContext.response.responseBody = Blob.valueOf('失敗：'+ e.getMessage());    
        }            
        return thisAccount.Id;
    }    
}