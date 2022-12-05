public class OpCo_Account_trgHandler {
    public static Void handler(List<OpCo_Account__c> lstAcc){
        List<Account>lstDUNS=[SELECT ID,ParentId,DUNS_Number__c FROM Account where DUNS_Number__c !=null];
        for(OpCo_Account__c ac:lstAcc){
            String XUNMATCHED='';
            String DONOTUSE='';
                       
            if(ac.Account__c!=null){
                List<Account>acc=[SELECT ID,Name FROM Account Where ParentId = :ac.Account__c AND (NAME Like '%XUNMATCHED%' OR NAME Like '%DO NOT USE%') ORDER BY Name];
                DONOTUSE=acc[0].ID;
                XUNMATCHED=acc[1].ID; 
            }
            // Country Mapping for Leica
            if(!(ac.Source__c=='Leica' && (ac.Shipping_Country__c.containsAny('United States')||
             ac.Shipping_Country__c.containsAny('United States America')||ac.Shipping_Country__c.containsAny('US')||
             ac.Shipping_Country__c.containsAny('USA')||ac.Shipping_Country__c.containsAny('Canada')||ac.Shipping_Country__c.containsAny('CA')||
             ac.Shipping_Country__c.containsAny('CAN')||ac.Billing_Country__c.containsAny('United States')||ac.Billing_Country__c.containsAny('United States America')||
             ac.Billing_Country__c.containsAny('US')||ac.Billing_Country__c.containsAny('USA')||ac.Billing_Country__c.containsAny('Canada')||ac.Billing_Country__c.containsAny('CA')||
             ac.Billing_Country__c.containsAny('CAN')||ac.Unit_Code__c.containsAny('Canada')))){
               
                 ac.Account__c=DONOTUSE;
                continue;
            }
            // Country Mapping other OpCo
            if(!(ac.Source__c!='Leica' && (ac.Shipping_Country__c.containsAny('United States')||ac.Shipping_Country__c.containsAny('United States America')||ac.Shipping_Country__c.containsAny('US')||ac.Shipping_Country__c.containsAny('USA')||ac.Shipping_Country__c.containsAny('Canada')||ac.Shipping_Country__c.containsAny('CA')||ac.Shipping_Country__c.containsAny('CAN')||ac.Billing_Country__c.containsAny('United States')||ac.Billing_Country__c.containsAny('United States America')||ac.Billing_Country__c.containsAny('US')||ac.Billing_Country__c.containsAny('USA')||ac.Billing_Country__c.containsAny('Canada')||ac.Billing_Country__c.containsAny('CA')||ac.Billing_Country__c.containsAny('CAN')))){
                ac.Account__c=DONOTUSE;
                continue;
            }
            // FOR DUNS 
            if(ac.DUNS_Number__c!=null){
                for(Account acc:lstDUNS){
                    if(acc.DUNS_Number__c.containsAny(ac.DUNS_Number__c)){
                        ac.Account__c=acc.ParentID;
                        continue;
                    }
                }
            }
            //
            
            
        }
    }
}