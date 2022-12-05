trigger trgOnOpCoAddtionalComment on OpCo_Additional_Comment__c (before insert) {
    
    if(trigger.IsInsert && trigger.IsBefore){
        
        Set<string> setOpp= new Set<string>();
        Set<string> setCon = new Set<string>();
        
        for(OpCo_Additional_Comment__c opCoAdd:trigger.new)
        {
            if(opCoAdd.Opportunity_OpCo_Record_Id__c !=null){                              
                setOpp.add(opCoAdd.Opportunity_OpCo_Record_Id__c);
            }
            if(opCoAdd.Related_Contact_OpCo_Record_Id__c !=null){                                
                setCon.add(opCoAdd.Related_Contact_OpCo_Record_Id__c);                
            }                      
        } 
        
        List<Opportunity> lstOpp=[Select id,name from Opportunity where Id IN : setOpp ];
        List<contact> lstCon=[Select id,name from contact where Id IN : setCon];
        
        if(lstOpp.size()>0){
            
            for(OpCo_Additional_Comment__c opCoAdd:trigger.new)
            {
                
                for(Opportunity op:lstOpp){
                    
                    if(op.Id==opCoAdd.Opportunity_OpCo_Record_Id__c){
                        
                        opCoAdd.Opportunity__c = opCoAdd.Opportunity_OpCo_Record_Id__c; 
                    }                    
                }                
                for(contact con :lstCon){
                    
                    if(con.Id==opCoAdd.Related_Contact_OpCo_Record_Id__c){
                        
                        opCoAdd.OpCo_Related_Contact__c = opCoAdd.Related_Contact_OpCo_Record_Id__c;
                        
                    }                                      
                }                
            }
        }        
    }
}