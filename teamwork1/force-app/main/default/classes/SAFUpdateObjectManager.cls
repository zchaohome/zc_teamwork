@RestResource(urlMapping='/UpdateObject/')
global with sharing class SAFUpdateObjectManager { 
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
        //String requestParams = request.params.get('DestinationInfoId');
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
    global static String updateAccountFields() {
        RestRequest request = RestContext.request;
        String rikoraId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        
        //String requestParamsrikoraId = request.params.get('rikoraId');
        //system.debug('rikoraId===='+requestParamsrikoraId);
        //String requestParamsAccountId = request.params.get('AccountId');
        //system.debug('AccountId===='+requestParamsAccountId);
        //String requestParamsDestinationInfoId = request.params.get('DestinationInfoId');
        //String requestParamsClaimGroupId = request.params.get('ClaimGroupId');
        //String requestParamsServiceId = request.params.get('ServiceId');
        
        //Service__c sers = [SELECT id,Name,AccountId__c,DestinationInfoId__c,ClaimGroupId__c from Service__c where id = :rikoraId];    
        //Account accts = [SELECT id,Name,eats__c,says__c,Active__c from Account where id= :sers.AccountId__c];
        //DestinationInfo__c dests = [SELECT id,Name from DestinationInfo__c where id= :sers.DestinationInfoId__c]; 
        //ClaimGroup__c claims = [SELECT id,Name from ClaimGroup__c where id= :sers.ClaimGroupId__c];
        

     
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
         system.debug('params===='+params);
/********  
{
"Account":{
"AccountNumber":"11111",
"Name":"test1"
},
"DestinationInfo__c":{
"DestinationInfo_Number__c":"22222",
"Name":"test2"
},
"ClaimGroup__c":{
"ClaimGroup_Number__c":"33333",
"Name":"test3"
},
"Service__c":{
"Services_Number__c":"44444",
"Name":"test4"
}
}
********/   
        
        /********  
{
"Account":{
"Id":"0010o00002pHGZUAA4",
"AccountNumber":"0000000",
"Name":"yyyyyyyyy"
},
"DestinationInfo__c":{
"DestinationInfo_Number__c":"22222",
"Name":"test2"
},
"ClaimGroup__c":{
"ClaimGroup_Number__c":"33333",
"Name":"test3"
},
"Service__c":{
"Services_Number__c":"44444",
"Name":"test4"
}
}
********/         
        
            Account accts = null;
            DestinationInfo__c dests = null;
            ClaimGroup__c claims = null;
            Service__c sers = null;     
        String request_time = '';
         String request_comment = '';
         for(String fieldName : params.keySet()) {
            system.debug('fieldName1111===='+fieldName);
           }
             
        for(String fieldName : params.keySet()) {
            system.debug('fieldName===='+fieldName);
            
              if(fieldName == 'request_time'){
                //Map<String, Object> request_time111 = (Map<String, Object>)params.get('request_time');
                request_time = (String)params.get('request_time');
            }
            
           // if(fieldName == 'request_time'){
           //     Map<String, Object> request_comment111 = (Map<String, Object>)params.get('request_comment');
            //    request_comment = (String)request_comment111.get('request_comment');
//            }
            
            if(fieldName == 'request_object'){
             Map<String, Object> request_object = (Map<String, Object>)params.get('request_object');
               
              system.debug('request_object1111===='+request_object);
              //system.debug('accounts.get='+accounts.get('Id'));
               //accts = [SELECT id,Name,AccountNumber from Account where id= :(Id)accounts.get('Id')];
                
              for(String key: request_object.keySet()) {             
                    system.debug('key=='+key);
                   // accts.put(key,accounts.get(key));      
                    if(key == 'Account'){
             Map<String, Object> accounts = (Map<String, Object>)request_object.get('Account');
               
              system.debug('accounts===='+accounts);
              system.debug('accounts.get='+accounts.get('Id'));
               accts = [SELECT id,Name,AccountNumber from Account where id= :(Id)accounts.get('Id')];
                
              for(String key2: accounts.keySet()) {             
                    system.debug('key=='+key2);
                    accts.put(key2,accounts.get(key2));                   
              }

           }
          if(key == 'DestinationInfo__c'){
             Map<String, Object> destinationInfos = (Map<String, Object>)request_object.get('DestinationInfo__c');
              system.debug('destinationInfos===='+destinationInfos);
                 system.debug('destinationInfos.get='+(Id)destinationInfos.get('Id'));
                 dests = [SELECT id,Name,DestinationInfo_Number__c from DestinationInfo__c where id= :(Id)destinationInfos.get('Id')];
              for(String key3: destinationInfos.keySet()) { 
                  //if(key == 'Id'){
                  dests.put(key3,destinationInfos.get(key3));                
                // }
              }
           }
           
            
             if(key == 'ClaimGroup__c'){
             Map<String, Object> claimGroups = (Map<String, Object>)request_object.get('ClaimGroup__c');
              system.debug('claimGroups===='+claimGroups);
                 claims = [SELECT id,Name,ClaimGroup_Number__c from ClaimGroup__c where id= :(Id)claimGroups.get('Id')];
              for(String key4: claimGroups.keySet()) {        
                  claims.put(key4,claimGroups.get(key4));                               
              }
           }
            
            
             if(key == 'Service__c'){
             Map<String, Object> services = (Map<String, Object>)request_object.get('Service__c');
              system.debug('services===='+services);
                 sers = [SELECT id,Name,AccountId__c,DestinationInfoId__c,ClaimGroupId__c,Services_Number__c from Service__c where id = :(Id)services.get('Id')];  
              for(String key5: services.keySet()) {             
                  sers.put(key5,services.get(key5));              
              }
           }
                   
              }
                
             // system.debug('params.get(fieldName)===='+params.get(fieldName));
              //services.put(fieldName, params.get(fieldName));
              
           }
                
          
    } 
         update accts;
         update dests;
         update claims;
         update sers;  
        
         Map<String,Object> maps = new Map<String,Object>();
            
            maps.put('Account', accts);
            maps.put('DestinationInfo__c', dests);
            maps.put('ClaimGroup__c', claims);
            maps.put('Service__c', sers);
        
        //JSON格納構築
        
         Map<String,Object> request_json = new Map<String,Object>();    
                //String request_time = System.now().format('yyyy/MM/dd HH:mm:ss.SSS');
                //String request_comment = 'SFA→RISE TEST';
                request_json.put('request_object',maps);            
                request_json.put('request_comment',request_comment);
                request_json.put('request_time',request_time);
        
             //JSON変換
          String jsonMap = System.JSON.serialize(request_json);      
        system.debug('jsonMap===='+jsonMap);
        return jsonMap;     
        
          //JSON変換
          //String jsonMap = System.JSON.serialize(maps);      
       // system.debug('jsonMap===='+jsonMap);
        //return jsonMap;     
   }        
/********        
      Account thisAccount = null;  
      try{  
        thisAccount = [SELECT Id FROM Account WHERE Id = :rikoraId];
          system.debug('requestParamsrikoraId===='+rikoraId);
/********
{
  "name" : "test0000",
  "AccountNumber" : "12345678",
  "says__c" : "1111111",
  "eats__c" : "2222222"
}
{
  "name" : "RRRRR",
  "traits": {
   "AccountNumber" : "666666",
   "says__c" : "aaaaa"
  },  
  "eats__c" : "bbbbbb"
}

{
"Account"：{
"Id":"001tsada0000000001",
"Name":"test"
},
"DestinationInfo__c"：{
"Id":"001tsada0000000001",
"Name":"test"
},
"ClaimGroup__c"：{
"Id":"001tsada0000000001",
"Name":"test"
},
"Service__c"：{
"Id":"001tsada0000000001",
"Name":"test"
}
}
********/
        /********
        // JSON文字列を名前と値に逆シリアル化する
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        system.debug('params===='+params);
          // 各パラメータ項目と値を繰り返し処理する
        for(String fieldName : params.keySet()) {
            system.debug('fieldName===='+fieldName);
            //if(fieldName!='traits'){
            system.debug('params.get(fieldName)===='+params.get(fieldName));
            // Accountに項目と値を設定する
            
            thisAccount.put(fieldName, params.get(fieldName));
           //}
        }
          //Map<String, Object> traits = (Map<String, Object>)params.get('traits');
           //system.debug('traits===='+traits);
            //for(String key: traits.keySet()) {
              //Object value = traits.get(key);                
               //thisAccount.put(key,traits.get(key));                
            //}
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
********/
}