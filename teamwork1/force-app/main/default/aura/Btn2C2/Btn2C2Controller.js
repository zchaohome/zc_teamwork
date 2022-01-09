({
	showbutton : function(component, event, helper) {
		// To get the value from the event
		var btnflag = event.getParam("flag");
        component.set("v.showbtnflag",btnflag); 
	}
})