describe('filters.js:', function() {
  var xhr;
  var requests;

  beforeEach(function() {
    xhr = sinon.useFakeXMLHttpRequest();
    requests = [];
    xhr.onCreate = function (req) { requests.push(req); };

    fixture.set(
        '<div class="row">' +
          '<div class="col-md-4 offset-md-8 text-muted clear-all"><a href="#">Clear</a></div>' +
          '<div class="col-12">' +
            '<div class="form-group">'+
              '<label for="sectors">Sectors</label>' +
              '<input name="sectors[]" type="hidden" value=""></input>' +
              '<select multiple="multiple" class="custom-select filter-element" name="sectors[]" id="sectors">' +
              '<option value="1">Advocacy</option>' +
              '<option value="2">Agriculture</option>' +
              '<option value="3">Anti-corruption</option>' +
              '</select>' +
            '</div>' +
          '</div>' +
        '</div>' +
        '<div class="row">' +
          '<div id="test" class="col-12 badges">a</div>' +
        '</div>'
    );

    prepareFilters();
  });

  afterEach(function() {
    xhr.restore();
  });

  it('should get filters on load.', function() {
    expect(requests.length).to.be(1);
    expect(requests[0].url).to.be("/get_filters");
  });

  it('should call add_filter when control value changes.', function() {

    $('.filter-element')
      .val(2)
      .trigger('change');

    expect(requests.length).to.be(2);
    expect(requests[1].url).to.be("/add_filter");
  });

  it('should create remove filter div when filter is added.', function() {
    expect($(".remove-filter", fixture.el).attr('id') === undefined);

    var newFilter = [];
    newFilter.push({value: "test", label: "test"})
    addToList('sectors', newFilter);

    expect($(".remove-filter").attr('id')).to.be("remove-sectors-test");

  });

  it('should create reload filters when clear button is clicked.', function() {

    var newFilter = [];
    newFilter.push({value: "test", label: "test"})
    addToList('sectors', newFilter);

    $('.filter-element')
      .trigger('click');
    
    expect(requests.length).to.be(1);
    expect(requests[0].url).to.be("/get_filters");

    expect($(".remove-filter", fixture.el).attr('id') === undefined);

  });
});