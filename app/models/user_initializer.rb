# frozen_string_literal: true

class UserInitializer
  def initialize(user_params)
    @user_params = user_params
  end

  def create!
    user = User.new(@user_params)
    user.projects = build_projects
    user.save!
    user
  end

  private

  def build_projects
    names = I18n.t('project_names')
    [
      Project.new(color: '#4ab8b8', name: names[0]),
      Project.new(color: '#a1c45a', name: names[1]),
      Project.new(color: '#f95959', name: names[2])
    ]
  end
end
