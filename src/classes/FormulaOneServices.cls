public class FormulaOneServices {

    public static String generateKey(SObject record, List<SObjectField> fields, String separator){
             String result = '';
        for (Integer i = 0; i < fields.size(); i++){
            if( i == fields.size()-1){
                result += record.get(fields.get(i));
            } else {
                result += record.get(fields.get(i)) + separator;
            }
            
        }
        return result;
    }

    public static Boolean isHatTrick (Race_Result__c raceResult){
        if (raceResult.Position__c == 1 && raceResult.Grid__c == 1 && raceResult.Is_Fastest_Lap__c) {
            return true;
        } else {
            return false;
        }
    }

    public static void createDriver(String firstName, String lastName, Integer age){
        Driver__c driver = new Driver__c(
                First_Name__c = firstName, Last_Name__c = lastName, Age__c = age
        );
        insert driver;
    }


    public static void createDrivers(List<DriverDTO> drivers){
        List<Driver__c> driversList = new List<Driver__c>();
        for (DriverDTO driverDTO : drivers){
            Driver__c driver = new Driver__c(
                    First_Name__c = driverDTO.firstName,
                    Last_Name__c = driverDTO.lastName,
                    Age__c = driverDTO.age
            );
            driversList.add(driver);
        }
        insert driversList;
    }


    public static Driver__c updateDriverName(
            Id driverId, String firstName, String lastName
    ){
        Driver__c driver = [
                SELECT Id, First_Name__c, Last_Name__c
                FROM Driver__c
                WHERE Id=:driverId
        ];
        driver.First_Name__c = firstName;
        driver.Last_Name__c = lastName;
        update driver;
        return driver;
    }


    public static List<Race__c> updateGrandPrixWinners(Set<Id> raceIds){
        List<Race_Result__c> raceResults = new List<Race_Result__c>([
                SELECT Grand_Prix__c, Grand_Prix__r.Name, Grand_Prix__r.Winner__c,
                        Grand_Prix__r.Podium_Second__c, Grand_Prix__r.Podium_Third__c,
                        Racer__c, Position__c
                FROM Race_Result__c
                WHERE Grand_Prix__c =:raceIds
        ]);

        Map<Id, Race__c> racesIdsToRaces =  new Map<Id, Race__c>();


        for (Race_Result__c rr : raceResults){
            Race__c currentRace= new Race__c(Id = rr.Grand_Prix__c);
            if (racesIdsToRaces.containsKey(rr.Grand_Prix__c)) {
                currentRace = racesIdsToRaces.get(rr.Grand_Prix__c);
            }
            if (rr.Position__c == 1) {
                currentRace.Winner__c = rr.Racer__c;
                System.debug('Update winner in ' + rr.Grand_Prix__r.Name);

            } else if (rr.Position__c == 2){
                currentRace.Podium_Second__c = rr.Racer__c;
                System.debug('Update 2nd podium in ' + rr.Grand_Prix__r.Name);

            } else if (rr.Position__c == 3){
                currentRace.Podium_Third__c = rr.Racer__c;
                System.debug('Update 3rd podium in ' + rr.Grand_Prix__r.Name);

                } else {
                System.debug('Nothing to change');
            }
            racesIdsToRaces.put(rr.Grand_Prix__c, currentRace);
        }


        update racesIdsToRaces.values();
        return racesIdsToRaces.values();

    }

}