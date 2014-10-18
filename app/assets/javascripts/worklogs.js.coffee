window.App ||= {}

Worklog =
  elems:
    worklog_summary: ->
      $('.worklog-summary')
  init: ->
    _this = this
    $('.reset-time').on 'click touchstart', (e) ->
      e.preventDefault()
      _this.setEndToNow()
      _this.setStartToNow()
    $('.end-time-now').on 'click touchstart', (e) ->
      e.preventDefault()
      _this.setEndToNow()
      _this.updateTotal()
    $('.start-time').on 'change', (e) ->
      _this.updateEndTimeStartTime()
    $('.new_worklog, .edit_worklog').on 'change', (e) ->
      _this.updateTotal()
    $('.new_worklog, .edit_worklog').on 'change', "#worklog_client_id", (e) ->
      _this.hide_or_show_total_calculations()

  setEndToNow: ->
    current = this.getCurrentTime()
    $('#worklog_to_date').val(current[2] + "/" + current[1] + "/" + current[0])
    $('#worklog_to_time').val(current[3] + ":" + current[4] + ":" + current[5])

  setStartToNow: ->
    current = this.getCurrentTime()
    $('#worklog_from_date').val(current[2] + "/" + current[1] + "/" + current[0])
    $('#worklog_from_time').val(current[3] + ":" + current[4] + ":" + current[5])

  getCurrentTime: ->
    d = new Date()
    convert = this.convertToZeroBased
    return [d.getFullYear(), convert(d.getMonth() + 1), convert(d.getDate()),
      convert(d.getHours()), convert(d.getMinutes()), convert(d.getSeconds())]

  convertToZeroBased: (number)->
    if number < 10
      return "0" + number
    else
      return number
  updateEndTimeStartTime: ->
    $('#worklog_to_date').val($('#worklog_from_date').val())

  updateTotal: ->
    start = this.getStartDate()
    end = this.getEndDate()
    new_total = this.calcTotal(start, end, this.getHourlyCentRate())
    return if !start || !end || !new_total
    window.App.Github.get_commit_messages(start, end)
    total_dom = $('.worklog-total')
    currency = total_dom.data().currency
    new_total = new_total + currency
    total_dom.html(new_total)

  getHourlyCentRate: ->
    custom_rate_per_hour = parseFloat($('#worklog_hourly_rate').val())
    selected_client = $('#worklog_client_id option:selected')
    if custom_rate_per_hour && custom_rate_per_hour > 0
      # Convert into cents
      return custom_rate_per_hour * 100
    else if selected_client.length > 0
      return selected_client.data().hourlyRateCents
    else
      return false

  hide_or_show_total_calculations: ->
    toggle_el = $("#worklog-total-calculations")
    if $('#worklog_client_id option:selected').data().userOwnsClient
      toggle_el.show()
    else
      toggle_el.hide()

  calcTotal: (start, end, per_hour) ->
    return if !start || !end
    time_span_seconds = (end - start) / 1000
    return "0.00" if time_span_seconds < 0
    per_second = per_hour / 3600
    return ((time_span_seconds * per_second) / 100).toFixed(2)

  getStartDate: ->
    date = $('#worklog_from_date').val().split("/")
    time = $('#worklog_from_time').val().split(":")
    date_obj =
      year: date[2]
      month: date[1]
      day: date[0]
      hour: time[0]
      minute: time[1]
      second: time[2]
    return this.dateFromDateAndTime(date_obj)

  getEndDate: ->
    date = $('#worklog_to_date').val().split("/")
    time = $('#worklog_to_time').val().split(":")
    date_obj =
      year: date[2]
      month: date[1]
      day: date[0]
      hour: time[0]
      minute: time[1]
      second: time[2]

    return this.dateFromDateAndTime(date_obj)

  dateFromDateAndTime: (date_obj) ->
    # date should be this format [18, 05, 2013]
    # time should be this format [22, 51, 19]
    try
      return moment("#{date_obj.year}-#{date_obj.month}-#{date_obj.day} #{date_obj.hour}:#{date_obj.minute}:#{date_obj.second}")
    catch err
      return false

  add_to_worklog: (text)->
    summary = this.elems.worklog_summary()
    old_val = summary.val()
    if old_val == ""
      new_val = " * #{text}"
    else
      new_val = "#{old_val}\n * #{text}"
    summary.val(new_val)

window.App.Worklog = Worklog
