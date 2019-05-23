module Macro
  module NestedForm
    def self.Association(param_key:, attribute:)
      step = ->(input, options) do
        params = options['params'][param_key]
        collection = {}
        index = 0
        params[:"#{attribute}_attributes"].each do |item|
          unless item[:_destroy].eql?('1')
            item[:position] = index
          end
          collection[index] = item unless item[:_destroy].eql?('1') && item[:id].blank?
          index += 1
        end if params.key?("#{attribute}_attributes")
  
        params[:"#{attribute}_attributes"] = collection
      end
      [ step, name: "nested.association" ]
    end

    def self.MarkForDestruction(param_key:, attribute:)
      step = ->(input, options) do
        params = options['params'][param_key]
        ids = params[:"#{attribute}_attributes"].values.map do |item|
          item['id'].to_i if item['_destroy'].eql?('1')
        end.compact
  
        options['model'].send(attribute).where(id: ids).destroy_all
        options['contract.default'].send(attribute).reject! {|item| ids.include?(item.id) }
        true
      end
      [ step, name: "nested.mark_for_destruction" ]
    end

    def self.Serialized(param_key:, attribute:)
      step = ->(input, options) do
        params = options['params'][param_key]
        collection = {}
        params[:"#{attribute}_attributes"].each_with_index do |item, index|
          unless item[:_destroy].eql?('1')
            item[:position] = index + 1
            collection[index] = item
          end
        end if params.key?("#{attribute}_attributes")
  
        params[:"#{attribute}_attributes"] = collection
        options['model'].send("#{attribute}=", nil)
      end
      [ step, name: "nested.serialized" ]
    end
  end
end
