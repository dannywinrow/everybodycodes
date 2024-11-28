include("../../helper.jl")

dist(ci1,ci2) = sum(abs.(Tuple(ci1 - ci2)))

using DataStructures
using Combinatorics

function solve1(part=1,problem="p")
    grid = loadhashgrid(part=part,problem=problem,truechar="*")
    makeconstellation(grid)
end

function makeconstellation(grid)
    stars = findall(grid)
    pq = PriorityQueue()
    for c in combinations(stars,2)
        pq[c] = dist(c...)
    end
    groups = []
    tot = 0
    while true
        #isempty(pq) && break
        (cis,d) = dequeue_pair!(pq)
        #@info cis, d
        f = findfirst(x->in(cis[1],x),groups)
        g = findfirst(x->in(cis[2],x),groups)
        if isnothing(f)
            if isnothing(g)
                push!(groups,[cis...])
            else
                push!(groups[g],cis[1])
            end
            tot += d
        else
            if isnothing(g)
                push!(groups[f],cis[2])
                tot += d
            else
                if f != g
                    groups[f] = vcat(groups[f],groups[g])
                    deleteat!(groups,g)
                    tot += d
                end
            end
        end
        length(groups) == 1 && length(groups[1]) == length(stars) && break
    end
    tot + length(stars)
end

pt1 = solve1(1)
@show pt1

pt2 = solve1(2)
@show pt2

function solve3(part=1,problem="p")
    grid = loadhashgrid(part=part,problem=problem,truechar="*")
    makebrilliant(grid,5)
end

function makebrilliant(grid,maxconn)
    stars = findall(grid)
    pq = PriorityQueue()
    for c in combinations(stars,2)
        pq[c] = dist(c...)
    end
    groups = []
    tots = []
    while true
        #isempty(pq) && break
        (cis,d) = dequeue_pair!(pq)
        d > maxconn && break
        #@info cis, d
        f = findfirst(x->in(cis[1],x),groups)
        g = findfirst(x->in(cis[2],x),groups)
        if isnothing(f)
            if isnothing(g)
                push!(groups,[cis...])
                push!(tots,d)
            else
                push!(groups[g],cis[1])
                tots[g] += d
            end
        else
            if isnothing(g)
                push!(groups[f],cis[2])
                tots[f] += d
            else
                if f != g
                    groups[f] = vcat(groups[f],groups[g])
                    deleteat!(groups,g)
                    tots[f] += tots[g] + d
                    deleteat!(tots,g)
                end
            end
        end
        length(groups) == 1 && length(groups[1]) == length(stars) && break
    end
    sizes = tots .+ length.(groups)
    prod(sort(sizes)[end-2:end])
end

pt3 = solve3(3)
@show pt3