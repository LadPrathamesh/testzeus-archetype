global class  unsetSkipTrigger_Oppty implements Database.Batchable<sObject>,Schedulable {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([select Id,Skip_Trigger__c from Opportunity where Skip_Trigger__c = true limit 200]);
    }
    global void execute(SchedulableContext sc)           
    {      
        unsetSkipTrigger_Oppty b = new unsetSkipTrigger_Oppty();             
        database.executeBatch(b,1);
        
    }
    global void execute(Database.BatchableContext BC, List<Opportunity> scope ){
        
        List<Opportunity> updtOpp= new List<Opportunity>();
        for(Opportunity opp : scope)                
        {            
            opp.Skip_Trigger__c =False;  
            updtOpp.add(opp);
        }
        if(updtOpp.size() > 0){
            
            database.update(updtOpp,False);
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}