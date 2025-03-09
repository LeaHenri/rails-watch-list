# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'json'
require 'open-uri'

puts 'Cleaning database...'
Bookmark.destroy_all
Movie.destroy_all

puts 'Creating movie seeds'

url = 'https://tmdb.lewagon.com/movie/top_rated'
list = JSON.parse(URI.parse(url).read) # mettre du JSON en RUBY

movies_list = list['results']

movies_list.each do |hash|
  movie = Movie.new(
    title: hash['title'],
    overview: hash['overview'],
    poster_url: "https://image.tmdb.org/t/p/w500/#{hash['poster_path']})",
    rating: hash['vote_average']
  )
  movie.save
end

puts "Finished! Created #{Movie.count} movies."
