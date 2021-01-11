describe("products.js:", function() {
  beforeEach(function() {
    fixture.set(
      '<div id="digisquare-element">' +
      '  <div class="dropdown">' +
      '    <button type="button" class=".btn">' +
      '      Some text.' +
      '    </button>' +
      '    <input type="hidden" value="2">' +
      '    <div class="dropdown-menu" aria-labelledby="digisquare-selector">' +
      '      <div class="dropdown-item" data-sub-indicator="1">' +
      '        <div>Low</div>' +
      '        <div>Some text!</div>' +
      '      </div>' +
      '      <div class="dropdown-item" data-sub-indicator="2">' +
      '        <div>Medium</div>' +
      '        <div>Other text!</div>' +
      '      </div>' +
      '      <div class="dropdown-item" data-sub-indicator="3">' +
      '        <div>High</div>' +
      '        <div>Another text!</div>' +
      '      </div>' +
      '    </div>' +
      '  </div>' +
      '</div>' +
      '<input type="checkbox" id="product-assessment" />' +
      '<div id="product-assessment-section"></div>'
    );
    productsReady();
  });

  it('should hide the product assessment section by default', function() {
    expect($("#product-assessment-section").is(":hidden")).to.be(true);
  });

  it('should display the product assessment section', function() {
    $('#product-assessment').prop('checked', true);
    $('#product-assessment').trigger('change');
    expect($("#product-assessment-section").is(":hidden")).to.be(false);
    $('#product-assessment').prop('checked', false);
    $('#product-assessment').trigger('change');
    expect($("#product-assessment-section").is(":hidden")).to.be(true);
  });

  it('should assign the text to the button and input on selection', function() {
    $("[data-sub-indicator='1']").click();
    expect($(".dropdown").find("button").html()).to.have.string("Some text!");
    expect($(".dropdown").find("input").val()).to.be('1');
    $("[data-sub-indicator='2']").click();
    expect($(".dropdown").find("button").html()).to.have.string("Other text!");
    expect($(".dropdown").find("input").val()).to.be('2');
    $("[data-sub-indicator='3']").click();
    expect($(".dropdown").find("button").html()).to.have.string("Another text!");
    expect($(".dropdown").find("input").val()).to.be('3');
  });
});