include("../../helper.jl")

saveinputs()
saveexamples()

function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    sum(solveline.(lines))
end

function solveline(line)
    m = match(r"ISO-(\d+) (\d+)",line)
    pws = CircularArray(parse.(Int,split(m.captures[1],"")))
    ms = CircularArray(parse.(Int,split(m.captures[2],"")))

    n = 0
    for i in 1:length(ms)
        n += pws[-i+1]^(i-1)*ms[-i+1]
    end
    n
end

pt1 = solve()
pt2 = solve(2)

function solve3(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    sum(solveline3.(lines))
end

function solveline3(line)
    m = match(r"ISO2-(\d+) (\d+)",line)
    if isnothing(m)
        @info line
    end
    iso = parse(Int,m.captures[1])
    m = parse(Int,m.captures[2])

    ison = calciso(iso,m)

    for n in 1:m-1
        if calciso(iso,n) == ison
            return 0
        end
    end
    ison
end

function calciso(iso,m)
    iso = CircularArray(parse.(Int,split(string(iso),"")))
    ms = CircularArray(parse.(Int,split(string(m),"")))
    n = 0
    for i in 1:length(ms)
        n += iso[-i+1]^(i-1)*ms[-i+1]
    end
    n
end

pt3 = solve3(3)