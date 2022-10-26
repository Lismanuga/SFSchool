

public with sharing class wonRaceResultController {
    @AuraEnabled (Cacheable=true)
    public static List<RRDTO> getRaceResultsList(Id recordId) {

        List<RRDTO> result = new List<RRDTO>();
        for (Race_Result__c item: [
                SELECT
                        Id, Name,
                        Position__c,
                        Racer__c,
                        Grand_Prix__r.Name
                FROM Race_Result__c
                WHERE Position__c = 1 AND Racer__c = :recordId
        ]){
            result.add(new RRDTO(item.Name, item.Grand_Prix__r.Name));
        }
        return result;
    }

    public class RRDTO {

        @AuraEnabled
        public String Name;
        @AuraEnabled
        public String GrandPrix;
        public RRDTO(String name, String grandName) {
            this.Name = name;
            this.GrandPrix = grandName;
        }
    }
}