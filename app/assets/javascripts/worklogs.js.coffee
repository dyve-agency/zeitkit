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
      SaveTime.updateRemote()
    $('.start-time').on 'change', (e) ->
      _this.updateEndTimeStartTime()
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
    $.ajax $('.temp_worklog_save_path').attr('href') + ".json",
      type: 'PUT'
      dataType: 'json'
      data: _this.elems.form().serialize()
