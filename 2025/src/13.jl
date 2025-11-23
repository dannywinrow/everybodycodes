include("../../helper.jl")

saveinputs()
saveexamples()

function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    ns = parse.(Int,lines)
    p = [1]
    for i in 1:length(ns)
        if i % 2 != 0
            push!(p,ns[i])
        else
            pushfirst!(p,ns[i])
        end
    end
#return p
    CircularArray(p)[2025+(length(p)+1) ÷ 2]
end

pt1 = solve(1)

function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    ns = [parse.(Int,x) for x in split.(lines,"-")]
    ns = [x[1]:x[2] for x in ns]
    v = [1:1,ns[1:2:length(ns)]...,reverse(reverse.(ns[2:2:length(ns)]))...]
    l = sum(length.(v))
    if part == 3
        m = (202520252025+1) % l
    elseif part == 2
        m = (20252025+1) % l
    end
    for x in v
        if length(x) < m
            m = m-length(x)
        else
            @info x
            return x[m]
        end
    end
end

pt2 = solve(2)
pt3 = solve(3)