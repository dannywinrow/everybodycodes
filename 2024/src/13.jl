include("../../helper.jl")

function solve1(filename)
    grid = loadgrid(filename)
    start = findall(==('S'),grid)
    lastone = findfirst(==('E'),grid)
    grid[start] .= '0'
    grid[lastone] = '0'
    visited = []
    totraverse = start
    sp = Dict()
    for x in start
        sp[x] = 0
    end
    while !isempty(totraverse)
        ci = popfirst!(totraverse)
        w = grid[ci] - '0'
        for d in directions
            nci = ci + d
            if nci in CartesianIndices(grid) && grid[nci] != '#' && !in(nci,visited)
                v = grid[nci] - '0'
                cost = min(mod(v-w,10),mod(w-v,10)) + 1 + sp[ci]
                fsp = get!(sp,nci,99999999)
                if cost < fsp
                    sp[nci] = cost
                    push!(totraverse,nci)
                end
            end
        end
    end
    sp[lastone]
end

pt1 = solve1(getfilename(2024,13,1))
@show pt1

pt2 = solve1(getfilename(2024,13,2))
@show pt2

pt3 = solve1(getfilename(2024,13,3))
@show pt3