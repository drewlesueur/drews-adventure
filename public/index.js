$(function() {
  var adventView, ajaxMaker, app, bind, post, s, trigger;
  ajaxMaker = _.ajaxMaker, s = _.s, bind = _["on"], trigger = _.trigger;
  post = ajaxMaker("POST");
  app = (function() {
    var command, handleNewPlace, init, ret, start, user, view;
    view = null;
    init = function() {
      view = adventView.init();
      bind(view, "command", command);
      start();
      return ret;
    };
    user = {};
    handleNewPlace = function(err, _user) {
      if (err) {
        return view.setDesc(err.message);
      } else {
        user = _user;
        return view.setDesc(user.place.desc);
      }
    };
    start = function() {
      return post("/whereami", handleNewPlace);
    };
    command = function(cmd) {
      return post("/commands/" + cmd, handleNewPlace);
    };
    ret = {
      user: user,
      handleNewPlace: handleNewPlace,
      start: start,
      init: init
    };
    return ret;
  })();
  adventView = (function() {
    var init, ret, setDesc;
    setDesc = function(desc) {
      return $("#desc").text(desc);
    };
    init = function() {
      $('#command-form').submit(function(e) {
        var cmd;
        e.preventDefault();
        cmd = $("#command").val();
        trigger(adventView, "command", cmd);
        return $("#command").val("");
      });
      return ret;
    };
    return ret = {
      setDesc: setDesc,
      init: init
    };
  })();
  return app.init();
});