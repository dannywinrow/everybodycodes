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

function solve2(part=2,problem="p")
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
        #@info cols
    end
    j
end

function solve3(part=3,problem="p")
    lines = loadlines(part=part,problem=problem)
    cols = parse.(Int,lines)
    s = sum(cols)
    av = s ÷ length(cols)
    moves = cols .- av
    sum(filter(>(0),moves))
end

pt1 = solve1()
pt2 = solve2()
pt3 = solve3()
