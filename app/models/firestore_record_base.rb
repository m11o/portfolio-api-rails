# frozen_string_literal: true

require 'google/cloud/firestore'

class FirestoreRecordBase
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :id, :string

  def create!
    raise ActiveModel::ValidationError, self unless valid?

    added_doc = collection.add(attributes.except(:id))
    self.id = added_doc.document_id
    self
  end

  def create
    create!
  rescue StandardError => e
    Rails.logger.error e.message
    false
  end

  def update!(update_attributes = {})
    assign_attributes(update_attributes) if update_attributes.any?

    raise ActiveModel::ValidationError, self unless valid?

    doc_ref = collection.doc(document_path)
    doc_ref.update(attributes.except(:id))
    self
  end

  def update(update_attributes = {})
    update!(update_attributes)
  rescue StandardError => e
    Rails.logger.error e.message
    false
  end

  def document_path
    "#{collection_name}/#{id}"
  end

  def firestore
    self.class.firestore
  end

  def collection
    self.class.collection
  end

  class << self
    def collection_name(name)
      @collection_name = name.to_s
    end

    def subcollection(subcollection_name)
      @subcollections ||= []
      @subcollections << subcollection_name.to_s
    end

    def firestore
      @firestore ||= Google::Cloud::Firestore.new(
        project_id: ENV.fetch('GOOGLE_CLOUD_PROJECT'),
        database_id: ENV.fetch('FIRESTORE_DATABASE_ID')
      )
    end

    def collection
      @collection ||= firestore.col @collection_name
    end

    def find(id)
      doc_ref = collection.doc("#{collection_name}/#{id}")
      doc = doc_ref.get
      return nil unless doc.exists?

      self.id = id
      assign_attributes(doc.data)
      self
    end

    def all
      collection.get.map do |doc|
        new(id: doc.document_id, **doc.data)
      end
    end
  end
end
