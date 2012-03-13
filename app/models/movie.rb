class Movie < ActiveRecord::Base
  def self.all_ratings
    # Can't figure out how to do "select distinct..." in DB without raw SQL
    all_ratings = self.select(:rating).uniq.map { |movie| movie.rating }
    all_ratings.uniq!
    all_ratings.sort!
    all_ratings
  end
end
