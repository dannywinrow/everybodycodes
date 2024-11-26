include("../../helper.jl")

function solve1(filename)
    lines = loadlines(filename)
    branches = Dict{AbstractString,Vector{AbstractString}}()
    for line in lines
        k,v = split(line,":")
        v = split(v,",")
        branches[k] = v
    end
    shortestpath = Dict{String,Tuple{String,Int}}()
    totraverse = ["RR"]
    shortestpath["RR"] = ("RR",1)
    flowers = []
    while !isempty(totraverse)
        b = popfirst!(totraverse)
        sp = shortestpath[b]
        if haskey(branches,b)
            for twig in branches[b]
                if twig == "@"
                    push!(flowers,(sp[1]*twig,sp[2]+1))
                end
                push!(totraverse,twig)
                if !haskey(shortestpath,twig)
                    shortestpath[twig] = ("",999999999)
                end
                if shortestpath[twig][2] > sp[2]+1
                    shortestpath[twig] = (sp[1]*twig,sp[2]+1)
                end
            end
        end
    end
    shortestpath, flowers
    fd = freqdict(f[2] for f in flowers)
    for (k,v) in fd
        if v == 1
            return flowers[findfirst(x->x[2]==k,flowers)][1]
        end
    end
end

pt1 = solve1(getfilename(2024,6,1))
@show pt1

function solve2(filename)
    lines = loadlines(filename)
    branches = Dict{AbstractString,Vector{AbstractString}}()
    for line in lines
        k,v = split(line,":")
        v = split(v,",")
        branches[k] = v
    end
    shortestpath = Dict{String,Tuple{String,Int}}()
    totraverse = ["RR"]
    shortestpath["RR"] = ("R",1)
    flowers = []
    visited = []
    while !isempty(totraverse)
        b = popfirst!(totraverse)
        push!(visited,b)
        sp = shortestpath[b]
        if haskey(branches,b)
            for twig in branches[b]
                if twig == "@"
                    push!(flowers,(sp[1]*twig[1],sp[2]+1))
                end
                !(twig in visited) && push!(totraverse,twig)
                if !haskey(shortestpath,twig)
                    shortestpath[twig] = ("",999999999)
                end
                if shortestpath[twig][2] > sp[2]+1
                    shortestpath[twig] = (sp[1]*twig[1],sp[2]+1)
                end
            end
        end
    end
    shortestpath, flowers
    fd = freqdict(f[2] for f in flowers)
    for (k,v) in fd
        if v == 1
            return flowers[findfirst(x->x[2]==k,flowers)][1]
        end
    end
end

pt2 = solve2(getfilename(2024,6,2))
@show pt2

pt3 = solve2(getfilename(2024,6,3))
@show pt3