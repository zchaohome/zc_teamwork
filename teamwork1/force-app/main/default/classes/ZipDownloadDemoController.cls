public with sharing class ZipDownloadDemoController {

  // Constructor
  public ZipDownloadDemoController() {
  }
  
  @RemoteAction
  public static PageReference getZipDownloadUrl(String objectId) {
  
    Zippex newZip = new Zippex();
    List<Attachment> attachments = [SELECT Name, Body FROM Attachment WHERE ParentId = :objectId];
    
    for(Attachment att : attachments ) {
      newZip.addFile('folder/' + att.Name, att.Body, null);
    }    
    Blob zipData = newZip.getZipArchive();
        
    ContentVersion cv = new ContentVersion();
    cv.Title = 'demo';
    cv.PathOnClient = 'demo.zip';
    cv.VersionData = zipData;
    cv.IsMajorVersion = true;
    cv.FirstPublishLocationId = UserInfo.getUserId();

    insert cv;
  
    PageReference pageRef = new PageReference('https://zc-dev-ed.lightning.force.com/sfc/servlet.shepherd/version/download/' + cv.Id + '?asPdf=false&operationContext=CHATTER');
    pageRef.setRedirect(true);

    return pageRef;
  }

}