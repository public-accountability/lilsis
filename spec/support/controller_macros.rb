# frozen_string_literal: true

module ControllerMacros
  def login_admin
    let(:example_user) { RspecHelpers::ExampleMacros.create_admin_user }

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in example_user, scope: :user
    end
  end

  def login_user(abilities = [:edit])
    let(:example_user) { RspecHelpers::ExampleMacros.create_basic_user }

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      example_user.add_ability(*abilities)
      sign_in example_user, scope: :user
    end
  end

  def login_basic_user
    login_user
  end

  def login_restricted_user
    let(:example_user) { RspecHelpers::ExampleMacros.create_restricted_user }

    before do
      sign_in example_user, scope: :user
    end
  end

  def login_user_without_permissions
    let(:example_user) { RspecHelpers::ExampleMacros.create_basic_user }

    before do
      sign_in example_user, scope: :user
    end
  end
end
