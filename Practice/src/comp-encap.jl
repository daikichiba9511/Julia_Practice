# in Julia, composition is provided by structs
# encapsulation is provided by function methods (= multiple dispatch)

# delare your structs
mutable struct Point2
    x::Float64
    y::Float64
end

mypoint = Point2(5, 7)

println(mypoint.x)

mypoint.x = 10.0

println(mypoint.x)

mutable struct Starship
    name::String
    location::Point2
end

ship = Starship("D.C", Point2(2, 5))

println(ship)

ship.location = Point2(3, 4)

println(ship)

## Method
# multi dispatch

struct Rectangle
    width::Float64
    height::Float64
end
width(r::Rectangle) = r.width
height(r::Rectangle) = r.height

struct Square
    length::Float64
end
width(s::Square) = s.length
height(s::Square) = s.length

area(shape) = width(shape) * height(shape)

r = Rectangle(3, 4)
s = Square(3)
@show area(r)
@show area(s)