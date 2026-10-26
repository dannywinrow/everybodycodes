include("../../helper.jl")

mutable struct Node
    n
    c
    left
    right
end
Node(n,c) = Node(n,c,nothing,nothing)
function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    ns = parseit.(lines)
    l = ns[1][1]
    r = ns[1][2]
    for g in ns[2:end]
        addnode!(l,g[1])
        addnode!(r,g[2])
    end
    code(l)*code(r)
end
function addnode!(node,nodeadd)
    if nodeadd.n < node.n
        if isnothing(node.left)
            node.left = nodeadd
        else
            addnode!(node.left,nodeadd)
        end
    elseif nodeadd.n > node.n
        if isnothing(node.right)
            node.right = nodeadd
        else
            addnode!(node.right,nodeadd)
        end
    end
end
function addnode!(node,n,c)
    if n < node.n
        if isnothing(node.left)
            node.left = Node(n,c)
        else
            addnode!(node.left,n,c)
        end
    elseif n > node.n
        if isnothing(node.right)
            node.right = Node(n,c)
        else
            addnode!(node.right,n,c)
        end
    end
end
function code(node)
    levels = code!(node)
    m = maximum(length.(levels))
    join(levels[findfirst(x->length(x)==m,levels)])
end
function code!(node,n=1,levels=[])
    if !isnothing(node)
        if n > length(levels)
            push!(levels,[])
        end
        push!(levels[n],node.c)
        code!(node.left,n+1,levels)
        code!(node.right,n+1,levels)
    end
    levels
end
function parseit(s)
    if contains(s,"SWAP")
        parse(Int,match(r"\d+",s).match)
    else
        m = match(r"left=\[(\d+),(.)\] right=\[(\d+),(.)\]",s)
        (Node(parse(Int,m[1]),m[2]),Node(parse(Int,m[3]),m[4]))
    end
end
pt1 = solve()

function solve2(part=2,problem="p")
    lines = loadlines(part=part,problem=problem)
    ns = parseit.(lines)
    nodes = [ns[1]]
    l = ns[1][1]
    r = ns[1][2]
    for g in ns[2:end]
        if typeof(g) <: Int
            a,b = nodes[g]
            n = a.n
            c = a.c
            a.n = b.n 
            a.c = b.c
            b.n = n
            b.c = c
        else
            push!(nodes,g)
            addnode!(l,g[1])
            addnode!(r,g[2])
        end
    end
    code(l)*code(r)
    #code!(l),code!(r)
end
pt2 = solve2()

function solve3(part=3,problem="p")
    lines = loadlines(part=part,problem=problem)
    ns = parseit.(lines)
    nodes = [ns[1]]
    l = ns[1][1]
    r = ns[1][2]
    for g in ns[2:end]
        if typeof(g) <: Int
            a,b = nodes[g]
            n = a.n
            c = a.c
            left = a.left
            right = a.right
            a.n = b.n 
            a.c = b.c
            a.left = b.left
            a.right = b.right
            b.n = n
            b.c = c
            b.left = left
            b.right = right
        else
            push!(nodes,g)
            addnode!(l,g[1])
            addnode!(r,g[2])
        end
    end
    code(l)*code(r)
end
pt3 = solve3()