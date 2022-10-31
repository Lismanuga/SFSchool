/**
 * Created by ADMIN on 26.10.2022.
 */

global class PostponeRaceBatch implements Database.Batchable<sObject>, Database.Stateful{

    public static Integer recordsProcessed = 0;

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
                'SELECT Id, Status__c, Date__c FROM Race__c WHERE Status__c = \'Active\' '
        );
    }

    global void execute(Database.BatchableContext bc, List<Race__c> races) {
        List<Race__c> racesList = new List<Race__c>();
        for (Race__c race :races){
            race.Date__c = race.Date__c.addMonths(1);
            racesList.add(race);
            ++recordsProcessed;
            System.debug(recordsProcessed);
        }
        update racesList;

    }

    global void finish(Database.BatchableContext param1) {
        System.debug(recordsProcessed + ' records processed!');
    }


}