# Enumerate over all of the straight lines in an n-dimentional box of size m
class Box
  def initialize(n, m, box)
    @n = n
    @m = m
    @box = box
    validate!
  end

  def lines
    if block_given?
      each_lines { |l| yield l }
    else
      to_enum :each_lines
    end
  end

  private

  def validate!(box = nil, n = nil)
    box ||= @box
    n ||= @n

    if box.size != @m
      raise "Invalid box: all dimentions must be of size m = #{@m}"
    end

    if n == 1
      if box.any?{ |v| v.is_a? Array }
        raise "Invalid box: nesting exceeds specified value of n = #{@n}"
      end
    else
      if box.any?{ |v| !v.is_a? Array }
        raise "Invalid box: must nest to specified value of n = #{@n}"
      end

      box.each do |sub_box|
        validate!(sub_box, n - 1)
      end
    end
  end

  def each_lines
    lines_as_enums do |v|
      yield build_line_from_enum_vector(v)
    end
  end

  def lines_as_enums(line = [], &block)
    if line.size > @n
      raise 'Something has gone terribly wrong'
    elsif line.size == @n
      block.call line
    else
      if line.none?(&:walking)
        if line.size < @n - 1
          @m.times do |i|
            lines_as_enums(line + [Enumerator.fixed(i, @m)], &block)
          end
        end

        lines_as_enums(line + [Enumerator.up(@m)], &block)
      else
        @m.times do |i|
          lines_as_enums(line + [Enumerator.fixed(i, @m)], &block)
        end

        lines_as_enums(line + [Enumerator.up(@m)], &block)
        lines_as_enums(line + [Enumerator.down(@m)], &block)
      end
    end
  end

  def build_line_from_enum_vector(v)
    rewound_vector = v.map(&:rewind)
    @m.times.map { value_at_vector(rewound_vector.map(&:next)) }
  end

  def value_at_vector(v)
    value = @box
    @n.times { |d| value = value[v[d]] }
    value
  end
end

class Enumerator
  attr_accessor :walking, :s

  def self.up(m)
    e = m.times
    e.walking = true
    e.s = "u#{m}"
    e
  end

  def self.down(m)
    e = (m - 1).downto(0)
    e.walking = true
    e.s = "d#{m}"
    e
  end

  def self.fixed(i, m)
    e = self.new { |y| m.times { y << i } }
    e.walking = false
    e.s = "f#{i},#{m}"
    e
  end
end