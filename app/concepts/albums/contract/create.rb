module Albums::Contract
  class Create < Reform::Form
    property :artist
    property :title
    property :release_year

    validates :artist, presence: true
    validates :title, presence: true
    validates :release_year, presence: true

    collection :tracks, populate_if_empty: Track do
      property :title
      property :length

      validates :title, presence: true
      validates :length, presence: true
    end
  end
end
