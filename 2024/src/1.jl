include("helper.jl")

p1in = loadlines(part=1)[1]
d = Dict('A'=>0,'B'=>1,'C'=>3)
pt1 = sum(d[bug] for bug in p1in)
@show pt1

p2in = loadlines(part=2)[1]
d = Dict('x'=>0, 'A'=>0,'B'=>1,'C'=>3, 'D'=>5)
pt2 = sum(d[bug] for bug in p2in) + 2*sum(   [!('x' in (p2in[1+x*2],p2in[2+x*2])) for x in 0:999])
@show pt2

p3in = loadlines(part=3)[1]
grps = Dict(3=>0,2=>0,1=>2,0=>6)
pt3 = sum(d[bug] for bug in p3in) + sum([grps[count(==('x'),p3in[(i*3-2):(i*3)])] for i in 1:length(p3in) ÷ 3])
@show pt3