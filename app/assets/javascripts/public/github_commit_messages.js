/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
if (!window.App) { window.App = {}; }

const Github = {
  init() {
    const _this = this;
    return $(function() {
      _this.el = $('#github_commit_messages');
      _this.get_commit_messages(window.App.Worklog.getStartDate(), window.App.Worklog.getEndDate());
      return _this.el.on('click', 'a', function(e){
        e.preventDefault();
        const elem = $(e.currentTarget);
        return window.App.Worklog.add_to_worklog(elem.data().text);
      });
    });
  },
  get_commit_messages(start_date, end_date){
    const _this = this;
    const url = this.github_messages_link;
    if (!url) { return; }
    // Make sure we don't spam the Github API
    if (this.loading) { return; }
    start_date = this.date_or_string_format(start_date);
    end_date = this.date_or_string_format(end_date);
    const data = {
      start_date,
      end_date
    };

    return $.ajax(url, {
      data,
      beforeSend() {
        _this.loading = true;
        return _this.el.html("<i class='icon-spinner icon-spin'></i>");
      },
      success(response){
        _this.render_template(response);
        return _this.loading = false;
      }
    }
    );
  },

  render_template(data){
    let result = "";
    const template = _.template("<li><%= message %> <a href='#' data-text='<%= message %>'>(Add)</a></li>");
    _.each(data, elem=> result += template({message: elem}));
    return this.el.html(result);
  },

  date_or_string_format(date_or_string) {
    if (typeof(date_or_string) === "string") { return date_or_string; }
    const date = moment(date_or_string);
    return date.format("YYYY-MM-DD");
  }
};

window.App.Github = Github;

