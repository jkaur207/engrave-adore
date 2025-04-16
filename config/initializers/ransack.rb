# config/initializers/ransack.rb
Rails.application.config.to_prepare do
  ActiveStorage::Attachment.class_eval do
    def self.ransackable_attributes(auth_object = nil)
      ["id", "name", "record_type", "record_id", "blob_id", "created_at"]
    end
  end
end
