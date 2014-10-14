window.App ||= {}

Github =
  init: ->
    _this = this
    $ ->
      _this.el = $('#github_commit_messages')
      _this.get_commit_messages(window.App.Worklog.getStartDate(), window.App.Worklog.getEndDate())
      _this.el.on 'click', 'a', (e)->
        e.preventDefault()
        elem = $(e.currentTarget)
        window.App.Worklog.add_to_worklog(elem.data().text)
  get_commit_messages: (start_date, end_date)->
    _this = this
    url = this.github_messages_link
    return unless url
    # Make sure we don't spam the Github API
    return if this.loading
    start_date = this.date_or_string_format(start_date)
    end_date = this.date_or_string_format(end_date)
    data =
      start_date: start_date
      end_date: end_date

    $.ajax url,
      data: data
      beforeSend: ->
        _this.loading = true
        _this.el.html("<i class='icon-spinner icon-spin'></i>")
      success: (response)->
        _this.render_template(response)
        _this.loading = false

  render_template: (data)->
    result = ""
    template = _.template("<li><%= message %> <a href='#' data-text='<%= message %>'>(Add)</a></li>")
    _.each(data, (elem)->
      result += template(message: elem)
    )
    this.el.html(result)

  date_or_string_format: (date_or_string) ->
    return date_or_string if typeof(date_or_string) == "string"
    date = moment(date_or_string)
    return date.format("YYYY-MM-DD")

window.App.Github = Github

