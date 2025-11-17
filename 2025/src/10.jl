include("../../helper.jl")

saveinputs()
saveexamples()

v = [CartesianIndex(2,1),CartesianIndex(2,-1)]
kmoves = vcat(v,rotr90.(v),rotl90.(v),rot180.(v))

function solve(part=1,problem="p")
    grid = loadgrid(part=part,problem=problem)
    D = findfirst(==('D'),grid)
    s = fill(false,size(grid))
    s[D] = true
    for _ in 1:4
        for d in findall(==(true),s)
            for k in kmoves
                if k+d in CartesianIndices(s)
                    s[k+d] = true
                end
            end
        end
    end
    count(==('S'),grid[s])
end

pt1 = solve()


function solve(part=1,problem="p";visualise=false)
    grid = loadgrid(part=part,problem=problem)
    D = [findall(==('D'),grid)]
    G = findall(==('#'),grid)
    S = findall(==('S'),grid)
    s = fill(false,size(grid))
    for i in 1:20
        @info i
        push!(D,[])
        for d in D[end-1]
            for k in kmoves
                if k+d in CartesianIndices(s)
                    push!(D[end],k+d)
                end
            end
        end
        D[end] = unique(D[end])
    end
    eaten = 0
    for (i,d) in enumerate(D[2:end])
        if visualise
            println("Dragon turn $i:")
            viewdragons(size(grid),G,S,d)
        end
        if visualise
            println("Sheep turn $(i-1):")
            viewsheeps(size(grid),G,S,d)
        end

        eatenV = setdiff(intersect(S,d),G)
        eaten += length(eatenV)
        S = setdiff(S,eatenV)
        println("eaten $(length(eatenV)): $eatenV")

        S = S .+ CartesianIndex(1,0)
        filter!(x->x in CartesianIndices(grid),S)
        if visualise
            println("Sheep turn $i:")
            viewsheeps(size(grid),G,S,d)
            viewhides(size(grid),G,S,d)
        end
        eatenV = setdiff(intersect(S,d),G)
        eaten += length(eatenV)
        S = setdiff(S,eatenV)
        println("eaten $(length(eatenV)): $eatenV")
    end
    eaten
end

function viewsheeps(s,gates,sheeps,dragons)
    sheep = "S"
    protectedsheep = "\033[92m#\033[0m"
    eatensheep = "\033[91mX\033[0m"
    g = fill(".",s)
    g[sheeps] .= sheep
    g[intersect(sheeps,dragons)] .= eatensheep
    g[intersect(sheeps,dragons,gates)] .= protectedsheep
    println(gridtostring(g))
end

function viewdragons(s,gates,sheep,dragons)
    dragon = "X"
    g = fill(".",s)
    g[dragons] .= dragon
    println(gridtostring(g))
end

function viewhides(s,hides,sheep,dragons)
    hide = "#"
    usedhide = "\033[92m#\033[0m"
    g = fill(".",s)
    g[hides] .= hide
    g[intersect(sheep,hides)] .= usedhide
    println(gridtostring(g))
end

pt2 = solve(2)


function solve(part=1,problem="p";visualise=false)
    grid = loadgrid(part=part,problem=problem)
    D = findfirst(==('D'),grid)
    G = findall(==('#'),grid)
    S = findall(==('S'),grid)
    empty!(dp)
    wins(size(grid),D,S,G,false)
end

dp = Dict{Tuple{CartesianIndex{2},Vector{CartesianIndex{2}},Bool},Int}()
function dragonmoves(s,dragon)
    filter(x->(x in CartesianIndices(s)),dragon .+ kmoves)
end

function sheepmoves(s, sheep, dragon, hides)
    canmove = false
    r = Vector{CartesianIndex{2}}[]
    for i in eachindex(sheep)
        m = sheep[i] + CartesianIndex(1,0)
        if m != dragon || m in hides
            canmove = true
            if m[1] <= s[1]
                c = copy(sheep)
                c[i] = m
                push!(r,c)
            end
        end
    end
    canmove, r
end

function wins(s,dragon,sheep,hides,dragontomove)

    haskey(dp,(dragon,sheep,dragontomove)) && return dp[(dragon,sheep,dragontomove)]

    if isempty(sheep)
        return 1
    end

    dp[(dragon,sheep,dragontomove)] = 
        if dragontomove
            sum([wins(s,dm,filter(x-> x != dm || x in hides,sheep),hides,false) for dm in dragonmoves(s,dragon)])
        else
            cm,r = sheepmoves(s,sheep,dragon,hides)
            if cm
                if isempty(r)
                    0
                else
                    sum([wins(s,dragon,x,hides,true) for x in r])
                end
            else
                wins(s,dragon,sheep,hides,true)
            end
        end
end

dp



pt3 = solve(3,"i")

pt3 = solve(3)
