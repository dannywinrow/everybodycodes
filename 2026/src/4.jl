include("../../helper.jl")

using DataFrames

function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    nums = getnums.(lines)
    df = DataFrame(permutedims(hcat(nums...),(2,1)),[:id,:quest,:part,:time])
    dfc = sort(combine(groupby(df,[:id]),:time=>sum=>:time),:time)
    sum(dfc.time .* collect(1:length(dfc.time)))

end

function solve2(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    nums = getnums.(lines)
    df = DataFrame(permutedims(hcat(nums...),(2,1)),[:id,:quest,:part,:time])
    dfc = combine(groupby(df,[:id]),:time=>sum=>:time, nrow => :parts)
    dfc.parts = .-(dfc.parts)
    sort!(dfc,[:parts,:time])
    sum(dfc.time .* collect(1:length(dfc.time)))

end

pt1 = solve()

pt2 = solve2(2)

function solve3(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    nums = getnums.(lines)
    df = DataFrame(permutedims(hcat(nums...),(2,1)),[:id,:quest,:part,:time])
    
    p = DataFrame()
    for i in sort(unique(df.quest))
        @info i
        append!(p,points(filter(x->x.quest == i,df)),cols=:union)
    end

    p = combine(groupby(p,:id),:apoints=>sum=>:apoints)
    sort!(p,:apoints,rev=true)
    p.rank = collect(1:length(p.id))
    leftjoin!(p,combine(groupby(p,:apoints),:rank=>minimum=>:arank),on=:apoints)

    sum(p.arank .* p.apoints)

end
function points(df)
    p1rank = sort(filter(x->x.part == 1,df),:time)
    
    p2rank = sort(filter(x->x.parts == 2, combine(groupby(filter(x->x.part <= 2,df),:id),:time=>sum=>:time, nrow=>:parts)),:time)
    @info p2rank

    p3rank = sort(filter(x->x.parts == 3, combine(groupby(filter(x->x.part <= 3,df),:id),:time=>sum=>:time, nrow=>:parts)),:time)

    p1rank.points = collect(50:-1:50-length(p1rank.time)+1)
    p1rank.points = (x->x<0 ? 0 : x).(p1rank.points)
    p2rank.points = collect(100:-1:100-length(p2rank.time)+1)
        p2rank.points = (x->x<0 ? 0 : x).(p2rank.points)
    p3rank.points = collect(150:-1:150-length(p3rank.time)+1)
        p3rank.points = (x->x<0 ? 0 : x).(p3rank.points)


    leftjoin!(p1rank,combine(groupby(p1rank,:time),:points=>maximum=>:apoints),on=:time)
    p1rank.part .= 1
    if !isempty(p2rank)
        leftjoin!(p2rank,combine(groupby(p2rank,:time),:points=>maximum=>:apoints),on=:time)
        p2rank.part .= 2
        append!(p1rank,p2rank,cols=:union)

    end
    if !isempty(p3rank)
        leftjoin!(p3rank,combine(groupby(p3rank,:time),:points=>maximum=>:apoints),on=:time)
        p3rank.part .= 3
        append!(p1rank,p3rank,cols=:union)
    end
    p1rank.quest .= df[1,:quest]
    p1rank
end


pt3 = solve3(3)
