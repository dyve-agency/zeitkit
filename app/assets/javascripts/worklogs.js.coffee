$ ->
  Worklog.setTimeInit()

Worklog =
  setTimeInit: ->
    _this = this
    $('.set-time').on 'click touchstart', (e) ->
      e.preventDefault()
      _this.setCurrentTime()
  setCurrentTime: ->
    current = this.getCurrentTime()
    views = this.getViews()
    _.each(views, (elem, index)->
      elem.val(current[index])
    )
  getCurrentTime: ->
    d = new Date()
    return [d.getFullYear(), this.getMonth()[d.getMonth()], d.getDate(),
      d.getHours(), d.getMinutes()]
  getMonth: ->
    ["January","February","March","April","May","June",
      "July","August","September","October","November","December"]
  getViews: ->
    return [this.elems.year(), this.elems.month(), this.elems.day(),
      this.elems.hour(), this.elems.minute()]
  elems: {
    year: ->
      $('#worklog_end_time_1i')
    month: ->
      $('#worklog_end_time_2i')
    day: ->
      $('#worklog_end_time_3i')
    hour: ->
      $('#worklog_end_time_4i')
    minute: ->
      $('#worklog_end_time_5i')
  }
