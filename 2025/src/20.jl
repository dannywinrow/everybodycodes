include("../../helper.jl")

saveinputs()
saveexamples()

function solve(part=1,problem="p")
    grid = loadgrid(part=part,problem=problem)
    Ts = findall(==('T'),grid)
    x = 0
    for ci in Ts
        for tci in trineighs(ci)
            if tci in Ts
                x += 1
            end
        end
    end
    x ÷ 2
end


function trineighs(ci)
    v = [(0,1),(0,-1)]
    if iseven(ci[1]+ci[2])
        push!(v,(-1,0))
    else
        push!(v,(1,0))
    end
    ci .+ CartesianIndex.(v)
end

pt1 = solve(1)

function viewgrid(grid)
    for row in eachrow(grid)
        println(join(row))
    end
end

function solve(part=1,problem="p")
    grid = loadgrid(part=part,problem=problem)
    Ts = findall(==('T'),grid)
    S = findfirst(==('S'),grid)
    E = findfirst(==('E'),grid)
    x = 0
    tovisit = [S]
    visited = []
    d = Dict(Ts.=>Inf)
    d[E] = Inf
    d[S] = 0
    while !isempty(tovisit)
        ci = popfirst!(tovisit)
        if ci == E
            return d[ci]
        end
        if !(ci in visited)
            push!(visited,ci)
            for tci in trineighs(ci)
                if tci in [E,Ts...]
                    if d[ci] + 1 < d[tci]
                        d[tci]= d[ci]+1
                        push!(tovisit,tci)
                    end
                end
            end
        end
    end
    d,S,E,Ts
end
solve(2)


function trirotgrid(grid)
    p = findall(!=('.'),grid)
    ngrid = fill('.',size(grid))
    mid = CartesianIndex((size(grid,2)+1) ÷ 2,size(grid,1))
    ngrid[trirot.(p,mid)] .= grid[p]
    ngrid
end

"""
    trirot(ci,mid)

Rotate ci of a grid representation of equilateral triangles by 120° anticlockwise
This formula was devised by looking at rewriting the triangle row by row
The first cell CI(1,1) gets filled with the lowest point on the grid, which I have called `mid`
and which is provided to trirot.
From mid, the next cell CI(1,2) is in the direction (-1,0) then the next in direction (0,-1) and so on
The next row starts at CI(2,2) to get there from mid, we add CI(-1,1)

by starting at its lowest point on the grid representation

The lowest point becomes CI(1,1) 
"""
function trirot(ci,mid)
    x = ci[1]
    y = ci[2] 
    mid + (x-1)*CI(-1,1) + ((y-x) ÷ 2)*CI(0,-1) + ((y-x+1) ÷ 2)*CI(-1,0)
end

function trineighsrot(ci,mid)
    v = [(0,1),(0,-1),(0,0)]
    if iseven(ci[1]+ci[2])
        push!(v,(-1,0))
    else
        push!(v,(1,0))
    end
    trirot.(ci .+ CartesianIndex.(v),mid)
end

function solve(part=1,problem="p")
    grid = loadgrid(part=part,problem=problem)
    Ts = findall(==('T'),grid)
    S = findfirst(==('S'),grid)
    E = findfirst(==('E'),grid)
    x = 0
    mid = CartesianIndex((size(grid,2)+1) ÷ 2,size(grid,1))
    tovisit = [S]
    visited = []
    d = Dict(Ts.=>typemax(Int))
    d[E] = typemax(Int)
    d[S] = 0
    while !isempty(tovisit)
        ci = popfirst!(tovisit)
        if ci == E
            return d[ci]
        end
        if !(ci in visited)
            push!(visited,ci)
            for tci in trineighsrot(ci,mid)
                if tci in [E,Ts...]
                    if d[ci] + 1 < d[tci]
                        d[tci]= d[ci]+1
                        push!(tovisit,tci)
                    end
                end
            end
        end
    end
    d,S,E,Ts
end

pt3 = solve(3)
