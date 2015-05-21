module Sorter
  MAX_SORTING_ARGS = 2
  MAX_NESTING_LEVEL = 2
  VALID_DIRECTIONS = %w(asc ASC desc DESC)
  ARG_MATCHER = /^(?<field>[a-zA-Z]\w*(\.\w+)*)( (?<dir>#{VALID_DIRECTIONS.join('|')})){0,1}$/

  def self.order(str_args, use_cache=true, use_nesting=true)
    @sorters ||= {}
    @sorters[[str_args, use_nesting]] = nil unless use_cache
    if @sorters[[str_args, use_nesting]] && use_cache
      return @sorters[[str_args, use_nesting]]
    end

    args = str_args.split(',').map(&:strip)

    # FIXME: Use Jekyll way of outputting errors here
    raise ArgumentError, "Can't order by more than #{MAX_SORTING_ARGS} fields" if args.size > MAX_SORTING_ARGS

    args.map! do |arg|
      m = arg.match(ARG_MATCHER)
      raise ArgumentError, "Invalid order argument. Valid argument are: '<field_name> <dirrection>, " \
                           "with <dir> in: #{VALID_DIRECTIONS.inspect}" if m.nil?
      [m[:field], (m[:dir] || 'asc').downcase == 'asc' ? true : false]
    end

    @sorters[[str_args, use_nesting]] ||= lambda do |a, b|
      cmp = 0
      args.each do |arg|
        field, asc = arg
        da = use_nesting ? access(a.data, field) : a.data[field]
        db = use_nesting ? access(b.data, field) : b.data[field]
        break if cmp != 0
        # FIXME: Handle missing fields
        cmp = asc ? da <=> db : db <=> da
      end

      cmp
    end
  end

  def self.proc_order(str_args, use_cache=true, use_nesting=true)
    @proc_sorters ||= {}
    @proc_sorters[[str_args, use_nesting]] = nil unless use_cache
    if @proc_sorters[[str_args, use_nesting]] && use_cache
      return @proc_sorters[[str_args, use_nesting]]
    end

    args = str_args.split(',').map(&:strip)

    # FIXME: Use Jekyll way of outputting errors here
    raise ArgumentError, "Can't order by more than #{MAX_SORTING_ARGS} fields" if args.size > MAX_SORTING_ARGS

    args.map! do |arg|
      m = arg.match(ARG_MATCHER)
      raise ArgumentError, "Invalid order argument. Valid argument are: '<field_name> <dirrection>, " \
                           "with <dir> in: #{VALID_DIRECTIONS.inspect}" if m.nil?
      [m[:field], (m[:dir] || 'asc').downcase]
    end

    @proc_sorters[[str_args, use_nesting]] ||= Proc.new do |a, b|
      cmp = 0
      args.each do |arg|
        field, dir = arg
        da = use_nesting ? access(a.data, field) : a.data[field]
        db = use_nesting ? access(b.data, field) : b.data[field]
        break if cmp != 0
        # FIXME: Handle missing fields
        case dir
        when 'asc'
          cmp = da <=> db
        when 'desc'
          cmp = db <=> da
        end
      end

      cmp
    end
  end

  def self.no_args_block_order(array)
    array.sort! do |a,b|
      cmp = b.date <=> a.date
      if 0 == cmp
       cmp = b.slug <=> b.slug
      end
      cmp
    end
  end

  def self.block_order(array, args, use_cache=true, use_nesting=true)
    @cached_args ||= {}
    @cached_args[args] = nil unless use_cache
    if @cached_args[args] && use_cache
      args = @cached_args[args]
    else
      args = args.split(',').map(&:strip)

      raise ArgumentError, "Can't order by more than #{MAX_SORTING_ARGS} fields" if args.size > MAX_SORTING_ARGS

      args.map! do |arg|
        m = arg.match(ARG_MATCHER)
        raise ArgumentError, "Invalid order argument. Valid argument are: '<field_name> <dirrection>, " \
                             "with <dir> in: #{VALID_DIRECTIONS.inspect}" if m.nil?
        [m[:field], (m[:dir] || 'asc').downcase]
      end
    end

    array.sort! do |a, b|
      cmp = 0
      args.each do |arg|
        field, dir = arg
        da = use_nesting ? access(a.data, field) : a.data[field]
        db = use_nesting ? access(b.data, field) : b.data[field]
        break if cmp != 0
        # FIXME: Handle missing fields
        case dir
        when 'asc'
          cmp = da <=> db
        when 'desc'
          cmp = db <=> da
        end
      end

      cmp
    end
  end

  def self.ce_order(array, str_args, use_cache=true)
    @cached_methods ||= {}
    @cached_methods[str_args] = nil unless use_cache
    if @cached_methods[str_args] && use_cache
      self.send(@cached_methods[str_args], array)
    else
      args = str_args.split(',').map(&:strip)
      raise ArgumentError, "Can't order by more than #{MAX_SORTING_ARGS} fields" if args.size > MAX_SORTING_ARGS

      args.map! do |arg|
        m = arg.match(ARG_MATCHER)
        raise ArgumentError, "Invalid order argument. Valid argument are: '<field_name> <dirrection>, " \
                             "with <dir> in: #{VALID_DIRECTIONS.inspect}" if m.nil?
        [m[:field], (m[:dir] || 'asc').downcase]
      end

      method_name = "_morder_#{args.join('_')}"
      cmp_code_part = args.each_with_index.map do |arg, i|
        str = ""
        field, dir = arg
        str << "if cmp == 0\n" if i != 0
        if dir == 'asc'
          str << "  cmp = a.data['#{field.split('.').join("']['")}'] <=> b.data['#{field.split('.').join("']['")}']\n"
        else
          str << "  cmp = b.data['#{field.split('.').join("']['")}'] <=> a.data['#{field.split('.').join("']['")}']\n"
        end
        str << "end\n" if i != 0

        str
      end

      clsmth = <<-RUBY
        def #{method_name}(array)
          cmp = 0
          array.sort! do |a,b|
            #{cmp_code_part.join}
          end
        end
      RUBY

      self.class.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{method_name}(array)
          cmp = 0
          array.sort! do |a,b|
            #{cmp_code_part.join}
          end
        end
      RUBY

      @cached_methods[str_args] = method_name
      self.send(method_name, array)
    end
  end

  def self.access(hash, field)
    value = hash
    fields = field.split('.')
    raise ArgumentError, "Maximum nesting level of sorting " \
                         "is #{MAX_NESTING_LEVEL}" if fields.size - 1 > MAX_NESTING_LEVEL
    fields.each do |f|
      value = value[f]
      break if value.nil?
    end

    value
  end
end
