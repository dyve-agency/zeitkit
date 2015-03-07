class TeamUsersController < ApplicationController
  def create
    form = TeamInviteForm.new params[:team_invite_form]
    form.inviter = current_user
    if form.valid?
      form.save
      redirect_to members_team_path(form.team), notice: "Successfully invited user."
    else
      build_url = -> do
        if form.team
          members_team_path(form.team)
        else
          teams_path
        end
      end
      redirect_to build_url.call, alert: form.errors.full_messages.join(", ")
    end
  end
end
