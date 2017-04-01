# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
tag1 = Tag.create(name: "tech", color: "#ffffff")
tag2 = Tag.create(name: "general", color: "#ffffff")

source1 = Source.create(name: "Korben", url: "http://korben.info/feed", last_update: Time.at(0))
source2 = Source.create(name: "Slashdot", url: "http://rss.slashdot.org/Slashdot/slashdotMain", last_update: Time.at(0))

source1.tags<<(tag1)
source2.tags<<(tag2)
