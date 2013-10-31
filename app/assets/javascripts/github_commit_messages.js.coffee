window.App ||= {}

$ ->
  Github.el = $('#github_commit_messages')
  Github.get_commit_messages("2013-10-24", "2013-10-27")


Github =
  get_commit_messages: (start_date, end_date)->
    _this = this
    url = window.App.github_messages_link
    return unless url
    # Make sure we don't spam the Github API
    return if this.loading
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
