describe("map-sector-control.js: ", function() {
  var xhr;
  var requests;

  beforeEach(function() {
    requests = [];
    xhr = sinon.useFakeXMLHttpRequest();

    xhr.onCreate = function(xhr) {
      requests.push(xhr);
    };

    fixture.set(
      '<select id="sector" class="custom-select">' + 
        '<option value=-1>All sectors</option>' +
      '</select>'
    );
  });

  it("should prepare the options for the sector.", function() {
    sectorSelectionReady();

    expect(requests.length).to.be(1);
    expect($("#sector").children().size()).to.be(1);

    request = requests.shift();
    expect(request.url).to.have.string("/sectors.json?display_only=true&without_paging=true");

    var sectors = [{
      id: 1,
      name: "some sector name"
    }];

    request.respond(200, { "Content-Type": "application/json" }, JSON.stringify(sectors));
    expect($("#sector").children().size()).to.be(2);

    expect(mapObject).not.to.be(undefined);
    mapObject.popup = {
      setPosition: sinon.spy()
    }

    $("#sector").val(1);
    $("#sector").change();

    expect(mapObject.popup.setPosition.called).to.be(true);
  });
});