({
   init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Driver Name', fieldName: 'Name', type: 'text'},
            { label: 'Hat Tricks', fieldName: 'Hat_Tricks__c', type: 'number'}
        ]);
        helper.getData(cmp);
    }
})