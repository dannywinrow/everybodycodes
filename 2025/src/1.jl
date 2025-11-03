include("../../helper.jl")

saveinputs()

function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    names = split(lines[1],",")
    instr = split(lines[3],",")
    x = 1
    for i in instr
        if i[1] == 'L'
            x = max(1,x-parse(Int,i[2]))
        else
            x = min(length(names),x+parse(Int,i[2]))
        end
    end
    names[x]
end
pt1 = solve()


function solve2(part=2,problem="p")
    lines = loadlines(part=part,problem=problem)
    names = CircularArray(split(lines[1],","))
    instr = split(lines[3],",")
    x = 1
    for i in instr
        if i[1] == 'L'
            x = x-parse(Int,i[2:end])
        else
            x = x+parse(Int,i[2:end])
        end
    end
    names[x]
end
pt2 = solve2()


function solve3(part=3,problem="p")
    lines = loadlines(part=part,problem=problem)
    names = CircularArray(split(lines[1],","))
    instr = split(lines[3],",")
    x = 1
    for i in instr
        if i[1] == 'L'
            v = names[1]
            names[1] = names[1-parse(Int,i[2:end])]
            names[1-parse(Int,i[2:end])] = v
        else
            v = names[1]
            names[1] = names[1+parse(Int,i[2:end])]
            names[1+parse(Int,i[2:end])] = v
        end
    end
    names[1]
end
pt3 = solve3() 