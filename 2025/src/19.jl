include("../../helper.jl")

saveinputs()
saveexamples()

function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    solveit(lines)
end

function solveit(lines)
    maxdistplusheight = 0
    currdist = 0
    for line in lines
        dist,height,gap = parse.(Int,split(line,","))
        if dist > currdist
            maxdistplusheight = max(dist+height,maxdistplusheight)
            currdist = dist
        end
    end
    ceil(Int,maxdistplusheight/2)
end

pt1 = solve(1)
pt2 = solve(2)
pt3 = solve(3)

# My solution doesn't work for adversarial inputs below:

MyAdversarial = """1262,288,3
1280,250,5
1280,281,7
1298,258,7
1298,282,5
1322,125,116"""

solveit(split(MyAdversarial,"\n")) # should be 781

AllanTaylorAdversarial = """10,1,1
10,3,1
10,5,1
10,7,2
10,11,1
10,13,1
10,15,1
10,17,1
10,19,1
10,21,1
10,23,1
10,25,1
10,27,1
10,29,1
10,31,1
10,33,1
10,35,1
10,37,1
10,39,1
10,41,1
10,43,1
10,45,1
10,47,1
10,49,1
20,15,10
100,95,10
105,3,10
105,30,60
105,100,4
105,110,20
120,5,50
120,85,1
120,90,20"""

solveit(split(AllanTaylorAdversarial,"\n")) # should be 105
