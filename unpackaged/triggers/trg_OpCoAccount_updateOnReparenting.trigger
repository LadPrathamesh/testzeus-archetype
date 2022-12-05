trigger trg_OpCoAccount_updateOnReparenting on OpCo_Account__c (after update) {
    Map<ID,OpCo_Account__c> oldMap=Trigger.OldMap;
    Map<ID,OpCo_Account__c> newMap=Trigger.NewMap;
    
    for(OpCo_Account__c opAcc:Trigger.NEW)
    {
        if(opAcc.Skip_Re_parenting__c==TRUE && oldMap.get(opAcc.Id).Account__c!=newMap.get(opAcc.Id).Account__c)
        {
            /*Total OpCo Related Contact*/
            List<OpCo_Related_Contact__c> opConList=[SELECT LSIG_Contact__c FROM OpCo_Related_Contact__c WHERE Source_Account__c = :opAcc.ID];
            Set<ID> conIDs=new Set<ID>();
            for(OpCo_Related_Contact__c opCon:opConList)
            {
                conIDs.add(opCon.LSIG_Contact__c);
            }
            
            /*Total Opportunity*/
            List<Opportunity> oppList=[SELECT AccountId FROM Opportunity WHERE  OpCo_Account__c = :opAcc.ID];
            /*Error if Opportunity and OpCo Related Contact is greater than 100*/
            if(opConList.Size()+oppList.Size()>100)
                {
                    opAcc.addError('Sorry this OpCo Account has more than 100 Contacts/Opptys, reparenting will not work at the moment. Please update using data loader or inspector.');
                }
            List<Contact> conList=[SELECT AccountId FROM Contact WHERE ID IN :conIDs];
            /* Update Opportunity */
            for(Opportunity opp:oppList)
                {
                    opp.AccountId=opAcc.Account__c;
                }   
            /* Update LSIG Contact */
            for(Contact con:conList)
                {
                 con.AccountId=opAcc.Account__c;
                }
            /* Update Contact and Opportunity */
            update conList;
            update oppList;
      } 
    }
}