# frozen_string_literal: true

# A module for editable pages
#   required fields:
#     - name
#     - last_user_id
module EditablePage
  extend ActiveSupport::Concern

  included do
    belongs_to :last_user, foreign_key: 'last_user_id', class_name: 'User', optional: true
    validates :name, uniqueness: { case_sensitive: false }, presence: true
    before_validation :modify_name
    before_create :set_markdown_to_be_blank_string_if_nil
  end

  class_methods do
    def pagify_name(name)
      name.downcase.tr(' ', '_')
    end
  end

  private

  def set_markdown_to_be_blank_string_if_nil
    self.markdown = "" if markdown.nil?
  end

  def modify_name
    return if persisted? || name.nil?
    self.name = self.class.pagify_name(name)
  end
end
