include("../../helper.jl")

saveinputs()

function getv(part,problem="p")
    lines = loadlines(part=part,problem=problem)
    v = parse.(Int,split(lines[1],","))
end

pt1 = sum(unique(getv(1)))
pt2 = sum(sort(unique(getv(2)))[1:20])
pt3 = maximum(values(freqdict(getv(3))))