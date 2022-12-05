({
    Inherit : function(component, event, helper) {
        
        var recordid=component.get("v.recordId");
        component.set('v.showSpinner',true);
        var action1 = component.get("c.UpdateOpportunity");
        
        action1.setParams({
            "recid" : recordid          
        }); 
        
        action1.setCallback(this,function(response){
            
            var state1 = response.getState(); 
            console.log('state1:::'+state1);
            if(state1 === "SUCCESS"){                
                var responseValue1 = response.getReturnValue();                             
                                              
            }else if(state === "ERROR"){
                var errors = response.getError();
                console.log('error::',errors);
                if(errors||errors[0].message){                    
                }
            }
            component.set('v.showSpinner',false);
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire(); 
            location.reload(); 
            
        });
        $A.enqueueAction(action1);
    }
    
});