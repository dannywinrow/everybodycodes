include("../../helper.jl")

saveinputs()
saveexamples()

diagonals = [CartesianIndex(1,1),CartesianIndex(-1,1),CartesianIndex(1,-1),CartesianIndex(-1,-1)]
function solve(part=1,problem="p")
    grid = loadgrid(part=part,problem=problem)
    g = copy(grid)
    x = 0
    v = []
    if part == 1
        r = 10
    else
        r = 2025
    end
    for _ in 1:r
        g = doround(g)
        #viewgrid(g)
        push!(v,count(==('#'),g))
        x += count(==('#'),g)
    end
    x
end

function counton(ci,grid)
        x = 0
        for d in diagonals
            nci = d + ci
            if nci in CartesianIndices(grid)
                #@info grid[nci]
                if grid[nci] == '#'
                    #@info "added"
                    x += 1
                end
            end
        end
        #@info "x=",x
        x
end

function doround(grid)
    ngrid = deepcopy(grid)
    
    for ci in CartesianIndices(grid)
        if grid[ci] == '.'
            #@info counton(ci)
            if counton(ci,grid) % 2 == 0
                ngrid[ci] = '#'
            end
        else
            #@info counton(ci)
            if counton(ci,grid) % 2 == 0
                ngrid[ci] = '.'
            end
        end
    end
    ngrid
end
function viewgrid(g)
    for r in eachrow(g)
        println(join(r))
    end
    print("\n")
end

pt1 = solve(1)
pt2 = solve(2)

function solve(part=1,problem="p")
    grid = loadgrid(part=part,problem=problem)
    #viewgrid(grid)
    #@info size(grid)
    g = fill('.',(34,34))
    #viewgrid(g)
    n = size(grid)[1]
    middle = CartesianIndices((14:21,14:21))
    #@info size(g[middle])
    x = 0
    v = []
    w = []
    for i in 1:1000000000
        g = doround(g)
        f = findfirst(==(g),v)
        if isnothing(f)
            push!(v,g)
            #viewgrid(g)
            if g[middle] == grid
                push!(w,count(==('#'),g))
            else
                push!(w,0)
            end
        else
            replen = length(v) - f + 1
            init = f - 1
            reps = (1000000000-init) ÷ replen
            rems = (1000000000-init) % replen
            #@info replen,init,reps,rems,w
            x = reps*sum(w[f:end])+sum(w[f:f+rems-1])
            break
        end
    end
    x
end

pt3 = solve(3)