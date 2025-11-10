include("../../helper.jl")

saveinputs()


struct Sword
    n
    s
end

function Base.isless(a::Sword,b::Sword)
    quality(a) > quality(b) && return false
    quality(a) < quality(b) && return true
    for (x,y) in zip(a.s,b.s)
        levelnum(x) < levelnum(y) && return true
        levelnum(x) > levelnum(y) && return false
    end
    false
end

function place!(spine,x)
    for seg in spine
        if x > seg[2] && isnothing(seg[3])
            seg[3] = x
            return seg
        elseif x < seg[2] && isnothing(seg[1])
            seg[1] = x
            return seg
        end
    end
    push!(spine,[nothing,x,nothing])
end

function parsesword(line::AbstractString)
    n,s = split(line,":")
    n = parse(Int,n)
    s = parse.(Int,split(s,","))
    spine = []
    for x in s
        place!(spine,x)
    end
    Sword(n,spine)
end

function quality(sword::Sword)
    parse(Int,join([x[2] for x in sword.s]))
end

function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    v = parsesword.(lines)
    quality.(v)
end

function getswords(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    v = parsesword.(lines)
end

function solve2()
    v = getswords(2)
    q = sort(quality.(v))
    q[end] - q[1]
end

function solve3()
    v = getswords(3)
    sort!(v)
    sum((1:length(v)) .* reverse([x.n for x in v]))
end

levelnum(a) = parse(Int,join(filter(!isnothing,a)))

pt1 = solve()

pt2 = solve2()

pt3 = solve3()