({
    getAccounts : function(component, event, helper) {
        //call getAccountsHelper method
        helper.getAccountsHelper(component, event, helper);
    },
     
    // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // remove slds-hide class from mySpinner
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // add slds-hide class from mySpinner    
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    }
})