public with sharing class AccountMapController {
    @AuraEnabled
    public static Boolean UpdateAcc(String conId, String accId) {
        
            List<Account> accList = [SELECT Id, phone
            FROM Account
            WHERE Id =: accId limit 1];
            List<Contact> conList = [SELECT Id, phone
            FROM Contact
            WHERE Id =: conId limit 1];        
            accList[0].phone = conList[0].phone;
            if(accList.size()>0){
                update accList;
                return true;
            }else{
                return false;
            }
            
        
    }

    @AuraEnabled(cacheable=true)
    public static List<objInfo> getAccounts(){
        List<Account> accList = [SELECT Id, Name, BillingCountry, BillingState, BillingCity, BillingStreet, Description
                FROM Account 
                WHERE Name ='張　超'];
        List<objInfo> infoList = new List<objInfo>();
        if(accList.size() > 0){
            objInfo info = new objInfo();
            info.objId = accList[0].Id;
            info.objName = accList[0].Name;
            info.objCountry = accList[0].BillingCountry;
            info.objState = accList[0].BillingState;
            info.objCity = accList[0].BillingCity;
            info.objStreet = accList[0].BillingStreet;
            info.objDescription = accList[0].Description;
            infoList.add(info);
        }
        for(Contact con : [SELECT Id, Name, MailingCountry, MailingState, MailingCity, MailingStreet, Description 
                FROM Contact 
                WHERE MailingCity != NULL AND MailingStreet != NULL
                AND AccountId != :accList[0].Id
                //AND MailingCountry in ('JP','Japan','日本','日本国')  
                LIMIT 9])
        {
            objInfo info = new objInfo();
            info.objId = con.Id;
            info.objName = con.Name;
            info.objCountry = con.MailingCountry;
            info.objState = con.MailingState;
            info.objCity = con.MailingCity;
            info.objStreet = con.MailingStreet;
            info.objDescription = con.Description;
            infoList.add(info);
        }
        return infoList;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(){
        return [SELECT Id, Name, MailingCountry, MailingState, MailingCity, MailingStreet, Description 
                FROM Contact 
                WHERE MailingCity != NULL AND MailingStreet != NULL LIMIT 10];
    } 
    class objInfo{
        @AuraEnabled
        public Id objId {get;set;}
        @AuraEnabled
        public String objName {get;set;}
        @AuraEnabled
        public String objCountry {get;set;}
        @AuraEnabled
        public String objState {get;set;}
        @AuraEnabled
        public String objCity {get;set;}
        @AuraEnabled
        public String objStreet {get;set;}
        @AuraEnabled
        public String objDescription {get;set;}
    }
}