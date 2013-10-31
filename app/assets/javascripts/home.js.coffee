window.App ||= {}

SignupTracker =
  init: (custom_class = $('.signup-link'))->
    custom_class.on 'click', (e) ->
      _gaq.push(['_trackEvent', 'Signup', 'Click', 'Submit'])

window.App.SignupTracker = SignupTracker
