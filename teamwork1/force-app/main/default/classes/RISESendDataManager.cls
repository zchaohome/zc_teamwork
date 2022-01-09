public class RISESendDataManager {

    //public Animal animal;
    
    //public class Animal {
        //public Integer id;
        //public String name;
        //public String eats;
        //public String says;
    //}
    
    //サンプルＡＰＩに送信メソッド
    public static void sendData(){
        
    //endpoint定義
    String myendpoint = 'https://th-apex-http-callout.herokuapp.com/animals';
    //String myendpoint = 'https://www.alphavantage.co/query?function=INCOME_STATEMENT&symbol=IBM&apikey=demo';

    //Accountレコード取得  
    list<Account> accts = [SELECT id,Name,eats__c,says__c,Active__c from Account where Active__c = 'Yes' Limit 1];
   
    if(!accts.isEmpty()){
       
        // JSON文字列の生成
        JSONGenerator gen = JSON.createGenerator(true); 
         //gen.writeStartObject();     
         //gen.writeFieldName('AccountList');
         //gen.writeStartArray();
        List<Object> momeList = new List<Object>();
            for(Account acc: accts){
                //①
                gen.writeStartObject();  
                //gen.writeStringField('id',acc.id);
                gen.writeStringField('name', acc.Name);            
                //gen.writeStringField('eats',acc.eats__c);
                //gen.writeStringField('says',acc.says__c);
                gen.writeEndObject();          
                
                //各フォーマットテスト
                //②                 
                Map<String,String> momeMap = new Map<String,String>();
                momeMap.put('id', acc.id);    
                momeMap.put('name', acc.Name);    
                momeMap.put('eats', acc.eats__c);    
                momeMap.put('says', acc.says__c);  
                
                momeList.add(momeMap);                    
             } 
        
          //gen.writeEndArray();
          //gen.writeEndObject();
            // JSON文字列を作成①
            String accountJSON = gen.getAsString();	
            System.debug('accountJSON：：'+accountJSON);          
        
           // JSON文字列を作成②             
            String json = JSON.serialize(momeList); 
            System.debug('json：：'+json);    
        
            //Mapに変換
            //Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(accountJSON);
              //System.debug('jsonMap：：'+jsonMap);
              //System.debug('jsonMap：name：'+jsonMap.get('name'));
              
            // List<Object>に変換
            //String accountJSONList  = '[' + gen.getAsString() + ']';
              //List<Object> jsonAccountList = (List<Object>) JSON.deserializeUntyped(accountJSONList);
              // System.debug('jsonAccountList：：'+jsonAccountList);
               //List<Object> items = (List<Object>)jsonMap.get('AccountList');
               //for (Object item : items) {
                   //Map<String, Object> i = (Map<String, Object>)item;
                   //System.debug(i.get('name'));
               //}
               
            HttpRequest req = new HttpRequest();  
            req.setEndpoint(myendpoint);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json;charset=UTF-8'); 
            //req.setBody(JSON.serialize(accts));
            //System.debug('JSON.serialize：：'+JSON.serialize(accts));
            req.setBody(accountJSON); //①
            //req.setBody(json);//②
            HttpResponse res = new Http().send(req);
             if (res.getStatusCode() != 201) {
                        System.debug('返されるステータスコードは予期されていませんでした： ' +
                            res.getStatusCode() + ' ' + res.getStatus());
              } else {
                  System.debug(res.toString());
                  System.debug(res.getStatus());
                  System.debug(res.getStatusCode());
                  System.debug(res.getBody()); 
             }
     }
   }
    
    //サンプルＡＰＩに送信メソッド、データ登録バッチから、このメッセージを呼び出し
    public static void testData(String ServiceId){
        
    //取引先レコード取得  
    //list<Account> accts = [SELECT id,Name,eats__c,says__c,Active__c from Account where Active__c = 'Yes' Limit 1];
    //送付先レコード取得
    //list<DestinationInfo__c> dests = [SELECT id,Name from DestinationInfo__c Limit 1]; 
    //請求グループレコード取得
    //list<ClaimGroup__c> claims = [SELECT id,Name from ClaimGroup__c  Limit 1];
    //サービスレコード取得
    //list<Service__c> services = [SELECT id,Name from Service__c  Limit 1]; 
        
    Service__c services = [SELECT id,Name,AccountId__c,DestinationInfoId__c,ClaimGroupId__c from Service__c where id = :ServiceId];    
        Account accts = [SELECT id,Name,eats__c,says__c,Active__c from Account where id= :services.AccountId__c];
        DestinationInfo__c dests = [SELECT id,Name,OwnerId from DestinationInfo__c where id= :services.DestinationInfoId__c]; 
        ClaimGroup__c claims = [SELECT id,Name from ClaimGroup__c where id= :services.ClaimGroupId__c];
        
        if(accts !=null && dests !=null && claims !=null && services !=null){
            List<Object> momeList = new List<Object>();
            Map<String,Map<String,String>> momeMap = new Map<String,Map<String,String>>();
//"Account"：{
//"Id":"001tsada0000000001",
//"Name":"test"
//},  
/**
{
	"request_time": "2021/01/01 12:59:59.347",
	"request_comment": "SFA→RISE PTL（内容は任意）",
	"request_object": {
		"Account": {
                        "Id": "10001",
			"FirstName": "進一",
			"LastName": "安丸"
		},
		"DestinationInfo__c": {
                        "Id": "20001",
			"Name": "安丸進一",
			"OwnerId": "testId"
		},
		"ClaimGroup__c": {
                        "Id": "30001",
			"Name": "安丸進一",
			"RecordTypeId": "testId"
		},
		"Service__c": {
                        "Id": "40001",
			"Name": "安丸進一",
			"RecordTypeId": "testId"
		}
	}
}          
*/           
           
            
            //for(Service__c service: services){
                Map<String,String> servicemomeMap = new Map<String,String>();
                servicemomeMap.put('name', services.Name);
                servicemomeMap.put('id', services.id);     
                Map<String,Object> servicemomeMaps = new Map<String,Object>();
                servicemomeMaps.put('Service__c', servicemomeMap);
                //momeList.add(servicemomeMaps);
                momeMap.put('Service__c',servicemomeMap);
            //}
            //for(ClaimGroup__c claim: claims){
                Map<String,String> claimmomeMap = new Map<String,String>();
                claimmomeMap.put('name', claims.Name);    
                claimmomeMap.put('id', claims.id);    
                Map<String,Object> claimmomeMaps = new Map<String,Object>();
                claimmomeMaps.put('ClaimGroup__c', claimmomeMap);
                //momeList.add(claimmomeMaps);
                momeMap.put('ClaimGroup__c',claimmomeMap);
            //}                   
                 //for(DestinationInfo__c dest: dests){
                Map<String,String> destmomeMap = new Map<String,String>();
                destmomeMap.put('name', dests.Name);
                destmomeMap.put('id', dests.id);                        
                Map<String,Object> destmomeMaps = new Map<String,Object>();
                destmomeMaps.put('DestinationInfo__c', destmomeMap);
                //momeList.add(destmomeMaps);
                momeMap.put('DestinationInfo__c',destmomeMap);
            //}
            
             //for(Account acc: accts){
                Map<String,String> accmomeMap = new Map<String,String>();
                accmomeMap.put('name', accts.Name);
                accmomeMap.put('id', accts.id);                        
                Map<String,Object> accmomeMaps = new Map<String,Object>();
                accmomeMaps.put('Account', accmomeMap);
                //momeList.add(accmomeMaps);
                momeMap.put('Account',accmomeMap);
            //}
       
            
            //複数レコード
            //System.debug('momeList：：'+momeList);   
            //String json = JSON.serialize(momeList); 
            //System.debug('json：：'+json);  
            
            
            //一レコードずつ
            //Map<String,Map<String,Object>> request_object = new Map<String,Map<String,Object>>();
            //request_object.put('request_object',momeMap);
            
            System.debug('momeMap：：'+momeMap);   
            String json1 = JSON.serialize(momeMap); 
            System.debug('json1：：'+json1); 
            
            //System.debug('request_object：：'+request_object);   
            //String json2 = JSON.serialize(request_object); 
            //System.debug('json=request_object：：'+json2); 
            
            system.debug('system time==='+System.now().format('yyyy-dd-mm HH:mm:ss'));
            
            Map<String,Object> request_json = new Map<String,Object>();
            
            request_json.put('request_object',momeMap);            
            request_json.put('request_comment','SFA→RISE TEST');
            request_json.put('request_time',System.now().format('yyyy/MM/dd HH:mm:ss.SSS'));
            
            String json2 = JSON.serialize(request_json); 
            System.debug('json=request_object：：'+json2); 
        
            HttpRequest req = new HttpRequest();  
            req.setEndpoint('https://api.thecatapi.com/v1/votes');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json;charset=UTF-8'); 
            //req.setHeader('x-api-key', 'DEMO-API-KEY'); 
            String jsonString =  '{"image_id": "ererer","sub_id": "my-user-1234","value": "1"}';
            req.setBody(jsonString);
            HttpResponse res = new Http().send(req);
            if (res.getStatusCode() != 200) {
                            System.debug('返されるステータスコードは予期されていませんでした： ' +
                                res.getStatusCode() + ' ' + res.getStatus());
                  } else {
                      System.debug(res.toString());
                      System.debug(res.getStatus());
                      System.debug(res.getStatusCode());
                      System.debug(res.getBody()); 
                 }
   
    }
}    
}