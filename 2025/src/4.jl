include("../../helper.jl")

saveinputs()

function solve1()
    lines = loadlines(part=1)
    v = parse.(Int,lines)
    2025*v[1] ÷ v[end]
end

function solve2()
    lines = loadlines(part=2)
    v = parse.(Int,lines)
    ceil(10000000000000*v[end] ÷ v[1])
end

using Printf
function solve3()
    lines = loadlines(part=3)
    s = @sprintf "%i" (100
            * prod([\(parse.(Int,split(x,"|"))...) for x in lines[2:end-1]])
            * parse(Int,lines[1])) ÷ parse(Int,lines[end])
    s |> clipboard
    s
end

solve1()
solve2()
solve3()