({
    select: function(component) {
        let selectApex = component.get("c.selectApex");
        selectApex.setParams({
            name: component.get("v.objects.Name"),
            flag: component.get("v.objects.flag__c"),            
            objectId: component.get("v.recordId") 
        });      
        selectApex.setCallback(this, function(response) {
            let state = response.getState(); 
            //alert('2222222'+state);
            if (state === "SUCCESS") {
                console.log("YES!");      
                $A.get("e.force:closeQuickAction").fire();  
                $A.get("e.force:refreshView").fire();
            } else {
                //var errors = response.getError();                       
                //component.set("v.objectsError",true);
              //  alert(1111111111);
                // alert(v.objectsError);
                //component.set("v.errorMessage",errors[0].message);
                console.log("NO: " + state);
            }
        });
        $A.enqueueAction(selectApex);
    },
    doCancel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();      
    }
});