require './init.rb'

start_date = Time.now
array = []
puts "populating big array..."
ELEMENTS.times do |x|
  array << O.new(start_date - x * 86400, x.to_s)
end
puts "populating small arrays..."
arrays = array.each_slice(SMALL_SIZE).to_a

expected_array = array.dup.sort!
rev_expected_array = expected_array.dup.reverse!

expected_arrays = arrays.dup.each { |array| array.sort! }
rev_expected_arrays = expected_arrays = arrays.dup.each { |array| array.sort!.reverse! }

puts "------ BIG ARRAY ------\n"
res = Sorter.no_args_block_order(array.dup)
puts "NO ARGS BLOCK ORDER: #{res == rev_expected_array}"

res = Sorter.ce_order(array.dup, "date DESC")
puts "CLASS EVAL ORDER: #{res == rev_expected_array}"

puts "------ SMALL ARRAYS ------\n"
res = arrays.dup.each { |array| Sorter.no_args_block_order(array) }
puts "NO ARGS BLOCK ORDER: #{res == rev_expected_arrays}"

res = arrays.dup.each { |array| Sorter.ce_order(array, "date DESC") }
puts "CLASS EVAL ORDER: #{res == rev_expected_arrays}"
