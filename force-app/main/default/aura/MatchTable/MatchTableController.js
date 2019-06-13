({
    toggleSpinner: function (component, event) {
        var spinner = component.find("spinner");
        $A.util.toggleClass(spinner, "slds-hide");
    },

    findPeriod: function (component, event, helper) {
        helper.hideElements(component, event, helper);

        var startDate = component.find("startDate").get("v.value");
        var endDate = component.find("endDate").get("v.value");

        if (startDate != '' && endDate != '' && startDate <= endDate) {
            helper.getColumns(component, event, helper);
            helper.getRecordsWithDatePeriod(component, event, helper);
            helper.showTable(component, event, helper);
        } else {
            document.getElementById("messageError").style.display = "block";
        }
    },
})