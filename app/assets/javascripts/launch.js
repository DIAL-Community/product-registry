var launchData = {

    getCrumb: function(jenkinsData) {
        var jenkinsCrumb;

        var crumbUrl = jenkinsData.jenkinsUrl+"/crumbIssuer/api/json";
        $.ajax({
            async: false,
            type: "GET",
            url: crumbUrl,
            crossDomain: true,
            dataType: "json",
            beforeSend: function (xhr) {
                xhr.setRequestHeader ("Authorization", "Basic " + btoa(jenkinsData.jenkinsUser + ":" + jenkinsData.jenkinsPassword));
            },
            success: function (data){
                jenkinsCrumb = data.crumb;
            }
        });

        return jenkinsCrumb;
    },

    reportSuccess: function(jenkinsData, jenkinsCrumb, jobNumber) {

        var jobUrl=jenkinsData.jenkinsUrl+"/job/"+jenkinsData.jobName+"/"+jobNumber+"/logText/progressiveText?start=0";

        $.ajax({
            type: "GET",
            url: jobUrl,
            crossDomain: true,
            beforeSend: function (xhr) {
                xhr.setRequestHeader ("Authorization", "Basic " + btoa(jenkinsData.jenkinsUser + ":" + jenkinsData.jenkinsPassword));
                xhr.setRequestHeader ("Jenkins-Crumb", jenkinsCrumb);
            },
            success: function (data){
                //console.log("Job data: " + JSON.stringify(data))
                var offset1 = data.indexOf("docker-machine ip " + jenkinsData.orgId+"-"+jenkinsData.jobName) + 1
                var offset = data.indexOf("docker-machine ip " + jenkinsData.orgId+"-"+jenkinsData.jobName, offset1) + 21
                offset += jenkinsData.orgId.length
                offset += jenkinsData.jobName.length
                $("#launchDiv").append('<p id="launchStatus" class="card-text text-muted">Your machine is here: </p><a class="card-text text-muted" target="_blank" href=\'http://'+data.substring(offset, offset+15)+'\'>http://'+data.substring(offset, offset+15)+'</a>');
            }
        });
    },

    queryJob: function(jenkinsData, jenkinsCrumb, jobNumber) {

        var jobUrl=jenkinsData.jenkinsUrl+"/job/"+jenkinsData.jobName+"/"+jobNumber+"/api/json";
        var that = this;

        $.ajax({
            type: "GET",
            url: jobUrl,
            crossDomain: true,
            beforeSend: function (xhr) {
                xhr.setRequestHeader ("Authorization", "Basic " + btoa(jenkinsData.jenkinsUser + ":" + jenkinsData.jenkinsPassword));
                xhr.setRequestHeader ("Jenkins-Crumb", jenkinsCrumb);
            },
            success: function (data){
                if (data.result == "SUCCESS") {
                    $("#launchStatus").text("SUCCESS!!")
                    that.reportSuccess(jenkinsData, jenkinsCrumb, jobNumber)
                } else if (data.result == null) {
                    // Ping again in 10 seconds
                    $("#launchStatus").remove()
                    $("#launchDiv").append('<p id="launchStatus" class="card-text text-muted">Waiting for job to complete...<i class="fas fa-spinner fa-spin ml-3"></i></p>');
                    setTimeout(function() { that.queryJob(jenkinsData, jenkinsCrumb, jobNumber) }, 10000);
                } else {
                    // Error
                    $("#launchStatus").text("Error. Please try again")
                }
            }
        });
    },

    launchBuild: function(jenkinsData) {
        var jenkinsCrumb = this.getCrumb(jenkinsData);
        console.log("Jenkins_crumb: "+jenkinsCrumb);

        var buildUrl;
        if (jenkinsData.provider == "DO") {
            buildUrl=jenkinsData.jenkinsUrl+"/job/"+jenkinsData.jobName+"/buildWithParameters?AUTH_TOKEN="+jenkinsData.authToken+"&ORG_ID="+jenkinsData.orgId+"&PROVIDER="+jenkinsData.provider;
        } else {
            buildUrl=jenkinsData.jenkinsUrl+"/job/"+jenkinsData.jobName+"/buildWithParameters?AUTH_TOKEN="+jenkinsData.accessKey+"&ORG_ID="+jenkinsData.orgId+"&PROVIDER="+jenkinsData.provider+"&SECRET_KEY="+jenkinsData.secretKey;
        }
        var that = this;
        $.ajax({
            type: "POST",
            url: buildUrl,
            crossDomain: true,
            beforeSend: function (xhr) {
                xhr.setRequestHeader ("Authorization", "Basic " + btoa(jenkinsData.jenkinsUser + ":" + jenkinsData.jenkinsPassword));
                xhr.setRequestHeader ("Jenkins-Crumb", jenkinsCrumb);
            },
            statusCode: {
                201: function(data, status, xhr) {
                    $("#launchStatus").remove()
                    $("#launchDiv").append('<p id="launchStatus" class="card-text text-muted">Build launched...<i class="fas fa-spinner fa-spin ml-3"></i></p>');
                    var location = xhr.getResponseHeader("Location").split('/')
                    // The job number is the second to last element
                    var jobNumber = location[location.length-2]
                    setTimeout(function() { that.queryJob(jenkinsData, jenkinsCrumb, jobNumber) }, 10000);
                }
            },
            success: function (data, status, xhr){
                
            },
            error: function (xhr, ajaxOptions, thrownError) {
                console.log("Error")
                $("#launchStatus").text("There was an issue in launching your build. Please try again.")
              }
        });
    },

    startLaunch: function() {
        // Read data from #jenkins_data div
        var jenkinsData = $("#jenkinsData").data();

        // Append our inputs to the jenkins data
        jenkinsData.provider = $("#provider").val()
        jenkinsData.authToken = $("#authToken").val()
        jenkinsData.orgId = $("#orgId").val()
        jenkinsData.accessKey = $("#accessKey").val()
        jenkinsData.secretKey = $("#secretKey").val()
        console.log(jenkinsData);

        if (jenkinsData.orgId == "") {
            $("#orgValidate").toggleClass("field-valid");
            return
        }

        if (jenkinsData.provider == "DO") {
            if (jenkinsData.authToken == "") {
                $("#authValidate").toggleClass("field-valid");
                return
            }
        } else {
            if (jenkinsData.accessKey == "") {
                $("#accessValidate").toggleClass("field-valid");
                return
            }
            if (jenkinsData.secretKey == "") {
                $("#secretValidate").toggleClass("field-valid");
                return
            }
        }

        $("#launchDiv").empty();

        if (jenkinsData.provider == "DO") {
            $("#launchDiv").append('<p id="launchMessage" class="card-text text-muted">Product is being launched on Digital Ocean droplet</p>');
        } else {
            $("#launchDiv").append('<p id="launchMessage" class="card-text text-muted">Product is being launched on AWS</p>');
        }
        $("#launchDiv").append('<p id="launchStatus" class="card-text text-muted">Waiting...<i class="fas fa-spinner fa-spin ml-3"></i></p>');
        this.launchBuild(jenkinsData); 
    },

    popInstructions: function() {
        $("#instPopup").toggleClass("show");
    },

    providerChange: function() {
        if ($("#provider").val() == "DO") {
            $("#accessKey").hide()
            $("#secretKey").hide()
            $("#authToken").show()
        } else {
            $("#accessKey").show()
            $("#secretKey").show()
            $("#authToken").hide()
        }
    },

    initialize : function() {

        $("#launchDiv").empty();

        $("#launchDiv").append('<div id="launchForm" class="col-8" style="float:left">')
        $("#launchForm").append('<input id="orgId" type="text" class="form-control mt-2 col-10" placeholder="Organization Identifier" />')
        $("#launchForm").append('<p id="orgValidate" class="field-valid ml-3" style="color: red;">Organization Identifier is required</p>')
        $("#launchForm").append('<select id="provider" class="form-control mt-2 col-10"><option value="DO">Digital Ocean</option><option value="AWS">AWS</option></select>')
        $("#launchForm").append('<input id="authToken" type="text" class="form-control mt-2 col-10" placeholder="Authentication Token" />')
        $("#launchForm").append('<p id="authValidate" class="field-valid ml-3" style="color: red;">Authentication Token is required</p>')
        $("#launchForm").append('<input id="accessKey" type="text" class="form-control mt-2 col-10" placeholder="Access Key" />')
        $("#launchForm").append('<p id="accessValidate" class="field-valid ml-3" style="color: red;">Access Key is required</p>')
        $("#launchForm").append('<input id="secretKey" type="text" class="form-control mt-2 col-10" placeholder="Secret Key" />')
        $("#launchForm").append('<p id="secretValidate" class="field-valid ml-3" style="color: red;">Secret Key is required</p>')
        $("#launchForm").append('<div id="launchInstructions" class="launch-popup"><i class="far fa-question-circle fa-2x col-1"></i><span class="launch-popuptext" id="instPopup"></span></div>')
        $("#authToken").css('display', 'inline')
        $("#secretKey").css('display', 'inline')
        $("#launchForm").append('<button id="launchButton" class="btn btn-primary mt-3 col-4">Launch</button>')
        $("#instPopup").append('<p class="card-text text-muted ml-2">For information on how to create an authentication token or access key, visit these links: </p>')
        $("#instPopup").append('<p><a class="ml-5 card-text text-muted" target="_blank" href="https://www.digitalocean.com/docs/api/create-personal-access-token/">Digital Ocean</a></p>')
        $("#instPopup").append('<p><a class="ml-5 card-text text-muted" target="_blank" href="https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html">AWS</a></p>')

        // Hide AWS field by default
        $("#accessKey").hide()
        $("#secretKey").hide()

        $("#launchButton").click(this.startLaunch.bind(this))    
        $("#launchInstructions").click(this.popInstructions.bind(this))  
        $("#provider").change(this.providerChange)
    }

}