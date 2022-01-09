({
	doSave : function(component, event, helper) {
		var accountRecord = component.get("v.acc");
        var action = component.get("c.insertAccount");
        action.setParams({"objA":accountRecord});
        action.setCallback(this,function(response){
           var state = response.getState();
            if(state == 'SUCCESS'){
                var res = response.getReturnValue();
                if(res != 'error'){
                    // fire an event.
                    var evt = component.getEvent("first");
                    evt.setParams({"flag":true});
                    evt.fire();
                }
            }
        });
        $A.enqueueAction(action);
	},
    doCancel : function(component, event, helper){
        var acc;
        console.log('acc->>'+acc);
        component.set("v.acc",acc); 
        var evt = component.getEvent("first");
        evt.setParams({"flag":false});
        evt.fire();
    }
})