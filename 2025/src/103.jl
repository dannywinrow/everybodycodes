include("../../helper.jl")

function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    snails = parseit.(lines)
    pos = move.(snails,100)
    sum(score.(pos))
end

function parseit(s)
    [parse.(Int,x.match) for x in eachmatch(r"\d+",s)]
end

function move(snail,m)
    x,y = snail
    v = x + y - 1
    mod(x+m,1:v),mod(y-m,1:v)
end

function score(snail)
    x,y = snail
    x + y*100
end

pt1 = solve()

function solve2(part=2,problem="p")
    lines = loadlines(part=part,problem=problem)
    snails = parseit.(lines)
    snails = sort(snails,by=sum)
    m = 0
    x = 1
    for s in snails
        ms = 0
        while true
            if (m + x * ms) % (sum(s)-1) == s[2]-1
                break
            end
            ms += 1
        end
        m += ms*x
        x = lcm(x,sum(s)-1)
    end
    m
end


pt2 = solve2(2)
pt3 = solve2(3)