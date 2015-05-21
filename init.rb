require 'pp'
require './sorter.rb'

ELEMENTS = 100_000
SMALL_SIZE = 100

class O
  attr_accessor :data

  def initialize(date, slug)
    @data = {
      'date' => date,
      'slug' => slug
    }
  end

  def date
    @data['date']
  end

  def slug
    @data['slug']
  end

  def <=>(other)
    cmp = self.date <=> other.date
    if 0 == cmp
     cmp = self.slug <=> other.slug
    end
    return cmp
  end
end
