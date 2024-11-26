include("../../helper.jl")

function solve1(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    moves = split(lines[1],",")
    h = 0
    maxh = 0
    for m in moves
        dir = m[1]
        dist = parse(Int,m[2:end])
        if dir == 'U'
            h += dist
        elseif dir == 'D'
            h -= dist
        end
        if h > maxh
            maxh = h
        end
    end
    maxh
end

pt1 = solve1(1)
@show pt1

function solve2(part=2,problem="p")
    dir = Dict()
    dir['U'] = CartesianIndex(1,0,0)
    dir['D'] = CartesianIndex(-1,0,0)
    dir['F'] = CartesianIndex(0,1,0)
    dir['B'] = CartesianIndex(0,-1,0)
    dir['L'] = CartesianIndex(0,0,-1)
    dir['R'] = CartesianIndex(0,0,1)

    lines = loadlines(part=part,problem=problem)
    trees = split.(lines,",")
    s = Set{CartesianIndex}()
    for moves in trees
        ci = CartesianIndex(0,0,0)
        for m in moves
            d = m[1]
            dist = parse(Int,m[2:end])
            for _ in 1:dist
                ci += dir[d]
                push!(s,ci)
            end
        end
    end
    length(s)
end

solve2()
@show pt2

dir = Dict()
dir['U'] = CartesianIndex(1,0,0)
dir['D'] = CartesianIndex(-1,0,0)
dir['F'] = CartesianIndex(0,1,0)
dir['B'] = CartesianIndex(0,-1,0)
dir['L'] = CartesianIndex(0,0,-1)
dir['R'] = CartesianIndex(0,0,1)

function solve3(part=3,problem="p")
    lines = loadlines(part=part,problem=problem)
    trees = split.(lines,",")
    s = Set{CartesianIndex}()
    leaves = Set{CartesianIndex}()
    for moves in trees
        ci = CartesianIndex(0,0,0)
        for m in moves
            d = m[1]
            dist = parse(Int,m[2:end])
            for _ in 1:dist
                ci += dir[d]
                push!(s,ci)
            end
        end
        push!(leaves,ci)
    end
    mainstem = filter(x->x[2]==x[3]==0,s)
    sps = Dict()
    for leaf in leaves
        sps[leaf] = shortestpath(leaf,s)
    end
    minimum(sum(sps[leaf][m] for leaf in leaves) for m in mainstem)
end

function shortestpath(leaf,tree)
    start = leaf
    visited = []
    totraverse = [start]
    sp = Dict()
    sp[start] = 0
    while !isempty(totraverse)
        ci = popfirst!(totraverse)
        for d in values(dir)
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

pt3 = solve3()
@show pt3