include("../../helper.jl")

fluffbolts = CircularArray(['R','G','B'])
function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    balloons = lines[1]
    if part == 1
        solveit(balloons,fluffbolts)
    elseif part == 2
        solveitcirc(balloons,100,fluffbolts)
    elseif part == 3
        solveitcirc(balloons,100000,fluffbolts)
    end
end

function solveit(balloons,fluffbolts)
    i = 1
    b = 1
    while b < length(balloons)
        if fluffbolts[i] != balloons[b]
            i += 1
        end
        b += 1
    end
    i
end


function solveitcirc(balloons,times,fluffbolts)
    br = repeat(balloons,times)
    brc = [x for x in br]
    i = 0
    while length(brc) > 0
        #@info i, fluffbolts[i+1], join(brc)
        even = iseven(length(brc))
        if !even
            i += 1
            popfirst!(brc)
        else
            pops = fill(false,length(brc) ÷ 2)
            y = 1
            for x in 1:length(pops)
                if even && brc[x] == fluffbolts[x+i]
                    pops[y] = true
                    y += 1
                else
                    if even
                        y += 1
                    end
                    even = !even
                end
            end
            i += length(pops)
            brc = brc[length(brc) ÷ 2 + 1:end][.!pops]
        end
    end
    i
end

pt1 = solve()
pt2 = solve(2)
pt3 = solve(3)

# For performance after solved

function solveitcircll(balloons,times,fluffbolts)
    brc = repeat([x for x in balloons],times)
    pops = fill(false,length(brc))
    even = iseven(length(brc))
    j = (length(brc) + 1) ÷ 2 + 1
    i = 0
    for x in 1:length(brc)
        if !pops[x]
            i += 1
            if brc[x] == fluffbolts[i] && even
                pops[j] = true
                j += 1
            else
                if even
                    j += 1
                end
                even = !even
            end
        end
    end
    length(brc) - sum(pops)
end


function solveitcircca(balloons,times,fluffbolts)
    brc = CircularArray([x for x in balloons])
    pops = []
    len = length(brc)*times
    even = iseven(len)
    j = (len + 1) ÷ 2 + 1
    i = 0
    k = 1
    for x in 1:length(brc)*times
        if k > length(pops) || x != pops[k]
            i += 1
            if brc[x] == fluffbolts[i] && even
                push!(pops,j)
                j += 1
            else
                if even
                    j += 1
                end
                even = !even
            end
        elseif k <= length(pops) && x == pops[k]
            k += 1
        end
    end
    len - length(pops)
end


function solveitcircca2(balloons,times,fluffbolts)
    brc = CircularArray([x for x in balloons])
    len = length(brc)*times
    even = iseven(len)
    pops = fill(false, (len ÷ 2))
    j = 1
    i = 0
    k = 1
    for x in 1:length(brc)*times
        if x <= (len + 1) ÷ 2 || !pops[x-(len+1)÷2]
            i += 1
            if brc[x] == fluffbolts[i] && even
                pops[j] = true
                j += 1
            else
                if even
                    j += 1
                end
                even = !even
            end
        end
    end
    len - sum(pops)
end

using BenchmarkTools

## Fastest is solveitcircll
## Most memory efficient is solveitcircca2

@benchmark solveitcirc(balloons,100000,fluffbolts)
@benchmark solveitcircll(balloons,100000,fluffbolts)
@benchmark solveitcircca(balloons,100000,fluffbolts)
@benchmark solveitcircca2(balloons,100000,fluffbolts)