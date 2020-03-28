@RestResource(urlMapping='/Opportunities/*')

global with sharing class OpportunityManager {

    @HttpGet
    global static Opportunity getOpportunityById(){
        RestRequest request = RestContext.request;
        System.debug('URI: ' + request.requestURI);
        //Get case id from end of url
        String oppId = request.requestURI.substring(
        	request.requestURI.lastIndexOf('/')+1);
        
        Opportunity opp = [SELECT Id, Name, Description, Amount, OwnerId
                      	FROM Opportunity
                      	WHERE Id = :oppId];
        
        return opp;
    }
    
    @HttpPost
    global static ID createOpportunity(String name, String description, Decimal amount, String owner, String stageName, Date closeDate){
                                    
  		Opportunity opp = new Opportunity();
                  
        opp.Name = name;
        opp.Description = description;
        opp.Amount = amount;
        opp.OwnerId = owner;
        opp.StageName = stageName;
        opp.CloseDate = closeDate;
       	   
    	insert opp;
     	return opp.Id; 
  	}
    
    @HttpDelete
    global static void deleteOpportunity(){
        RestRequest request = RestContext.request;
        
        String oppId = request.requestURI.substring(
        	request.requestURI.lastIndexOf('/')+1);
        
        Case opp = [SELECT ID FROM Case WHERE ID = :oppId];
    }
    
    
    @HttpPut
    global static ID upsertOpportunity(String name, String description, Decimal amount, String owner, String stageName, Date closeDate, String Id){
        
        Opportunity opp = new Opportunity();
        opp.Id = id;
        opp.Name = name;
        opp.Description = description;
        opp.Amount = amount;
        opp.OwnerId = owner;
        opp.StageName = stageName;
        opp.CloseDate = closeDate;
        
        upsert opp;
        return opp.Id;        
    }
    
    
    @HttpPatch
    global static ID updateOpportunityFields(){
        RestRequest request = RestContext.request;
        
        String oppId = request.requestURI.substring(
        	request.requestURI.lastIndexOf('/')+1);
        
        Opportunity opp = [SELECT ID FROM Opportunity WHERE ID = :oppId];
        
        //Deserialize JSON string to name-val pairs
        Map<String, Object> params = (Map<String,Object>)JSON.deserializeUntyped(request.requestBody.toString());
        
        //iterate each param field and val
        for(String fieldName : params.keySet()){
            //set field and val on case obj
            opp.put(fieldName, params.get(fieldName));
        }
        update opp;
        return opp.Id;
    }
    
}