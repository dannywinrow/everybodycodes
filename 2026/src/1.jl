include("../../helper.jl")

saveinputs()
saveexamples()

function solve(part=1,problem="p";squares=squares)
    lines = loadlines(part=part,problem=problem)
    ns = parse.(Int,split(lines[1],","))
    a = 0
    for x in ns
        i = findfirst(>=(x),squares)
        a += squares[i] - x
    end
    a
end

squares = (1:50).^2
pt1 = solve(1;squares=squares)

frames = ((3:5000) .-1) .* 4
pt2 = solve(2;squares=frames)

bigframes = (3:2:5001) .^ 2 .-1
pt3 = solve(3;squares=bigframes)