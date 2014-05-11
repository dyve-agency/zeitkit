window.App ||= {}

window.App.Kpis =
  init: ->
    form = $('#new_kpi')
    form.on 'change', (e) ->
      form.submit()

    data_el = $('#kpi-data')

    form.on("ajax:beforeSend", (e, data, status, xhr) ->
      data_el.html("<i class='icon-spinner icon-spin'></i>")
    )

    form.on("ajax:success", (e, data, status, xhr) ->
      data_el.html(data)
    )

    form.on("ajax:error", (e, xhr, status, error) ->
      data_el.html("<div class='alert alert-error'>There has been an error while generating the data</div>")
    )

