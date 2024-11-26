include("../../helper.jl")

function solve1(filename)
    lines = loadlines(filename)
    sum(solve.(parse.(Int,lines),Ref(stampdict())))
end

function solve(num,dd)
    if num > 20
        tens = num ÷ 10 - 1
        dd[num - tens*10] + tens
    else
        dd[num]
    end
end

function stampdict()
    stamps = [1,3,5,10]
    dd = Dict{Int,Int}()
    for s in stamps
        dd[s] = 1
    end

    function smallest(i)
        if !haskey(dd,i)
            dd[i] = 1 + minimum(smallest(i-s) for s in filter(x->x<i,stamps))
        end
        dd[i]
    end

    for i in 1:20
        smallest(i)
    end
    dd
end

pt1 = solve1(getfilename(2024,9,1))
@show pt1

function solve2(filename)
    lines = loadlines(filename)
    sparks = parse.(Int,lines)
    stamps = [1, 3, 5, 10, 15, 16, 20, 24, 25, 30]
    sd = stampdict(stamps,maximum(sparks))
    sum(getindex.(Ref(sd),sparks))
end

function stampdict(stamps,n)

    dd = Dict{Int,Int}()
    for s in stamps
        dd[s] = 1
    end

    function smallest(i)
        if !haskey(dd,i)
            dd[i] = 1 + minimum(smallest(i-s) for s in filter(x->x<i,stamps))
        end
        dd[i]
    end

    for i in 1:n
        smallest(i)
    end
    dd
end

pt2 = solve2(getfilename(2024,9,2))
@show pt2

function solve3(filename)
    lines = loadlines(filename)
    sparks = parse.(Int,lines)
    stamps = [1, 3, 5, 10, 15, 16, 20, 24, 25, 30, 37, 38, 49, 50, 74, 75, 100, 101]

    sd = stampdict(stamps,maximum(sparks) ÷ 2 + 51)

    sum(solvespark.(sparks,Ref(sd)))
end

function solvespark(spark,sd)
    lower = spark ÷ 2 - 50 + spark % 2
    bests = []
    for i in 0:50
        l = lower + i
        h = spark - l
        if l <= h
            push!(bests,sd[l]+sd[h])
        end
    end
    minimum(bests)
end

pt3 = solve3(getfilename(2024,9,3))
@show pt3