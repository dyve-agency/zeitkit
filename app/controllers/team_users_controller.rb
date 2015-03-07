class TeamUsersController < ApplicationController
  before_filter :load_team_user, only: %i[accept reject]
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

  def accept
    @team_user.state = "confirmed"
    @team_user.save!
    redirect_to teams_path, notice: "Invite accepted"
  end

  def reject
    @team_user.destroy
    redirect_to teams_path, notice: "Invite rejected"
  end

  def destroy
    @team_user = TeamUser.where(team_id: current_user.team_ids, id: params[:id]).first
    if @team_user.team.creator == @team_user.user
      redirect_to members_team_path(@team_user.team), alert: "Can not remove the creator from the team."
    elsif @team_user.user == current_user
      @team_user.destroy
      redirect_to teams_path, notice: "Successfully removed yourself from the team."
    else
      @team_user.destroy
      redirect_to members_team_path(@team_user.team), notice: "Removed user."
    end
  end

private

  def load_team_user
    @team_user = current_user.team_users.find(params[:id])
  end
end
