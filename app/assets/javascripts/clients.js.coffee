$ ->
  $('.client-filter').on 'change', ->
    Worklogs.filterClient()
Worklogs = {
  filterClient: ->
    new_url = $('.client-filter option:selected').data().url
    window.location.href = window.location.origin + new_url
}
