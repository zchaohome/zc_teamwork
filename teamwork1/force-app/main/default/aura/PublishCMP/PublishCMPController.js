({
    select: function(component) {
        let selectApex = component.get("c.selectApex");
        alert('123');
        //let fields = event.getParam('v.objects.Publish__c');
        //let fields = component.get("v.objects.Publish__c");
       // let eeee = component.get("c.objects.fields.Name.Value")
           //let eeee = component.get("v.Activity_Report__c.fields.Name.Value")        
       // alert(eeee);
        alert('456');
        //alert(field2s);
        selectApex.setParams({           
            selected: component.get("v.objects.Publish__c"),    
            flag: component.get("v.objects.flag__c"), 
            flag2: component.get("v.objects.flag2__c"),    
            objectId: component.get("v.recordId")
        });       
        selectApex.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                 alert('0000');
                console.log("YES!");
                //let url ='/lightning/r/Activity_Report__c/'+component.get("v.recordId")+'/view';
                //window.location.href = url;
                $A.get("e.force:closeQuickAction").fire();
                
                $A.get("e.force:refreshView").fire();
                
            } else {
                 alert('1111');
                console.log("NO: " + state);
            }
        });
        $A.enqueueAction(selectApex);
    },
    doCancel: function(component, event, helper) {
         $A.get("e.force:closeQuickAction").fire();      
    }
});