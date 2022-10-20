public class FormulaOneDAO {
    public static Driver__c getDriver(Id driverId) {

        return [
                SELECT Id
                FROM Driver__c
                WHERE Id = :driverId
        ];

    }
    public static List<Race_Result__c> getRaceResults(Id driverId) {

        return [
                SELECT Id
                FROM Race_Result__c
                WHERE Racer__r.Id = :driverId
        ];

    }

    public static Set<String> getDriverCircuits(Id driverId) {

        List<Race__c> races = [
                SELECT Name
                FROM Race__c
                WHERE Id IN (
                        SELECT Grand_Prix__c
                        FROM Race_Result__c
                        WHERE Racer__c = :driverId
                )
        ];
        Set<String> driversCircuits = new Set<String>();

        for (Race__c race : races) {
            driversCircuits.add(race.Name);
        }
        return driversCircuits;
    }

    public static Driver__c getYoungestDriverOnRace(Id raceId) {
        return [
                SELECT Id, Age__c
                FROM Driver__c
                WHERE Id IN (
                        SELECT Racer__c
                        FROM Race_Result__c
                        WHERE Grand_Prix__c = :raceId
                )
                ORDER BY Age__c
                LIMIT 1
        ];
    }

    public static Map<String, List<String>> getAllDriversByCircuit(){

        Map<String, List<String>> result = new Map<String, List<String>>();

        List<Race_Result__c> raceResults = [
                SELECT Grand_Prix__c, Grand_Prix__r.Name, Racer__r.Name
                FROM Race_Result__c
        ];
        Set<String> racesName = new Set<String>();
        for (Race_Result__c rr : raceResults){
            racesName.add(rr.Grand_Prix__r.Name);
        }

        for (String rN : racesName){
            List<String> driverNames = new List<String>();
            for (Race_Result__c rr : raceResults){
                if (rr.Grand_Prix__r.Name == rN) {
                    driverNames.add(rr.Racer__r.Name);
                }
            }
            result.put(rN,driverNames);
        }

        return result;
    }
}
/*
        System.debug(FormulaOneDAO.getDriver('a027Q000003SQvNQAW'));
        System.debug(FormulaOneDAO.getRaceResults('a027Q000003SQvNQAW'));
        System.debug(FormulaOneDAO.getDriverCircuits('a027Q000003SQvNQAW'));
        System.debug(FormulaOneDAO.getYoungestDriverOnRace('a007Q00000BHeZtQAL'));
        System.debug(FormulaOneDAO.getAllDriversByCircuit());
 */

/*



 */