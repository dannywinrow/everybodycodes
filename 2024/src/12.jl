include("../../helper.jl")

function solve1(filename)
    grid = loadgrid(filename)
    a = findfirst(==('A'),grid)
    b = findfirst(==('B'),grid)
    c = findfirst(==('C'),grid)
    t = findall(==('T'),grid)
    hs = findall(==('H'),grid)
    fromto = Dict()
    totalpower = 0
    for (i,from) in enumerate(vcat(a,b,c)), to in t
        l = to[2]-from[2]
        h = to[1]-from[1]
        if (l-h) % 3 == 0
            power =  (l-h) ÷ 3
            fromto[(from,to)] = power
            totalpower += power * i
        end
    end
    for (i,from) in enumerate(vcat(a,b,c)), to in hs
        l = to[2]-from[2]
        h = to[1]-from[1]
        if (l-h) % 3 == 0
            power =  (l-h) ÷ 3
            fromto[(from,to)] = power
            totalpower += 2 * power * i
        end
    end
    totalpower
end

pt1 = solve1(getfilename(2024,12,1))
@show pt1

pt2 = solve1(getfilename(2024,12,2))
@show pt2

function solve3(filename)
    lines = loadlines(filename)
    meteors = [CartesianIndex(parse.(Int,split(line," "))...) for line in lines]
    sum(power.(meteors))
end

function power(meteor)
    time = (meteor[1] + 1) ÷ 2
    pos = meteor - CartesianIndex(time,time)
    powerofpos(pos)
end

function powerofpos(pos)   
    l = pos[1]
    h = pos[2]

    if l == h
        # A fires and hits on up
        power = h
    elseif l == h - 1
        # A can't hit, B will hit with less power
        power = 2*(h - 1)
    elseif l == h - 2
        # Only C can hit
        power = 3*(h - 2)
    elseif l < h - 2
        @warn "$pos can never be hit"
    elseif l <= h*2
        # A hits by reaching the height and going along
        power = h
    else
        # can only be hit by up along and drop
        power = (((l+h) % 3)+1) * ((l+h) ÷ 3)
    end
    power
end

pt3 = solve3(getfilename(2024,12,3))
@show pt3