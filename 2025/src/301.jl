include("../../helper.jl")

saveinputs()
saveexamples()

function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
end

lines = loadlines()

function parseline(line)
    n,colors = split(line,":")
    n = parse(Int,n)
    colors = split(colors," ")
    vals = [parse(Int,replace(x,r"[rgb]"=>"0",r"[RGB]"=>"1")) for x in colors]
    vals[2] > vals[1] && vals[2] > vals[3] ? n : 0

end

parsed = parseline.(lines)
sum(parsed)



lines = loadlines(part=2)
function parseline2(line)
    n,colors = split(line,":")
    n = parse(Int,n)
    colors = split(colors," ")
    vals = [parse(Int,replace(x,r"[rgbs]"=>"0",r"[RGBS]"=>"1")) for x in colors]
    n,sum(vals[1:3]),vals[4]
end

parsed = parseline2.(lines)

shines = [x[3] for x in parsed]
highshine = maximum(shines)

hss = filter(x->x[3]==highshine,parsed)
darkn = minimum([x[2] for x in hss])

lines = loadlines(part=3)
function parseline3(line)
    n,colors = split(line,":")
    n = parse(Int,n)
    colors = split(colors," ")
    vals = [parse(Int,replace(x,r"[rgbs]"=>"0",r"[RGBS]"=>"1")) for x in colors]
    shine = vals[4] >= 100001 ? :shiny : vals[4] <= 11110 ? :matte : :ignore
    domc = 0
    colors = vals[1:3]
    c = count(==(maximum(colors)),colors)
    if c == 1
        domc = argmax(colors)
    end
    n,join([domc,shine])
end


parsed = parseline3.(lines)
groups = [x[2] for x in parsed]
[x=>count(==(x),groups) for x in unique(groups)]



argmax(groups)
gs = filter(x->x[2]=="3matte",parsed)
sum(x[1] for x in gs)

vals[findall(==(max(shines)),shines)]
[sum(x) for x in highshine]

pt1 = solvpe()



pt2 = solve(2)



pt3 = solve(3)