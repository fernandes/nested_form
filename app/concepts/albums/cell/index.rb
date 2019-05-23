module Albums::Cell
  class Index < Trailblazer::Cell
    def ibox_title
      "Albums"
    end

    def model_attributes
      %w(artist title release_year)
    end

    def item_cell
      Albums::Cell::Item
    end

    def no_item_message
      "No Albums"
    end

    def new_element_path
      new_album_path
    end

    def new_element_label
      "New Album"
    end
  end
end
