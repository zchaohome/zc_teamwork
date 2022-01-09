public class pdfDownloadController {
    //public pdfDownloadController(ApexPages.StandardController controller){}
    public String getPdf() {
        HttpRequest req = new HttpRequest();
        //req.setEndpoint('https://www.irs.gov/pub/irs-pdf/fw4.pdf');
        req.setEndpoint('https://bytescout-com.s3.amazonaws.com/files/demo-files/cloud-api/pdf-edit/sample.pdf');
        req.setMethod('GET');                          

        // Make call
        Http client = new Http();
        HttpResponse rsp = client.send(req);
        system.debug('rsp->'+rsp);
        system.debug('rsp.getBodyAsBlob()->'+rsp.getBodyAsBlob());
        system.debug('EncodingUtil->'+EncodingUtil.base64Encode(rsp.getBodyAsBlob()));
        return EncodingUtil.base64Encode(rsp.getBodyAsBlob()); 
    }
}