include("../helper.jl")


function solve1(filename)
    lines = loadlines(filename)
    nails = parse.(Int,lines)
    sum(nails) - minimum(nails)*length(nails)
end

pt1 = solve1(getfilename(2024,4,1))
@show pt1

pt2 = solve1(getfilename(2024,4,2))
@show pt2

function solve3(filename)
    lines = loadlines(filename)
    nails = parse.(Int,lines)
    med = sort(nails)[length(nails) ÷ 2]
    hits = nails .- med
    sum(abs.(hits .+ 1))
end

pt3 = solve3(getfilename(2024,4,3))
@show pt3