public class DepPicklist {

    //選択リスト型の選択できる値を取得
    public static List<Schema.PicklistEntry> getPicklist(String sObjName, String fieldName){
        List<Schema.PicklistEntry> pickList;
        Schema.SObjectType sObjType = (Schema.SObjectType) Schema.getGlobalDescribe().get(sObjName);
        if(sObjType != null){
            Map<String, Schema.SObjectField> fieldmap = sObjType.getDescribe().fields.getMap();
            Schema.SObjectField f = (Schema.SObjectField) fieldmap.get(fieldName);
            if(f != null){
                Schema.DescribeFieldResult r = f.getDescribe();
                pickList = r.getPicklistValues();
                System.debug('値' + pickList);
            }
        }
        return pickList;
    }
    
      //選択値の取得
      /**
    public static  List<selectOption> getPicklist(String sObjName, String fieldName){
        List<selectOption> optionList = new List<selectOption>();
        Schema.SObjectType sObjType = (Schema.SObjectType) Schema.getGlobalDescribe().get(sObjName);
        if(sObjType != null){
            Map<String, Schema.SObjectField> fieldMap = sObjType.getDescribe().fields.getMap();
            Schema.SObjectField objfield = (Schema.SObjectField) fieldMap.get(fieldName);
            if(objfield != null){
                Schema.DescribeFieldResult fr = objfield.getDescribe();
                List<Schema.PicklistEntry> peList = fr.getPicklistValues();
                for (Schema.PicklistEntry pe: peList) {
                    optionList.add(new selectOption(pe.getValue(), pe.getLabel()) );
                }
            }
        }
        return optionList;
    }
    */
    //連動の値の取得
    public static List<selectOptions> getDependentPicklist(String sObjName, String ctlFieldName, String depFieldName){
        List<selectOptions> depSelList = new List<selectOptions>();
        Schema.SObjectType sObjType = (Schema.SObjectType) Schema.getGlobalDescribe().get(sObjName);
        if(sObjType != null){
            Map<String, Schema.SObjectField> fieldMap = sObjType.getDescribe().fields.getMap();
            Schema.SObjectField ctlObjfield = (Schema.SObjectField) fieldMap.get(ctlFieldName);
            Schema.SObjectField depObjfield = (Schema.SObjectField) fieldMap.get(depFieldName);
           
            if(ctlObjfield != null && depObjfield != null){
                List<Schema.PicklistEntry> ctlPeList = ctlObjfield.getDescribe().getPicklistValues();
                List<Schema.PicklistEntry> depPeList = depObjfield.getDescribe().getPicklistValues();
               
                for (Schema.PicklistEntry pe: ctlPeList) {
                    depSelList.add(new selectOptions(pe.getValue(), pe.getLabel()) );
                }
               
                List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(depPeList);               
                for (PicklistEntryWrapper pew : depEntries) {
                    String label = pew.label;
                    String validForBits = base64ToBits(pew.validFor);
                   
                    for (Integer i = 0; i < validForBits.length(); i++) {
                        List<selectOption> optionList = new List<selectOption>();
                        String bit = validForBits.mid(i, 1);
                        if (bit == '1') {
                            String ctlValue = depSelList[i].sel.value;
                            depSelList[i].depList.add(new selectOption(pew.value, pew.label));
                        }
                    }
                }
            }
        }
        return depSelList;
    }
   
    public class selectOptions {
        public selectOption sel { get;set; }
        public List<selectOption> depList { get;set; }
        public selectOptions(String value, String label) {
            this.sel = new selectOption(value, label);
            this.depList = new List<selectOption>();
        }
    }
    public class selectOption {
        public String label { get;set; }
        public String value { get;set; }
        //public Boolean selected { get;set; }
        public selectOption(String value, String label) {
            this.value = value;
            this.label = label;
            //this.selected = false;
        }
    }
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }
    public static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) return '';
        String validForBits = '';
        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }
       
        return validForBits;
    }
   
    private static String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> peList) {
        return (List<PicklistEntryWrapper>)
            JSON.deserialize(JSON.serialize(peList), List<PicklistEntryWrapper>.class);
    }
    public class PicklistEntryWrapper{
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
        public PicklistEntryWrapper(){           
        }
    }

}