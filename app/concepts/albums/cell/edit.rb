module Albums::Cell
  class Edit < Trailblazer::Cell
    def ibox_title
      "Album"
    end

    def form_submit_label
      "Save"
    end

    def form_path
      album_path(model.id)
    end
  end
end
