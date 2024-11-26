include("../../helper.jl")

in1 = 4098562
inex1 = 13

function solve1(in1)
    n = ceil(Int,in1^(1/2))
    width = n * 2 - 1
    missingblocks = n^2-in1
    width*missingblocks
end

pt1ex = solve1(inex1)
pt1 = solve1(in1)
@show pt1

in2 = 369
in2a = 1111
in2b = 20240000

inex2 = 3
inex2a = 5
inex2b = 50

function solve2(in2,in2a,in2b)
    blocksused = 1
    layer = 1
    thickness = 1
    while blocksused < in2b
        layer += 1
        thickness = thickness * in2 % in2a
        width = layer*2 - 1
        blocksused += thickness * width
    end
    width = layer*2 - 1
    missingblocks = blocksused - in2b
    width*missingblocks
end

pt2ex = solve2(inex2,inex2a,inex2b)
pt2 = solve2(in2,in2a,in2b)
@show pt2

in3 = 954942
in3a = 10
in3b = 202400000

struct Shrine
    thicks
    priests
    acolytes
end
Shrine(priests,acolytes) = Shrine([1],priests % acolytes,acolytes)
function buildlayer!(shrine::Shrine)
    layer = length(shrine.thicks)+1
    thickness = shrine.thicks[1]
    thickness = ((thickness * shrine.priests) % shrine.acolytes) + shrine.acolytes
    pushfirst!(shrine.thicks,thickness)
end
blocksused(shrine::Shrine) = sum(((length(shrine.thicks)*2-1):-2:1) .* shrine.thicks)
function blockstoremove(shrine::Shrine)
    layer = length(shrine.thicks)
    width = layer*2-1
    removefromlayer(l) = 
        (l == 1 ? 0 : l == layer ? 1 : 2) *
        min(sum(shrine.thicks[1:l-1]),(shrine.priests * sum(shrine.thicks[1:l]) * width) % shrine.acolytes)
    blockstoremove = sum(removefromlayer(x) for x in 1:layer)
end
blocks(shrine::Shrine) = blocksused(shrine) - blockstoremove(shrine)
function solve3(priests,acolytes,blocksavail)
    shrine = Shrine(priests,acolytes)
    while blocks(shrine) < blocksavail
        buildlayer!(shrine)
    end
    blocks(shrine) - blocksavail
end

pt3ex = solve3(2,5,160)
pt3 = solve3(in3,in3a,in3b)
@show pt3