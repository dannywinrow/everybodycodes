include("../../helper.jl")

function solve1(filename)
    lines = loadlines(filename)
    plans = Dict()
    for line in lines
        k,plan = split(line,":")
        plan = split(plan,",")
        println(plan)
        plans[k] = essencegathered(plan,10)
    end
    x = sort(by=x->x[2],[(k,v) for (k,v) in plans],rev=true)
    #return x
    join(j[1] for j in x)
end

function essencegathered(plan,len)
    total = 0
    power = 10
    for i in 1:len
        step = CircularArray(plan)[i]
        power += step == "+" ? 1 : step =="-" ? -1 : 0
        total += power
    end
    total
    #p = count(==("+"),plan) - count(==("-"),plan)
    #fullloops = length(plan) ÷ len
    #finalstrait = length(plan) % len
    #partloop = count(==("+"),plan[1:finalstrait]) - count(==("-"),plan[1:finalstrait])
    #println("p =$p, fullloops:$fullloops, finalstrait=$finalstrait, partloop = $partloop")
    #10 + p*fullloops + partloop
end

pt1 = solve1(getfilename(2024,7,1))
@show pt1

racetrack = "S-=++=-==++=++=-=+=-=+=+=--=-=++=-==++=-+=-=+=-=+=+=++=-+==++=++=-=-=--
-                                                                     -
=                                                                     =
+                                                                     +
=                                                                     +
+                                                                     =
=                                                                     =
-                                                                     -
--==++++==+=+++-=+=-=+=-+-=+-=+-=+=-=+=--=+++=++=+++==++==--=+=++==+++-"


racetrackex = """
S+===
-   +
=+=-+"""

racetrack3 = """
S+= +=-== +=++=     =+=+=--=    =-= ++=     +=-  =+=++=-+==+ =++=-=-=--
- + +   + =   =     =      =   == = - -     - =  =         =-=        -
= + + +-- =-= ==-==-= --++ +  == == = +     - =  =    ==++=    =++=-=++
+ + + =     +         =  + + == == ++ =     = =  ==   =   = =++=
= = + + +== +==     =++ == =+=  =  +  +==-=++ =   =++ --= + =
+ ==- = + =   = =+= =   =       ++--          +     =   = = =--= ==++==
=     ==- ==+-- = = = ++= +=--      ==+ ==--= +--+=-= ==- ==   =+=    =
-               = = = =   +  +  ==+ = = +   =        ++    =          -
-               = + + =   +  -  = + = = +   =        +     =          -
--==++++==+=+++-= =-= =-+-=  =+-= =-= =--   +=++=+++==     -=+=++==+++-"""

function converttrack2(track)
    rtl = split(track,"\n")
    maxline = maximum(length.(rtl))
    rtl = rpad.(rtl,maxline," ")
    rtg = parsegrid(rtl)
    cis = CartesianIndices(rtg)
    ind = CartesianIndex(1,1)
    dir = R
    track = []
    #print("track: ")
    while true
        if !(ind+dir in cis) || rtg[ind+dir] == ' '
            if !(ind+rotl90(dir) in cis) || rtg[ind+rotl90(dir)] == ' '
                dir = rotr90(dir)
            else
                dir = rotl90(dir)
            end
        end
        ind += dir
        #print(rtg[ind])
        push!(track,rtg[ind])
        rtg[ind] == 'S' && break
    end
    #println()
    track
end

function essencegathered(plan,track,laps)
    total = 0
    power = 10
    planout = pout = tout = ""
    for i in 1:length(track)*laps
        step = CircularArray(plan)[i]
        road = CircularArray(track)[i]
        tout *= road
        planout *= step
        power += 
            if road == '+'
                pout *= "+"
                1
            elseif road == '-'
                pout *= "+"
                -1
            elseif step == "+"
                pout *= "+"
                1
            elseif step =="-"
                pout *= "-"
                -1
            else
                pout *= "="
                0
            end
        total += power
    end
    #println("track: $tout")
    #println("plan:  $planout")
    #println("exec:  $pout")

    total

end

function getplans(filename)
    lines = loadlines(filename)
    plans = Dict()
    for line in lines
        k,plan = split(line,":")
        plan = split(plan,",")
        plans[k] = plan
    end
    plans
end
function solve2(filename,racetrack,laps)
    track = converttrack2(racetrack)
    plans = getplans(filename)
    essence = Dict()
    for (k,plan) in plans
        essence[k] = essencegathered(plan,track,laps)
    end
    x = sort(by=x->x[2],[(k,v) for (k,v) in essence],rev=true)
    join(j[1] for j in x)
end

pt2ex = solve2(getfilename(2024,7,2,"ex"),racetrackex,1)
pt2 = solve2(getfilename(2024,7,2),racetrack,10)
@show pt2

using Combinatorics

function solve3(filename,racetrack,laps)
    track = converttrack2(racetrack)
    #c = analysetrack(track)
    
    plan = collect(values(getplans(filename)))[1]
    len = length(plan)
    shortcutessence(plan) = essencegathered(plan,track,len)
        # Don't even need to multiply as all plans multiplied the same * (laps ÷ len)
        # This part is zero because 2024 divisible by 11 + essencegathered(plan,track,laps % len)
    
    tobeat = shortcutessence(plan)  
    count(>(tobeat),shortcutessence.(multiset_permutations(plan,len)))
end

pt3 = solve3(getfilename(2024,7,3),racetrack3,2024)
@show pt3

# Code written for speed but not used
function analysetrack(track)
    plan = CircularArray(fill(0,11))
    steps = length(track)*11
    for i in 1:steps
        road = CircularArray(track)[i]
        if !(road in ('+','-'))
            plan[i] += steps - i + 1
        end
    end
    plan
end

function calcval(analysis,plan)
    plan .* analysis
end