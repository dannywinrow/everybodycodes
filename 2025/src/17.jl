include("../../helper.jl")

saveinputs()
saveexamples()

ispoint(ci,v,r) = ((v[1] - ci[1])^2  + (v[2]-ci[2])^2) <= r^2
function solve(part=1,problem="p")
    grid = loadgrid(part=part,problem=problem)
    v = findfirst(==('@'),grid)
    #return [((ci != v) && dist(ci,v) <= 10) ? grid[ci]-'0' : 0 for ci in CartesianIndices(grid)]
    r = 10
    sum([((ci != v) && ispoint(ci,v,r)) ? grid[ci]-'0' : 0 for ci in CartesianIndices(grid)])
end

pt1 = solve(1)

function solve(part=1,problem="p")
    grid = loadgrid(part=part,problem=problem)
    v = findfirst(==('@'),grid)
    ds = [sum([((ci != v) && ispoint(ci,v,r) && !ispoint(ci,v,r-1)) ? grid[ci]-'0' : 0 for ci in CartesianIndices(grid)]) for r in 1:size(grid,1)]
    maximum(ds)*argmax(ds)
end


pt2 = solve(2)

ispoint(ci,v,r) = ((v[1] - ci[1])^2  + (v[2]-ci[2])^2) <= r^2
function solve(part=1,problem="p")
    grid = loadgrid(part=part,problem=problem)
    v = findfirst(==('@'),grid)
    S = findfirst(==('S'),grid)
    ngrid = [g == '@' ? Inf : g=='S' ? 0 : g - '0' for g in grid]
    qlen = size(grid,1)÷2
    midp = qlen + 1
    for r in 0:qlen
        g = getgrid(ngrid,v,r)
        maxtime = (r+1)*30
        ffa,pa = floodfill(g[:,1:midp],S,maxtime)
        ng = copy(g)
        ng[midp+1:end,midp-1] .= Inf
        ffb,pb = floodfill(ng,S,maxtime)
        st = ffa[midp+1:end,end] .+ ffb[midp+1:end,midp] .- ngrid[midp+1:end,midp]
        m = minimum(st)
        if m < maxtime
            cia = CartesianIndex(midp+argmin(st),midp)
            cib = cia #- CartesianIndex(0,qlen)
            highlight = union(pathto(pa,cia),pathto(pb,cib)) #.+ CartesianIndex(0,qlen))
            viewgrid(grid,r,highlight)
            return m * r,m,r
        end
    end
end

function getgrid(grid,v,r)
    g = copy(grid)
    [ispoint(ci,v,r) && (g[ci] = Inf) for ci in CartesianIndices(g)]
    g
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

function floodfill(grid,S,maxtime)
    val = fill(Inf,size(grid))
    val[S] = 0
    from = Dict()
    tovisit = [S]
    visited = Set()
    while !isempty(tovisit)
        ci = popfirst!(tovisit)
         # if !(ci in visited)
            push!(visited,ci)
            if val[ci] < maxtime
                for ni in adjacents(ci)
                    if ni in CartesianIndices(grid) && grid[ni] != Inf
                        if val[ni] > val[ci] + grid[ni]
                            val[ni] = val[ci] + grid[ni]
                            from[ni] = ci
                            if !(ni in tovisit)
                                push!(tovisit,ni)
                            end
                        end
                    end
                end
            end
        #end
    end
    [v >= maxtime ? Inf : v for v in val],from
end

function viewgrid(grid,r,highlight)
    v = findfirst(==('@'),grid)
    @info highlight
    g = [ispoint(ci,v,r) ? "." : ci in highlight ? "\033[92m$(grid[ci])\033[0m" : string(grid[ci]) for ci in CartesianIndices(grid)]
    s = join([join(row)*"\n" for row in eachrow(g)])
    print(s)
end


pt3 = solve(3)[1]