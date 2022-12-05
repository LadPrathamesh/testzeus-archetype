trigger trgcheckIfContactExistsNowInOpCo on Opportunity (before insert,before update) {   
        
     if(trigger.IsInsert && trigger.IsBefore){ 
                
        map<ID,OpCo_Related_Contact__c> mapOpCofinalRelated=new map<ID,OpCo_Related_Contact__c>();
        set<Id> setLSIG=new set<Id>();        
        
        for(Opportunity op:trigger.new){        
            if(op.LSIG_Contact__c!=null && op.Destination__c!=null){                
                setLSIG.add(op.LSIG_Contact__c);
            }                 
        }
        system.debug('setLSIG'+setLSIG);
        map<ID,OpCo_Related_Contact__c> mapOpCoRelated=new map<ID,OpCo_Related_Contact__c>();
        
        List<OpCo_Related_Contact__c> lstOpCoRelated= [Select id,name,Email__c,Source__c,Source_Account__c,LSIG_Contact__c from OpCo_Related_Contact__c where LSIG_Contact__c in :setLSIG  order by CreatedDate desc];
        
        
        system.debug('lstOpCoRelated'+lstOpCoRelated);
        if(lstOpCoRelated.size()>0){
            for(Opportunity op:trigger.new){  
                
                for(OpCo_Related_Contact__c rcon:lstOpCoRelated){
                    
                   if(op.LSIG_Contact__c==rcon.LSIG_Contact__c){  
                       
                    if(rcon.Source__c==op.Destination__c){
                        mapOpCoRelated.put(rcon.id, rcon );  
                    }                       
                  }
                }
            }
            mapOpCofinalRelated=mapOpCoRelated.Clone();  
            system.debug('27mapOpCofinalRelated'+mapOpCofinalRelated);
        }
        
      /*  if(mapOpCoRelated.size() > 1){
            
            List<Opportunity> lstOppCount=new List<Opportunity>();
            map<id,integer>mapCount=new map<id,integer>();       
            
            List<Opportunity> lstChildOpp=[Select id,name,OpCo_Related_Contact__c from opportunity where OpCo_Related_Contact__c in :mapOpCoRelated.keySet()];
            
            List<OpCo_Related_Contact__c> lstParentOpCo=[Select id,name,Email__c,Source__c,Source_Account__c,LSIG_Contact__c from OpCo_Related_Contact__c where id in:mapOpCoRelated.keySet()]; 
            
            if(lstChildOpp.size()>0){
                
                for(OpCo_Related_Contact__c opco:lstParentOpCo){
                    
                    for(Opportunity op:lstChildOpp){
                        
                        if(op.OpCo_Related_Contact__c==opco.id){
                            lstOppCount.add(op);
                            
                            mapCount.put(opco.id,lstOppCount.size());
                        }                
                    }            
                }
                system.debug('mapCount'+mapCount);
                
                List<integer> highestcount=mapCount.values();
                highestcount.sort();
                
                //get the max value of the count
                Integer i_max_value = highestcount[(highestcount.size()-1)];            
                
                set<id> setOpCo = new set<id>();
                for(String s : mapCount.keySet()){
                    Integer oppty_map_value = mapCount.get(s);
                    
                    if(oppty_map_value == i_max_value){                    
                        setOpCo.add(s);                    
                    }                
                } 
                
                if(setOpCo.size()>0){
                    
                    Map<Id,OpCo_Related_Contact__c> MapfinalOpCo=new Map<Id,OpCo_Related_Contact__c>([Select id,name,CreatedDate,Email__c,Source__c,Source_Account__c,LSIG_Contact__c from OpCo_Related_Contact__c where id in:setOpCo order by CreatedDate desc limit 1]); 
                    mapOpCofinalRelated.clear();
                    mapOpCofinalRelated=MapfinalOpCo.Clone();
                    
                }
                
            }else{
                
                Map<Id,OpCo_Related_Contact__c> MapfinalOpCo=new Map<Id,OpCo_Related_Contact__c>([Select id,name,CreatedDate,Email__c,Source__c,Source_Account__c,LSIG_Contact__c from OpCo_Related_Contact__c where id in:mapOpCoRelated.keySet()  order by CreatedDate desc]); 
                mapOpCofinalRelated.clear();
                mapOpCofinalRelated=MapfinalOpCo.Clone();
                
            }           
            system.debug('84mapOpCofinalRelated'+mapOpCofinalRelated);
        }    */           
       
        
        
        for(Opportunity op:trigger.new){     
                        
            If(mapOpCofinalRelated.size()> 0){
                
                for(OpCo_Related_Contact__c con :mapOpCofinalRelated.values()){
                    
                    if(op.LSIG_Contact__c==con.LSIG_Contact__c){
                        
                        if(op.Destination__c==con.Source__c){  
                            
                            op.Contact_Exists_in_OpCo__c='Yes';
                            op.Interface_Status__c='3-Ready';   
                            op.OpCo_Account__c=con.Source_Account__c;
                            op.OpCo_Related_Contact__c=con.Id;                
                            
                        }            
                    }
                }
            }           
        }        
    }     
    
    if(trigger.IsUpdate && trigger.IsBefore){        
        
        map<ID,OpCo_Related_Contact__c> mapOpCofinalRelated=new map<ID,OpCo_Related_Contact__c>();
        set<Id> setLSIG=new set<Id>();        
        
        for(Opportunity op:trigger.new){        
            if(op.LSIG_Contact__c!=null && op.Destination__c!=null){                
                setLSIG.add(op.LSIG_Contact__c);
            }                 
        }
        
        map<ID,OpCo_Related_Contact__c> mapOpCoRelated=new map<ID,OpCo_Related_Contact__c>();
        
        List<OpCo_Related_Contact__c> lstOpCoRelated= [Select id,name,Email__c,Source__c,Source_Account__c,LSIG_Contact__c from OpCo_Related_Contact__c where LSIG_Contact__c in :setLSIG ];
        
        
        system.debug('lstOpCoRelated'+lstOpCoRelated);
        if(lstOpCoRelated.size()>0){
            for(Opportunity op:trigger.new){  
                for(OpCo_Related_Contact__c rcon:lstOpCoRelated){
                    if(op.LSIG_Contact__c==rcon.LSIG_Contact__c){ 
                        if(rcon.Source__c==op.Destination__c){
                            mapOpCoRelated.put(rcon.id, rcon );  
                        }
                    }
                }
            }
            mapOpCofinalRelated=mapOpCoRelated.Clone();  
            system.debug('27mapOpCofinalRelated'+mapOpCofinalRelated);
        }
        
      /*  if(mapOpCoRelated.size() > 1){
            
            List<Opportunity> lstOppCount=new List<Opportunity>();
            map<id,integer>mapCount=new map<id,integer>();       
            
            List<Opportunity> lstChildOpp=[Select id,name,OpCo_Related_Contact__c from opportunity where OpCo_Related_Contact__c in :mapOpCoRelated.keySet()];
            
            List<OpCo_Related_Contact__c> lstParentOpCo=[Select id,name,Email__c,Source__c,Source_Account__c,LSIG_Contact__c from OpCo_Related_Contact__c where id in:mapOpCoRelated.keySet()]; 
            
            if(lstChildOpp.size()>0){
                
                for(OpCo_Related_Contact__c opco:lstParentOpCo){
                    
                    for(Opportunity op:lstChildOpp){
                        
                        if(op.OpCo_Related_Contact__c==opco.id){
                            lstOppCount.add(op);
                            
                            mapCount.put(opco.id,lstOppCount.size());
                        }                
                    }            
                }
                system.debug('mapCount'+mapCount);
                
                List<integer> highestcount=mapCount.values();
                highestcount.sort();
                
                //get the max value of the count
                Integer i_max_value = highestcount[(highestcount.size()-1)];            
                
                set<id> setOpCo = new set<id>();
                for(String s : mapCount.keySet()){
                    Integer oppty_map_value = mapCount.get(s);
                    
                    if(oppty_map_value == i_max_value){                    
                        setOpCo.add(s);                    
                    }                
                } 
                
                if(setOpCo.size()>0){
                    
                    Map<Id,OpCo_Related_Contact__c> MapfinalOpCo=new Map<Id,OpCo_Related_Contact__c>([Select id,name,CreatedDate,Email__c,Source__c,Source_Account__c,LSIG_Contact__c from OpCo_Related_Contact__c where id in:setOpCo order by CreatedDate desc limit 1]); 
                    mapOpCofinalRelated.clear();
                    mapOpCofinalRelated=MapfinalOpCo.Clone();
                    
                }
                
            }else{
                
                Map<Id,OpCo_Related_Contact__c> MapfinalOpCo=new Map<Id,OpCo_Related_Contact__c>([Select id,name,CreatedDate,Email__c,Source__c,Source_Account__c,LSIG_Contact__c from OpCo_Related_Contact__c where id in:mapOpCoRelated.keySet()  order by CreatedDate desc]); 
                mapOpCofinalRelated.clear();
                mapOpCofinalRelated=MapfinalOpCo.Clone();
                
            }           
            system.debug('84mapOpCofinalRelated'+mapOpCofinalRelated);
        }   */            
        
        for(Opportunity op:trigger.new){ 
            
            if((op.LSIG_Contact__c != trigger.oldMap.get(op.Id).LSIG_Contact__c && op.LSIG_Contact__c!=null ) || (op.Destination__c != trigger.oldMap.get(op.Id).Destination__c && op.Destination__c!=null)) {
                
                If(mapOpCofinalRelated.size()> 0){               
                    
                    for(OpCo_Related_Contact__c con :mapOpCofinalRelated.values()){                        
                        
                        if(op.LSIG_Contact__c==con.LSIG_Contact__c){
                            
                            if(op.Destination__c==con.Source__c){ 
                                
                                op.Contact_Exists_in_OpCo__c='Yes';
                                op.Interface_Status__c='3-Ready';   
                                op.OpCo_Account__c=con.Source_Account__c;
                                op.OpCo_Related_Contact__c=con.Id;                
                                
                            }            
                        }
                    }
                }              
            }        
        }     
    }    
   
}