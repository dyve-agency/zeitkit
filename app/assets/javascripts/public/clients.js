/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
$(() =>
  $('.client-filter').on('change', () => Worklogs.filterClient()),
);
var Worklogs = {
  filterClient() {
    const new_url = $('.client-filter option:selected').data().url;
    return window.location.href = window.location.origin + new_url;
  },
};
