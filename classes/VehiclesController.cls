public class VehiclesController {
      @AuraEnabled
      public static List <Vehicle__c> getVehicles() {
        
       	return [SELECT Id, Name, Brand__c, Image__c, Price__c from Vehicle__c];
      }
    
      @AuraEnabled
      public static List <String> getVehicleTypes() {
          
        List <String> listOfTypes = new List<String>();
        Schema.DescribeFieldResult fieldResult = Vehicle__c.Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            listOfTypes.add(pickListVal.getLabel());
        }   
       	return listOfTypes;
      }
    
	  @AuraEnabled
      public static Vehicle__c getVehicleDetails(String vehicleId) {
          
       	return [SELECT Id, Name, Brand__c, Image__c, Price__c, Production_Year__c from Vehicle__c WHERE Id = :vehicleId LIMIT 1];
      }

      @AuraEnabled
      public static List <Vehicle__c> searchVehicles(String brand, String [] types) {
          
          List <Vehicle__c> vehiclesList = new List<Vehicle__c> ();
          String vehiclesQuery = 'SELECT Id, Name, Type__c, Brand__c, Image__c, Price__c, Production_Year__c from Vehicle__c';
          if(!String.isEmpty(brand)){
          	String searchKey = '%'+ brand + '%';
          	vehiclesQuery = vehiclesQuery+' WHERE Brand__c LIKE :searchKey';
          }
          
          if(types.size()>0){
              if(vehiclesQuery.contains('WHERE')){
                  vehiclesQuery=vehiclesQuery+' AND Type__c IN :types';
              }else{
                  vehiclesQuery=vehiclesQuery+' WHERE Type__c IN :types';
              }
              
          }
          vehiclesList = Database.query(vehiclesQuery);
          return vehiclesList;
    }
    
    @AuraEnabled
    public static void sendInquiry(String subject, String text, String email) {
        Inquiry__c newInquiry = new Inquiry__c();
        
        newInquiry.Name = subject;
        newInquiry.Inquiry_Text__c = text;
        newInquiry.Email__c = email;
        
        insert(newInquiry);
        
    }
    
    @AuraEnabled
    public static void createOrder(Vehicle__c veh, String name, String lastName, String phone, String email, Date dateFrom, Date dateTo, String comments) {
        Car_Order__c newOrder = new Car_Order__c();
        
        newOrder.Name= 'CO'+name+lastName+'_'+dateFrom.year()+dateFrom.month()+dateFrom.day()+'-'+dateTo.year()+dateTo.month()+dateTo.day();
        newOrder.Vehicle__c = veh.Id;
        newOrder.Contact_Name__c = name+' '+lastName;
        newOrder.Contact_Phone__c = phone;
        newOrder.Email__c = email;
        newOrder.Date_from__c = dateFrom;
        newOrder.Date_to__c = dateTo;
        newOrder.Additional_Info__c = comments;
        insert(newOrder);
        
    }
}