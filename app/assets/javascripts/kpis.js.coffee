window.App ||= {}

window.App.Kpis =
  init: ->
    form = $('#new_kpi')
    form.on 'change', (e) ->
      form.submit()
