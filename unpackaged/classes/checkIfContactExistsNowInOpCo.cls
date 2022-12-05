global class checkIfContactExistsNowInOpCo implements Database.Batchable<sObject>,Database.Stateful, Schedulable {
    
    global  list<Database.SaveResult> result;
    
    global checkIfContactExistsNowInOpCo(){
        
        result = new list<Database.SaveResult>();
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator([Select Id,Name,LSIG_Contact__c,LSIG_Contact__r.Email,Destination__c,Contact_Exists_in_OpCo__c,Interface_Status__c,
                                         OpCo_Account__c,OpCo_Related_Contact__c from Opportunity where LSIG_Contact__c!=null 
                                         AND Destination__c!=null AND Interface_Status__c='2-Awaiting' AND Source__c='LSIG' ]);
    }
    
    global void execute(SchedulableContext ctx) {
        
        checkIfContactExistsNowInOpCo umg=new checkIfContactExistsNowInOpCo();
        Database.executeBatch(umg);
    }    
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        
        system.debug('scope' +scope);        
        set<Id> setLSIG=new set<Id>();
        map<ID,OpCo_Related_Contact__c> mapOpCofinalRelated=new map<ID,OpCo_Related_Contact__c>();
        List<Opportunity> lstUpdateOpp=new List<Opportunity>();
        
        for(Opportunity op : scope){
            if(op.LSIG_Contact__c!=null && op.Destination__c!=null){                 
                setLSIG.add(op.LSIG_Contact__c);
            }
        }
        system.debug('setLSIC'+setLSIG);
        List<Contact> lstLSIG = [Select id,name,Email from Contact where id in:setLSIG ];
        set<string> EmailSet=new set<string>();
        for(contact con :lstLSIG){            
            EmailSet.add(con.Email); 
        }
        
        map<ID,OpCo_Related_Contact__c> mapOpCoRelated=new map<ID,OpCo_Related_Contact__c>();
        
        List<OpCo_Related_Contact__c> lstOpCoRelated= [Select id,name,Email__c,Source__c,Source_Account__c,LSIG_Contact__c from OpCo_Related_Contact__c where Email__c in :EmailSet  order by CreatedDate desc ];
        system.debug('lstOpCoRelated'+lstOpCoRelated);
        
        if(lstOpCoRelated.size()>0){
            for(Opportunity op : scope){         
                for(OpCo_Related_Contact__c rcon:lstOpCoRelated){
                    
                    if(rcon.Email__c==op.LSIG_Contact__r.Email){
                        
                        system.debug('op.LSIG_Contact__r.Email'+op.LSIG_Contact__r.Email);
                        
                        if(rcon.Source__c == op.Destination__c){
                            
                            mapOpCoRelated.put(rcon.id, rcon ); 
                        }
                    }
                }
            }
            system.debug('mapOpCoRelated'+mapOpCoRelated);
            mapOpCofinalRelated=mapOpCoRelated.Clone();        
        }
        
        
        
        system.debug('mapOpCofinalRelated'+mapOpCofinalRelated);
        
        for(Opportunity op : scope){
            
            If(mapOpCofinalRelated.size()> 0){
                
                for(OpCo_Related_Contact__c con :mapOpCofinalRelated.values()){
                    
                    if(op.LSIG_Contact__r.Email==con.Email__C){
                        
                        if(op.Destination__c==con.Source__c){
                            
                            op.Contact_Exists_in_OpCo__c='Yes';
                            op.Interface_Status__c='3-Ready';   
                            op.OpCo_Account__c=con.Source_Account__c;
                            op.OpCo_Related_Contact__c=con.Id;                
                            lstUpdateOpp.add(op);
                            
                        }            
                    }
                }                
            }             
        }
        
        system.debug('lstUpdateOpp'+lstUpdateOpp);
        if(lstUpdateOpp.size()>0){
            
            result  = Database.update(lstUpdateOpp,false);
        }
    }
    
    global void finish(Database.BatchableContext BC){      
        
        set<string>  oppId = new set<string>();
        if( result.Size()>0){
            system.debug('checkIfContactExistsNowInOpCo.result:::'+result);
            for(Integer index = 0, size = result.size(); index < size; index++) {
                if(result[index].isSuccess()) {
                    
                    System.debug('Successfully Updated Opportunity. Opportunity ID: ' + result[index].getId());
                    oppId.add(result[index].getId());
                    
                }else{
                    
                }
            }
        }
        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemp = [Select id, Name,Subject, Body From EmailTemplate Where Name = 'Opportunity ready for transfer'];
        List<Opportunity> oppLst = [Select Id, name,ownerid,owner.Email from Opportunity where id IN :oppId];
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm()+'/'; 
        system.debug('finish oppLst'+oppLst);
        if(oppLst.size() > 0){
            for(opportunity op : oppLst){
                
                string Mbody ='<html style="overflow-y: hidden;"><head><title></title></head><body style="height: auto; min-height: auto;"><span style="font-size:12px;"><span style="font-family:Arial,Helvetica,sans-serif;">Good news!<br />'+
                    '<br />Your opportunity contact and account have been created in the OpCo org.<br />'+
                    '<br />You can now transfer your Opportunity. Please navigate to the opportunity below and click Transfer.<br />'+
                    '<br />Oppportunity Name:&nbsp;'+op.name+'<br />'+
                    'Opportunity link:&nbsp;<a href="'+sfdcBaseURL+'lightning/r/Opportunity/'+op.Id+'/view">'+sfdcBaseURL+'lightning/r/Opportunity/'+op.Id+'/view</a></span></span></body>'+
                    '</html>';
                
                
                string [] toaddress = new string[] {op.Owner.Email};
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(toaddress);
                mail.setHtmlBody(Mbody);
                mail.setTreatBodiesAsTemplate(true);
                mail.setSubject('ACTION - Opportunity is ready to be transferred to OpCo');
                mail.setUseSignature(false);
                mail.setBccSender(false);            
                //  mail.setTemplateId(emailTemp.Id);
                mail.setTargetObjectId(op.ownerId);
                mail.setSaveAsActivity(false);
                emailList.add(mail);
            }
        }
        if(!emailList.isEmpty()){
            system.debug('emailList' +emailList);
            Messaging.SendEmailResult [] r =  Messaging.sendEmail(emailList);
            system.debug('emailList resilt'+ r);
        }    
        
    }
}