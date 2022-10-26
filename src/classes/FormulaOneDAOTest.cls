/**
 * Created by ADMIN on 20.10.2022.
 */

@IsTest
private class FormulaOneDAOTest {

    @TestSetup
    static void dataSetup(){
        Driver__c driver1 = TestDataFactory.createDriver(1);
        Driver__c driver2 = TestDataFactory.createDriver(2);
        Driver__c driver3 = TestDataFactory.createDriver(3);

        Race__c race1 = TestDataFactory.createRace(1, driver1, driver2, driver3);
        Race__c race2 = TestDataFactory.createRace(2, driver2, driver1, driver3);

        Race_Result__c raceResult1 = TestDataFactory.createRaceResult(1, race1, driver1, 1,1, true);
        Race_Result__c raceResult2 = TestDataFactory.createRaceResult(2, race1, driver2, 2,2, false);
        Race_Result__c raceResult3 = TestDataFactory.createRaceResult(3, race1, driver3, 3,3, false);
        Race_Result__c raceResult4 = TestDataFactory.createRaceResult(4, race2, driver2, 1,1, true);
        Race_Result__c raceResult5 = TestDataFactory.createRaceResult(5, race2, driver1, 2,2, false);
        Race_Result__c raceResult6 = TestDataFactory.createRaceResult(6, race2, driver3, 3,3, false);

    }

    @IsTest
    static void getDriverByIdTest() {
        Driver__c driver = [
                SELECT Id
                FROM Driver__c
                WHERE Name = 'Test driver 1'
        ];

        Test.startTest();
        Driver__c driverTest = FormulaOneDAO.getDriver(driver.Id);
        Test.stopTest();

        System.assertEquals(driver, driverTest);
    }

    @IsTest
    static void getRaceResultTest(){
        List<Race_Result__c> raceResult = [
                SELECT Id, Racer__c
                FROM Race_Result__c
                WHERE Racer__r.Name = 'Test driver 1'
        ];

        Test.startTest();
        List<Race_Result__c> raceResults = FormulaOneDAO.getRaceResults(raceResult.get(0).Racer__c);
        Test.stopTest();

        System.assertEquals(raceResult, raceResults);

    }

    @IsTest
    static void getDriverCircuitsTest(){

        Set<String> setRacesName = new Set<String>();
        setRacesName.add('Test race 1');
        setRacesName.add('Test race 2');

        Test.startTest();
        Driver__c driver = [
                SELECT Id
                FROM Driver__c
                WHERE Name = 'Test driver 1'
        ];
        Set<String> testSet = FormulaOneDAO.getDriverCircuits(driver.Id);
        Test.stopTest();

        System.assertEquals(setRacesName, testSet);

    }


    @IsTest
    static void getYoungestDriverOnRaceTest(){

        Race_Result__c raceResult = [
                SELECT Racer__c, Grand_Prix__c
                FROM Race_Result__c
                WHERE Grand_Prix__r.Name = 'Test race 1'
                LIMIT 1
        ];

        Test.startTest();
        Driver__c driverTest = FormulaOneDAO.getYoungestDriverOnRace(raceResult.Grand_Prix__c);
        Test.stopTest();

        System.assertEquals(raceResult.Racer__c, driverTest.Id);

    }

    @IsTest
    static void getAllDriversByCircuitTest(){

        Map<String, List<String>> result = new Map<String, List<String>>();
        List<String> list1 = new List<String>{'Test driver 1','Test driver 2','Test driver 3'};
        List<String> list2 = new List<String>{'Test driver 2','Test driver 1','Test driver 3'};

        result.put('Test race 1', list1);
        result.put('Test race 2', list2);


        Test.startTest();
        FormulaOneDAO.getAllDriversByCircuit();
        Test.stopTest();

        System.assertEquals(result, FormulaOneDAO.getAllDriversByCircuit());
    }
}