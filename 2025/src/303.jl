include("../../helper.jl")

saveinputs()
saveexamples()

mutable struct Socket
    color
    shape
    node
end

struct Node
    id
    plug
    leftsocket
    rightsocket
end
import Base.parse
function Base.parse(::Type{Node},line::String)
    els = split(line,", ")
    els = [split(x,"=")[2] for x in els]
    id = parse(Int,els[1])
    els = split.(els[2:end-1]," ")
    sockets = [Socket(el...,nothing) for el in els]
    Node(id,sockets[1],sockets[2],sockets[3])
end

function traverse(tree)
    isnothing(tree) && return Int[]
    ret = Int[]
    if !isnothing(tree.leftsocket.node)
        append!(ret,traverse(tree.leftsocket.node))
    end
    push!(ret,tree.id)
    if !isnothing(tree.rightsocket.node)
        append!(ret,traverse(tree.rightsocket.node))
    end
    ret
end

function bondstrength(a::Socket,b::Socket)
    (a.color == b.color) + (a.shape == b.shape)
end

function bondstrength(a::Socket)
    isnothing(a.node) && return 0
    bondstrength(a,a.node.plug)
end

function addnode!(tree::Node,node::Node; minbond=1,bondreplace=false)
    #@info "Checking left socket of node $(tree.id)"
    node = addnode!(tree.leftsocket,node;minbond=minbond,bondreplace=bondreplace)
    isnothing(node) && return nothing
    #@info "Checking right socket of node $(tree.id)"
    addnode!(tree.rightsocket,node;minbond=minbond,bondreplace=bondreplace)
end

function addnode!(socket::Socket,node::Node; minbond=2,bondreplace=false)
    if bondstrength(socket) == 0
        if bondstrength(socket,node.plug) >= minbond
            socket.node = node
            #@info "Formed new bond", node, socket.node
            return nothing
        else
            return node
        end
    elseif bondreplace && bondstrength(socket) == 1
        if bondstrength(socket,node.plug) == 2
            xnode = socket.node
            socket.node = node
            node = xnode
            #@info "Swapped socket", node, socket.node
            return node
        end
    end
    addnode!(socket.node,node; minbond=minbond,bondreplace=bondreplace)
end

function solve(part=1,problem="p")
    minbond = [2,1,1][part]
    bondreplace = [false,false,true][part]
    lines = loadlines(;part=part,problem=problem)
    nodes = parse.(Node,lines)
    tree = nodes[1]
    for node in nodes[2:end]
        n = addnode!(tree,node;minbond=minbond,bondreplace=bondreplace)
        if !isnothing(n)
            n = addnode!(tree,n;minbond=minbond,bondreplace=bondreplace)
        end
    end
    t = traverse(tree)
    sum(collect(1:length(t)) .* t)
end

solve(1)
solve(2)
solve(3)