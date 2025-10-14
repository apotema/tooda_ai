class PaginationSerializer < ActiveModel::Serializer
  attributes :current_page, :next_page, :prev_page, :total_pages, :total_count, :per_page

  delegate :current_page, :next_page, :prev_page, :total_pages, :total_count, to: :object

  def per_page
    object.limit_value
  end
end
