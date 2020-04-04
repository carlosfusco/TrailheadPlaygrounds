trigger SpendTrigger on Trade__c (after insert, after update) {
	//error the trigger must on Account
    /*Set<Id> accIds = new Set<Id>();
    
    for(Trade__c actualTrade : Trigger.new){
        accIds.add(actualTrade.Account__c);
    }
    
    List<Trade__c> trades = [SELECT Account__c, Spend__c, Account__r.Points__c FROM Trade__c WHERE Account__c IN:accIds];
    
    if(!accIds.isEmpty()){
        Map<Id,List<Trade__c>> accToTrd = new Map<Id,List<Trade__c>>();
        
        for(Id id : accIds){
            accToTrd.put(id,new List<Trade__c>());
        }
TargetX_SRMb__Family_Relationship__c -> Trade
										-> Contact
TargetX_SRMb__Application__c -> Account
								-> Account
        
        System.debug('!!!!' + accToTrd);
        for(Trade__c trd : trades){
            accToTrd.get(trd.Account__c).add(trd);
        }
        
        System.debug('????' + accToTrd);
        
        List<Account> accUpdate = new List<Account>();
        
        for(Id id : accIds){
            
            Decimal totalSpend = 0;
            Decimal totalGlobal = 0;
            Decimal calc = 0;
            
            for(Trade__c trd : accToTrd.get(id)){
                totalSpend = trd.Spend__c;
                totalGlobal = trd.Account__r.Points__c;
            }
            System.debug('Spend: ' + totalSpend);
            System.debug('Total: ' + totalGlobal);
            calc = totalGlobal - totalSpend;
            System.debug('Calculation: ' + calc);
            
            accUpdate.add(new Account(Id=id,
                                     	Points__c = calc));
        }
        
        if (!accUpdate.isEmpty()) {

            update accUpdate;

        }

    }*/
    
    /*Map<ID, Account> accMap = new Map<Id, Account>();
    List<Id> accId = new List<Id>();
    
    for(Trade__c trade: Trigger.new){
        if(trade.Account__c != null){
            accId.add(trade.Account__c);
        }
    }
    
    System.debug('List Account Ids: ' + accId);
    
    if(accId != null){
        for(Id accountId : accId){
           accMap.put(accountId, new Account(Id= accountId, Points__c = 5000)); 
        }
        
        List<Trade__c> trds = [SELECT Id, Account__c, Spend__c FROM Trade__c WHERE Account__c IN : accId];
        for(Trade__c  tr: trds){
            
            System.debug('SPEND: ' + tr.Spend__c);
            accMap.get(tr.Account__c).Points__c -= tr.Spend__c;
        }
        
        System.debug('TOTAL: ' + accMap);
        
        Database.update(accMap.values());
    }*/
    
    /*Set<Id> accountId = new Set<Id>();
    Set<Id> tradeId = new Set<Id>();
    
    for(Trade__c trd: Trigger.new){
        accountId.add(trd.Account__c);
        tradeId.add(trd.Id);
    }
    
    List<Account> accounts = [SELECT Id, Points__c from Account WHERE Id IN :accountId];
    List<Trade__c> trades = [SELECT Id, Spend__c from Trade__c WHERE Id IN :tradeId];
    
    List<Account> accUpdate = new List<Account>();
    Decimal updatedValue;
    Decimal tradeVal;
    Decimal initialVal;
    
    for(Trade__c trd : Trigger.new){
        
        for(Trade__c trd2 : trades){
            for(Account acc : accounts){
                if(accounts.contains(acc)){
                    System.debug('Account: ' + acc);
                    initialVal = acc.Points__c;
                    
                }
                
                if(trades.contains(trd2)){
                    System.debug('Trade: ' + trd2);
                    tradeVal = trd2.Spend__c;
                }
                
                updatedValue = initialVal - tradeVal;
                System.debug('ACTUAL: ' + updatedValue);
                accUpdate.add(new Account(Id=acc.Id,
                                     	Points__c = updatedValue));
            }
        }
    }
    
    if (!accUpdate.isEmpty()) {

            update accUpdate;

        }*/
    
     //WORKING AS EXPECTED !!!!!!!!!!!
    /*Map<Id, Account> accToUpdate = new Map<Id, Account>();
    List<Id> listRelatedAcc = new List<Id>();
	//list vs set
    
    for(Trade__c trade : trigger.new){
        listRelatedAcc.add(trade.Account__c);
    }
    
    accToUpdate = new Map<Id,Account>([SELECT Id, Points__c FROM Account WHERE ID IN :listRelatedAcc]);
    
    System.debug('!!!: ' + accToUpdate);
    
    for(Trade__c trade : Trigger.new){
        Account parent = accToUpdate.get(trade.Account__c);
        
        parent.Points__c -= trade.Spend__c;
        System.debug('COUNT: ' + parent.Points__c);
    }
    
    update accToUpdate.values();*/
    
 	Map<Id, Account> parentAcc = new Map<Id, Account>();
    Set<Id> setIds = new Set<Id>();
    //list??
    //
    for(Trade__c trade : Trigger.new){
        setIds.add(trade.Account__c);
    }
    
    //parentAcc = new Map<Id,Account>([SELECT Id, Points__c, (SELECT Id, Spend__c FROM Trades__r) FROM Account WHERE Id = :setIds]);
	parentAcc = new Map<Id,Account>([SELECT Id, Points__c FROM Account WHERE Id = :setIds]);
    
    System.debug('MAP: ' + parentAcc);
    for(Trade__c trade : Trigger.new){
        Account parentAccount = parentAcc.get(trade.Account__c);
        parentAccount.Points__c -= trade.Spend__c;
    }
    
    update parentAcc.values();
    
}