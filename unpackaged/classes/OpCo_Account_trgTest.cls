@isTest
public class OpCo_Account_trgTest {
    @isTest
    public static void OpCo_Account_Test(){
        
        Account acc=new Account();
        acc.Name='test';
        acc.DUNS_Number__c = '123';
        insert acc;
        
        Account acc1 = new Account();
        acc1.ParentId = acc.Id;
        acc1.Name='test';
        acc1.BillingPostalCode = '01230';
        insert acc1;
        
        
    }
    
}