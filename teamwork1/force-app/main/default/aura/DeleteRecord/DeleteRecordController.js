({
    select: function(component) {
        let selectApex = component.get("c.selectApex");
        alert(123);
        //let fields = event.getParam('v.objects.Publish__c');
        //let fields = component.get("v.objects.Publish__c");
       // let eeee = component.get("c.objects.fields.Name.Value")
           //let eeee = component.get("v.Activity_Report__c.fields.Name.Value")        
       // alert(eeee);
        alert(456);
        //alert(field2s);
        selectApex.setParams({           
            selected: component.get("v.objects.Publish__c"),           
            objectId: component.get("v.recordId")
        });       
        selectApex.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                console.log("YES!");
                //let url ='/lightning/r/Activity_Report__c/'+component.get("v.recordId")+'/view';
                //window.location.href = url;
              //https://zc-dev-ed.lightning.force.com/lightning/o/Activity_Report__c/list?filterName=Recent
               // let url ='https://zc-dev-ed.lightning.force.com/lightning/o/Activity_Report__c/list?filterName=Recent';
              let url ='/lightning/o/Activity_Report__c/list?filterName=Recent';
                window.location.href = url;
                $A.get("e.force:closeQuickAction").fire();
                
               // $A.get("e.force:refreshView").fire();
                
            } else {
                console.log("NO: " + state);
            }
        });
        $A.enqueueAction(selectApex);
    },
    doCancel: function(component, event, helper) {
         $A.get("e.force:closeQuickAction").fire();      
    }
});