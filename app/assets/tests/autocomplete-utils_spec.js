describe("autocomplete-utils.js: ", function() {

  describe("remove function: ", function() {
    beforeEach(function() {
      fixture.set(
        '<div class="row">' +
          '<div id="base-selected-offices" class="col-6 col-lg-4 mb-2">' +
            '<div class="card h-100">' +
              '<div class="p-2 clearfix">' +
                '<p class="mb-0 float-left"></p>' +
                '<a class="float-right" onclick="remove(this);" style="cursor: pointer;">' +
                  '<i class="fas fa-trash-alt" style="color: #6c757d;"></i>' +
                '</a>' +
                '<input type="hidden"/>' +
              '</div>' +
            '</div>' +
          '</div>' +
        '</div>')
    });
  })

  describe("addElement function: ", function() {
    beforeEach(function() {
      fixture.set(
        '<div class="row">' +
          '<div id="base-selected-organizations" class="col-6 col-lg-4 mb-2">' +
            '<div class="card h-100">' +
              '<div class="p-2 clearfix">' +
                '<p class="mb-0 float-left"></p>' +
                '<a class="float-right" onclick="remove(this);" style="cursor: pointer;">' +
                  '<i class="fas fa-trash-alt" style="color: #6c757d;"></i>' +
                '</a>' +
                '<input type="hidden"/>' +
              '</div>' +
            '</div>' +
          '</div>' +
        '</div>')
    });

    it('should have blank template for search element', function() {
      expect($("#base-selected-organizations").parent().children().size()).to.be(1);
    });

    it('calling ready handler should hide the first element', function() {
      organizationAutoCompleteReady();

      var selectedElements = $("#base-selected-organizations").parent().children(); 
      expect(selectedElements.size()).to.be(1);
      expect(selectedElements.find(':first').is(":hidden")).to.be.true;
    });

    it('calling addElement will add new element to the row', function() {
      addElement("base-selected-organizations", "selected_organizations", "some-id", "some-magicKey");
      var selectedElements = $("#base-selected-organizations").parent().children(); 
      expect(selectedElements.size()).to.be(2);
      expect(selectedElements.find(":first").is(":hidden")).to.be.true;
      expect(selectedElements.find(":last").not(":hidden")).to.be.true;
    });
  });
});