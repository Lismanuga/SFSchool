/**
 * Created by ADMIN on 18.10.2022.
 */

trigger RaceResultTrigger on Race_Result__c (before insert, before update, after insert, after update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            RaceResultTriggerHandler.onBeforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            RaceResultTriggerHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    } else if (Trigger.isAfter){
        if (Trigger.isInsert) {
            RaceResultTriggerHandler.onAfterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            RaceResultTriggerHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}