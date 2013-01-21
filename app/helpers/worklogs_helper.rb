module WorklogsHelper
  def select_worklog_if_params(c)
    selected_attr = params[:client] && params[:client] == c.id.to_s ? 'selected="selected"' : " "
    "<option data-url='#{client_paid_path(c)}' data-id='#{c.id}'#{selected_attr}>#{c.name}</option>".html_safe
  end

  def client_paid_path(client)
    user_worklogs_path(current_user, paid: params[:paid], client: client.id)
  end

  def check_paid
    return if !params[:paid]
    return "active" if params[:paid] == "true"
  end

  def check_unpaid
    return if !params[:paid]
    return "active" if params[:paid] == "false"
  end

  def check_no_paid
    return "active" if !params[:paid]
  end
end
