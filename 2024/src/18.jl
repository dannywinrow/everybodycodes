include("../../helper.jl")



function getpaths(part=1)
    grid = loadgrid(part=part)
    palms = findall(in('P'),grid)
    available = findall(==('.'),grid)
    starts = filter(ci->ci[1] == 1 || ci[2] == 1 || ci[1] == size(grid,1) || ci[2] == size(grid,2),available)
    valid = union(palms,available)
    sps = Dict()
    for start in starts
        sps[start] = shortestpath(start,valid)
    end
    sps,palms,starts
end

function shortestpath(leaf,tree)
    start = leaf
    visited = []
    totraverse = [start]
    sp = Dict()
    sp[start] = 0
    while !isempty(totraverse)
        ci = popfirst!(totraverse)
        for d in directions
            nci = ci + d
            if nci in tree && !in(nci,visited)
                cost = 1 + sp[ci]
                fsp = get!(sp,nci,99999999)
                if cost < fsp
                    sp[nci] = cost
                    push!(totraverse,nci)
                end
            end
        end
    end
    sp
end

function solve1(part=1,problem="p")
    grid = loadgrid(part=part,problem=problem)
    sps,palms,starts = getpaths(part)
    maximum(sps[starts[1]][palm] for palm in palms)
end

pt1 = solve1(1)
@show pt1

function solve2(part=1,problem="p")
    grid = loadgrid(part=part,problem=problem)
    sps,palms,starts = getpaths(part)
    maximum(minimum(sps[start][palm] for start in starts) for palm in palms)
end

pt2 = solve2(2)
@show pt2

struct Farm
    grid
    sps
    palms
    available
end

function getpaths3(part=3)
    grid = loadgrid(part=part)
    palms = findall(in('P'),grid)
    available = findall(==('.'),grid)
    valid = union(palms,available)
    sps = Dict()
    for palm in palms
        sps[palm] = shortestpath(palm,valid)
    end
    Farm(grid,sps,palms,available)
end

function solve3(part=1,problem="p")
    grid = loadgrid(part=part,problem=problem)
    return farm = getpaths3(part)
    minimum(sum(farm.sps[palm][ci] for palm in farm.palms) for ci in farm.available)
end

farm = solve3(3)
@show pt3