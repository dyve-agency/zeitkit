/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
$(() => Tutorial.init());

var Tutorial = {
  elems: {
    container() {
      return $('.tutorial');
    },
    tips() {
      return $('.tip-explanations .tips');
    }
  },
  init() {
    const _that = this;
    this.initHider();
    $('.levels').on('mouseenter', 'a', e => _that.select($(e.currentTarget)));
    return $('.show-tutorial').on('click touchstart', function(e) {
      e.preventDefault();
      return _that.getTutorial($(e.currentTarget));
    });
  },
  initHider() {
    const _that = this;
    return $('.tutorial-close').on('touchstart click', function(e) {
      e.preventDefault();
      return _that.hideTutorial($(e.currentTarget));
    });
  },
  select(elem) {
    this.removeActive(this.elems.container().find('.shown'));
    const counterpart = this.elems.tips()[elem.parent().index()];
    this.addActive([elem, counterpart]);
    return this.animateLightBulb();
  },
  addActive(elems){
    return _.each(elems, el => $(el).addClass("shown"));
  },
  removeActive(elems) {
    return _.each(elems, el => $(el).removeClass("shown"));
  },
  animateLightBulb() {
    const elem = $('.icon-lightbulb');
    elem.removeClass("animate-bulb");
    return setTimeout((() => elem.addClass("animate-bulb")), 200);
  },
  hideTutorial(elem) {
    const url = elem.attr('href');
    this.elems.container().parent().remove();
    return $.ajax(url, {
      type: 'POST',
      dataType: 'json',
      error() {
        return console.log('error hiding demo warning');
      }
    }
    );
  },
  getTutorial(clicked_elem){
    const _that = this;
    // Tutorial already there, do nothing.
    if (this.elems.container().length > 0) {
      alert('Tutorial already shown');
      return;
    }
    return $.ajax(clicked_elem.attr('href'), {
      type: 'GET',
      dataType: 'html',
      success(response) {
        return window.location.reload();
      },
      error() {
        return console.log('there was an error');
      }
    }
    );
  }
};
