module WorklogsHelper
  def select_worklog_if_params(c)
    selected_attr = params[:client] && params[:client] == c.id.to_s ? 'selected="selected"' : " "
    "<option data-url='#{client_paid_path(c)}' data-id='#{c.id}'#{selected_attr}>#{c.name}</option>".html_safe
  end

  def client_paid_path(client)
    user_worklogs_path(merge_params(client: client.id))
  end

  def check_paid
    active_if_value_true(params[:paid], "true")
  end

  def check_unpaid
    active_if_value_true(params[:paid], "false")
  end

  def check_no_paid
    return "active" if !params[:paid]
  end

  def check_no_month
    return "active" if !params[:time]
  end

  def check_this_week
    active_if_value_true(params[:time], "this_week")
  end

  def check_today
    active_if_value_true(params[:time], "today")
  end

  def check_this_month
    active_if_value_true(params[:time], "this_month")
  end

  def check_last_month
    active_if_value_true(params[:time], "last_month")
  end

  def active_if_value_true(val_to_test, val)
    return "active" if val_to_test == val
  end

  def merge_params(new_param_hash)
    request.parameters.merge(new_param_hash)
  end

end
