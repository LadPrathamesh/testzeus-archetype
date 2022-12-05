trigger OpCo_Account_trg on OpCo_Account__c (before insert, before update) 
{
    //DUNS list to be used later in the code. 
    List<Account> lstDUNS = [SELECT ID, ParentId, DUNS_Number__c FROM Account where DUNS_Number__c !=null];
    Map<Integer,String> dunsMap = new Map<Integer,String>();
    for(Account a: lstDUNS)
        dunsMap.put(Integer.valueOf(a.DUNS_Number__c), a.Id);
    
    //Postcodes list & its Accounts list to be used later in the code
    List<Account> lstZIP = [SELECT ID, ParentId, BillingPostalCode, Global_Parent_Id__c, BillingCity, BillingState, Name
         FROM Account Where BillingPostalCode !=null and ParentId !=null];
    Map<String,String> mapAccsByZip = new Map<String,String>();
    //Map<String,List<Account>> postalCodeMap = new Map<String,List<Account>>();
    for(Account a: lstZIP)
    {
        String zip = a.BillingPostalCode.split('-')[0];
        if(mapAccsByZip.containsKey(zip))
        {
            String val = mapAccsByZip.get(zip);
            Integer cnt = Integer.valueOf(val.split('-')[0]) + 1;
            //mapAccsByZip.put(zip, cnt + '-na-na-'+a.BillingCity+'-'+a.BillingState+'-'+a.Name.split(' ')[0]);
            mapAccsByZip.put(zip, cnt + '-na-na');
        }
        else
            mapAccsByZip.put(zip, '1-' + a.Id + '-' + a.Global_Parent_Id__c);
    }
    
    
    //Start the Trigger process now    
    for(OpCo_Account__c ac: Trigger.new)
    {    
        if(ac.Skip_Trigger__c == TRUE || ac.Skip_Re_parenting__c == TRUE)
            continue;
          
        //Skip checking if no changes in billing or shipping country or DUNS
        /*if((Trigger.newMap.get(ac.Id).Billing_Country__c == Trigger.oldMap.get(ac.Id).Billing_Country__c) 
            && (Trigger.newMap.get(ac.Id).Shipping_Country__c == Trigger.oldMap.get(ac.Id).Shipping_Country__c)
            && (Trigger.newMap.get(ac.Id).DUNS_Number__c == Trigger.oldMap.get(ac.Id).DUNS_Number__c)
            && (Trigger.newMap.get(ac.Id).Billing_Zip__c == Trigger.oldMap.get(ac.Id).Billing_Zip__c)
            && (Trigger.newMap.get(ac.Id).Shipping_Zip__c == Trigger.oldMap.get(ac.Id).Shipping_Zip__c)
            && (Trigger.newMap.get(ac.Id).Billing_Street__c == Trigger.oldMap.get(ac.Id).Billing_Street__c)
            && (Trigger.newMap.get(ac.Id).Shipping_Street__c == Trigger.oldMap.get(ac.Id).Shipping_Street__c)
            && (Trigger.newMap.get(ac.Id).Billing_State__c == Trigger.oldMap.get(ac.Id).Billing_State__c)
            && (Trigger.newMap.get(ac.Id).Shipping_State__c == Trigger.oldMap.get(ac.Id).Shipping_State__c)
            && (Trigger.newMap.get(ac.Id).Billing_City__c == Trigger.oldMap.get(ac.Id).Billing_City__c)
            && (Trigger.newMap.get(ac.Id).Shipping_City__c == Trigger.oldMap.get(ac.Id).Shipping_City__c)
            && (Trigger.newMap.get(ac.Id).Skip_Trigger__c == Trigger.oldMap.get(ac.Id).Skip_Trigger__c))
            continue;*/
        
        String xunmatchedId = '';
        String doNotUseId = '';
        if(ac.Account__c != null)
        {
            List<Account> lstIDs = [SELECT Id FROM Account Where ParentId = :ac.Global_Parent_Id__c 
                AND (NAME Like '%XUNMATCHED%' OR NAME Like '%ZDO NOT USE%') ORDER BY Name];
            
            if(lstIDs.size() == 2)
            {
                doNotUseId = lstIDs[1].ID;
                xunmatchedId = lstIDs[0].ID;
            }
        }
        //ac.addError(ac.Global_Parent_Id__c);
        
        //[Start] Assign DO NOT USE as Parent if Country is not US OR Canada
        String country = ac.Billing_Country__c;
        if(country == null || country == '')
            country = ac.Shipping_Country__c;
        
        if(doNotUseId != '' && (country == null || country == '' || !(country.contains('United States')||
             country.contains('United States America')||country.contains('US')||
             country.contains('USA')||country.contains('Canada')||country=='CA'||
             country.contains('CAN')||country.contains('United States')||country.contains('United States America')||
             country.contains('US')||country=='USA'||country.contains('Canada')||country=='CA'||country=='us'||
             country=='CAN'||ac.Unit_Code__c=='Canada'||ac.Unit_Code__c=='USA')))
        {
            ac.Account__c = doNotUseId;
            continue;
        }
        //[End] Assign DO NOT USE as Parent if Country is not US OR Canada
        
        //[Start] Check for DUNS Matching Parent Accs
        if(ac.DUNS_Number__c != null && ac.DUNS_Number__c != '')
        {
            String dunsId = dunsMap.get(Integer.valueOf(ac.DUNS_Number__c));
            if(dunsId != null && dunsId != '')
            {
                ac.Account__c = dunsId;
                continue;
            }
        }
        //[End] Check for DUNS Matching Parent Accs
        
        //[Start] Check for Zipcode Matching Parent Accs
        String zip = ac.Billing_Zip__c;
        if(zip == null || zip == '')
            zip = ac.Shipping_Zip__c;
            
        if(zip != null && zip != '')
        {
            if(zip.split('-').size() == 0)
                continue;
                
            zip = zip.split('-')[0];
            String val;
            val = '';
            val = mapAccsByZip.get(zip);

            if(val == null)
            {
                if(xunmatchedId != '')
                {
                    ac.Account__c = xunmatchedId;
                }
                continue;
            }
            
            Integer cnt = Integer.valueOf(val.split('-')[0]);
            String accId = val.split('-')[1];
            String parentAccId = val.split('-')[2];
            Id parentId;
            
            if(parentAccId != null && parentAccId != '' && parentAccId != 'na' && parentAccId != 'null')
                parentId = (Id)parentAccId;
            else
            {
                if(accId != 'na')
                    parentId = (Id)accId;
            }
            
            if(cnt == 1)
            {
                if(parentId == ac.Account__c)
                {
                    ac.Account__c = accId;
                    continue;
                }
                else
                {
                    if(xunmatchedId != '')
                    {
                        ac.Account__c = xunmatchedId;
                    }
                    continue;
                }
            }
            else if(cnt > 1)
            {
                //Check for Account Name (1st word) & city & state match
                string accName = ac.Account_Name__c.split(' ')[0].replace('\'','').replace('\\','');
                string accName2 = '';
                if(ac.Account_Name__c.split(' ').size() > 1)
                     accName2 = ac.Account_Name__c.split(' ')[1].replace('\'','').replace('\\','');
                
                string query = '';
                if(accName2 == '')
                    query = 'select Id, BillingStreet, ShippingStreet, BillingCity, ShippingCity, BillingState, ShippingState'
                        + ' from Account where Is_Key_Account__c=false and Name like \'' + accName + '%\''
                        + ' and BillingCity like \'%' + ac.Billing_City__c + '%\''
                        + ' and BillingState like \'%' + ac.Billing_State__c + '%\'';
                else
                    query = 'select Id, BillingStreet, ShippingStreet, BillingCity, ShippingCity, BillingState, ShippingState'
                        + ' from Account where Is_Key_Account__c=false and (Name like \'' + accName + '%\' or Name like \'%' + accName2 + '%\')'
                        + ' and BillingCity like \'%' + ac.Billing_City__c + '%\''
                        + ' and BillingState like \'%' + ac.Billing_State__c + '%\'';
                
                List<Account> lstAccs = database.query(query);
                
                /*if(lstAccs.size() == 1)
                {
                    ac.Account__c = lstAccs[0].Id;
                    continue;
                }
                else*/
                if(lstAccs.size() >= 1)
                {
                    string street = ac.Billing_Street__c;
                    if(street == '')
                        street = ac.Shipping_Street__c;
                    
                    //check if street matches
                    if(street != null)
                    {
                        street = street.split(' ')[0];
                        boolean flag = false;
                        for(Account aa: lstAccs)
                        {
                            
                            if((aa.BillingStreet != null && aa.BillingStreet.startsWith(street)) || 
                                (aa.ShippingStreet != null && aa.ShippingStreet.startsWith(street)))
                            {
                                ac.Account__c = aa.Id;
                                flag = true;
                                break;
                            }
                        }

                        //Found match, move to nxt
                        if(flag == true)
                            continue;
                        else
                        {
                            //Assign to xunmatched since no Street Matches
                            if(xunmatchedId != '')
                            {
                                ac.Account__c = (Id)xunmatchedId;
                                continue;
                            }
                        }
                    }

                    //Since no street matches but name, city & state matches, we'll take the 1st one
                    //ac.Account__c = lstAccs[0].Id;
                    //continue;  
                }
                         
                //Check for billing street & city & state match
                if(ac.Billing_Street__c != null && ac.Billing_Street__c != '')
                {
                    string streetPart1;
                    if(ac.Billing_Street__c.split(' ').size() == 1)
                        streetPart1 = ac.Billing_Street__c.split(' ')[0];
                    else
                        streetPart1 = ac.Billing_Street__c.split(' ')[0] + ' ' + ac.Billing_Street__c.split(' ')[1];
                    query = 'select Id from Account where BillingStreet like \'' + streetPart1 + '%\''
                        + ' and BillingCity like \'%' + ac.Billing_City__c + '%\''
                        + ' and BillingState like \'%' + ac.Billing_State__c + '%\'';
                    
                    lstAccs = database.query(query);

                    if(lstAccs.size() == 1)
                    {
                        ac.Account__c = lstAccs[0].Id;
                        continue;
                    }
                }

                //Check for shipping street & city & state match
                if(ac.Shipping_Street__c != null && ac.Shipping_Street__c != '')
                {
                    string streetPart1 = ac.Shipping_Street__c.split(' ')[0];
                    query = 'select Id from Account where ShippingStreet like \'' + streetPart1 + '%\''
                        + ' and ShippingCity like \'%' + ac.Shipping_City__c + '%\''
                        + ' and ShippingState like \'%' + ac.Shipping_State__c + '%\'';
                    
                    lstAccs = database.query(query);
                    
                    if(lstAccs.size() == 1)
                    {
                        ac.Account__c = lstAccs[0].Id;
                        continue;
                    }
                }
                
                //If Zip matches, only city check & also to which parent DUNSs account name matches
                /*if(ac.Billing_City__c != null && ac.Billing_City__c != '')
                {    
                    query = 'select Id, Name from Account where Is_Key_Account__c=false'
                        + ' and BillingPostalCode like \'%' + zip + '%\''
                        + ' and (BillingCity like \'%' + ac.Billing_City__c + '%\''
                        + '      or BillingCity like \'%' + ac.Billing_City__c.split(' ')[0] + '%\')';
                        //+ ' and Global_Parent_Id__c = \'' + String.valueOf(ac.Account__c).substring(0,15) + '\'';
                    lstAccs = database.query(query);
                    
                    for(Account a: lstAccs)
                    {
                        if(a.Name.contains(ac.Account_Name__c.split(' ')[0]))
                        {
                            ac.Account__c = a.Id;
                            continue;
                        }
                        if(a.Name.contains(ac.Account_Name__c.split('-')[0]))
                        {
                            ac.Account__c = a.Id;
                            continue;
                        }
                    }
                }*/
                
                //Check for billing street only on zip matching
                /*if(ac.Billing_Street__c != null && ac.Billing_Street__c != '')
                {
                    string streetPart1 = ac.Billing_Street__c.split(' ')[0];
                    query = 'select Id from Account where BillingStreet like \'' + streetPart1 + '%\''
                        + ' and BillingCity like \'%' + ac.Billing_City__c + '%\'';
                    
                    lstAccs = database.query(query);

                    if(lstAccs.size() == 1)
                    {
                        ac.Account__c = lstAccs[0].Id;
                        continue;
                    }
                }
                
                //Check for billing state only on zip matching
                if(ac.Billing_State__c != null && ac.Billing_State__c != '')
                {
                    query = 'select Id from Account where BillingPostalcode like \'' + zip + '%\''
                        + ' and BillingState like \'%' + ac.Billing_State__c + '%\'';
                    
                    lstAccs = database.query(query);

                    if(lstAccs.size() > 0 && lstAccs.size() <= 3)
                    {
                        ac.Account__c = lstAccs[0].Id;
                        continue;
                    }
                }*/
                
                //Finally map to xunmatched
                if(xunmatchedId != '')
                    ac.Account__c = (Id)xunmatchedId;
            }
        }
        else
        {
            if(xunmatchedId != '')
            {
                ac.Account__c = xunmatchedId;
                continue;
            }
        }   
    }
}