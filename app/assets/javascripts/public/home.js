/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
if (!window.App) { window.App = {}; }

const SignupTracker = {
  init(custom_class){
    if (custom_class == null) { custom_class = $('.signup-link'); }
    return custom_class.on('click', e => _gaq.push(['_trackEvent', 'Signup', 'Click', 'Submit']));
  }
};

window.App.SignupTracker = SignupTracker;
