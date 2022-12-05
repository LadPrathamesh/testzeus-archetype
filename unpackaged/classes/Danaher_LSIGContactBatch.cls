/*
* @Developer-Sudhir Dhawan
* @Company-Nanostuffs Technologies Pvt Limited
* @Description- This batch class is used to update LSIG Contact Field on OpCoRelated Contact Object.The batch takes  all the 
* record from Contact Object.
* Then after iteration it compare with all related contacts email and finding the same email it update the contact ID.
*/

global class Danaher_LSIGContactBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator([ SELECT
                                         ID,LSIG_Contact__c,Email__c 
                                         FROM OpCo_Related_Contact__c
                                         Where Email__c!=''  ]);
        
    }
    global void execute(Database.BatchableContext BC, List<OpCo_Related_Contact__c> conLst){
        Set<String> setEmail=new Set<String>();
        for(OpCo_Related_Contact__c con:conLst){
            setEmail.add(con.Email__c);
        }
        
        // All OpCo Related Contacts 
        List<Contact> allConLst=[
            SELECT
            ID,OpCo_Contact_ID__c,Email
            FROM Contact 
            Where Email IN :setEmail ];
        // List of OpCoRelated Records that are to be updated 
        List<OpCo_Related_Contact__c> updateList=new List<OpCo_Related_Contact__c>();
        
        if(allConLst.Size()>0){
            for(OpCo_Related_Contact__c c:conLst){
                
                for(Contact opCon:allConLst){
                    if(c.Email__c==opCon.Email){
                        c.LSIG_Contact__c=opCon.ID;
                        updateList.add(c);
                    }
                }      
            }
        }
        system.debug(updateList);
        if(updateList.Size()>0){
            Database.update(updateList,false);
        }        
        
    }
    global void finish(Database.BatchableContext BC){
    }
    
}