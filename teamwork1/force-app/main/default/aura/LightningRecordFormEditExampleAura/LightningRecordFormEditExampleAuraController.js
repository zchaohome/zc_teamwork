({
    handleSubmit : function(cmp, event, helper) {
        event.preventDefault(); 
        //you can change values from here
        const fields = event.getParam('fields');
        fields.phone = '00000'; // modify a field
        cmp.find('myRecordForm').submit(fields);
    }
})