include("../../helper.jl")

saveinputs()
saveexamples()

function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    plantsstr = splitvect(lines,"")
    plants = parse.(Plant,plantsstr)
    global plantdict = Dict(p.id=>p for p in plants)
    global dp = Dict()
    last(energy.(plants))
end

dp = Dict()

struct Plant
    id
    thickness
    branches
end

abstract type Branch end
struct FreeBranch <: Branch
    thickness
end
struct ConnBranch <: Branch
    thickness
    connectedto
end

function Base.parse(::Type{Branch},s::AbstractString)
    m = match(r"- free branch with thickness +(-?\d+)",s)
    if !isnothing(m)
        FreeBranch(parse(Int,m[1]))
    else
        m = match(r"- branch to Plant +(-?\d+) with thickness +(-?\d+)",s)
        #@info s
        ConnBranch(parse(Int,m[2]),parse(Int,m[1]))
    end
end
function Base.parse(::Type{Plant},s)
    m = match(r"Plant +(-?\d+) with thickness +(-?\d+):",s[1])
    id = parse(Int,m[1])
    thickness = parse(Int,m[2])
    branches = parse.(Branch,s[2:end])
    Plant(id,thickness,branches)
end
function energy(p::Plant)
    haskey(dp,p) && return dp[p]
    dp[p] = begin
        if isempty(p.branches)
            #@info "Plant $(p.id) no branches energy 0"
            e = 0
        else
            es = [energy(branch) for branch in p.branches]
            for (i,b) in enumerate(p.branches)
                #@info "Plant $(p.id) energy branch $i - $(es[i])"
            end
            e = sum(es)
        end
        if e >= p.thickness
            e
        else
            0
        end
    end
end

function energy(b::FreeBranch)
    b.thickness
end
function energy(b::ConnBranch)
    b.thickness * energy(plantdict[b.connectedto])
end


pt1 = solve(1)


function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    plantsstr = splitvect(lines,"")
    
    plants = [ parse(Plant,p) for p in plantsstr[1:end-2]]
    testcases = plantsstr[end]
    #return plants
    v = []
    for case in testcases
        plantscase = getplantscase(plants,case)
        global plantdict = Dict(p.id=>p for p in plantscase)
        global dp = Dict()

        push!(v,last(energy.(plantscase)))
    end
    #@info "got here"
    sum(v)
end

function getplantscase(plants,case)
    v = []
    i = 1
    for plant in plants
        if typeof(plant.branches[1]) == FreeBranch
            if case[i] == '1'
                push!(v,plant)
            else
                push!(v,Plant(plant.id,plant.thickness,[]))
            end
            i += 2
        else
            push!(v,plant)
        end
    end
    v
end

pt2 = solve(2)

isfreeplant(plant) = typeof(plant.branches[1]) == FreeBranch

function caseenergy(case)
    plantscase = getplantscase(case)
    global plantdict = Dict(p.id=>p for p in plantscase)
    global dp = Dict()
    last(energy.(plantscase))
end

function getplantscase(case::BitVector)
    v = []
    i = 1
    for plant in plants
        if typeof(plant.branches[1]) == FreeBranch
            if case[i]
                push!(v,plant)
            else
                push!(v,Plant(plant.id,plant.thickness,[]))
            end
            i += 1
        else
            push!(v,plant)
        end
    end
    v
end

function maxcase(case)
    i = 1
    while true
        ncase = improvecase(case)
        if case == ncase
            return case
        else
            case = ncase
        end
        i % 10 == 0 && println("$i: $(join([b ? '1' : '0' for b in case]))")
        i += 1
        if i > 500 
            break
        end
    end
end

function switchi(case,i)
    c = copy(case)
    c[i] = !c[i]
    c
end

function improvecase(case)
    ncase = similar(case)
    val = caseenergy(case)
    #@info val
    for i in eachindex(case)
        v = caseenergy(switchi(case,i))
        if v > val
            #@info i, v
            ncase[i] = !case[i]
        else
            ncase[i] = case[i]
        end
    end
    ncase
end

using Colors

function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    plantsstr = splitvect(lines,"")
    
    global plants = [ parse(Plant,p) for p in plantsstr[1:end-2]]
    global testcases = [BitVector([t == "1" for t in split(tc," ")]) for tc in plantsstr[end]]

    v = [caseenergy(case) for case in testcases]
    seedcase = testcases[argmax(v)]
    mcase = maxcase(seedcase)
    display(Gray.(reshape(mcase,(9,9))))
    sum(caseenergy(mcase) .- filter(>(0),v))
end

pt3 = solve(3)


