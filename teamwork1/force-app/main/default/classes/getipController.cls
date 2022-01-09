public class getipController {
 public String ipAddress {get; set;}
 public getipController(){
 ipAddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
 }
 }