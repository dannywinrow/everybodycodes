include("../../helper.jl")

function solve1(filename)
    grid = loadgrid(filename;type=Int,delim=" ")
    lines = CircularArray([copy(c) for c in eachcol(grid)])
    last([doround!(lines,i) for i in 1:10])
end

function doround!(lines,n=1)
    a = popfirst!(lines[n])
    pos = CircularArray([1:length(lines[n+1])...,length(lines[n+1]):-1:2])[a]
    insert!(lines[n+1],pos,a)
    sum(d * 10 ^ (i-1) for (i,d) in enumerate(reverse(first.(lines))))
end

pt1 = solve1(getfilename(2024,5,1))
@show pt1

struct Dance
    dance
    nextlinenum
end
Base.:(==)(a::Dance, b::Dance) = (a.dance == b.dance) && (a.nextlinenum == b.nextlinenum)

function next(d::Dance)
    lines = deepcopy(d.dance)
    n = d.nextlinenum
    a = popfirst!(lines[n])
    pos = CircularArray([1:length(lines[n+1])+1...,length(lines[n+1]):-1:2...])[a]
    insert!(lines[n+1],pos,a)
    shout = parse(Int,join(first.(lines)))
    (shout,Dance(lines,n == length(lines) ? 1 : n + 1))
end


function solve2(filename)
    grid = loadgrid(filename;type=Int,delim=" ")
    d = Dance(CircularArray([copy(c) for c in eachcol(grid)]),1)
    shouts = Dict()
    i = 0
    while true
        i += 1
        shout,d = next(d)
        cnt = get!(shouts,shout,0)
        shouts[shout] += 1
        if cnt == 2023
            return i*shout, i , shout
        end
    end
end

pt2ex = solve2(getfilename(2024,5,2,"ex"))

pt2 = solve2(getfilename(2024,5,2))


function solve3(filename)
    grid = loadgrid(filename;type=Int,delim=" ")
    d = Dance(CircularArray([copy(c) for c in eachcol(grid)]),1)
    shouts = []
    dances = [d]
    repeatsat = 0
    while true
        shout,d = next(d)
        push!(dances,d)
        push!(shouts,shout)
        if d in dances[1:end-1]
            repeatsat = findfirst(==(d),dances)
            break
        end
    end

    return maximum(shouts)
end

pt3 = solve3(getfilename(2024,5,3))



# Originally tried to solve part 2 by finding a loop, but this was infeasible, brute count
# worked and used part of this solution to solve pt3


function solve2(filename)
    #lines = loadlines(filename)
    grid = loadgrid(filename;type=Int,delim=" ")
    d = Dance(CircularArray([copy(c) for c in eachcol(grid)]),1)
    shouts = []
    dances = [d]
    repeatsat = 0
    while true
        shout,d = next(d)
        push!(dances,d)
        push!(shouts,shout)
        if d in dances[1:end-1]
            repeatsat = findfirst(==(d),dances)
            break
        end
    end

    leadshouts = []
    repeatshouts = []
    if repeatsat == 1
        leadshouts = []
        repeatshouts = shouts
    else
        leadshouts = shouts[1:repeatsat-1]
        repeatshouts = shouts[repeatsat:end]
    end

    #return leadshouts, repeatshouts
    
    shoutcnt = Dict{Int,Int}()
    i = 0
    for s in leadshouts
        shoutcnt[s] = get!(shoutcnt,s,0) + 1
        i += 1
    end
    for s in repeatshouts
        shoutcnt[s] = get!(shoutcnt,s,0) + 1
        i += 1
    end
    b = true
    sh = 0
    while sh == 0
        for s in repeatshouts
            shoutcnt[s] += 1
            i += 1
            if shoutcnt[s] == 2024
                sh = s
                break
            end
        end
    end
    sh * i,sh,i,leadshouts,repeatshouts
end