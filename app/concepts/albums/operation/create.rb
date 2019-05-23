module Albums::Operation
  class Create < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(Album, :new)
      step Contract::Build( constant: Albums::Contract::Create )
    end

    step Nested( Present )
    step :set_order!
    step Macro::NestedForm::Association(param_key: :album, attribute: :tracks)
    step Contract::Validate( key: :album )
    step Contract::Persist( )

    def set_order!(opts, params:, **)
      opts['params']['album']['tracks_attributes'].each_with_index do |track, index|
        track['order'] = index
      end if opts['params']['album'].key?('tracks_attributes')
      true
    end
  end
end
