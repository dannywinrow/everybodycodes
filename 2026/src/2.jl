include("../../helper.jl")

saveinputs()
saveexamples()

function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    ords = makecompare.(lines)
    ords = join.(ords)
    sum(parse.(Int,ords))
end

function makecompare(line)
    cs = split(line," ")
    chrs = sort(filter(!isnothing,unique(tryparse.(Int,split(line,"")))))
    function isless(x,y)
        "$x<$y" ∈ cs || "$y>$x" ∈ cs
    end
    function isless2(x,y)
        if isless(x,y)
            return true
        else
            for z in chrs
                if isless(x,z) && isless(z,y)
                    return true
                end
                
            end
            return false
        end
    end
    sort!(chrs;lt=isless2,rev=true)
end

pt1 = solve()
pt2 = solve(2)
pt3 = solve(3)