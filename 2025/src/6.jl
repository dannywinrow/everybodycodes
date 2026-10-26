include("../../helper.jl")

saveinputs()

function getline(part)
    lines = loadlines(part=part)
    CircularArray(split(lines[1],""))
end
function solve1()
    line = getline(1)
    sum([x != "a" ? 0 : count(==(uppercase(x)),line[1:i-1]) for (i,x) in enumerate(line)])
end

function solve2()
    line = getline(2)
    sum([x == uppercase(x) ? 0 : count(==(uppercase(x)),line[1:i-1]) for (i,x) in enumerate(line)])
end

function solve3()
    line = getline(3)
    a = [x == uppercase(x) ? 0 : count(==(uppercase(x)),line[i-1000:i+1000]) for (i,x) in enumerate(line)]
    b = [x == uppercase(x) ? 0 : count(==(uppercase(x)),line[max(1,i-1000):min(10000,i+1000)]) for (i,x) in enumerate(line)]
    sum(a * 999 + b)
end
pt1 = solve1()

pt2 = solve2()

pt3 = solve3()

using BenchmarkTools
@benchmark solve1()
@benchmark solve2()
@benchmark solve3()