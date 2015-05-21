require './init.rb'
require 'benchmark'

start_date = Time.now
array = []
puts "populating big array..."
ELEMENTS.times do |x|
  array << O.new(start_date - x * 86400, x.to_s)
end
puts "populating small arrays..."
arrays = array.each_slice(SMALL_SIZE).to_a

# pp array

def bench(bm, arrays)
  # Jekyll
  bm.report('jekyll') do
    arrays.dup.each do |array|
      array.sort!.reverse!
    end
  end

  # INLINE BLOCK
  bm.report('sort inline block w/ reverse!') do
    arrays.dup.each do |array|
      array.sort! do |a,b|
        cmp = a.date <=> b.date
        if 0 == cmp
         cmp = b.slug <=> b.slug
        end
        cmp
      end.reverse!
    end
  end

  bm.report('sort inline block w/o reverse!') do
    arrays.dup.each do |array|
      array.sort! do |a,b|
        cmp = b.date <=> a.date
        if 0 == cmp
         cmp = b.slug <=> b.slug
        end
        cmp
      end
    end
  end

  # SORTER INLINE BLOCK WITHOUT ARGS
  bm.report('sorter inline no args block') do
    arrays.dup.each do |array|
      Sorter.no_args_block_order(array)
    end
  end

  # SORTER INLINE BLOCK
  bm.report('sorter inline block w/o cache w/o nesting') do
    arrays.dup.each do |array|
      Sorter.block_order(array, 'date desc', false, false)
    end
  end

  bm.report('sorter inline block w/ cache w/o nesting') do
    arrays.dup.each do |array|
      Sorter.block_order(array, 'date desc', true, false)
    end
  end

  bm.report('sorter inline block w/o cache w/ nesting') do
    arrays.dup.each do |array|
      Sorter.block_order(array, 'date desc', false, true)
    end
  end

  bm.report('sorter inline block w/ cache w/ nesting') do
    arrays.dup.each do |array|
      Sorter.block_order(array, 'date desc', true, true)
    end
  end

  # SORTER LAMBDA
  bm.report('sorter lambda w/o cache w/o nesting') do
    arrays.dup.each do |array|
      array.sort!(&Sorter.order('date desc', false, false))
    end
  end

  bm.report('sorter lambda w/ cache w/o nesting') do
    arrays.dup.each do |array|
      array.sort!(&Sorter.order('date desc', true, false))
    end
  end

  bm.report('sorter lambda w/o cache w/ nesting') do
    arrays.dup.each do |array|
      array.sort!(&Sorter.order('date desc', false, true))
    end
  end

  bm.report('sorter lambda w/ cache w/ nesting') do
    arrays.dup.each do |array|
      array.sort!(&Sorter.order('date desc', true, true))
    end
  end

  # SORTER PROC
  bm.report('sorter proc w/o cache w/o nesting') do
    arrays.dup.each do |array|
      array.sort!(&Sorter.proc_order('date desc', false, false))
    end
  end

  bm.report('sorter proc w cache w/o nesting') do
    arrays.dup.each do |array|
      array.sort!(&Sorter.proc_order('date desc', true, false))
    end
  end

  bm.report('sorter proc w/o cache w/ nesting') do
    arrays.dup.each do |array|
      array.sort!(&Sorter.proc_order('date desc', false, true))
    end
  end

  bm.report('sorter proc w/ cache w/ nesting') do
    arrays.dup.each do |array|
      array.sort!(&Sorter.proc_order('date desc', true, true))
    end
  end

  # CLASS EVAL ORDER
  bm.report('sorter class eval w/ cache (w/ nesting)') do
    arrays.dup.each do |array|
      Sorter.ce_order(array, 'date_desc', true)
    end
  end
end

puts "\n## Big Array (1 x #{ELEMENTS} elements)\n\n```sh"
Benchmark.bmbm(7) do |bm|
  bench(bm, [array])
end
puts "```"

puts "\n## Small Arrays (#{ELEMENTS / SMALL_SIZE} x #{SMALL_SIZE} elements)\n\n```sh"
Benchmark.bmbm(7) do |bm|
  bench(bm, arrays)
end
puts "```"
