include("../../helper.jl")

function solve1(filename)
    grid = loadgrid(filename)
    start = CartesianIndex(1,findfirst(==('.'),grid[1,:]))
    herbs = findall(==('H'),grid)
    available = findall(==('.'),grid)
    valid = union(herbs,available)
    visited = []
    totraverse = [start]
    sp = Dict()
    sp[start] = 0
    while !isempty(totraverse)
        ci = popfirst!(totraverse)
        for d in directions
            nci = ci + d
            if nci in valid && !in(nci,visited)
                cost = 1 + sp[ci]
                fsp = get!(sp,nci,99999999)
                if cost < fsp
                    sp[nci] = cost
                    push!(totraverse,nci)
                end
            end
        end
    end
    minimum(sp[herb] for herb in herbs) * 2
end

pt1 = solve1(getfilename(2024,15,1))
@show pt1

using Combinatorics

function solve2(filename)
    grid = loadgrid(filename)
    start = CartesianIndex(1,findfirst(==('.'),grid[1,:]))
    #herbdict()
    #for herbsym in 'A':'E'
    herbs = findall(in(['A','B','C','D','E']),grid)
    available = findall(==('.'),grid)
    valid = union(herbs,available)
    sps = Dict()
    for herb in herbs
        sp = shortestpath(herb,valid)
        sps[herb] = sp
    end
    #return sps
    herbdict = Dict()
    for x in 'A':'E'
        herbdict[x] = filter(herb->grid[herb]==x,herbs)
    end
    
    order = "ABCDE"
    perms = collect(permutations(order))
    dists = [collectherbs(sps,herbdict,start,o) for o in perms]
    perms[argmin(dists)]

    hcs = [minimum(routedist.(Ref(sps),herbcombs(herbdict,order),Ref(start))) for order in perms]
    minimum(ans)
end

function routedist(sps,cis,start)
    dist = 0
    for i in 1:(length(cis) - 1)
        dist += sps[cis[i]][cis[i+1]]
    end
    dist += sps[cis[1]][start]
    dist += sps[cis[end]][start]
    dist
end

function collectherbs(sps,herbdict,start,order)
    pos = start
    totdist = 0
    for x in order
        minherb = nothing
        mindist = 99999999
        for herb in herbdict[x]
            dist = sps[herb][pos]
            if dist < mindist
                mindist = dist
                minherb = herb
            end
        end
        pos = minherb
        totdist += mindist
    end
    totdist += sps[pos][start]
end

function herbcombs(herbdict,order)
    t = []
    for x in order
        push!(t,1:length(herbdict[x]))
    end
    #@show CartesianIndices(Tuple(t))
    combs = []
    for ci in CartesianIndices(Tuple(t))
        comb = []
        for i in 1:length(ci)
            push!(comb,herbdict[order[i]][ci[i]])
        end
        push!(combs,comb)
    end
    combs
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

pt2 = solve2(getfilename(2024,15,2))
@show pt2

function getpaths(filename)
    grid = loadgrid(filename)
    start = findfirst(==('S'),grid)
    herbs = findall(in('A':'S'),grid)
    available = findall(==('.'),grid)
    valid = union(herbs,available)
    sps = Dict()
    for herb in herbs
        sp = shortestpath(herb,valid)
        sps[herb] = sp
    end
    herbdict = Dict()
    for x in 'A':'R'
        herbdict[x] = filter(herb->grid[herb]==x,herbs)
    end
    filter!(((k,v),)->!isempty(v),herbdict)
    Maze(grid, sps, herbdict, start)
end

struct Maze
    grid
    sps
    herbdict
    start
end

herbnames(maze::Maze) = collect(keys(maze.herbdict))

dp = Dict{Tuple{CartesianIndex{2},Set{Char}},Int}()
function solve3dp(m::Maze,ci,herbs)
    haskey(dp,(ci,herbs)) && return dp[(ci,herbs)]
    isempty(herbs) && return (dp[(ci,herbs)] = m.sps[ci][m.start])
    dp[(ci,herbs)] = minimum(
        [
            minimum(
                [m.sps[ci][nci] + solve3dp(m,nci,setdiff(herbs,herb)) for nci in m.herbdict[herb]]
            ) for herb in herbs
        ]
    )
end


function simplifygrid(part=3)
    grid = loadgrid(part=part)
    start = CartesianIndex(1,findfirst(==('.'),grid[1,:]))
    grid[start] = 'S'
    changesmade = true
    while changesmade
        changesmade = false
        for ci in findall(==('.'),grid)
            if count(==('#'),grid[adjacents(ci)]) >= 3
                grid[ci] = '#'
                changesmade = true
            end
            if count(==('#'),grid[adjacents(ci)]) == 2
                for d in directions
                    if grid[ci+d] == grid[ci+rotl90(d)] == '#' && grid[ci-(d + rotl90(d))] != '#'
                        grid[ci] = '#'
                        changesmade = true
                    end
                end
            end 
        end
        for ci in findall(in('A':'Z'),grid)
            if grid[ci] != 'S'
                if count(==('#'),grid[adjacents(ci)]) == 3 && count(==(grid[ci]),grid[adjacents(ci)]) == 1
                    grid[ci] = '#'
                    changesmade = true
                end 
            end
        end
    end
    outstr = join(join(row)*"\n" for row in eachrow(grid))
    write("2024/inputs/15p$(part)simp.txt",outstr)
    grid
end

### The maze input was simplified first using the function simplifygrid.  I then went through
### the input and manually removed herbs which could reach another herb of the same type before
### an exit.  E.g. a line of As were surrounded by poison on one side and poison with 3 gaps
### (exits) on the other side.  Only the 3 As nearest to the exits are relevant for shortest
### path.
m = getpaths("2024/inputs/15p3man.txt")

pt3 = solve3dp(m,m.start,Set(collect(keys(m.herbdict))))
@show pt3


### FAILED ATTEMPT TO USE PriorityQueue to solve part 3

struct Path
    ci
    visited
end
Path(maze::Maze) = Path(maze.start,Set())
Base.:(==)(path1::Path,path2::Path) = path1.ci == path2.ci && path1.visited == path2.visited
notvisited(path::Path,maze::Maze) = filter(!in(path.visited),herbnames(maze))
visit(ci::CartesianIndex,path::Path,maze::Maze) = Path(ci,path.visited*maze.grid[ci])
dist(ci::CartesianIndex,path::Path,maze::Maze) = maze.sps[path.ci][ci]

using DataStructures

function solve3(m::Maze)
    pq = PriorityQueue{Path,Int}()
    pq[Path(m)] = 0
    i = 0
    while true
        i += 1
        #@info "Loop $i"
        path, dis = dequeue_pair!(pq)
        #@show path.visited, dis, path
        'S' in path.visited && return dis

        tovisit = notvisited(path,m)
        if length(tovisit) == 1
            nhl = union(Set([herb,'S']),path.visited)
            for nci in m.herbdict[herb]
                newpath = Path(start,nhl)
                newdist = dis + m.sps[path.ci][nci] + m.sps[nci][start]
                if get!(pq,newpath,typemax(Int)) > newdist
                    pq[newpath] = newdist
                end
            end
        else
            for herb in tovisit
                nhl = union(Set(herb),path.visited)
                for nci in m.herbdict[herb]
                    newpath = Path(nci,nhl)
                    newdist = dis + m.sps[path.ci][nci]
                    if get!(pq,newpath,typemax(Int)) > newdist
                        pq[newpath] = newdist
                    end
                end
            end
        end
    end
end