({
    findAge : function(component, event, helper) {
        var birthday = component.find("birthday").get("v.value");
        var date1 = new Date(birthday);

        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth()+1;
        var yyyy = today.getFullYear();

        if(dd < 10) {
            dd = '0' + dd
        }

        if(mm < 10) {
            mm = '0' + mm
        }

        today = yyyy + '-' + mm + '-' + dd;
        var date2 = new Date(today);

        var timeDiffrence = Math.abs(date2 - date1);
        var differDays = Math.floor(timeDiffrence / (1000 * 3600 * 24));
		var differMonths = Math.floor(differDays / 30);
        var differYears = Math.floor(differDays / 365);

        alert('Your ' + differDays + ' days ' + differMonths + ' months ' + differYears + ' years.');

    }
})