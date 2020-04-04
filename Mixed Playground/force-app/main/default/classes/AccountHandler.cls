public with sharing class AccountHandler {
    public static void insertAccount(Integer accNumber){

        List<Account> addAccounts = new List<Account>();
        Integer n = 1;

        while(n<=accNumber){
            Account acc = new Account();
            acc.Name = 'Acme Inc ' + n;
            acc.AccountNumber = 'A000' + n;
            acc.Teste__c = 'jibajaba';
            addAccounts.add(acc);
            n+=1; 
        }

        insert addAccounts;
    }
}