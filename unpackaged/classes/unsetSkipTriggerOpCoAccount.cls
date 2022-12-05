global class  unsetSkipTriggerOpCoAccount implements Database.Batchable<sObject>,Schedulable {
        
        global Database.QueryLocator start(Database.BatchableContext BC){
            return Database.getQueryLocator([ select Id,Skip_Trigger__c from OpCo_Account__c where Skip_Trigger__c = true limit 200]);
        }
        
        global void execute(SchedulableContext sc)
        {
            unsetSkipTriggerOpCoAccount b = new unsetSkipTriggerOpCoAccount();
            database.executeBatch(b,1);
        }
        
        global void execute(Database.BatchableContext BC, List<OpCo_Account__c> scope ){
            
            List<OpCo_Account__c> updtAcc = new List<OpCo_Account__c>();
            for(OpCo_Account__c con : scope){
                con.Skip_Trigger__c =False;
                updtAcc.add(con);
            }
            if(updtAcc.size() > 0){
               
                database.update(updtAcc,False);
                
            }  
         
        }
        global void finish(Database.BatchableContext BC){
            
        }
    }