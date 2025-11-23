include("../../helper.jl")

saveinputs()
saveexamples()

"""
    dist(a,b)
Returns manhatten distance between two CartesianIndex
"""
dist(a,b) = sum(abs.(Tuple((a - b))))

"""
    betw(a,b)
Returns unit range between a and b even if a > b
"""
function betw(a,b)
    if length(a:b) == 0
        b:a
    else
        a:b
    end
end

"""
    shortestpath(grid,S,E)
Returns unit range between a and b even if a > b
"""
function shortestpath(grid,S,E)
    val = fill(Inf,size(grid))
    val[S] = 0
    from = Dict()
    tovisit = [S]
    visited = Set()
    while !isempty(tovisit)
        ci = popfirst!(tovisit)
        if !(ci in visited)  
            push!(visited,ci)
            for ni in adjacents(ci)
                if ni in CartesianIndices(grid) && !grid[ni]
                    if val[ni] > val[ci] + 1
                        val[ni] = val[ci] + 1
                        from[ni] = ci
                        if ni == E
                            return pathto(from,ni)
                        end
                        push!(tovisit,ni)
                    end
                end
            end
        end
    end
end

"""
    pathto(from,E)
Returns a Vector of chained objects ending at `E` in Dictionary `from`
"""
function pathto(from,E)
    ci = E
    path = [ci]
    while haskey(from,ci)
        ci = from[ci]
        push!(path,ci)
    end
    path
end

function solve(part,problem="p")    
    lines = loadlines(part=part,problem=problem)
    v = split(lines[1],",")
    v = [(x[1],parse(Int,x[2:end])) for x in v]
    S = CartesianIndex(0,0)
    r = [S]
    dir = CartesianIndex(-1,0)
    for (d,len) in v
        if d == 'L'
            dir = rotl90(dir)
        else
            dir = rotr90(dir)
        end
        push!(r,r[end]+dir*len)
    end
    E = r[end]

    #remap
    xs = unique(x[1] for x in r)
    xs = sort(unique(vcat(xs,xs .+ 1,xs .- 1)))
    ys = unique(x[2] for x in r)
    ys = sort(unique(vcat(ys,ys .+ 1,ys .- 1)))
    grid = [CartesianIndex(x,y) for x in xs, y in ys]
    Sd = findfirst(==(S),grid)
    Ed = findfirst(==(E),grid)

    walls = fill(false,size(grid))
    rd = [findfirst(==(x),grid) for x in r]
    for i in 1:length(rd)-1
        walls[betw(rd[i+1],rd[i])] .= true
    end
    walls[Ed] = false

    p = shortestpath(walls,Sd,Ed)
    pd = [grid[x] for x in p]
    sum(dist.(pd[1:end-1],pd[2:end]))
end

solve(1)
solve(2)
solve(3)