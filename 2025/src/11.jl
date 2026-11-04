include("../../helper.jl")

saveinputs()
saveexamples()


function solve1(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    cols = parse.(Int,lines)
    moved = true
    j = 0
    while moved
        moved = false
        for i in 1:length(cols)-1
            if cols[i] > cols[i+1]
                cols[i] -= 1
                cols[i+1] += 1
                moved = true
            end
        end
        moved && (j += 1)
        #@info cols
    end
    moved = true
    while moved
        moved = false
        for i in 1:length(cols)-1
            if cols[i] < cols[i+1]
                cols[i] += 1
                cols[i+1] -= 1
                moved = true
            end
        end
        moved && (j += 1)
        j == 10 && break
        #@info cols
    end
    sum(collect(1:length(cols)) .* cols)
end

function solve2(part=2,problem="p";rcols=nothing)
    lines = loadlines(part=part,problem=problem)
    cols = parse.(Int,lines)
    if !isnothing(rcols)
        cols = cols[rcols]
    end
    moved = true
    j = 0
    p0 = copy(cols)
    while moved
        moved = false
        for i in 1:length(cols)-1
            if cols[i] > cols[i+1]
                cols[i] -= 1
                cols[i+1] += 1
                moved = true
            end
        end
        moved && (j += 1)
        #@info cols
    end
    p1m = j
    p1 = copy(cols)
    moved = true
    while moved
        moved = false
        for i in 1:length(cols)-1
            if cols[i] < cols[i+1]
                cols[i] += 1
                cols[i+1] -= 1
                moved = true
            end
        end
        moved && (j += 1)
        #@info cols
    end
    j, p1m, j-p1m, p1, p0
end

function solve3(part=3,problem="p")
    lines = loadlines(part=part,problem=problem)
    cols = parse.(Int,lines)
    s = sum(cols)
    av = s ÷ length(cols)
    moves = cols .- av
    sum(filter(>(0),moves))
end

function flydir(cols)
    j = 0
    sections = []
    while j < length(cols)
        avs = [sum(cols[j+1:i]) / (i-j) for i in j+1:length(cols)]
        k = argmin(avs) + j
        push!(sections,j+1:k)
        j = k
    end
    phase1 = similar(cols)
    moves = 0
    @info sections
    m = []
    for sec in sections
        secav = sum(cols[sec]) ÷ length(sec)
        secrem = sum(cols[sec]) % length(sec)
        for i in eachindex(sec)
            phase1[sec[i]] = secav + (length(sec) - i < secrem)
        end
        #@info cols[sec],phase1[sec],sum(filter(>(0),cols[sec] .- phase1[sec]))
        diffs = cols[sec] .- phase1[sec]
        cs = cumsum(diffs)

        extras = 0 #secrem
        #count(>(0),phase1[1:argmax(cs)] .- (sum(phase1[1:argmax(cs)]) / argmax(cs)))
        secmoves = maximum(cs) + extras
        push!(m,secmoves)
        moves = max(secmoves,moves)
    end
    @info m
    phase1, moves, sections
end

function generalsolve3(part=3,problem="p")
    lines = loadlines(part=part,problem=problem)
    cols = parse.(Int,lines)
    p1, p1m, p1sec = flydir(cols)
    p2, p2m, p2sec = flydir(reverse(p1))
    p1m+p2m, p1m,p2m, p1, p2sec
end
collect(eachindex(3:5))
pt1 = solve1()
pt2 = solve2()
pt3 = solve3()
gs = generalsolve3(2)

pt2[5] .- pt2[4]

