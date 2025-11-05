include("../../helper.jl")

saveinputs()

struct CN
    a
    b
end
Base.:+(x::CN,y::CN) = CN(x.a + y.a, x.b + y.b)
Base.:*(x::CN,y::CN) = CN(x.a * y.a - x.b * y.b, x.a * y.b + x.b * y.a)
Base.:÷(x::CN,y::CN) = CN(x.a ÷ y.a, x.b ÷ y.b)

function getA(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    CN([parse(Int,x.captures[1]) for x in eachmatch(r"(-?\d+)",lines[1])]...)
end

function solve1()
    A = getA(1)
    R = CN(0,0)
    D = CN(10,10)
    for _ in 1:3
        R = R * R
        R = R ÷ D
        R = R + A
    end
    R
end

function engravepoint(cn::CN)
    r = CN(0,0)
    for i in 1:100
        r *= r
        r ÷= CN(100000,100000)
        r += cn
        if -1000000 <= r.a <= 1000000 && -1000000 <= r.b <= 1000000
        else
            return false
        end
    end
    true

end

function solve2()
    A = getA(2)
    engravepoint.(A + CN(x,y) for x in 0:10:1000, y in 0:10:1000)
end

function solve3()
    A = getA(3)
    engravepoint.(A + CN(x,y) for x in 0:1000, y in 0:1000)
end

pt1 = solve1()
pt2 = solve2()
sum(pt2)
pt3 = solve3()
sum(pt3)

using Colors
Gray.(pt2)
Gray.(pt3)