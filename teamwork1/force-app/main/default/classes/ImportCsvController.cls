/***********************************************************
 This cotroller inserts the input CSV data into Sobject 
  maintenance history
  Date         Name        Subject
  2021/03/07   ryu         Created
***********************************************************/ 
public with sharing class ImportCsvController{
    // 行毎のCSVの本文
    private static List<String> fileLines = new List<String>();
    // CSVファイル名
    private static String sObjName = '';
    // エラーメッセージ一覧
    private static List<CustomException> errorList = new List<CustomException>();
    // カスタム例外
    private static CustomException error = null;
    /** 技術者のレコードタイプID */
    private static final Id ACCOUNT_ENGINEER_RECORD_TYPE_ID = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get('EngineerAccount').getRecordTypeId();
    // チェックボックス容許値
    private static Set<String> booleanSet = new Set<String>{'0','1','true','false'};
    // 数値のみ正規表現
    private static String numberRegex = '^[0-9]+$';
    private static Set<String> pNameSet = new Set<String>();
    private static Map<String, String> pSetMap = new Map<String, String>();

    @AuraEnabled
    public static List<ImportCSVWrapper.option> doInit(){
        ImportCSVWrapper wrapper = new ImportCSVWrapper();
        List<ImportCSVWrapper.option> options = wrapper.getAllObject();
        //List<ImportCSVWrapper.option> options = wrapper.getSObject();
        return options;
    }

    @AuraEnabled
    public static void insertCsvData(String sObj, List<String> csvRows) {
        fileLines = csvRows;
        sObjName = sObj;
        Savepoint sp = Database.setSavepoint();
        try {
            Integer i = checkCsvFile();
            if (sObj.toLowerCase() == 'user'){
                if (i == 1){
                    throw new CustomException('インポートデータがありません');
                } else if (i > 1){
                    throw new CustomException(i+'行目入力不備があります');
                }
                InsertUsers(csvRows);
            }else{
                InsertObject(csvRows);
                if(error != null ) throw error;
            }
        }
        catch(Exception e) {
            Database.rollback(sp);
            throw new CustomException( e.getMessage(), e);
        }
    }

    private static Map<String,Id> getProfile(){
        Map<String,Id> profileMap = new Map<String,Id>();
        for(profile p : [SELECT Id,Name from Profile]){
            profileMap.put(p.Name, p.Id);
        }
        return profileMap;
    }
    
    private static void InsertUsers(List<String> fileLines){
        List<SObject> objsAcc = new List<SObject>();
        List<SObject> objsNormalUser = new List<SObject>();
        List<SObject> objsPortalUser = new List<SObject>();

        Map<String, Id> pMap = getProfile();

        // 取引先
        SObjectType workAccObj = Schema.getGlobalDescribe().get('Account');
        // ユーザ
        SObjectType workUserObj = Schema.getGlobalDescribe().get('User');
        // 1行目のヘッダー（項目API参照名）
        List<String> headers = fileLines[0].replace('"','').split(','); 
        System.debug(headers);

        // ユーザ項目定義を取得する
        Map<String, ImportCSVWrapper.sObjInfos> fieldInfo = ImportCSVWrapper.getObjectFieldInfo('user');
        // 行毎に処理を行う
        for (Integer i=1; i < fileLines.size(); i++) { 
            if(String.isBlank(fileLines[i])) continue;
            SObject workAcc = workAccObj.newSObject();
            SObject workUser = workUserObj.newSObject();

            // 権限セットマップ用変数
            string pSetKey = '';
            string pSetValue = '';

            // ダブルコードを消し、各項目値を取得
            String[] inputvalues = new String[]{}; 
            inputvalues = fileLines[i].replace('"','').split(','); 

            Boolean isPortalUser = false;
            for( Integer j=0; j<inputvalues.size();j++){
                // 項目API参照名
                String fieldapiName = headers[j].trim().toLowerCase();
                // 項目値
                String value = inputvalues[j].replace('"','');

                // ユーザ登録情報
                // プロファイル名を元にプロファイルIdを取得して設定する
                if (fieldapiName == 'ProfileId') {
                    String profileName = value;
                    workUser.put(fieldapiName, pMap.get(profileName)); 

                    if(profileName.contains('_技術者')){
                        isPortalUser = true;
                    }
                } else 
                // 権限セット
                if (fieldapiName == 'permissionset') {
                    pSetValue = value;
                    for(String s : pSetValue.split(':')){
                        pNameSet.add(s);
                    }
                } else
                // 漏電官庁フラグは取引先項目なので、Userに設定しない 
                if(fieldapiName != 'denkihoan__rodenkanchoflag__pc') {
                    // ポータルユーザの場合全項目設定、一般ユーザの場合communitynicknameを除外
                    if(isPortalUser || (!isPortalUser && fieldapiName != 'communitynickname')){
                        // チェックボックス項目値をConvertする
                        if (fieldInfo.get(fieldapiName).dataType == Schema.DisplayType.Boolean) {
                            workUser.put(fieldapiName, Boolean.valueOf(value)); 
                        } else {
                            workUser.put(fieldapiName, value); 
                        }
                    } 
                    // 権限セット名のマップ (Key：ユーザ名　Value：権限セット名)
                    if (fieldapiName == 'username') {
                        pSetKey = value;
                    } 
                }
                
                // ポータルユーザの場合、個人取引先の登録情報
                switch on fieldapiName {
                    when 'lastname','firstname' {
                        workAcc.put(fieldapiName, value); 
                    }
                    when 'denkihoan__rodenkanchoflag__pc' {
                        workAcc.put(fieldapiName, Boolean.valueOf(value)); 
                    }
                    when 'email' {
                        workAcc.put('personemail', value); 
                    }
                }
                // 取引先（技術者）のプロファイルを設定する
                workAcc.put('recordtypeid', ACCOUNT_ENGINEER_RECORD_TYPE_ID); 
            }
            // 権限セットマップを作成
            if (String.isNotBlank(pSetValue)) pSetMap.put(pSetKey, pSetValue);

            if(isPortalUser) {
                objsAcc.add(workAcc);
                objsPortalUser.add(workUser);
            }else{
                objsNormalUser.add(workUser);
            }
        }
    
        // 個人取引先を登録する
        if (objsAcc.size() > 0) insert objsAcc;

        set<String> accIds = new Set<String>();
        // 個人取引先Id
        for(sobject acc : objsAcc){
            accIds.add((String)acc.get('Id'));
        }
        // 個人取引先の登録によって自動作成された取引先責任者を取得
        Map<Id,Id> conMap = new Map<Id,Id>();
        for(Contact con : [select Id, AccountId from Contact where AccountId =:accIds]){
            conMap.put(con.AccountId, con.Id);
        } 
        // ポータルユーザのContactIdを設定する
        for(Integer i = 0; i < objsPortalUser.size(); i++) {
            String contactId = conMap.get((String)objsAcc[i].get('Id'));
            objsPortalUser[i].put('ContactId', contactId);
        }
        // ユーザを一括登録する
        if (objsNormalUser.size() > 0) insert objsNormalUser;
        if (objsPortalUser.size() > 0) insert objsPortalUser;

        // 権限セット割り当て
        // 一括登録したユーザのIdを取得する
        Set<String> userIds = new Set<String>();
        for (SObject user : objsNormalUser){
            userIds.add(String.valueOf(user.get('Id')));
        }
        for (SObject user : objsPortalUser){
            userIds.add(String.valueOf(user.get('Id')));
        }
        setPermissionSet(userIds);
    }
    //　権限セット自動割り当て
    private static void setPermissionSet(Set<String> userIds){
        if (userIds.size() == 0 ) return;
        // Userマップを作成、キー：UserName、Value：Id
        Map<String, Id> userMap = new Map<String, Id>();
        for(User user : [SELECT Id, UserName FROM User WHERE Id = :userIds]){
            userMap.put(user.UserName, user.Id);
        }
        // 権限セットマップ作成、キー：権限セット名、Value：権限セットId
        Map<String, Id> pNameMap = new Map<String, Id>();
        for(PermissionSet pmsn : [SELECT Id,label FROM PermissionSet WHERE label = :pNameSet]){
            pNameMap.put(pmsn.label, pmsn.Id);
        }
        List<PermissionSetAssignment> psaObjs = new List<PermissionSetAssignment>();
        for(String userName : pSetMap.keySet()){
            for(String pName : pSetMap.get(userName).split(':')){
                PermissionSetAssignment psa = new PermissionSetAssignment();
                psa.AssigneeId = userMap.get(userName);
                psa.PermissionSetId = pNameMap.get(pName);
                psaObjs.add(psa);
            }
        }
        if (psaObjs.size() > 0) insert psaObjs;
    }
    //
    private static void InsertObject(List<String> fileLines){
        ImportCSVWrapper wrapper = new ImportCSVWrapper();
        //
        List<SObject> objs = new List<SObject>();
        // 共通エラーメッセージ
        String errorMsg = '&1行目&2列に入力不備があります';
        String notSupportMsg = '&1が存在しない、又はサポートされてない項目です';
        Map<String, Id> recortTypeMap = getRecordType();
        // オブジェクト
        SObjectType workObjs = Schema.getGlobalDescribe().get(sObjName);
        // 1行目のヘッダー（項目API参照名）
        List<String> headers = fileLines[0].replace('"','').split(','); 

        // 項目定義を取得する
        Map<String, ImportCSVWrapper.sObjInfos> fieldInfo = ImportCSVWrapper.getObjectFieldInfo(sObjName);
        // 行毎に処理を行う
        for (Integer i=1;i<fileLines.size();i++) { 
            // 空行の場合、処理しない
            if(String.isBlank(fileLines[i])) continue;
            SObject workObj = workObjs.newSObject();

            // ダブルコードを消し、カンマを識別子として各項目値を取得
            String[] inputvalues = new String[]{}; 
            inputvalues = fileLines[i].replace('"','').split(','); 

            for( Integer j=0; j<inputvalues.size();j++){
                String fieldapiName = headers[j].trim().toLowerCase();
                String value = inputvalues[j].replace('"','');
                // 項目値は空白の場合、チェックしない
                if (String.isBlank(value)) {
                    workObj.put(fieldapiName, null);
                    continue;
                }

                // ユーザ登録情報
                // レコードタイプ名を元にレコードタイプIdを取得して設定する
                if (fieldapiName == 'recordtypeId' && recortTypeMap.size() > 0) {
                    if(recortTypeMap.get(value) != null){
                        workObj.put(fieldapiName, recortTypeMap.get(value));
                    } else if (String.isNotBlank(wrapper.getObjectNameByRelationFiledId(value))) {
                        workObj.put(fieldapiName, value);
                    } else {
                        error = new CustomException(errorMsg.Replace('&1',''+i)
                            .Replace('&2',fieldapiName));
                        break;
                    }
                } else {
                    if (fieldInfo.get(fieldapiName) == null) {
                        error = new CustomException(notSupportMsg.Replace('&1',fieldapiName));
                        break;
                    }
                    // 参照項目の場合、15桁又は18桁ではなければエラーになる
                    if (fieldInfo.get(fieldapiName).dataType == Schema.DisplayType.Reference) {
                        String relatedName = wrapper.getObjectNameByRelationFiledId(value);
                        // Idからオブジェクトを特定できない場合
                        if (String.isBlank(relatedName)) {
                            error = new CustomException(errorMsg.Replace('&1',''+i)
                                .Replace('&2',fieldapiName));
                            break;
                        }
                        workObj.put(fieldapiName, value);
                    } else 
                    // チェックボックスの場合
                    if (fieldInfo.get(fieldapiName).dataType == Schema.DisplayType.Boolean) {
                        if (!booleanSet.contains(value.toLowerCase())){
                            error = new CustomException(errorMsg.Replace('&1',''+i)
                                .Replace('&2',fieldapiName));
                            break;
                        }
                        workObj.put(fieldapiName, Boolean.valueOf(value)); 
                    } else 
                    // Integer
                    if(fieldInfo.get(fieldapiName).dataType == Schema.DisplayType.INTEGER){
                        try {
                            workObj.put(fieldapiName, Integer.valueOf(value));
                        } catch (Exception e) {
                            error = new CustomException(errorMsg.Replace('&1',''+i)
                                .Replace('&2',fieldapiName),e);
                            break;
                        }
                    }else 
                    // Long
                    if(fieldInfo.get(fieldapiName).dataType == Schema.DisplayType.LONG){
                        try {
                            workObj.put(fieldapiName, Long.valueOf(value));
                        } catch (Exception e) {
                            error = new CustomException(errorMsg.Replace('&1',''+i)
                                .Replace('&2',fieldapiName),e);
                            break;
                        }
                    } else 
                    // 通貨、数値、パーセントの場合
                    if (fieldInfo.get(fieldapiName).dataType == Schema.DisplayType.CURRENCY
                        || fieldInfo.get(fieldapiName).dataType == Schema.DisplayType.DOUBLE
                        || fieldInfo.get(fieldapiName).dataType == Schema.DisplayType.Percent
                    ){
                        try {
                            workObj.put(fieldapiName, Decimal.valueOf(value));
                        } catch (Exception e) {
                            error = new CustomException(errorMsg.Replace('&1',''+i)
                                .Replace('&2',fieldapiName),e);
                            break;
                        }
                    } else 
                    // 日付型
                    if (fieldInfo.get(fieldapiName).dataType == Schema.DisplayType.Date){
                        value = value.replace('/','-');
                        try {
                            workObj.put(fieldapiName, Date.valueOf(value));
                        } catch (Exception e) {
                            error = new CustomException(errorMsg.Replace('&1',''+i)
                                                                .Replace('&2',fieldapiName),e);
                            break;
                        }
                    } else 
                    // 日付時間型
                    if (fieldInfo.get(fieldapiName).dataType == Schema.DisplayType.DateTime){
                        try {
                            DateTime dt = Datetime.valueOf(value.replace('/', '-'));
                        } catch (Exception e){
                            error = new CustomException(errorMsg.Replace('&1',''+i)
                                                                .Replace('&2',fieldapiName),e);
                            break;
                        }
                    } else 
                    // 時間型
                    if (fieldInfo.get(fieldapiName).dataType == Schema.DisplayType.Time){
                        try{
                            List<String> timeInfo = new List<String>();
                            timeInfo = value.split(':');
                            if(timeInfo.size() == 3){
                                String second = timeInfo[3].split('.')[0];
                                String ms = timeInfo[3].split('.').size() > 1 ? timeInfo[3].split('.')[1] : '0';
                                workObj.put(fieldapiName, Time.newInstance(Integer.valueOf(timeInfo[0])
                                                                        ,Integer.valueOf(timeInfo[1])
                                                                        ,Integer.valueOf(second)
                                                                        ,Integer.valueOf(ms))
                                );
                            }else if(timeInfo.size() == 2) {
                                workObj.put(fieldapiName, Time.newInstance(Integer.valueOf(timeInfo[0])
                                                                        ,Integer.valueOf(timeInfo[1])
                                                                        ,0,0)
                                );
                            }else{
                                error = new CustomException(errorMsg.Replace('&1',''+i)
                                                                    .Replace('&2',fieldapiName));
                                break;
                            }
                        } catch (Exception e){
                            error = new CustomException(errorMsg.Replace('&1',''+i)
                                                                .Replace('&2',fieldapiName),e);
                            break;
                        }
                    } else 
                    // テキスト、メール、電話、選択リスト、テキストエリア、URLはそのまま登録する
                    if (fieldInfo.get(fieldapiName).dataType == Schema.DisplayType.STRING
                    || fieldInfo.get(fieldapiName).dataType == Schema.DisplayType.EMAIL
                    || fieldInfo.get(fieldapiName).dataType == Schema.DisplayType.PHONE
                    || fieldInfo.get(fieldapiName).dataType == Schema.DisplayType.PICKLIST
                    || fieldInfo.get(fieldapiName).dataType == Schema.DisplayType.TEXTAREA
                    || fieldInfo.get(fieldapiName).dataType == Schema.DisplayType.URL){
                        workObj.put(fieldapiName, value);
                    } 
                }
            }
            objs.add(workObj);
        }
        // オブジェクトにデータを登録する
        if (objs.size() > 0) insert objs;
    }

    private static Map<String,Id> getRecordType(){
        Map<String,Id> rtMap = new Map<String,Id>();
        for(recordtype r : [SELECT Id,Name from recordtype where SobjectType =:sObjName]){
            rtMap.put(r.Name, r.Id);
        }
        return rtMap;
    }

    /* validation for csv file */
    private static Integer checkCsvFile(){
        Boolean hasError = false;
        // no csv file
        //only header
        if(fileLines.size()<=1){
            return 1;
        }else{
            // wrong columns
            String[] inputvalues = new String[]{}; 
            String[] inputHeaders = fileLines[0].split(','); 
            for (Integer i=1;i<fileLines.size();i++) { 
                inputvalues = fileLines[i].split(','); 
                if(String.isBlank(fileLines[i])) continue;
                if(inputvalues.size() != inputHeaders.size()) {
                    return i+1;
                }
            }
        }
        return 0;
    }
}