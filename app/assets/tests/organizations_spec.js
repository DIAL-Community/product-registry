describe("organizations.js:", function() {

  it("should have jquery loaded.", function() {
    expect(jQuery).to.not.be(undefined);
  });

  it('should setup feature object.', function() {
    expect(feature).to.not.be(undefined);
    expect(feature instanceof ol.Feature).to.be.true;
  });

  describe("addOffice function: ", function() {
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
                '<input type="hidden"/>' +
              '</div>' +
            '</div>' +
          '</div>' +
        '</div>')
    });

    it('should have blank template for search office', function() {
      expect($("#base-selected-offices").size()).to.be(1);
    });

    it('calling setupFormView should hide the first selected office element', function() {
      setupFormView();
      expect($("#base-selected-offices").size()).to.be(1);
      expect($("#base-selected-offices").first().is(":hidden")).to.be.true;
    })

    it('calling addOffice will add new office element to the row', function() {
      addOffice("some-label", "some-id", "some-magicKey");
      expect($("#base-selected-offices").parent().children().size()).to.be(2);
      expect($("#base-selected-offices").parent().children(":first").is(":hidden")).to.be.true;
      expect($("#base-selected-offices").parent().children(":last").not(":hidden")).to.be.true;
    })
  })

});