/**
 * Created by ADMIN on 21.10.2022.
 */

@IsTest
private class RaceResultTriggerTest {
    @TestSetup
    public static void dataSetup(){
        Driver__c driver1 = TestDataFactory.createDriver(1);
        Driver__c driver2 = TestDataFactory.createDriver(2);
        Driver__c driver3 = TestDataFactory.createDriver(3);

        Race__c race1 = TestDataFactory.createRace(1, driver1, driver2, driver3);
        Race__c race2 = TestDataFactory.createRace(2, driver2, driver1, driver3);


        Race_Result__c raceResult1 = TestDataFactory.createRaceResult(1, race1, driver1, 1,1, true);
        Race_Result__c raceResult2 = TestDataFactory.createRaceResult(2, race1, driver2, 2,2, false);
        Race_Result__c raceResult3 = TestDataFactory.createRaceResult(3, race1, driver3, 3,3, false);
        Race_Result__c raceResult4 = TestDataFactory.createRaceResult(4, race2, driver2, 4,1, true);
        Race_Result__c raceResult5 = TestDataFactory.createRaceResult(5, race2, driver1, 2,2, false);
        Race_Result__c raceResult6 = TestDataFactory.createRaceResult(6, race2, driver3, 3,3, false);
    }

    @IsTest
    static void insertValidationTest() {
        Race_Result__c testResult = [
                SELECT Id, Grand_Prix__c, Racer__c
                FROM Race_Result__c
                WHERE Name = 'Test race result 1'
        ];

        Test.startTest();

        Race_Result__c raceResult = new Race_Result__c(
                Name = 'Race Result',
                Racer__c = testResult.Racer__c,
                Grand_Prix__c = testResult.Grand_Prix__c,
                Position__c = 6,
                Is_Fastest_Lap__c = false,
                Grid__c = 5

        );
        String message;
        try {
            insert raceResult;
        } catch (DmlException e){
            message = e.getMessage();
        }
        Test.stopTest();

        System.assertEquals('Insert failed. First exception on row 0; first error:' +
                ' FIELD_CUSTOM_VALIDATION_EXCEPTION, Wrong position or racer!: []', message);

    }


    @IsTest
    static void updateValidationPositionTest() {
        Race_Result__c testResult = [
                SELECT Id, Grand_Prix__c, Racer__c
                FROM Race_Result__c
                WHERE Name = 'Test race result 1'
        ];

        Test.startTest();

        testResult.Position__c = 2;
        String message;
        try {
            update testResult;
        } catch (DmlException e){
            message = e.getMessage();
        }
        Test.stopTest();

        System.assert(message.contains('Wrong position!'));

    }

    @IsTest
    static void updateValidationRacerTest() {
        Race_Result__c testResult = [
                SELECT Id, Grand_Prix__c, Racer__c, Grand_Prix__r.Name
                FROM Race_Result__c
                WHERE Grand_Prix__r.Name = 'Test race 1'
        ];

        Test.startTest();

        testResult.Racer__c = testResult.Racer__c;
        String message;
        try {
            update testResult;
        } catch (DmlException e){
            message = e.getMessage();
        }
        Test.stopTest();

        System.assert(message.contains('Wrong racer!'));

    }

    @IsTest
    static void decreaseHatTrick() {
        Race_Result__c testResult = [
                SELECT Id, Grand_Prix__r.Name, Grand_Prix__c, Racer__r.Hat_Tricks__c
                FROM Race_Result__c
                WHERE Grand_Prix__r.Name = 'Test race 1'AND Racer__r.Name = 'Test driver 1'
        ];

        Test.startTest();
        System.debug(testResult.Racer__r.Hat_Tricks__c);
        testResult.Position__c = 4;
        update testResult;

        Race_Result__c newResult = [
                SELECT Id, Grand_Prix__r.Name, Grand_Prix__c, Racer__r.Hat_Tricks__c
                FROM Race_Result__c
                WHERE Grand_Prix__r.Name = 'Test race 1'AND Racer__r.Name = 'Test driver 1'
        ];
        Test.stopTest();

        System.assertEquals(0, newResult.Racer__r.Hat_Tricks__c);

    }

    @IsTest
    static void increaseHatTrick() {
        Race_Result__c testResult = [
                SELECT Id, Grand_Prix__r.Name, Grand_Prix__c, Racer__r.Hat_Tricks__c
                FROM Race_Result__c
                WHERE Grand_Prix__r.Name = 'Test race 2'AND Racer__r.Name = 'Test driver 2'
        ];

        Test.startTest();
        System.debug(testResult.Racer__r.Hat_Tricks__c);
        testResult.Position__c = 1;
        update testResult;

        Race_Result__c newResult = [
                SELECT Id, Grand_Prix__r.Name, Grand_Prix__c, Racer__r.Hat_Tricks__c
                FROM Race_Result__c
                WHERE Grand_Prix__r.Name = 'Test race 2'AND Racer__r.Name = 'Test driver 2'
        ];
        Test.stopTest();

        System.assertEquals(1, newResult.Racer__r.Hat_Tricks__c);

    }

}