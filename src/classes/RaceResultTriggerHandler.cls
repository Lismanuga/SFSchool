/**
 * Created by ADMIN on 18.10.2022.
 */

public with sharing class RaceResultTriggerHandler {
    public static void onBeforeInsert(List<Race_Result__c> raceResults){
        RaceResultTriggerHandler.raceResultInsertDuplicateValidation(raceResults);
    }


    public static void onBeforeUpdate(List<Race_Result__c> raceResults, Map<Id, Race_Result__c> oldRaceResultsMap){
        RaceResultTriggerHandler.raceResultUpdateDuplicateValidation(raceResults, oldRaceResultsMap);
    }

    public static void raceResultInsertDuplicateValidation(List<Race_Result__c> results){
        Set<Id> setRaceIds = new Set<Id>();
        for (Race_Result__c raceResult : results){
            setRaceIds.add(raceResult.Grand_Prix__c);
        }

        if (setRaceIds.size() > 0) {
            List<Race_Result__c> listResults = [
                    SELECT Racer__c, Position__c
                    FROM Race_Result__c
                    WHERE Grand_Prix__c IN :setRaceIds
            ];

            Map<Decimal, Race_Result__c> mapPositionResult = new Map<Decimal, Race_Result__c>();
            Map<Id, Race_Result__c> mapRacerResult = new Map<Id, Race_Result__c>();

            for (Race_Result__c raceResult : listResults){
                mapPositionResult.put(raceResult.Position__c, raceResult);
                mapRacerResult.put(raceResult.Racer__c, raceResult);
            }

            for (Race_Result__c raceResult : results){
                if (mapRacerResult.containsKey(raceResult.Racer__c) || (
                        mapPositionResult.containsKey(raceResult.Position__c)
                )) {
                    raceResult.addError('Wrong position or racer!');
                }
            }
        }
    }

    public static void raceResultUpdateDuplicateValidation(List<Race_Result__c> newList ,Map<Id, Race_Result__c> oldRaceResultsMap) {
        Set<Id> setRaceIds = new Set<Id>();
        for (Race_Result__c raceResult : newList){
            setRaceIds.add(raceResult.Grand_Prix__c);
        }

        if (setRaceIds.size() > 0) {
            List<Race_Result__c> listResults = [
                    SELECT Racer__c, Position__c
                    FROM Race_Result__c
                    WHERE Grand_Prix__c IN :setRaceIds
            ];

            Map<Decimal, Race_Result__c> mapPositionResult = new Map<Decimal, Race_Result__c>();
            Map<Id, Race_Result__c> mapRacerResult = new Map<Id, Race_Result__c>();

            for (Race_Result__c raceResult : listResults){
                mapPositionResult.put(raceResult.Position__c, raceResult);
                mapRacerResult.put(raceResult.Racer__c, raceResult);
            }

            for (Race_Result__c newResult : newList){
                Race_Result__c oldResult = oldRaceResultsMap.get(newResult.Id);
                    if (oldResult.Position__c == newResult.Position__c && oldResult.Racer__c != newResult.Racer__c) {
                        if (mapRacerResult.containsKey(newResult.Racer__c)) {
                            newResult.Racer__c.addError('Wrong racer!');
                        }
                    } else if (oldResult.Racer__c == newResult.Racer__c && oldResult.Position__c != newResult.Position__c) {
                        if (mapPositionResult.containsKey(newResult.Position__c)) {
                            newResult.Position__c.addError('Wrong position!');
                        }
                    } else if (oldResult.Racer__c != newResult.Racer__c && oldResult.Position__c != newResult.Position__c) {
                        if (mapRacerResult.containsKey(newResult.Racer__c) || (
                                mapPositionResult.containsKey(newResult.Position__c)
                        )) {
                            newResult.Racer__c.addError('Wrong racer!');
                            newResult.Position__c.addError('Wrong position!');
                        }
                    }
            }
        }
    }


    public static void onAfterInsert(List<Race_Result__c> raceResults){
        RaceResultTriggerHandler.driverHattrick(raceResults);
    }

    public static void driverHattrick (List<Race_Result__c> raceResults){
        Map<Id, Race_Result__c> raceResultMap = new Map<Id, Race_Result__c>();

        for (Race_Result__c raceResult: raceResults){
            if (raceResult.Position__c == 1 && raceResult.Is_Fastest_Lap__c) {
                raceResultMap.put(raceResult.Racer__c, raceResult);
            }
        }

        List<Driver__c> drivers = [
                SELECT Hat_Tricks__c, Id
                FROM Driver__c
                WHERE Id IN :raceResultMap.keySet()
        ];

        for (Driver__c driver : drivers){
            if (raceResultMap.containsKey(driver.Id)) {
                driver.Hat_Tricks__c += 1;
            }
        }

        update drivers;
    }


    public static void onAfterUpdate(List<Race_Result__c> newList, Map<Id,Race_Result__c> oldRaceResultsMap){

        Map<Id, Race_Result__c> plusHTMap = new Map<Id, Race_Result__c>();
        Map<Id, Race_Result__c> minusHTMap = new Map<Id, Race_Result__c>();

        for (Race_Result__c newResult : newList){

            Race_Result__c oldResult = oldRaceResultsMap.get(newResult.Id);

            if (oldResult.Racer__c == newResult.Racer__c) {
                if ((oldResult.Position__c == 1 && newResult.Position__c != 1) ||
                        (oldResult.Is_Fastest_Lap__c && !newResult.Is_Fastest_Lap__c)) {

                    minusHTMap.put(newResult.Racer__c, newResult);

                } else if ((oldResult.Position__c != 1 && newResult.Position__c == 1 && newResult.Is_Fastest_Lap__c) ||
                        (!oldResult.Is_Fastest_Lap__c && newResult.Is_Fastest_Lap__c && newResult.Position__c == 1)) {

                    plusHTMap.put(newResult.Racer__c, newResult);
                }
            } else if (oldResult.Racer__c != newResult.Racer__c) {
                if (oldResult.Position__c == 1 && oldResult.Is_Fastest_Lap__c) {

                    minusHTMap.put(oldResult.Racer__c, oldResult);

                    if (newResult.Position__c == 1 && newResult.Is_Fastest_Lap__c) {

                        plusHTMap.put(newResult.Racer__c, newResult);
                    }
                }
            }

        }

        List<Driver__c> drivers = [
                SELECT Hat_Tricks__c, Id
                FROM Driver__c
                WHERE
                        Id IN :plusHTMap.keySet() OR
                        Id IN :minusHTMap.keySet()
        ];


        for (Driver__c driver : drivers){
            if (plusHTMap.containsKey(driver.Id)) {
                driver.Hat_Tricks__c += 1;
            } else if (minusHTMap.containsKey(driver.Id)) {
                driver.Hat_Tricks__c -= 1;
            }
        }

        update drivers;
    }


}