({
	invoke : function(component, event, helper) {
		// get the Component Event
        var evt = component.getEvent("first");
        // set the parameter to the event attribute
        evt.setParams({"flag":true});
        // fire an event.
        evt.fire(); 
	}
})