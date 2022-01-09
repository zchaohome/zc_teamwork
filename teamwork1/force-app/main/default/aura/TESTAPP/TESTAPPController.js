({
invoke : function(component, event, helper) {
var btnId = event.getSource().getLocalId();
var a = component.find("fv").get("v.value");
var b = component.find("sv").get("v.value");
var res = 0; 
if(btnId =='addbtn'){
res = parseInt(a) + parseInt(b);
component.set("v.res",res);
}
if(btnId === 'mulbtn'){
res = parseInt(a) * parseInt(b);
component.set("v.res",res);
}
if(btnId == 'refreshbtn'){
component.find("fv").set("v.value",null);
component.find("sv").set("v.value",null);
res='_';
component.set("v.flag1",false);
    console.log("f: "+component.get("v.flag1"));
console.log("final");
var m = component.get("v.ddd");
console.log("m: "+m);
}
if(isNaN(res)){
component.set("v.flag1",true);
}
}
})