({
    init: function (cmp, event, helper) {
        
        var action = cmp.get("c.getAccounts");
        cmp.set('v.mapMarkers', [{location: {}}]);

        action.setCallback(this, function(response){
            
            var accounts = response.getReturnValue();
            var markers = [];
            for(var i = 0; i < accounts.length; i++){
                var acc = accounts[i];
                markers.push({
                    location: {
                        Country : acc.BillingCountry,
                        State : acc.BillingState,
                        City: acc.BillingCity,
                        Street: acc.BillingStreet
                    },
    
                    icon : "standard:account",
                    value: acc.Id,
                    title: acc.Name,
                    description: acc.Description
                });
            }
            
            if(markers.length != 0){
                cmp.set('v.mapMarkers', markers);
            }
        });

        $A.enqueueAction(action);
    },

    handlerMarkerSelect: function (cmp, event, helper) {
        console.log(event.getParam("selectedMarkerValue"));
    }
});