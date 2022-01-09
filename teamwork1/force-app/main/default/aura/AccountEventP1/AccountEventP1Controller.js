({
	displayAccounts : function(component, event, helper) {
		// Columns
		var cols = [
            {label:'Account Name',fieldName:'Name',type:'text'},
            {label:'Account Phone',fieldName:'Phone',type:'text'},
            {label:'Account Industry',fieldName:'Industry',type:'text'}
        ];
        component.set("v.myColumns",cols); 
        // Data
        var action=component.get("c.getAccounts");
        action.setCallback(this,function(response){
           	var state = response.getState();
            if(state == 'SUCCESS'){
                var res = response.getReturnValue();
                var flg = event.getParam("flag");                
                if(flg){
                    component.set("v.lstAccounts",res);
                    component.set("v.flag1",true);   
                    console.log('doSave');
                    console.log('v.flag1=>>'+component.get("v.flag1"));
                }else{  
                    component.set("v.flag1",flg);                 
                    console.log('doCancel');
                    console.log('v.flag1=>>'+component.get("v.flag1"));             
               }
            }
        });
        $A.enqueueAction(action);
	}
})