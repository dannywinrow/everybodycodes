include("../../helper.jl")

saveinputs()
saveexamples()

function solve(part=1,problem="p")

    grid = loadgrid()
    start = findfirst(==('@'),grid)
    vocal = findfirst(==('#'),grid)
    dirs = CircularArray([U,R,D,L])
    d = 1
    loc = start
    steps = 0
    while loc != vocal
        if grid[loc+dirs[d]] == '#'
            steps += 1
            break
        elseif grid[loc+dirs[d]] == '.'
            loc += dirs[d]
            grid[loc] = '+'
            steps += 1
        end
        d += 1 
    end
    steps
end

function isdone(grid,vocal::CI{2} = findfirst(==('#'),grid))
    dirs = vocal .+ directions
    all(grid[dirs] .!= '.')
end

function isdone(grid,vocals::Vector{CI{2}} = findall(==('#'),grid))
    all(isdone(grid,x) for x in vocals)
end

function isloop(grid,piece = findfirst(==('@'),grid))
    ch = piece
    curr = nothing
    cnt = 0
    for x in [U,R,D,D,L,L,U,U]
        ch += x
        if ch in CIs(grid)
            if grid[ch] == '.'
                if curr == '.'
                else
                    cnt += 1
                    curr = '.'
                end
            else
                if curr == '+'
                else
                    cnt += 1
                    curr = '+'
                end
            end
        else
            return false
        end
        if cnt == 4
            return true
        end
    end
    false
end

function floodgroup(grid,f)
    tovisit = [f]
    visited = CI{2}[]
    outty = false
    while !isempty(tovisit)
        p = popfirst!(tovisit)
        for g in p .+ directions
            if !in(g,visited) && !in(g,tovisit)
                if g in CIs(grid)
                    if grid[g] == '.'
                        push!(tovisit,g)
                    end
                else
                    outty = true
                end
            end
        end
        push!(visited,p)
    end
    return outty,visited
end

function floodfill!(grid)
    tovisit = findall(==('.'),grid)
    while !isempty(tovisit)
        outty,visited = floodgroup(grid,tovisit[1])
        if !outty
            grid[visited] .= '+'
        end
        tovisit = setdiff(tovisit,visited)
    end
end

function move!(grid,d,piece=findfirst(==('@'),grid);dirs=[U,R,D,L])
    for x in 1:length(dirs)
        newpiece = piece + dirs[d+x]
        if newpiece in CIs(grid)
            if grid[newpiece] == '.'
                grid[piece] = '+'
                piece = newpiece
                grid[piece] = '@'
                return piece,d+x
            end
        end
    end
    print(gridtostringfocus(grid))
    throw("Couldn't move")
end

function expandgrid(grid,n,t='.')
    x,y = size(grid)
    ngrid = fill('.',x+n*2,y+n*2)
    ngrid[n+1:n+x,n+1:n+y] .= grid
    ngrid
end

function solve2()
    grid = loadgrid(;part=2)
    grid = expandgrid(grid,25)

    piece = findfirst(==('@'),grid)
    vocal = findfirst(==('#'),grid)

    dirs = CircularArray([U,R,D,L])
    d = 0
    steps = 0
    println("Step: $steps")
    println(gridtostringfocus(grid))
    while !isdone(grid,vocal)
        piece,d = move!(grid,d,piece;dirs=dirs)
        steps += 1
        if isloop(grid,piece)
            floodfill!(grid)
        end
    end
    println("Step: $steps")
    println(gridtostringfocus(grid))
    steps
end
solve2()

function solve3()
        
    grid = loadgrid(;part=3)
    grid = expandgrid(grid,25)

    piece = findfirst(==('@'),grid)
    vocals = findall(==('#'),grid)
    dirs = CircularArray([U,U,U,R,R,R,D,D,D,L,L,L])
    d = 0
    steps = 0
    println("Step: $steps")
    println(gridtostringfocus(grid))
    debug = false
    while !isdone(grid,vocals)
        piece,d = move!(grid,d,piece;dirs=dirs)
        steps += 1
        if isloop(grid,piece)
            floodfill!(grid)
        end
    end
    println("Step: $steps")
    println(gridtostringfocus(grid))
    steps
end
solve3()