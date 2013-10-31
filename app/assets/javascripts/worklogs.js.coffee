window.App ||= {}

$ ->
  Worklog.init()
  SaveTime.init()

Worklog =
  init: ->
    _this = this
    $('.reset-time').on 'click touchstart', (e) ->
      e.preventDefault()
      _this.setEndToNow()
      _this.setStartToNow()
      SaveTime.updateRemote()
    $('.end-time-now').on 'click touchstart', (e) ->
      e.preventDefault()
      _this.setEndToNow()
      _this.updateTotal()
      SaveTime.updateRemote()
    $('.start-time').on 'change', (e) ->
      _this.updateEndTimeStartTime()
    $('.new_worklog, .edit_worklog').on 'change', (e) ->
      _this.updateTotal()

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

SaveTime =
  elems: {
    form: ->
      $('.new_worklog')
  }
  init: ->
    _this = this
    this.elems.form().on 'change', (e) ->
      _this.updateRemote()
    $('.dismiss-save-time').on 'click touchstart', (e) ->
      _this.dismissSaveTime($(e.currentTarget))
      return false
  updateRemote: ->
    _this = this
    window.App.ajax_loading_message = "saving..."
    $.ajax $('.temp_worklog_save_path').attr('href') + ".json",
      type: 'PUT'
      dataType: 'json'
      data: _this.elems.form().serialize()

window.App.Worklog = Worklog
window.App.SaveTime = SaveTime
