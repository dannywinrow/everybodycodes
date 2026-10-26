include("../../helper.jl")

saveinputs()
saveexamples()

using Combinatorics

function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    ps = split.(lines,"")
    ps = [p[3:end] for p in ps]
    m,d,c = ps
    sum(m .== c) * sum(d .== c)
end

pt1 = solve()

struct Person
    dna
    parents
    children
end

function Base.show(io::IO, p::Person)
    s = "Person with dna: $(join(p.dna))\n"
    for (i,v) in enumerate(p.parents)
        s *= "Parent $i dna: $(join(v.dna))\n"
    end
        for (i,v) in enumerate(p.children)
        s *= "Child $i dna: $(join(v.dna))\n"
    end
    print(io, s)
end
Person(dna) = Person(dna,Set{Person}(),Set{Person}())
Base.:(==)(p1::Person,p2::Person) = p1.dna == p2.dna
Base.getindex(p::Person,i::Int) = getindex(p.dna,i)
Base.length(p::Person) = length(p.dna)
Base.iterate(p::Person,i::Int) = iterate(p.dna,i)
Base.iterate(p::Person) = iterate(p.dna)
areparents(m::Person,d::Person,c::Person) = all((m .== c) .| (d .== c))
hasparents(c::Person) = !isempty(c.parents)
isparent(p::Person) = !isempty(p.children)
isorphan(p::Person) =  !hasparents(p)
function parentof!(p::Person, c::Person)
    push!(c.parents,p)
    push!(p.children,c)
end
isparentof(p::Person, c::Person) = c in p.children

function areparents!(m::Person,d::Person,c::Person)
    if areparents(m,d,c)
        parentof!(m,c)
        parentof!(d,c)
        return true
    end
    false
end
score(c::Person) = prod(sum(p .== c) for p in c.parents)
function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    ps = [Person([y for y in x[2]]) for x in split.(lines,":")]
    r = [[] for i in eachindex(ps), j in eachindex(ps)]
    for i in eachindex(ps)
        for j in eachindex(ps)
            r[i,j] = ps[i] .== ps[j]
        end
    end
    perms =  permutations(ps,3)

    for p in perms
        m,d,c = p
        if !hasparents(m) && !hasparents(d) && isorphan(c) && !isparent(c)
            areparents!(m,d,c)
        end
    end

    children = filter(hasparents,ps)

    sum(score.(children))

end

pt2 = solve(2,"e")
pt2 = solve(2)

function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    ps = [Person([y for y in x[2]]) for x in split.(lines,":")]
    r = [BitVector() for i in eachindex(ps), j in eachindex(ps)]
    for i in eachindex(ps)
        for j in eachindex(ps)
            r[i,j] = ps[i] .== ps[j]
        end
    end
    rels = sum.(r)
    function areparents(m::Int,d::Int,c::Int)
        all(r[c,m] .| r[c,d])
    end
    function areparents!(m::Int,d::Int,c::Int)
        if areparents(m,d,c)
            parentof!(ps[m],ps[c])
            parentof!(ps[d],ps[c])
            return true
        end
        false
    end
    function findparents!(c,rel)
        s = sortperm(rel,rev=true)
        pot = Int[]
        while !isempty(s)
            m = pop!(s)
            if m != c
                for d in pot
                    if areparents!(m,d,c)
                        return m, d
                    end
                end
                push!(pot,m)
            end
        end
    end
    for c in 1:length(ps)
        findparents!(c,rels[c,:])
    end

    fams = families(ps)
    sort!(fams,by=length)
    sum([findfirst(==(p),ps) for p in fams[end]])

end
function trawl(p,fam=Set{Person}())
    push!(fam,p)
    for r in p.parents
        if !(r in fam)
            union(fam,trawl(r,fam))
        end
    end
    for r in p.children
        if !(r in fam)
            union(fam,trawl(r,fam))
        end
    end
    fam
end
function families(ps)
    fs = []
    while !isempty(ps)
        p = ps[1]
        ps = ps[2:end]
        f = trawl(p)
        push!(fs,f)
        ps = setdiff(ps,f)
    end
    fs
end

solve(3)