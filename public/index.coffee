$ ->
  {
    ajaxMaker: ajaxMaker  
    s: s
    "on": bind
    trigger
  } = _
  post = ajaxMaker "POST"

  #adventPresenter = 
  app =  do ->
    view = null
    init = () ->
      view = adventView.init()
      bind view, "command", command
      start()
      ret
    user = {}
    handleNewPlace = (err, _user) ->
      if err
        view.setDesc err.message 
      else
        user = _user
        view.setDesc user.place.desc
    start = () ->
      post "/whereami", handleNewPlace
    command = (cmd) ->
      post "/commands/#{cmd}", handleNewPlace
    ret = 
      user: user
      handleNewPlace: handleNewPlace
      start: start
      init: init
    return ret
    
  adventView = do () ->
    setDesc = (desc) ->
      $("#desc").text desc
    init = () ->
      $('#command-form').submit (e) ->
        e.preventDefault()
        cmd = $("#command").val()
        trigger adventView, "command", cmd
        $("#command").val ""
      ret
    ret =
      setDesc: setDesc
      init: init




  app.init() 

    

    
