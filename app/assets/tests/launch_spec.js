describe("launch.js: ", function() {
    var xhr;
    var requests;

      beforeEach(function() {
        xhr = sinon.useFakeXMLHttpRequest();
        requests = [];
        xhr.onCreate = function (req) { requests.push(req); };
        fixture.set('<div id="launchDiv"></div><div id="jenkinsData"></div>');
        launchData.initialize();
        $("#jenkinsData").data({jenkins_url: 'http://134.209.170.222', jenkins_user: 't4d', jenkins_password: 't4d', job_name: 'Test Git', provider: 'DO'});
        $("#orgId").val("DIAL");
        $("#authToken").val("123");
      });

      afterEach(function() {
        xhr.restore();
      });


    it('should change launch page after startLaunch is called', function() {
        // The launch form should be gone
        launchData.startLaunch();
        
        expect($("#launchForm").length).not.to.be.ok;
        
    });

    it('should call the Digital Oceans API', function() {
        launchData.startLaunch();
        // The launch message & status should be visible 
        expect(requests.length).to.be(1);
        expect(requests[0].url).to.be("https://api.digitalocean.com/v2/droplets/?tag_name=t4dlaunched");
    });
});