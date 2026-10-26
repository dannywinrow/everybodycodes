include("../../helper.jl")

function solve(part=1,problem="p")
    rems = [rems1,rems2,rems3][part]
    lines = loadlines(part=part,problem=problem)
    maximum(solveit.(lines,rems))
end


function solveit(s,rems)
    ms = [parse(Int,m.match) for m in collect(eachmatch(r"\d+",s))]
    A = ms[1]
    B = ms[2]
    C = ms[3]
    X = ms[4]
    Y = ms[5]
    Z = ms[6]
    M = ms[7]
    rems(A,X,M) + rems(B,Y,M) + rems(C,Z,M)
end

function rems1(N,E,M)
    b = 1
    ns = Int[]
    for _ in 1:E
        b = (b * N) % M
        push!(ns,b)
    end
    parse(Int,join(reverse(ns)))
end

function rems2(N,E,M)
    b = 1
    ns = Int[]
    v = 0
    for _ in 1:E
        b = (b * N) % M
        if b in ns
            v = findfirst(==(b),ns)
            ns = ns[v:end]
            break
        end
        push!(ns,b)
    end
    f = (E-v+1) % length(ns)
    rs = CircularArray(ns)[f-4:f]
    parse(Int,join(reverse(rs)))
end


function rems3(N,E,M)
    b = 1
    ns = Int[]
    v = 0
    s = 0
    for _ in 1:E
        b = (b * N) % M
        if b in ns
            v = findfirst(==(b),ns)
            s = sum(ns[1:v-1])
            ns = ns[v:end]
            break
        end
        push!(ns,b)
    end
    d = (E-v+1) ÷ length(ns)
    f = (E-v+1) % length(ns)
    d*sum(ns) + sum(ns[1:f])
end


pt1 = solve()
pt2 = solve(2)
pt3 = solve(3)