/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
$(function() {
  if (!Loading.elem) { Loading.elem = $('.loading-animation'); }
  if (!Loading.message) { Loading.message = $('.loading-message'); }
  $('form').on('submit', e => Loading.show());
  $(document).ajaxComplete(function(e){
    Loading.hide();
    return delete window.App.ajax_loading_message;
  });
  return $(document).ajaxSend(e=> Loading.show(window.App.ajax_loading_message));
});

var Loading = {
  show(text){
    if (text == null) { text = false; }
    this.elem.addClass('active');
    if (text) { return this.message.addClass('active').html(text); }
  },
  hide() {
    this.elem.removeClass('active');
    return this.message.removeClass('active').html();
  }
};
