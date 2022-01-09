/* Reference
 * Great thanks to Neel
 * http://titancronus.com/blog/2014/05/01/salesforce-acquiring-dependent-picklists-in-apex/
 */

public class DepPickListCtrl {
    public static Map<String,List<DepPickListCtrl.TPicklistEntry>> GetDependentOptions(String pObjName, String pControllingFieldName, String pDependentFieldName){
        Map<String,List<DepPickListCtrl.TPicklistEntry>> objResults = new Map<String,List<DepPickListCtrl.TPicklistEntry>>();
        //get the string to sobject global map
        Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
        if (!objGlobalMap.containsKey(pObjName))
            return objResults;
        //get the type being dealt with
        Schema.SObjectType pType = objGlobalMap.get(pObjName);
        Map<String, Schema.SObjectField> objFieldMap = pType.getDescribe().fields.getMap();
        //verify field names
        if (!objFieldMap.containsKey(pControllingFieldName) || !objFieldMap.containsKey(pDependentFieldName))
            return objResults;     
        //get the control values   
        List<Schema.PicklistEntry> ctrl_ple = objFieldMap.get(pControllingFieldName).getDescribe().getPicklistValues();
        //get the dependent values
        List<Schema.PicklistEntry> dep_ple = objFieldMap.get(pDependentFieldName).getDescribe().getPicklistValues();
        //iterate through the values and get the ones valid for the controlling field name
        DepPickListCtrl.DependentValidFor dvf=new DepPickListCtrl.DependentValidFor();

        //set up the results
        for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){          
            //get the pointer to the entry
            Schema.PicklistEntry ctrl_entry = ctrl_ple[pControllingIndex];
            //get the label
            String pControllingLabel = ctrl_entry.getLabel();
            //create the entry with the label
            objResults.put(pControllingLabel,new List<DepPickListCtrl.TPicklistEntry>());
        }
        //cater for null and empty
        objResults.put('',new List<DepPickListCtrl.TPicklistEntry>());
        objResults.put(null,new List<DepPickListCtrl.TPicklistEntry>());
        //check the dependent values
        for(Integer pDependentIndex=0; pDependentIndex<dep_ple.size(); pDependentIndex++){          
            //get the pointer to the dependent index
            Schema.PicklistEntry dep_entry = dep_ple[pDependentIndex];
            //get the valid for
            String pEntryStructure = JSON.serialize(dep_entry);                
            DepPickListCtrl.TPicklistEntry objDepPLE = (DepPickListCtrl.TPicklistEntry)JSON.deserialize(pEntryStructure, DepPickListCtrl.TPicklistEntry.class);
            //if valid for is empty, skip
            if (objDepPLE.validFor==null || objDepPLE.validFor==''){
                continue;
            }
            //iterate through the controlling values
            for(Integer idx : dvf.getControlIndexes(objDepPLE.validFor)){
                //get the label
                String pControllingValue = ctrl_ple[idx].getValue();
                objResults.get(pControllingValue).add(objDepPLE);
            }
        } 
        return objResults;
    }
    public class TPicklistEntry{
        public string active {get;set;}
        public string defaultValue {get;set;}
        public string label {get;set;}
        public string value {get;set;}
        public string validFor {get;set;}
        public TPicklistEntry(){
        }
    }
    private class DependentValidFor {
        private Map<String,Set<Integer>> mapValidForIndexes=new Map<String,Set<Integer>>();
        public Set<Integer> getControlIndexes(String validFor){
            if(mapValidForIndexes.containsKey(validFor))
                return mapValidForIndexes.get(validFor);
            String hex=EncodingUtil.convertToHex(EncodingUtil.base64Decode(validFor));
            Set<Integer> result=new Set<Integer>();
            for(Integer i=0; i<hex.length(); i++){
                String b=hex.substring(i, i+1);
                Integer off=i*4;
                switch on b {   //0123(index)
                    when '0'{   //0000
                    }
                    when '1'{   //0001
                        result.add(off+3);
                    }
                    when '2'{   //0010
                        result.add(off+2);
                    }
                    when '3'{   //0011
                        result.add(off+2);
                        result.add(off+3);
                    }
                    when '4'{   //0100
                        result.add(off+1);
                    }
                    when '5'{   //0101
                        result.add(off+1);
                        result.add(off+3);
                    }
                    when '6'{   //0110
                        result.add(off+1);
                        result.add(off+2);
                    }
                    when '7'{   //0111
                        result.add(off+1);
                        result.add(off+2);
                        result.add(off+3);
                    }
                    when '8'{   //1000
                        result.add(off+0);
                    }
                    when '9'{   //1001
                        result.add(off+0);
                        result.add(off+3);
                    }
                    when 'a'{   //1010
                        result.add(off+0);
                        result.add(off+2);
                    }
                    when 'b'{   //1011
                        result.add(off+0);
                        result.add(off+2);
                        result.add(off+3);
                    }
                    when 'c'{   //1100
                        result.add(off+0);
                        result.add(off+1);
                    }
                    when 'd'{   //1101
                        result.add(off+0);
                        result.add(off+1);
                        result.add(off+3);
                    }
                    when 'e'{   //1110
                        result.add(off+0);
                        result.add(off+1);
                        result.add(off+2);
                    }
                    when 'f'{   //1111
                        result.add(off+0);
                        result.add(off+1);
                        result.add(off+2);
                        result.add(off+3);
                    }
                }
            }
            mapValidForIndexes.put(validFor,result);
            return result;
        }
    }
}