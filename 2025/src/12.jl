include("../../helper.jl")

saveexamples()
saveinputs()

function solve(part=1,problem="p")
    grid = loadgrid(part=part,problem=problem)
    tovisit = [CartesianIndex(1,1)]
    visited = fill(false,size(grid))
    while !isempty(tovisit)
        v = pop!(tovisit)
        if !visited[v]
            visited[v] = true
            for a in adjacents(v)
                if a in CartesianIndices(grid) && grid[a] <= grid[v]
                    push!(tovisit,a)
                end
            end
        end
    end
    sum(visited)
end

pt1 = solve()

function solve(part=1,problem="p")
    grid = loadgrid(part=part,problem=problem)
    tovisit = [CartesianIndex(1,1),CartesianIndex(size(grid)...)]
    visited = fill(false,size(grid))
    while !isempty(tovisit)
        v = pop!(tovisit)
        if !visited[v]
            visited[v] = true
            for a in adjacents(v)
                if a in CartesianIndices(grid) && grid[a] <= grid[v]
                    push!(tovisit,a)
                end
            end
        end
    end
    sum(visited)
end


pt2 = solve(2)



function explosion(ci,grid)
    tovisit = [ci]
    visited = fill(false,size(grid))
    while !isempty(tovisit)
        v = pop!(tovisit)
        if !visited[v]
            visited[v] = true
            for a in adjacents(v)
                if a in CartesianIndices(grid) && grid[a] <= grid[v]
                    push!(tovisit,a)
                end
            end
        end
    end
    visited
end

function solve(part=1,problem="p")
    grid = loadgrid(part=part,problem=problem)
    vs = [explosion(ci,grid) for ci in CartesianIndices(grid)]
    ss = sum.(vs)
    ord = sort([CartesianIndices(grid)...],by=x->ss[x],rev=true)
    localmaxes = []
    covered = fill(false,size(grid))
    for ci in ord
        if !covered[ci]
            push!(localmaxes,ci)
            covered = covered .| vs[ci]
        end
    end
    i = localmaxes[1]
    j = localmaxes[argmax([sum(vs[ci] .| vs[i]) for ci in localmaxes])]
    v = vs[i] .| vs[j]
    k = localmaxes[argmax([sum(vs[ci] .| v) for ci in localmaxes])]
    sum(vs[k] .| vs[i] .| vs[j])
end

pt3 = solve(3)