include("../../helper.jl")

function solve1(filename,loops,start)
    origins, evolvers = loadevolver(filename)
    runsolve(origins,evolvers,loops,start)
end

function loadevolver(filename)
    lines = loadlines(filename)
    evolve = []
    origins = []
    i = 1
    for x in lines
        origin, evolution = split(x,":")
        push!(origins,origin)
        push!(evolve,split(evolution,","))
    end
    evolvers = []
    for x in evolve
        evolver = fill(0,length(origins))
        for c in x
            evolver[findfirst(==(c),origins)] += 1
        end
        push!(evolvers,evolver)
    end
    origins, evolvers
end

function runsolve(origins,evolvers,loops,start)
    termites = fill(0,length(origins))
    termites[findfirst(==(start),origins)] = 1

    for _ in 1:loops
        newtermites = fill(0,length(origins))
        for t in 1:length(origins)
            newtermites .+= termites[t] .* evolvers[t] 
        end
        termites = newtermites
    end
    sum(termites)
end

pt1 = solve1(getfilename(2024,11,1),4,"A")
@show pt1

pt2 = solve1(getfilename(2024,11,2),10,"Z")
@show pt2

function solve3(filename,loops)
    origins, evolvers = loadevolver(filename)
    pops = [runsolve(origins,evolvers,loops,c) for c in origins]
    maximum(pops) - minimum(pops)
end

pt3 = solve3(getfilename(2024,11,3),20)
@show pt3