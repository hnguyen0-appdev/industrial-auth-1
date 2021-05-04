class UsersController < ApplicationController
  before_action :set_user, only: %i[ show liked feed followers following discover ]
  before_action :ensure_current_user_is_accepted_follower, only: [:feed, :discover]

  private

    def set_user
      if params[:username]
        @user = User.find_by!(username: params.fetch(:username))
      else
        @user = current_user
      end
    end

    def ensure_current_user_is_accepted_follower
      if current_user.accepted_sent_follow_requests.find_by(recipient_id: @user.id) == nil &&
        current_user != @user
        redirect_back fallback_location: root_url, alert: "You're not authorized for that."
        
      end
    end
end