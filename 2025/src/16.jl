include("../../helper.jl")

saveinputs()
saveexamples()

function spelltowall(spell,walllength)
    walllength = 90
    wall = fill(0,walllength)
    for n in spell
        wall[n:n:walllength] .+= 1
    end
    wall
end
function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    s = split.(lines[1],",")
    spell = parse.(Int,s)
    wall = spelltowall(spell,90)
    sum(wall)
end

pt1 = solve()

function walltospell(wall)
    w = copy(wall)
    spell = []
    for i in eachindex(wall)
        for _ in 1:w[i]
            push!(spell,i)
        end
        w[i:i:end] .-= w[i]
    end
    spell
end
function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    s = split.(lines[1],",")
    wall = parse.(Int,s)
    spell = walltospell(wall)
    return wall, spell
    prod(spell)
end

pt2 = solve(2)

spelltoblocks(spell,walllength) = sum(walllength .÷ spell)
function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    s = split.(lines[1],",")
    wall = parse.(Int,s)
    spell = walltospell(wall)
    n = sum(wall)
    c = length(spell)
    m = []
    walllength = 202520252025000
    mul = 2
    while true
        x = 10^mul
        v = walllength - spelltoblocks(spell,x)
        if v > 0
            mul += 1
        else
            break
        end
    end
    mul -= 1
    x = string(10^mul)
    for i in 1:length(x)
        for n in 9:-1:0
            y = parse(Int,x[1:i-1]*string(n)*x[i+1:end])
            v =  walllength - spelltoblocks(spell,y)
            if v >= 0
                x = x[1:i-1]*string(n)*x[i+1:end]
                v == 0 && return parse(Int,x)
                break
            end
        end
    end
   parse(Int,x)
end

pt3 = solve(3)