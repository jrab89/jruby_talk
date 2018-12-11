class Circle
  attr_reader :radius
  def initialize(radius)
    @radius = radius
  end

  def area
    Math::PI * radius**2
  end
end

radius = ARGV[0].to_i
puts Circle.new(radius).area
