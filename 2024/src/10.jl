include("../../helper.jl")

function solve1(filename)
    grid = loadgrid(filename)
    dots = findall(==('.'),grid)
    for dot in dots
        row = vcat(grid[dot[1],1:2],grid[dot[1],end-1:end])
        col = vcat(grid[1:2,dot[2]],grid[end-1:end,dot[2]])
        grid[dot] = intersect(row,col)[1]
    end
    g = grid[CartesianIndex(3,3):CartesianIndex(6,6)]
    ret = ""
    for r in eachrow(g)
        ret *= join(r)
    end
    ret
end

function solvegrid(grid)
    dots = findall(==('.'),grid)
    for dot in dots
        row = vcat(grid[dot[1],1:2],grid[dot[1],end-1:end])
        col = vcat(grid[1:2,dot[2]],grid[end-1:end,dot[2]])
        inter = intersect(row,col)
        if !isempty(inter)
            grid[dot] = inter[1]
        end
    end
    g = grid[CartesianIndex(3,3):CartesianIndex(6,6)]
    ret = ""
    for r in eachrow(g)
        ret *= join(r)
    end
    ret
end

function removeelementsin(a,b)
    @assert length(a) >= length(b)
    abefore = copy(a)
    for x in b
        f = findfirst(==(x),a)
        if !isnothing(f)
            deleteat!(a,f)
        else
            #@warn "removeelements, can't remove $x from $a, inputs: $abefore, $b"
            return []
        end
    end
    a
end

function guessgrid!(grid)
    dots = findall(==('.'),grid)
    for dot in dots
        row = vcat(grid[dot[1],1:2],grid[dot[1],end-1:end])
        col = vcat(grid[1:2,dot[2]],grid[end-1:end,dot[2]])
        inter = intersect(row,col)
        if !isempty(inter)
            grid[dot] = inter[1]
        end
    end
    runegrid = CartesianIndex(3,3):CartesianIndex(6,6)
    function massagerow(r,grow)
        if count(==('.'),grow) == 1
            if count(==('?'),r) == 0
                sd = removeelementsin(copy(r),filter(!=('.'),grow))
                if isempty(sd)
                    #@warn "r=$r, grow=$grow, sd=$sd, parent=$(parentindices(grow))"
                else
                    grow[findfirst(==('.'),grow)] = sd[1]
                end
            end
        end
        if count(==('.'),grow) == 0
            if count(==('?'),r) == 1
                sd = removeelementsin(copy(grow),filter(!=('?'),r))
                if isempty(sd)
                    #@warn "r=$r, grow=$grow, sd=$sd, parent=$(parentindices(grow))"
                else
                    r[findfirst(==('?'),r)] = sd[1]
                end
            end
        end
    end
    for row in eachrow(runegrid)
        r = @view grid[row[1][1],[1:2...,end-1:end...]]
        grow = @view grid[row]
        massagerow(r,grow)
    end
    for row in eachcol(runegrid)
        r = @view grid[[1:2...,end-1:end...],row[1][2]]
        grow = @view grid[row]
        massagerow(r,grow)
    end
end

function powerofword(word)
        sum((x - 'A' + 1)*i for (i,x) in enumerate(word);init=0)
end

pt1 = solve1(getfilename(2024,10,1))
@show pt1

function solve2(filename)
    grid = loadgrid(filename)
    minigrids = [grid[(ci * 9 - CartesianIndex(8,8)):(ci * 9 - CartesianIndex(1,1))] for ci in CartesianIndices((size(grid) .+ 1) .÷ 9)]
    words = solvegrid.(minigrids)
    powers = powerofword.(words)
    sum(powers)
end

pt2 = solve2(getfilename(2024,10,2))
@show pt2

function extractword(grid)
    g = grid[CartesianIndex(3,3):CartesianIndex(6,6)]
    ret = ""
    if count(==('.'),g) == 0
        for r in eachrow(g)
            ret *= join(r)
        end
    end
    ret
end

function solve3(filename)
    grid = loadgrid(filename)
    minigrids = [@view grid[(ci * 6 - CartesianIndex(5,5)):(ci * 6 + CartesianIndex(2,2))] for ci in CartesianIndices((size(grid) .- 2) .÷ 6)]
    [guessgrid!.(minigrids) for _ in 1:3]
    words = extractword.(minigrids)
    powers = powerofword.(words)
    sum(powers)
end

pt3 = solve3(getfilename(2024,10,3))
@show pt3