class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    return unless user.admin?
    alias_action :create, :read, :destroy, to: :crud
    can :crud, User
  end
end
