module ApplicationHelper
  # Public: Pick the correct arguments for form_for when shallow routes
  # are used.
  #
  # parent - The Resource that has_* child
  # child - The Resource that belongs_to parent.
  def shallow_args(parent, child)
    child.try(:new_record?) ? [parent, child] : child
  end

  def notices?
    flash[:notice] || flash[:alert] || flash[:error]
  end

  def check_if_css_class
    classes = ""
    classes += @css_class if @css_class
    if cookies[:mac_app]
      classes += " " if !classes.empty?
      classes += "mac-app"
    end
    classes
  end

  def mac_app?
    cookies[:mac_app]
  end

  def val_or_nil_string(obj)
    obj.nil? ? "-" : obj
  end

  def success_or_warning(value_check)
    value_check ? "success" : "warning"
  end

  def css_class_if_cond(cond, css_class = "completed")
    return " #{css_class}" if cond
    ""
  end

end
