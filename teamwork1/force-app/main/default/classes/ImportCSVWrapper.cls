/**
@name ImportCSVWrapper 
@CreateDate 14/03/2021
@Description Wrapper Class for auto Import CSV
@Version 1.0 
@reference 
*/
public class ImportCSVWrapper {
    public static Map<String, sObjInfos> getObjectFieldInfo(String sObjName){
        String sObjectName = sObjName;
        Map<String, sObjectType> sObjTypeMap = Schema.getGlobalDescribe();
        sObjectType sObjType = sObjTypeMap.get(sObjectName);
        DescribeSObjectResult sObjectDescribe= sObjType.getDescribe();
        // オブジェクトに対する作成権限
        Boolean canCreate = sObjectDescribe.isCreateable();
        // 作成権限がない場合、空を返す
        if (!canCreate) return new Map<String, sObjInfos>();

        Map<String, SObjectField> fields = sObjectDescribe.fields.getMap();
        
        Map<String, sObjInfos> fieldInfotMap = new Map<String, sObjInfos>();
        for(String fld : fields.keySet()){
            DescribeFieldResult field = fields.get(fld).getDescribe();
            if(field.isCreateable()){
                sObjInfos sObj = new sObjInfos();
                // データ型
                sObj.dataType = field.getType();
                // 項目API参照名
                sObj.fieldName = field.getName();
                // 項目ラベル
                sObj.fieldLabel = field.getLabel();
                fieldInfotMap.put(fld,sObj);
            }
        }
        return fieldInfotMap;
    }
    //globalDescribe
    public Map<String, Schema.SObjectType> globalDescribe {
        get{
            if(globalDescribe == null){
                globalDescribe = Schema.getGlobalDescribe();
            }
            return globalDescribe;
        }
        set;
    }
    //リレーションフィールドのprefixからオブジェクト名を
    public String getObjectNameByRelationFiledId(String objectId){
        String objName;
        //先頭から3文字
        String headFiled = objectId.substring(0, 3);
        System.debug('★headFiled='+headFiled);
        for (Schema.SObjectType stypekey : globalDescribe.values()) {

            String prefix = stypekey.getDescribe().getKeyPrefix();
            //プレフィックス名と一致
            if( headFiled == prefix){
                objName = stypekey.getDescribe().getName();
                break;
            }
        }
        return objName;
    }

    public class sObjInfos{
        @AuraEnabled
        public Schema.DisplayType dataType { get; set; }

        @AuraEnabled
        public String fieldName { get; set; }

        @AuraEnabled
        public String fieldLabel { get; set; }

        public sObjInfos() {
        }
    } 

    public static List<option> getAllObject(){
        List<option> options = new List<option>();
        //すべてのオブジェクトを取得
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        for(String k : schemaMap.keySet()) {
            Schema.DescribeSObjectResult schemaSobj = schemaMap.get(k).getDescribe();
            //クエリできるオブジェクト
            if(schemaSobj.isQueryable() &&                  
            //アクセスできるオブジェクト
            schemaSobj.isAccessible() &&
            //更新可能なオブジェクト
            schemaSobj.isCreateable() &&                 
            //新規機能用に予約されたオブジェクトではない
            !schemaSobj.isDeprecatedAndHidden() &&       
            //カスタム設定ではない（任意）
            !schemaSobj.isCustomSetting() &&            
            //グローバル検索できないオブジェクトまたはカスタムオブジェクトである
            //カスタムオブジェクトを新規作成した場合は、デフォルトでカスタムオブジェクトがオフになっているため、
            //OR条件でカスタムオブジェクトであるを追加しています
            (schemaSobj.isSearchable() || schemaSobj.isCustom())) {
                option o = new option(schemaMap.get(k).getDescribe().getLabel(), schemaMap.get(k).getDescribe().getName());
                options.add(o);
            }
        }
        return options;
    }

    public static List<option> getSObject(){
        List<option> options = new List<option>();
        //すべてのオブジェクトを取得
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        for(String k : schemaMap.keySet()) {
            Schema.DescribeSObjectResult schemaSobj = schemaMap.get(k).getDescribe();
            //以下のオブジェクトのみ表示
            if(schemaSobj.getLabel()=='ユーザ' ||
            schemaSobj.getLabel()=='サービス'  ||
            schemaSobj.getLabel()=='Account'  ||
            schemaSobj.getLabel()=='メール宛先'  ||
            schemaSobj.getLabel()=='漏電監視機器'  ||
            schemaSobj.getLabel()=='保安設備マスター'  ||
            schemaSobj.getLabel()=='保安設備'){ 
                //クエリできるオブジェクト
                //if(schemaSobj.isQueryable() &&                  
                //アクセスできるオブジェクト
                //schemaSobj.isAccessible() &&
                //更新可能なオブジェクト
                //schemaSobj.isCreateable() &&                 
                //新規機能用に予約されたオブジェクトではない
                //!schemaSobj.isDeprecatedAndHidden() &&       
                //カスタム設定ではない（任意）
                //!schemaSobj.isCustomSetting() &&            
                //グローバル検索できないオブジェクトまたはカスタムオブジェクトである
                //カスタムオブジェクトを新規作成した場合は、デフォルトでカスタムオブジェクトがオフになっているため、
                //OR条件でカスタムオブジェクトであるを追加しています
                //(schemaSobj.isSearchable() || schemaSobj.isCustom())) {
                    option o = new option(schemaMap.get(k).getDescribe().getLabel(), schemaMap.get(k).getDescribe().getName());
                    options.add(o);
                //}
            }
        }
        return options;
    }

    public class option{
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string value;

        public option (String label, String value){
            this.label = label;
            this.value = value;
        }
    }
}