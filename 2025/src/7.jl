include("../../helper.jl")

saveinputs()

function getvalids(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    names = split(lines[1],",")
    rules = lines[3:end]
    rules = Dict(parserule.(rules))
    #@info names, rules
    x = []
    for (i,name) in enumerate(names)
        m = true
        for i in 1:length(name)-1
            a = string(name[i])
            b = string(name[i+1])
            #@info name[i+1], get(rules,a,[])
            if m && haskey(rules,a)
                if b in rules[a]
                    continue
                else
                    m = false
                end
            else
                m = false
            end
        end
        push!(x,m)
    end
    valids = x .== true
    names,valids,rules
end

function solve1()
    n,valid,rules = getvalids(1)
    n[valid][1]
end

function solve2(problem="p")
    n,valid,rules = getvalids(2,problem)
    sum(collect(1:length(valid))[valid])
end

function solve3(problem="p")
    n,valids,rules = getvalids(3,problem)
    x = n[valids]
    x = x[[sum(occursin.(x,Ref(p))) == 1 for p in x]]
    global dp = Dict()
    v = sum([countfrom(a[end],11-length(a),rules) for a in x])
end

function countfrom(a,len,rules)
    if haskey(dp,(a,len))
        return dp[(a,len)]
    elseif len == 0
        f = 0
    elseif haskey(rules,string(a))
        f = sum([countfrom(w,len-1,rules) for w in rules[string(a)]])
    else
        f = 0
    end
    if len <= 4
        f += 1
    end
    dp[(a,len)] = f
    f
end

function parserule(line)
    a,v = split(line," > ")
    v = split(v,",")
    a=>v
end

pt1 = solve1()
pt2 = solve2()
pt3 = solve3()


