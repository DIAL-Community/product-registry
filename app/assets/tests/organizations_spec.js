describe("organizations.js:", function() {

  it("should have jquery loaded.", function() {
    expect(jQuery).to.not.be(undefined);
  });

  it('should setup feature object.', function() {
    expect(feature).to.not.be(undefined);
    expect(feature instanceof ol.Feature).to.be(true);
  });

  describe("sourceHandle function: ", function() {
    var xhr;
    var requests;

    var searchRequest;
    var searchResponse;

    beforeEach(function() {
      requests = [];
      xhr = sinon.useFakeXMLHttpRequest();
  
      xhr.onCreate = function(xhr) {
        requests.push(xhr);
      };

      searchResponse = sinon.spy();
      searchRequest = {
        term: "some search term"
      };
      
      sourceHandle(searchRequest, searchResponse);
    });

    it("should execute search for location on the db.", function() {
      var sectorData = [{
        id: 1,
        name: "some-name"
      }];

      expect(requests.length).to.be(1);

      var request = requests.shift();
      expect(request.url).to.have.string("/locations.json?office_only=true");
      expect(request.url).to.have.string("search", "some search term");

      request.respond(200, { "Content-Type": "application/json" }, JSON.stringify(sectorData));

      var responseParam = [{
        id: 1,
        label: "some-name",
        value: "some-name",
        magicKey: null
      }];
      expect(searchResponse.calledWith(responseParam)).to.be(true);
    });

    it("should fall to searching ESRI if there's no match in the database.", function() {
      var request;
      var dbSectorData = [];
      
      expect(requests.length).to.be(1);
      
      request = requests.shift();
      request.respond(200, { "Content-Type": "application/json" }, JSON.stringify(dbSectorData));
      
      var esriSectorData =  {
        suggestions: [{
          magicKey: "some-magic-key",
          text: "some-esri-name"
        }]
      };

      // fallback and call the esri api.
      expect(requests.length).to.be(1);

      request = requests.shift();
      expect(request.url).to.have.string("https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/suggest");
      expect(request.url).to.have.string("text", "some search term");
      expect(request.url).to.have.string("category", "City");

      request.respond(200, { "Content-Type": "application/json" }, JSON.stringify(esriSectorData));

      var responseParam = [{
        id: null,
        label: "some-esri-name",
        value: "some-esri-name",
        magicKey: "some-magic-key"
      }];
      expect(searchResponse.calledWith(responseParam)).to.be(true);
    });
  });

  describe("setupAutocomplete function: ", function() {
    beforeEach(function() {
      fixture.set(
        '<div id="base-selected-products"></div>' +
        '<div id="base-selected-sectors"></div>' +
        '<div id="base-selected-countries"></div>' +
      );
    });

    it("should hide all the search result divs.", function() {
      setupAutoComplete();
      expect($("#base-selected-products").is(":hidden")).to.be(true);
      expect($("#base-selected-sectors").is(":hidden")).to.be(true);
      expect($("#base-selected-countries").is(":hidden")).to.be(true);
    });
  });

  describe("setupMapView function: ", function() {
    it("should setup the map view needed to display office.", function() {
      setupMapView();
      expect(map).not.to.be(undefined);
      expect(tooltip).not.to.be(undefined);
    });
  });

  describe("addOffice function: ", function() {
    beforeEach(function() {
      fixture.set(
        '<div class="row">' +
          '<div id="base-selected-offices" class="col-6 col-lg-4 mb-2">' +
            '<div class="card h-100">' +
              '<div class="px-1 clearfix badge badge-secondary">' +
                '<p class="mb-0 float-left"></p>' +
                '<a class="float-right" onclick="remove(this);" style="cursor: pointer;">' +
                  '<i class="fas fa-trash-alt"></i>' +
                '</a>' +
                '<input type="hidden"/>' +
                '<input type="hidden"/>' +
              '</div>' +
            '</div>' +
          '</div>' +
        '</div>');
      setupFormView();
    });

    it('should have blank template for search office', function() {
      expect($("#base-selected-offices").parent().children().size()).to.be(1);
    });

    it('calling setupFormView should hide the first element', function() {
      expect($("#base-selected-offices").parent().children().size()).to.be(1);
      expect($("#base-selected-offices").parent().children(':first').is(":hidden")).to.be(true);
    });

    it('calling addOffice will add new element to the row', function() {
      addOffice("some-label", "some-id", "some-magicKey");
      expect($("#base-selected-offices").parent().children().size()).to.be(2);
      expect($("#base-selected-offices").parent().children(":first").is(":hidden")).to.be(true);
      expect($("#base-selected-offices").parent().children(":last").is(":hidden")).to.be(false);
    });
  });

});
