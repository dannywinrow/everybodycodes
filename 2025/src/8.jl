include("../../helper.jl")

saveinputs()

function getpairs(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    line = parse.(Int,split(lines[1],","))
    pairs = [line[i:i+1] for i in 1:length(line)-1]
    sort!.(pairs)
end

function solve1(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    line = parse.(Int,split(lines[1],","))
    x = length(line) ÷ 2
    count(==(16),abs.(line[2:end] .- line[1:end-1]))
end

function solve2(part=2,problem="p")
    pairs = getpairs(part)
    x = 0
    for i in 1:length(pairs)
        for j in i+1:length(pairs)
            x += cuts(pairs[i],pairs[j])
        end
    end
    x
end

function solve3(part=3,problem="p")
    pairs = getpairs(part)
    x = 0
    for n in 1:255
        for m in n+1:256
            v = sum(cuts.(Ref((n,m)),pairs))
            x = max(v,x)
        end
    end
    x
end

function cuts(x,y)
    a,c = x
    b,d = y
    a < b < c < d || b < a < d < c
end

pt1 = solve1()

pt2 = solve2()

pt3 = solve(3)