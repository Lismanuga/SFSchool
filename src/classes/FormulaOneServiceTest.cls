/**
 * Created by ADMIN on 20.10.2022.
 */

@IsTest
private class FormulaOneServiceTest {
    @TestSetup
    static void dataSetup(){
        Account account = TestDataFactory.createAccount();

        Driver__c driver1 = TestDataFactory.createDriver(1);
        Driver__c driver2 = TestDataFactory.createDriver(2);
        Driver__c driver3 = TestDataFactory.createDriver(3);

        Race__c race1 = TestDataFactory.createRace(1, driver3, driver2, driver1);
        Race__c race2 = TestDataFactory.createRace(2, driver2, driver1, driver3);

        Race_Result__c raceResult1 = TestDataFactory.createRaceResult(1, race1, driver1, 1,1, true);
        Race_Result__c raceResult2 = TestDataFactory.createRaceResult(2, race1, driver2, 2,2, false);
        Race_Result__c raceResult3 = TestDataFactory.createRaceResult(3, race1, driver3, 3,3, false);
        Race_Result__c raceResult4 = TestDataFactory.createRaceResult(4, race2, driver2, 1,1, true);
        Race_Result__c raceResult5 = TestDataFactory.createRaceResult(5, race2, driver1, 2,2, false);
        Race_Result__c raceResult6 = TestDataFactory.createRaceResult(6, race2, driver3, 3,3, false);


    }

    @IsTest
    static void testGeneratingKey() {

        List<SObjectField> fields = new List<SObjectField>();
        fields.add(Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Name'));
        fields.add(Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Id'));
        fields.add(Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Phone'));
        SObject rec = [SELECT Id, Name, Phone FROM Account LIMIT 1];
        String result = 'TestAccount==='+ rec.Id +'===380631152034';

        Test.startTest();
        String testResult = FormulaOneServices.generateKey(rec, fields,'===');
        Test.stopTest();


        System.assertEquals(result, testResult);

    }
    @IsTest
    static void IsHatTrickTest() {
        List<Race_Result__c> raceResult = [
                SELECT Position__c, Grid__c, Is_Fastest_Lap__c
                FROM Race_Result__c
                WHERE Racer__r.Name = 'Test driver 1'
        ];

        Test.startTest();
        Boolean test1 = FormulaOneServices.isHatTrick(raceResult.get(0));
        Boolean test2 = FormulaOneServices.isHatTrick(raceResult.get(1));
        Test.stopTest();

        System.assertEquals(true, test1);
        System.assertEquals(false, test2);
    }

    @IsTest
    static void createDriverTest(){

        Test.startTest();
        FormulaOneServices.createDriver('Bohdan','Hryshchenko', 21);
        List<Driver__c> testDriver = [
                SELECT Id
                FROM Driver__c
                WHERE First_Name__c = 'Bohdan' AND
                Last_Name__c = 'Hryshchenko' AND Age__c = 21
        ];
        Boolean test1;
        if (testDriver.size()>0) {
            test1 = true;
        }
        Test.stopTest();

        System.assertEquals(true, test1);
    }

    @IsTest
    static void createDriversTest(){

        List<DriverDTO> driverDTOS = new List<DriverDTO>();
        DriverDTO driverDTO = new DriverDTO();
        DriverDTO driverDTO2 = new DriverDTO();
        driverDTO.firstName = 'Donald';
        driverDTO.lastName = 'Tramp';
        driverDTO.age = 30;
        driverDTO2.firstName = 'Joseph';
        driverDTO2.lastName = 'Baiden';
        driverDTO2.age = 33;
        driverDTOS.add(driverDTO);
        driverDTOS.add(driverDTO2);

        Test.startTest();

        FormulaOneServices.createDrivers(driverDTOS);

        List<Driver__c> testList = [
                SELECT First_Name__c, Last_Name__c
                FROM Driver__c
                WHERE First_Name__c = 'Donald' OR First_Name__c = 'Joseph'
        ];
        Boolean test1;
        if (testList.size() == 2) {
            test1 = true;
        }
        Test.stopTest();

        System.assertEquals(true, test1);

    }

    @IsTest
    static void updateDriverNameTest(){
        Driver__c driver = [
                SELECT Id
                FROM Driver__c
                WHERE Name = 'Test driver 1'
        ];

        Test.startTest();
        Driver__c testDriver = FormulaOneServices.updateDriverName(driver.Id, 'FN', 'LN');
        Test.stopTest();


        System.assertEquals('FN', testDriver.First_Name__c);
        System.assertEquals('LN', testDriver.Last_Name__c);
    }


    @IsTest
    static void updateGrandPrixWinnersTest(){

        Race__c race = [
                SELECT Id, Winner__r.Name, Podium_Third__r.Name,
                        Winner__c, Podium_Third__c
                FROM Race__c
                WHERE Name = 'Test race 1'
        ];
        Id temp = race.Podium_Third__c;
        race.Podium_Third__c = race.Winner__c;
        race.Winner__c = temp;
        Set<Id> ids = new Set<Id>();
        ids.add(race.Id);

        Test.startTest();

        List<Race__c> raceResultTest = FormulaOneServices.updateGrandPrixWinners(ids);

        Test.stopTest();

        System.assertEquals(race.Podium_Third__c, raceResultTest.get(0).Podium_Third__c);
        System.assertEquals(race.Winner__c, raceResultTest.get(0).Winner__c);
    }
}