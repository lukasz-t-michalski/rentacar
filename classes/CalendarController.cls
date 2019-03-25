public class CalendarController {
	
	//newComment
    @AuraEnabled
    public static Vehicle__c getVehicle() {
        
        return [SELECT Id, Name, Brand__c, Image__c, Price__c from Vehicle__c LIMIT 2];
    }
    
    @AuraEnabled
    public static List<Car_Order__c> getBookedDates(Id vehicleId) {
        List<Car_Order__c> ordersList = new List<Car_Order__c>();
        ordersList = [SELECT Date_from__c, Date_to__c, Vehicle__r.Id, Contact_Name__c from Car_Order__c WHERE Vehicle__r.Id = :vehicleId];
        
        //List<String> returnDates = new List<String>();
        //return returnDates;
        return ordersList;
    }
}