"""Types which inherit from "Shape" should provide an "Ares" method
"""
abstract type Shape end
combined_ares(a::Shape, b::Shape) = area(a) + area(b)

struct Circle <: Shape
    diameter::Float64
end
radius(c::Circle) = c.diameter / 2
area(c::Circle) = π * radius(c) ^ 2

"""Types which inherit from "AbstractRectangle" should
provide 'height' and 'width' methods
"""
abstract type AbstractRectangle <: Shape end
area(r::AbstractRectangle) = width(r) * height(r)

struct Rectangle <: AbstractRectangle
    width::Float64
    height::Float64
end
width(r::Rectangle) = r.width
height(r::Rectangle) = r.height

struct Square <: AbstractRectangle
    length::Float64
end
width(s::Square) = s.length
height(s::Square) = s.length

c = Circle(3)
s = Square(3)
r = Rectangle(3, 2)

@show combined_ares(c, s)
@show combined_ares(s, r)

# structs cannot inherit data fields from super classes
struct HashInterestingField
    data::String
end

double(hif::HashInterestingField) = hif.data ^ 2
shout(hif::HashInterestingField) = uppercase(string(hif.data, "!"))

# the compositional way add those fields to another struct
struct WantInterestingField
    interesting::HashInterestingField
    # internal structor
    WantInterestingField(data) = new(HashInterestingField(data))
end

# forward methods
for method in (:double, :shout)
    @eval $method(wif::WantInterestingField) = $method(wif.interesting)
end

# same as:
#   double(wif::WantInterestingField) = double(wif.interesting)
#   shout(wif::WantInterestingField) = shout(wif.interesting)
wif = WantInterestingField("foo")
@show shout(wif)
@show double(wif);

# forward methods on a struct to a field of that struct
# good for your composition
# syntax: @forward Composite Type.property Base.iterate Base.length:*
# Symbol literals automatically become Base.:symbol. Good for adding
# methods to built-in operators
macro forward(property, functions...)
    structname = property.args[1]
    field = property.args[2].value
    block = quote end
    for f in functions
        # case for operators
        if f isa QuoteNode
            f = :(Base.$(f.value))
            def1 = :($f(x::$structname, y) = $f(x.$field, y))
            def2 = :($f(x, y::$structname) = $f(x, y.$field))
            push!(block.args, def1, def2)
        # case for other stuff
        else
            def = :($f(x::$structname, args...;kwargs...) = $f(x.$field, args...;kwargs...))
            push!(block.args, def)
        end
    end
    esc(block)
end

# demo:
struct Foo
    x::String
end

@forward Foo.x Base.string :* :^

foo = Foo("foo")

@show string(foo, "!")
@show foo * "!"
@show foo ^ 4;

# if you use forward macro, there are Lazy.jl package

struct GenPoint{T}
    x::T
    y::T
end

GenPoint(1, 3)

struct GenPoint2{X, Y}
    x::X
    y::Y
end

GenPoint2(1, 3.0)

struct RealPoint
    x::Real
    y::Real
end

RealPoint(0x5, 0xaa)

struct Point{T <: Real}
    x::T
    y::T
end

@show Point(1, 3)
@show Point(1.4, 2.5)

# Type which indicate end of list
struct Nil end

struct List{T}
    head::T
    tail::Union{List{T}, Nil}
end

# built a list from an array
mklist(array::AbstractArray{T}) where T = foldr(List{T}, array, init=Nil())

# implement the iteration protoco
Base.iterate(l::List) = iterate(l, l)
Base.iterate(::List, l::List) = l.head, l.tail
Base.iterate(::List, ::Nil) = nothing

# demo
list = mklist(1:3)
@show list

# according iterate protocol
for val in list
    println(val)
end

# The Trait Pattern
# Reference at below
# https://docs.julialang.org/en/v1/manual/methods/#Trait-based-dispatch-1
# https://github.com/JuliaLang/julia/issues/2345#issuecomment-54537633
Base.length(l::List) = 1 + length(tali(l))
Base.length(::Nothing) = 0

Base.IteratorSize(::List) = Base.HasLength()

struct Zlurmable end
Zlurmable(::T) where T = error("Type $T does not implement the Zlurmable trait")

zlurm(x) = zlurm(Zlurmable(x), x)
zlurm(::Zlurmable, x) = x + 1

# what we need to do is add the trait to a type:
Zlurmable(::Int64) = Zlurmable()
zlurm(3)


abstract type IteratorSize end
struct SizeUnknown <: IteratorSize end
struct HasLength <: IteratorSize end
struct HasShape{N} <: IteratorSize end
struct Isinfinite <: IteratorSize end

IteratorSize(::Any) = HasLength()