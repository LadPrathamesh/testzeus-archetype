@isTest
public class checkIfContactExistsNowInOpCoTest {
    
    @isTest public static void checkTest(){
        
        Account acc= new Account();
        acc.Name='Pfizer Inc.';
        insert acc;
        
        
        contact con = new contact();
        con.LastName=acc.Name;
        con.Email='testmd1@g.com';
        con.AccountId=acc.Id;
        insert con;
        
        OpCo_Related_Contact__c opRelated = new OpCo_Related_Contact__c();
        opRelated.Name=con.Name;
        opRelated.Email__c='testmd1@g.com';
        opRelated.LSIG_Contact__c=con.Id;
        opRelated.Source__c='Moldev';        
      //  opRelated.Source_Account__c=acc.Id;
        insert opRelated;
        
        OpCo_Related_Contact__c opRelated1 = new OpCo_Related_Contact__c();
        opRelated1.Name=con.Name;
        opRelated1.Email__c='testmd1@g.com';
        opRelated1.LSIG_Contact__c=con.Id;
        opRelated1.Source__c='Moldev';        
        insert opRelated1;
          
        
        OpCo_Account__c opco=new OpCo_Account__c();
        opco.OpCo_Related_Contact__c=opRelated.id;
        opco.Source__c='Moldev';
        opco.Account__c=acc.id;
        insert opco;
       
        
        
        Opportunity op =new Opportunity();
        op.Name='Test # opp';
        op.StageName='Qualification';
        op.CloseDate=Date.valueOf('2023-11-28');
        op.Destination__c='Moldev'; 
        op.Interface_Status__c='2-Awaiting';
        op.LSIG_Contact__c=con.Id;        
        op.Contact_Exists_in_OpCo__c='No';
        op.OpCo_Related_Contact__c = opRelated.id;
        insert op;        
        update op;
        
         Opportunity op1 =new Opportunity();
        op1.Name='Test # opp';
        op1.StageName='Qualification';
        op1.CloseDate=Date.valueOf('2023-11-28');
        op1.Destination__c='Moldev'; 
        op1.Interface_Status__c='2-Awaiting';
        op1.LSIG_Contact__c=con.Id;        
        op1.Contact_Exists_in_OpCo__c='No';
        op1.OpCo_Related_Contact__c = opRelated.id;
        insert op1;  
        
        Test.startTest();
        checkIfContactExistsNowInOpCo umg=new checkIfContactExistsNowInOpCo();
        Database.executeBatch(umg);
        Test.stopTest();
        
        
    }
    
}