public class DriverController {
@AuraEnabled
    public static List<Driver__c> getContacts() {
        List<Driver__c> drivers =
                [SELECT Id, Name, Hat_Tricks__c 
                 FROM Driver__c 
                 ORDER BY Hat_Tricks__c
                 DESC
                 LIMIT 5 ];
        //Add isAccessible() check
        return drivers;
    }
}