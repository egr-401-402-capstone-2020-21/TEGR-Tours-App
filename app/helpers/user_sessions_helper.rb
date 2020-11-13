module UserSessionsHelper
  def log_out
    sessiosn.delete(:user_id)
    @current_user = nil
  end
end
