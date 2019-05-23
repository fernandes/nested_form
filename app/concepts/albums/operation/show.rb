module Albums::Operation
  class Show < Trailblazer::Operation
    step Model(Album, :find_by)
  end
end
