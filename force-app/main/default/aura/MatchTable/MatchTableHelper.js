({
    hideElements: function(component, event, helper) {
        document.getElementById("messageError").style.display = "none";
        document.getElementById("messageInformation").style.display = "none";
    },

    getColumns: function(component, event, helper) {
        component.set('v.columns', [
            {label: 'Match Name', fieldName: 'Name', type: 'text'},
            {label: 'Match Date', fieldName: 'DateMatch__c', editable:'true', type: 'date-local'},
            {label: 'Team One', fieldName: 'linkTeamOne', type: 'url',
             typeAttributes: {label: { fieldName: 'teamOne' }, target: '_blank'}},
            {label: 'Team Two', fieldName: 'linkTeamTwo', type: 'url',
             typeAttributes: {label: { fieldName: 'teamTwo' }, target: '_blank'}}
        ]);
    },

    getRecordsWithDatePeriod: function(component, event, helper) {

        var startDate = component.find("startDate").get("v.value");
        var endDate = component.find("endDate").get("v.value");
        var action = component.get("c.getRecordsWithPeriod");

        action.setParams({
            "dateStart": startDate,
            "dateEnd": endDate
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records =response.getReturnValue();
                records.forEach(function(record){
                    record.linkTeamOne = '/'+record.TeamOne__c;
                    record.teamOne = record.TeamOne__r.Name;
                    record.linkTeamTwo = '/'+record.TeamTwo__c;
                    record.teamTwo = record.TeamTwo__r.Name;

                });
                if (records.length == 0) {
                    document.getElementById("messageInformation").style.display = "block";
                }
                component.set("v.records", records);
            }
        });
        $A.enqueueAction(action);
    },

    showTable: function(component, event, helper) {
        document.getElementById("tableVisible").style.display = "block";
    },
})