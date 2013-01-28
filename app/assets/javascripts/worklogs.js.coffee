$ ->
  Worklog.setTimeInit()
  Worklog.autoEndTimeInit()
  SaveTime.init()

Worklog =
  setTimeInit: ->
    _this = this
    $('.end-time-now').on 'click touchstart', (e) ->
      e.preventDefault()
      _this.setCurrentTime()
  autoEndTimeInit: ->
    _this = this
    $('.worklog_start_time').on 'change', 'select', (e) ->
      _this.updateEndTimeStartTime($(e.currentTarget))
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
    start_all: ->
      $('.worklog_start_time select')
    end_all: ->
      $('.worklog_end_time select')
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
  updateEndTimeStartTime: (elem)->
    return if !elem
    end_time = this.relatedEndTime(elem)
    end_time.val(elem.val())
  relatedEndTime: (elem)->
    return $(this.elems.end_all()[elem.index()])
SaveTime =
  init: ->
    _this = this
    $('.dismiss-save-time').on 'click touchstart', (e) ->
      _this.dismissSaveTime($(e.currentTarget))
      return false
  dismissSaveTime: (elem)->
      url = elem.attr('href')
      $.ajax url,
        type: 'DELETE'
        dataType: 'json'
        success: ->
          $('.alert').remove()
        error: ->
          alert "There has been an error"
