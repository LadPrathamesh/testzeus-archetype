@isTest
public class unsetSkipTriggerOpptyTest {
    @isTest
     public static void unsetSkipTriggerOppty(){
         Opportunity opp = new Opportunity();
      /*   opp.Name='Dinesh';
         opp.Skip_Trigger__c='';
         opp.AccountId='Deman';
         opp.CloseDate='10/10/2025';
         opp.StageName='Closed Lost';  */
         insert opp;
          
        Test.startTest();
        
        unsetSkipTrigger_Oppty obj = new unsetSkipTrigger_Oppty();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
}
}