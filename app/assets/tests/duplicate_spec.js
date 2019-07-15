describe('duplicate.js:', function() {
  var xhr;
  var requests;

  beforeEach(function() {
    requests = [];
    xhr = sinon.useFakeXMLHttpRequest();

    xhr.onCreate = function(xhr) {
      requests.push(xhr);
    }

    fixture.set(
      '<input id="contact_name" type="text">' +
      '<input id="original_name" type="hidden" value="some-org-name" />' +
      '<div id="duplicate-warning" class="alert alert-warning">' +
        'One or more organization(s) with similar name already exists.' +
      '</div>'
    );
    duplicateCheck("contact_name", "/contact_duplicates.json");
  });

  afterEach(function() {
    xhr.restore();
  });

  it('should hide duplicate warning when ajax return no dupes.', function() {
    $("#contact_name").val('new-org-name');
    $("#contact_name").trigger("input");

    expect(requests.length).to.be(1);

    var request = requests.shift();
    expect(request.url).to.have.string("/contact_duplicates.json");
    expect(request.url).to.have.string("current", "new-org-name");
    expect(request.url).to.have.string("original", "some-org-name");

    request.respond(200, { "Content-Type": "application/json" }, '[]');
    expect($("#duplicate-warning").is(":hidden")).to.be(true);
  });

  it('should display duplicate warning when ajax return dupes.', function() {
    $("#contact_name").val('other-org-name');
    $("#contact_name").trigger("input");

    expect(requests.length).to.be(1);
    
    var request = requests.shift();
    request.respond(200, { "Content-Type": "application/json" }, '["dupe1", "dupe2"]');
    expect($("#duplicate-warning").not(":hidden")).to.be.true;

    $("#contact_name").val('some-org-name');
    $("#contact_name").trigger("input");

    expect(requests.length).to.be(1);

    request = requests.shift();
    request.respond(200, { "Content-Type": "application/json" }, '[]');
    expect($("#duplicate-warning").is(":hidden")).to.be(true);
  });
});
