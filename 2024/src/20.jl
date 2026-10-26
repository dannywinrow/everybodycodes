include("../../helper.jl")

struct Glidepath
    ci
    lastci
    moves
    alt
    tovisit
end
Glidepath(ci,lastci,moves,alt) = Glidepath(ci,lastci,moves,alt,nothing)

using DataStructures

function getpaths(part=1,problem="p")

    function nextstates(s::Glidepath)
        ncis = adjacents(s.ci)
        gps = Glidepath[]
        for nci in ncis
            if nci != s.lastci && nci in valids
                if grid[nci] == '+'
                    push!(gps,Glidepath(nci,s.ci,s.moves + 1, s.alt + 1))
                elseif grid[nci] == '-'
                    push!(gps,Glidepath(nci,s.ci,s.moves + 1, s.alt - 2))
                elseif grid[nci] == '.'
                    push!(gps,Glidepath(nci,s.ci,s.moves + 1, s.alt - 1))
                end
            end
        end
        gps
    end

    grid = loadgrid(part=part,problem=problem)
    start = findfirst(==('S'),grid)
    ups = findall(==('+'),grid)
    downs = findall(==('-'),grid)
    available = findall(==('.'),grid)
    valids = union(ups,downs,available)
    sps = Dict()
    pq = PriorityQueue()
    gp = Glidepath(start,nothing,0,1000)
    pq[gp] = -gp.alt - (100-gp.moves)
    while true
        s = dequeue!(pq)
        if s.moves == 100
            return s.alt
        end
        gps = nextstates(s)
        for gp in gps
            pq[gp] = -gp.alt - (100-gp.moves)
        end
    end
end

pt1 = getpaths()

function shortestpath(sgp,dest,valids)

    visited = []
    totraverse = [gp]
    sp = Dict()
    sp[gp] = 0
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

manhat(ci1,ci2) = sum(abs.(Tuple(ci1-ci2)))
function getpaths2(part=2,problem="p")

    grid = loadgrid(part=part,problem=problem)
    start = findfirst(==('S'),grid)
    ups = findall(==('+'),grid)
    downs = findall(==('-'),grid)
    available = findall(==('.'),grid)
    targetA = findfirst(==('A'),grid)
    targetB = findfirst(==('B'),grid)
    targetC = findfirst(==('C'),grid)
    route = [targetA,targetB,targetC,start]
    valids = union(ups,downs,available,route)

    function nextstates(s::Glidepath)
        ncis = adjacents(s.ci)
        gps = Glidepath[]
        for nci in ncis
            if nci != s.lastci && nci in valids
                newalt = s.alt - 1 + (grid[nci] == '+' ? 1 : grid[nci] == '-' ? -1 : 0)
                newtovisit = s.tovisit[1] == grid[nci] ? s.tovisit[2:end] : s.tovisit
                if grid[nci] != 'S' || s.alt > 10000
                    push!(gps,Glidepath(nci,s.ci,s.moves + 1, newalt,newtovisit))
                end
            end
        end
        gps
    end

    pq = PriorityQueue()
    gp = Glidepath(start,nothing,0,10000,route)

    function priority(gp)
        pr = max(10000-gp.alt,0)
        curr = gp.ci
        for t in gp.tovisit
            pr += manhat(curr,t)
            curr = t
        end
        pr * 10000 + gp.moves
    end

    pq[gp] = priority(gp)

    if nci in tree && !in(nci,visited)
        cost = 1 + sp[ci]
        fsp = get!(sp,nci,99999999)
        if cost < fsp
            sp[nci] = cost
            push!(totraverse,nci)
        end
    end
    while true
        s = dequeue!(pq)
        s.ci == 'A' && isempty(s.tovisit) && return s.moves
        for gp in nextstates(s)
            pq[gp] = priority(gp)
        end
    end
end
#getpaths2()


function getpaths2a(part=2,problem="p")

    grid = loadgrid(part=part,problem=problem)
    start = findfirst(==('S'),grid)
    ups = findall(==('+'),grid)
    downs = findall(==('-'),grid)
    available = findall(==('.'),grid)
    targetA = findfirst(==('A'),grid)
    targetB = findfirst(==('B'),grid)
    targetC = findfirst(==('C'),grid)
    route = [targetA]#,targetB,targetC,start]
    valids = union(ups,downs,available,route)

    function nextstates(s::Glidepath)
        ncis = adjacents(s.ci)
        gps = Glidepath[]
        for nci in ncis
            if nci != s.lastci && nci in valids
                newalt = s.alt - 1 + (grid[nci] == '+' ? 1 : grid[nci] == '-' ? -1 : 0)
                newtovisit = s.tovisit[1] == nci ? s.tovisit[2:end] : s.tovisit
                if grid[nci] != 'S' || s.alt > 10000
                    push!(gps,Glidepath(nci,s.ci,s.moves + 1, newalt,newtovisit))
                end
            end
        end
        gps
    end

    pq = PriorityQueue()
    gp = Glidepath(start,nothing,0,10000,route)
    sp = Dict()
    function priority(gp)
        #pr = max(10000-gp.alt,0)
        pr = 0
        curr = gp.ci
        for t in gp.tovisit
            pr += manhat(curr,t)
            curr = t
        end
        pr * 10000 + gp.moves
        length(gp.tovisit)*10000 + gp.moves
    end

    pq[gp] = priority(gp)

    ret = []
    i = 0
    while length(ret) < 100 && i < 1000000 && !isempty(pq)
        i += 1
        s = dequeue!(pq)
        #isempty(s.tovisit) && push!(ret,s)

        for gp in nextstates(s)
            if isempty(gp.tovisit)
                push!(ret,s)
            else
                if !haskey(sp,gp.ci)
                    sp[gp.ci] = gp
                    pq[gp] = priority(gp)
                else
                    ma = sp[gp.ci]
                    gp.moves < ma.moves || gp.moves == ma.moves && gp.alt > ma.alt
                    sp[gp.ci] = gp
                    pq[gp] = priority(gp)
                    #@info gp
                end
            end
        end
    end
    ret,pq,sp
end
#r,q,s = getpaths2a()



function getpaths2b(part=2,problem="p")

    grid = loadgrid(part=part,problem=problem)
    start = findfirst(==('S'),grid)
    ups = findall(==('+'),grid)
    downs = findall(==('-'),grid)
    available = findall(==('.'),grid)
    targetA = findfirst(==('A'),grid)
    targetB = findfirst(==('B'),grid)
    targetC = findfirst(==('C'),grid)
    route = [targetA]#,targetB,targetC,start]
    valids = union(ups,downs,available,route)

    function nextstates(s::Glidepath)
        ncis = adjacents(s.ci)
        gps = Glidepath[]
        for nci in ncis
            if nci != s.lastci && nci in valids
                newalt = s.alt - 1 + (grid[nci] == '+' ? 1 : grid[nci] == '-' ? -1 : 0)
                newtovisit = s.tovisit[1] == nci ? s.tovisit[2:end] : s.tovisit
                if grid[nci] != 'S' || s.alt > 10000
                    push!(gps,Glidepath(nci,s.ci,s.moves + 1, newalt,newtovisit))
                end
            end
        end
        gps
    end

    pq = PriorityQueue()
    gp = Glidepath(start,nothing,0,10000,route)
    sp = Dict()
    function priority(gp)
        #pr = max(10000-gp.alt,0)
        pr = 0
        curr = gp.ci
        for t in gp.tovisit
            pr += manhat(curr,t)
            curr = t
        end
        pr * 10000 + gp.moves
        gp.moves
    end

    pq[gp] = priority(gp)

    ret = []
    i = 0
    
    while length(ret) < 100 && i < 1000000 && !isempty(pq)
        i += 1
        s = dequeue!(pq)
        #isempty(s.tovisit) && push!(ret,s)

        for gp in nextstates(s)
            if isempty(gp.tovisit)
                push!(ret,s)
            else
                if !haskey(sp,gp.ci)
                    sp[gp.ci] = gp
                    pq[gp] = priority(gp)
                else
                    ma = sp[gp.ci]
                    gp.moves < ma.moves # || gp.moves == ma.moves && gp.alt > ma.alt
                    sp[gp.ci] = gp
                    pq[gp] = priority(gp)
                    #@info gp
                end
            end
        end
    end
    ret,pq,sp
end
#r,q,s = getpaths2b()


function getpaths2c(part=2,problem="p")

    grid = loadgrid(part=part,problem=problem)
    start = findfirst(==('S'),grid)
    ups = findall(==('+'),grid)
    downs = findall(==('-'),grid)
    available = findall(==('.'),grid)
    targetA = findfirst(==('A'),grid)
    targetB = findfirst(==('B'),grid)
    targetC = findfirst(==('C'),grid)
    route = [targetA,targetB,targetC,start]
    valids = union(ups,downs,available,route)
    sps = Dict()
    lcis = Dict()
    for x in route
        sps[x],lcis[x] = shortestpathgrid(x,valids,grid)
    end

    return sps, lcis, start, targetA, targetB, targetC, grid

end

function nextstates(s::Glidepath)
    ncis = adjacents(s.ci)
    gps = Glidepath[]
    for nci in ncis
        if nci != s.lastci && nci in valids
            newalt = s.alt - 1 + (grid[nci] == '+' ? 1 : grid[nci] == '-' ? -1 : 0)
            newtovisit = s.tovisit[1] == nci ? s.tovisit[2:end] : s.tovisit
            if grid[nci] != 'S' || s.alt > 10000
                push!(gps,Glidepath(nci,s.ci,s.moves + 1, newalt,newtovisit))
            end
        end
    end
    gps
end

function shortestpathgrid(leaf,tree,grid)
    start = leaf
    visited = []
    totraverse = [start]
    sp = Dict()
    lci = Dict()
    sp[start] = 0
    lci[start] = nothing
    while !isempty(totraverse)
        ci = popfirst!(totraverse)
        for d in directions
            nci = ci + d
            if nci in tree && !in(nci,visited)
                cost = (grid[nci] == '-' ? 3 : grid[nci] == '+' ? 0 : 2) + sp[ci]
                fsp = get!(sp,nci,99999999)
                if cost < fsp
                    sp[nci] = cost
                    lci[nci] = ci
                    push!(totraverse,nci)
                end
            end
        end
    end
    sp,lci
end

#sps, lcis, start, targetA, targetB, targetC, grid = getpaths2c()
      
#@info moves = sps[start][targetA] + sps[targetA][targetB] + sps[targetB][targetC] + sps[targetC][start]
function routeto(cia,cib)
    r = [cib]
    ci = cib
    while true
        ci = lcis[cia][ci]
        pushfirst!(r,ci)
        ci == cia && break
    end
    r
end

#rte = vcat(routeto(start,targetA),routeto(targetA,targetB)[2:end],routeto(targetB,targetC)[2:end],routeto(targetC,start)[2:end])
#count(==('+'),grid[rte[2:end]]) - count(==('-'),grid[rte[2:end]]) - count(!=('+'),rte[2:end])


struct Gstate
    ci
    lastci
    lchk
end

function shortestpathgridstate(startstate,tree,grid,route)
    visited = []
    totraverse = PriorityQueue()
    totraverse[startstate] = 0
    sp = Dict()
    sp[start] = 0
    while !isempty(totraverse)
        if length(totraverse) > 30000
            break
        end
        s = dequeue!(totraverse)
        if !(s in visited)
            push!(visited,s)
            ci = s.ci
            for d in directions
                nci = ci + d
                if nci in tree && nci != s.lastci
                    if grid[nci] == route[s.lchk+1]
                        nlchk = s.lchk+1
                    else
                        nlchk = s.lchk
                    end
                    ns = Gstate(nci,ci,nlchk)
                    cost = (grid[nci] == '-' ? 3 : grid[nci] == '+' ? 0 : 2) + sp[s]
                    fsp = get!(sp,ns,99999999)
                    if cost < fsp
                        sp[ns] = cost
                        totraverse[ns] = cost
                    end
                end
            end
        end
    end
    sp,totraverse
end

function getpaths2d(filename::String)
    grid = loadgrid(filename)
    getpaths2d(grid)
end

function getpaths2d(part=2,problem="p")
    grid = loadgrid(part=part,problem=problem)
    getpaths2d(grid)
end

function getpaths2d(grid::Matrix{Char})
    start = findfirst(==('S'),grid)
    ups = findall(==('+'),grid)
    downs = findall(==('-'),grid)
    available = findall(==('.'),grid)
    targetA = findfirst(==('A'),grid)
    targetB = findfirst(==('B'),grid)
    targetC = findfirst(==('C'),grid)
    route = [targetA,targetB,targetC,start]
    valids = union(ups,downs,available,route)
    sp,t = shortestpathgridstate(Gstate(leaf,nothing,1,"SABCDX"),valids,grid)
    sp[Gstate(start,start + CartesianIndex(1,0),4)]
end

sp,t = getpaths2d(getfilename(2024,20,2,"ex"))
sp[Gstate(CartesianIndex(1,5),CartesianIndex(2,5),4)]

sp,t = getpaths2d(getfilename(2024,20,2,"ey"))
sp[Gstate(CartesianIndex(1,16),CartesianIndex(2,16),4)]

sp,t = getpaths2d(getfilename(2024,20,2,"ez"))
sp[Gstate(CartesianIndex(1,16),CartesianIndex(2,16),4)]

sp,t = getpaths2d(getfilename(2024,20,2))
sp[Gstate(CartesianIndex(1,79),CartesianIndex(2,79),4)]












struct Gs
    ci
    lastci
end

function shortestpathgs(startstate,tree,grid)
    visited = []
    totraverse = PriorityQueue()
    totraverse[startstate] = 0
    sp = Dict()
    sp[startstate] = 0
    while !isempty(totraverse)
        s = dequeue!(totraverse)
        if !(s in visited)
            push!(visited,s)
            ci = s.ci
            for d in directions
                nci = ci + d
                if nci in tree && nci != s.lastci
                    ns = Gs(nci,ci)
                    cost = (grid[nci] == '-' ? 2 : grid[nci] == '+' ? 0 : 1) + sp[s]
                    fsp = get!(sp,ns,99999999)
                    if cost < fsp
                        sp[ns] = cost
                        totraverse[ns] = cost
                    end
                end
            end
        end
    end
    sp
end


function getpaths3(part=3,problem="p")
    grid = loadgrid(part=part,problem=problem)
    getpaths3(grid)
end

function getpaths3(grid::Matrix{Char})
    start = findfirst(==('S'),grid)
    ups = findall(==('+'),grid)
    downs = findall(==('-'),grid)
    available = findall(==('.'),grid)
    valids = union(ups,downs,available)
    startstate = Gs(start,nothing)
    dp = Dict{Tuple{Int,Int},Int}()
    for x in 1:size(grid,2)
        ss = Gs(CartesianIndex(1,x),nothing)
        s = shortestpathgs(ss,valids,grid)
        for y in 1:size(grid,2)
            st = Gs(CartesianIndex(size(grid,1),y),CartesianIndex(size(grid,1)-1,y))
            if haskey(s,st)
                dp[(x,y)] = s[Gs(CartesianIndex(size(grid,1),y),CartesianIndex(size(grid,1)-1,y))]
            end
        end
    end
    dp
end

dp1 = getpaths3()

function xjoin(dp1,dp2)
    dp = Dict{Tuple{Int,Int},Int}()
    for x in 2:62
        for y in 2:62
            dp[(x,y)] = minimum(get(dp1,(x,z),99999999) + get(dp2,(z,y),99999999) for z in 2:62)
        end
    end
    dp
    filter(v->v[2]<99999999,dp)
end

xdbl(dp1) = xjoin(dp1,dp1)

dp2 = xjoin(dp1,dp1)
dp4 = xjoin(dp2,dp2)
dp8 = xjoin(dp4,dp4)

while true
    minimum(values(dp)) < 384400
end

dp1[34,32]

11, 13


alt = 384400 - 1
1 + (alt ÷ 2)*4 + alt % 2

dp1[32,32]

