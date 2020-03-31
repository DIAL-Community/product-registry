describe("application.js:", function() {
  var action = "some-action";
  var controller = "some-controller";

  var actionSpy = sinon.spy();
  var controllerSpy = sinon.spy();
  beforeEach(function() {
    fixture.set(
      '<div id="main-body" data-controller="' + controller + '" data-action="' + action + '"></div>'
    );
    // prep the handler
    $(document).on(controller + ':loaded', controllerSpy);
    $(document).on(controller + '#' + action + ':loaded', actionSpy);
  });

  it("should trigger based on body tag.", function() {
    setTimeout(function() {
      expect(actionSpy.called).to.be(true);
      expect(actionSpy.calledOnce).to.be(true);
      expect(controllerSpy.called).to.be(true);
      expect(controllerSpy.calledOnce).to.be(true);
    }, 1000);
  });
});
