@RestResource(urlMapping='/Cases/*')

global with sharing class CaseManager {

    @HttpGet
    global static Case getCaseById(){
        RestRequest request = RestContext.request;
        
        //Get case id from end of url
        String caseId = request.requestURI.substring(
        	request.requestURI.lastIndexOf('/')+1);
        
        Case result = [SELECT CaseNumber, Subject, Status, Origin, Priority
                      	FROM Case
                      	WHERE Id = :caseId];
        
        return result;
    }
    
    @HttpPost
    global static ID createCase(String subject, String status, 
                                String origin, String priority){
                                    
  		Case thisCase = new Case(
        	Subject = subject,
            Status = status,
            Origin = origin,
            Priority = priority
        );
                                    
    	insert thisCase;
     	return thisCase.Id; 
  	}
    
    @HttpDelete
    global static void deleteCase(){
        RestRequest request = RestContext.request;
        
        String caseId = request.requestURI.substring(
        	request.requestURI.lastIndexOf('/')+1);
        
        Case thisCase = [SELECT ID FROM Case WHERE ID = :caseId];
    }
    
    @HttpPut
    global static ID upsertCase(String subject, String status, String origin, String priority, String id){
        
        Case thisCase = new Case();
        thisCase.Id = id;
        thisCase.Subject = subject;
        thisCase.Status = status;
        thisCase.Origin = origin;
        thisCase.Priority = priority;
        
        upsert thisCase;
        return thisCase.Id;        
    }
    
    @HttpPatch
    global static ID updateCaseFields(){
        RestRequest request = RestContext.request;
        
        String caseId = request.requestURI.substring(
        	request.requestURI.lastIndexOf('/')+1);
        
        Case thisCase = [SELECT ID FROM Case WHERE ID = :caseId];
        
        //Deserialize JSON string to name-val pairs
        Map<String, Object> params = (Map<String,Object>)JSON.deserializeUntyped(request.requestBody.toString());
        
        //iterate each param field and val
        for(String fieldName : params.keySet()){
            //set field and val on case obj
            thisCase.put(fieldName, params.get(fieldName));
        }
        update thisCase;
        return thisCase.Id;
    }
    
}