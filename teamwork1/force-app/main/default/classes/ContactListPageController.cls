public class ContactListPageController{

public String utf8Bom {get {return '\uFEFF';} private set;}
public List<Contact> selectedContactList {get;set;}
public List<ContactMeisaiInfo> exportObjectList {get;set;}
List<Contact> ssId {get;set;}

public ContactListPageController(ApexPages.StandardSetController controller){

//選択したレコードを取得
ssId=(List<Contact>)controller.getSelected();

selectedContactList=[SELECT Id,IsDeleted,Name,Email,Title,Account.Name FROM Contact where Id IN:ssId order by Name];

system.debug('★SELECT='+ssId);

exportObjectList=new List<ContactMeisaiInfo>();
ContactMeisaiInfo cInfo;

for(Contact oneCont:selectedContactList){

cInfo=new ContactMeisaiInfo();
cInfo.AccountName=oneCont.Account.Name;
cInfo.ConactId=oneCont.Id;
cInfo.ConactName=oneCont.Name;

exportObjectList.add(cInfo);

}
}

public PageReference exportAction(){

system.debug('★exportAction');

//returnnull;

return Page.visualforce_export;

}


public PageReference back(){
String rtnPage=ApexPages.currentPage().getParameters().get('retURL');
PageReference cancel=new PageReference(rtnPage);
return cancel;
}

public class ContactMeisaiInfo{

public String ConactId {get;set;}
public String ConactName {get;set;}
public String AccountName {get;set;}

public ContactMeisaiInfo(){
}
}
}