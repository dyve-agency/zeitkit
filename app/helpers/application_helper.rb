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

end
