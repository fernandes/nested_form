module Albums::Cell
  class Item < Trailblazer::Cell
    property :id
    property :artist
    property :title
    property :release_year

    private
      def model_attributes
        %w(artist title release_year)
      end

      def edit_item_path
        edit_album_path(id)
      end

      def delete_item_path
        album_path(id: id)
      end

      def delete_confirm_message
        'Are you sure?'
      end
  end
end
