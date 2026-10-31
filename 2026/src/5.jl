include("../../helper.jl")

L = '#' #land
S = '=' #sand
W = '.' #water
T = '@' #tree

function solve(part=1,problem="p")
    grid = loadgrid(part=part,problem=problem)
    findland!(grid)
    findwater!(grid)
    
    if part >= 2
        findbeach!(grid)
        findsand!(grid)
    end

    if part >= 3
        findtrees!(grid)
        growtrees!(grid)
        growtrees!(grid)
    end

    print(gridtostring(grid))

    count(==([L,S,T][part]),grid)

end

function findtrees!(grid)
     tovisit = findall(==(L),grid)
     ds = cartesiancube(2,false,2,false)
     for v in tovisit
        ns = v .+ ds
        if all(in([L,T]),grid[ns])
            grid[v] = T
        end
     end
end

function growtrees!(grid)
    ngrid = copy(grid)
    tovisit = findall(==(L),grid)
    ds = cartesiancube(2,false,1)
    for v in tovisit
        ns = v .+ ds
        if count(==(T),grid[ns]) >= 4 && count(==(S),grid[ns]) == 0
            ngrid[v] = T
        end
    end
    grid .= ngrid
end


function findsand!(grid)
    
    tovisit = findall(==(L),grid)
    while !isempty(tovisit)
        v = popfirst!(tovisit)
        ns = filter(x->x in CartesianIndices(grid),neighbours(v))
        if grid[v] == L && count(==(S),grid[ns]) >= 5
            grid[v] = S
            append!(tovisit,filter(x->grid[x]==L,ns))
        end
    end
end

function findbeach!(grid)
    tovisit = findall(==(L),grid)
    while !isempty(tovisit)
        v = popfirst!(tovisit)
        ns = filter(x->x in CartesianIndices(grid),neighbours(v))
        if length(ns) < 8 || any(==(W),grid[ns])
            grid[v] = S
        end
    end
end
function findwater!(grid)

    grid .= (x->x==L ? L : W).(grid)
    
end

function findland!(grid)
    ci = CI(ceil.(Int,size(grid) ./ 2))

    tovisit = [ci]

    while !isempty(tovisit)
        v = popfirst!(tovisit)
        ns = filter(x->x in CartesianIndices(grid),neighbours(v))
        if v == ci || (grid[v] != '#' && count(x-> grid[x] == '#' || grid[x] == '1',ns) >= 5) 
            grid[v] = '#'
            for nv in ns
                if nv in CartesianIndices(grid) && grid[nv] != '#' 
                    push!(tovisit,nv)
                end
            end
        end
    end
end

pt1 = solve()

pt2 = solve(2)

pt3 = solve(3)