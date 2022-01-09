({
    newCaseAction : function(component, event, helper) {
        var homePageNewslabel = $A.get("$Label.c.HomePageZC");
        component.set('v.homePageNews', homePageNewslabel);
    }
})