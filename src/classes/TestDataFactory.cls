/**
 * Created by ADMIN on 20.10.2022.
 */

@IsTest
public class TestDataFactory {
    public static Driver__c createDriver(Integer i){
        Driver__c driver = new Driver__c(
                Name = 'Test driver '+ i,
                Age__c = 20 + i,
                Hat_Tricks__c = 0,
                First_Name__c = 'Michael' + i,
                Last_Name__c = 'Schumacher' + i,
                Is_Qualified__c = false
        );
        insert driver;
        return driver;
    }
    public static Driver__c createDriver(String firstName, String lastName, Integer age){
        Driver__c driver = new Driver__c(
                First_Name__c = firstName,
                Last_Name__c = lastName,
                Age__c = age,
                Name = 'test',
                Hat_Tricks__c = 0,
                Is_Qualified__c = false
        );
        insert driver;
        return driver;
    }

    public static Race__c createRace(Integer i, Driver__c winner,
                    Driver__c secondPodium, Driver__c trirdPodium){
        Race__c race = new Race__c(
                Name = 'Test race ' + i,
                Winner__c = winner.Id,
                Podium_Second__c = secondPodium.Id,
                Podium_Third__c = trirdPodium.Id
        );
        insert race;
        return race;
    }

    public static Race_Result__c createRaceResult(Integer i, Race__c race, Driver__c driver, Integer position,
            Integer grid, Boolean isFastestLap){
        Race_Result__c raceResult = new Race_Result__c(
                Name = 'Test race result '+ i,
                Grand_Prix__c = race.Id,
                Racer__c = driver.Id,
                Position__c = position,
                Grid__c = grid,
                Is_Fastest_Lap__c = isFastestLap
        );
        insert raceResult;
        return raceResult;
    }

    public static Account createAccount(){
        Account account = new Account();
        account.Name = 'TestAccount';
        account.Phone='380631152034';
        insert account;
        return account;
    }
}