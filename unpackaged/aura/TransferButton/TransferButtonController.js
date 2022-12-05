({
    
    doinit : function(component, event, helper) {
        var recordid=component.get("v.recordId");
        alert(recordid);
        var action = component.get("c.getOpportunity");  
        
        action.setParams({
            "recid" : recordid          
        });
        
        action.setCallback(this,function(response){
            
            var state = response.getState();          
            alert(state);
            if(state === "SUCCESS"){
                
                var responseValue = response.getReturnValue();
                console.log('response value:::'+responseValue);
                var IntStatus =responseValue.Interface_Status__c;
                console.log('response value:::'+IntStatus);
                /* if(responseValue.Interface_Status__c== 'Awaiting' || responseValue.Interface_Status__c=='Awaiting OpCo Account/Contact Selection' ){
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "variant": "Failed",
                        "title": "Failed!",
                        "message": "Cannot send this Opportunity to OpCo yet, either of LSIG Contact or OpCo Account or OpCo Contact is missing."
                    });
                    toastEvent.fire();    
                    
                }
                    else if(responseValue.Interface_Status__c== 'Sent' || responseValue.Interface_Status__c== 'Sync'){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "variant": "Failed",
                            "title": "Failed!",
                            "message": "The Opportunity is already Sent & in sync with the OpCo now."
                        });
                    
                    
                }else if(responseValue.Interface_Status__c== 'Ready To Send To OpCo' || responseValue.Interface_Status__c== 'Error'){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "variant": "Failed",
                            "title": "Failed!",
                            "message": "Sent, the Opportunity is getting transfered to OpCo now, please check back the Interface Status after 15-30 minutes."
                        });
                    }*/
            }else if(state === "ERROR"){
                var errors = response.getError();
                console.log('error::',errors);
                if(errors||errors[0].message){
                    
                }
            }
            
        });
        $A.enqueueAction(action);
    }
    
    
})