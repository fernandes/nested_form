module Albums::Operation
  class Index < Trailblazer::Operation
    step :model!

    def model!(options, params:, **)
      options["model"] = Album.all.includes(:tracks).order(:artist, :title)
    end
  end
end
