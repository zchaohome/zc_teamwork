global class WS_ZipUtil {

  /**
   * Receive Attachments info from Attachment ParentId
   */
  webService static String getAttachmentByParentId( String sfdcId ){

    if( String.isEmpty( sfdcId ) ) return WS_Util.errorJson('Parameter sfdcId is required.');
    
    List<Attachment> attachmentList =  [SELECT Id, Name, Body, ContentType FROM Attachment WHERE ParentId = :sfdcId];
    if( attachmentList == null || attachmentList.size() == 0 ) return WS_Util.errorJson('Attachment not found.');

    return wrapAttachmentList( attachmentList );
  }

  /**
   * Save Zip file to Document
   */
  webService static String saveToDocument( String zipFileData, String fileName ){

    try{
      String userId = UserInfo.getUserId();
      List<Document> docList = [SELECT Id, Name, FolderId, Body FROM Document WHERE Name = :fileName AND FolderId = :userId LIMIT 1 ];
      Document doc = new Document();
      if( docList == null || docList.size() == 0 ) {
        doc.Name = fileName;
        doc.FolderId = UserInfo.getUserId();
        doc.Body = EncodingUtil.base64Decode( zipFileData );
        insert doc;
      } else {
        doc = docList.get(0);
        doc.Body = EncodingUtil.base64Decode( zipFileData );
        update doc;
      }
      return WS_Util.normalJson( doc.Id );
    } catch ( Exception ex ) {
      return WS_Util.errorJson( ex.getMessage() );
    }
  }

  //Format JSON String from AttachmentList
  private static String wrapAttachmentList( List<Attachment> attachmentList ){

    List<Object> dataList = new List<Object>();
    for( Attachment at : attachmentList ){
      Map<String, String> atMap = new Map<String, String>();
      //atMap.put( 'Id', at.Id );
      atMap.put( 'Name', at.Name );
      atMap.put( 'Body', EncodingUtil.base64Encode( at.Body ) );
      //atMap.put( 'ContentType', at.ContentType );
      dataList.add( atMap );
    }
    return WS_Util.normalJson( dataList );
  }


}