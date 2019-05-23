# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

allaby = Album.create!(artist: "Allaby", title: "Reform", release_year: 2011)
allaby_1 = Track.create!(title: "Glade (Zen Mechanics Remix)",       length: "9:32",  order: 1, album: allaby)
allaby_2 = Track.create!(title: "Spiritually Connected",             length: "8:38",  order: 2, album: allaby)
allaby_3 = Track.create!(title: "Imaginarium (Burn in Noise Remix)", length: "9:02",  order: 3, album: allaby)
allaby_4 = Track.create!(title: "Glade (06 Remix)",                  length: "10:08", order: 4, album: allaby)

animalis = Album.create!(artist: "Animalis", title: "Infinit Movement", release_year: 2011)
animalis_1 = Track.create!(title: "Infinit Movement",      length: "7:46",  order: 1,  album: animalis)
animalis_2 = Track.create!(title: "Mumbo Jumbo Business",  length: "6:51",  order: 2,  album: animalis)
animalis_3 = Track.create!(title: "Electronic Symphaties", length: "7:19",  order: 3,  album: animalis)
