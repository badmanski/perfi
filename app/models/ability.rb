class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user
    if user.admin
      can :manage, :all
    else
      can :manage, EntryType, user_id: user.id
      can :manage, Entry, entry_type: { user_id: user.id }
      can :show, User, id: user.id
    end
  end
end
