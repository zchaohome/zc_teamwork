<aura:application implements="flexipage:availableForRecordHome,force:hasRecordId" access="global" >
 <lightning:recordViewForm recordId="{!v.recordId}" objectApiName="Account">
        <div style="width:500px;border:1px solid black;">
            <lightning:card title="Customer" iconName="standard:account">
                <div style="padding:20px;">
                 <lightning:outputField fieldName="Name"/> 
                 <lightning:outputField fieldName="Phone" />
                 <lightning:outputField fieldName="Industry" />
                </div>
            </lightning:card>
        </div>
    </lightning:recordViewForm>
</aura:application>