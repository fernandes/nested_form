module Albums::Operation
  class Update < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(Album, :find_by)
      step Contract::Build( constant: Albums::Contract::Update )
    end

    step Nested( Present )
    step :set_order!
    step Macro::NestedForm::Association(param_key: :album, attribute: :tracks)
    step Contract::Validate( key: :album )

    step Rescue( ActiveRecord::Rollback, handler: :rollback! ) {
      step Macro::NestedForm::MarkForDestruction(param_key: :album, attribute: :tracks)
      step Contract::Persist( )
    }

    def set_order!(opts, params:, **)
      def set_order!(opts, params:, **)
        # Use this index because as we are skipping destroyed objects
        # we can't consider on the ordering
        index = 0
        opts['params']['album']['tracks_attributes'].each do |track|
          next if track['_destroy'] == '1'
          track['order'] = index
          index += 1
        end if opts['params']['album'].key?('tracks_attributes')
        true
      end
    end

    def rollback!(exception, options)
      false
    end
  end
end
