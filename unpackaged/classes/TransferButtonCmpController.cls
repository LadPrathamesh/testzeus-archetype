public class TransferButtonCmpController {
    
    @AuraEnabled
    public static Opportunity getOpportunity(String recid){
        
        Opportunity opplist = [select id,name,Interface_Status__c from Opportunity where id=:recid];
        System.debug(opplist);
        return opplist;
    }
    
    @AuraEnabled
    public static list<Opportunity> UpdateOpportunity(String recid){
        list<Opportunity> updateOpp = new list<opportunity>();
        list<Opportunity> opplist = [select id,name,Interface_Status__c from Opportunity where id=:recid];
        for(Opportunity oplist:opplist){
            if(oplist.Interface_Status__c == '3-Ready'){
                oplist.Interface_Status__c = '4-Intransit';
                updateOpp.add(oplist);
            }
        }
        System.debug('opplist15:::'+updateOpp);
        
        if(updateOpp.size()>0){
            Database.update(updateOpp,false);
            return updateOpp;
        }
        
        return opplist;
    }
}