module Albums::Cell
  class Show < Trailblazer::Cell
    property :id
    property :artist
    property :title
    property :release_year

    private
      def ibox_title
        "Album"
      end

      def model_attributes
        [
          { label: "Artist", method: :artist },
          { label: "Title", method: :title },
          { label: "Release Year", method: :release_year },
        ]
      end

      def edit_item_path
        edit_album_path(id)
      end

      def edit_item_label
        "Edit"
      end
  end
end
