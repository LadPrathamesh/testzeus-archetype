({
    
    doinit : function(component, event, helper) {        
        
        helper.Inherit(component, event, helper);
       
       /* var recordid=component.get("v.recordId");
        var action = component.get("c.getOpportunity");  
        component.set('v.showSpinner',true);
        action.setParams({
            "recid" : recordid          
        });
        
        action.setCallback(this,function(response){
            
            var state = response.getState();          
            if(state === "SUCCESS"){
                
                var responseValue = response.getReturnValue();
                console.log('response value:::'+responseValue);
                var IntStatus =responseValue.Interface_Status__c;
                console.log('response value:::'+IntStatus);
                if(responseValue.Interface_Status__c== '1-Awaiting' ||    responseValue.Interface_Status__c=='2-Awaiting' ){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "info",
                        "message": "Cannot send this Opportunity to OpCo yet, either of LSIG Contact or OpCo Account or OpCo Contact is missing."
                        
                    });
                    toastEvent.fire();    
                    component.set('v.Msg',"Cannot send this Opportunity to OpCo yet, either of LSIG Contact or OpCo Account or OpCo Contact is missing.");
                }
                else if(responseValue.Interface_Status__c== '5-Sent' || responseValue.Interface_Status__c== '7-Sync'){
                   var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "info",
                        "message": "The Opportunity is already Sent & in sync with the OpCo now."
                    });
                    toastEvent.fire();   
                    component.set('v.Msg',"The Opportunity is already Sent & in sync with the OpCo now.");
                    
                }else if(responseValue.Interface_Status__c== '3-Ready' || responseValue.Interface_Status__c== '6-Error'){
                    console.log('inside if40::')
                    helper.Inherit(component, event, helper);
                }
            }else if(state === "ERROR"){
                var errors = response.getError();
                console.log('error::',errors);
                if(errors||errors[0].message){
                    
                }
            }
            
              $A.get('e.force:refreshView').fire();
            
            
        });
        $A.enqueueAction(action);*/
    }
    
    
})