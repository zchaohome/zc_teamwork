public with sharing class lwc_UserInfoController {
    public lwc_UserInfoController() {

    }
    @AuraEnabled(cacheable=true)
    public static User retrieveUserInfo(Id userId){
        System.debug('userid->>'+userId);
        try {
            User record = [
              select Id
              ,Username
              ,Name
              ,UserRole.Name
              ,Profile.Name
              ,UserType
              ,LanguageLocaleKey
              From User
              where
               Id = : userId

            ];
            //system.debug('record->>'+record);
            return record;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}