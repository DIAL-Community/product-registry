describe("application.js:", function() {
  var action = "index";
  var controller = "organizations";
  beforeEach(function() {
    fixture.set(
      '<body data-controller="' + controller + '" data-action="' + action + '">' +
      '</body>'
    );
  })

  it("should trigger 'controller:loaded' based on body tag.", function() {
    var eventSpy = sinon.spy();
    $(document).trigger(controller + ':loaded');

    expect(eventSpy.called).to.be.true;
    expect(eventSpy.calledOnce).to.be.true;
  });

  it("should trigger 'action:loaded' based on body tag.", function() {
    var eventSpy = sinon.spy();
    $(document).trigger(controller + '#' + action + ':loaded');

    expect(eventSpy.called).to.be.true;
    expect(eventSpy.calledOnce).to.be.true;
  });
});
