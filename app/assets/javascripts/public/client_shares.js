/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
if (!window.App) { window.App = {}; }

window.App.ClientShares = {
  init() {
    const _this = this;
    _this.bind_events();
    const base_el = $('.client-shares-wrapper');
    return base_el.on('nested:fieldAdded', function(e) {
      const elem = $($(e.field).find('.usernames-input input')[0]);
      return _this.bind_events(elem);
    });
  },
  bind_events(elem = null){
    const _this = this;
    const elems = elem ? [elem] : ($('.client-shares-wrapper input'));
    return _.each(elems, function(elem) {
      elem = $(elem);
      if (!elem.data().bound) {
        _this.bind_single(elem);
        return elem.data("bound", true);
      }
    });
  },
  bind_single(el){
    return el.typeahead({
      ajax: {
        url: "/users/usernames.json",
        triggerLength: 2
      }});
  }
};
