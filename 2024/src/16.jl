include("../../helper.jl")

struct FruitMachine
    wheelmoves
    wheels
end
Base.:(==)(fm1::FruitMachine,fm2::FruitMachine) =
    fm1.wheelmoves == fm2.wheelmoves && fm1.wheels == fm2.wheels

function getmachine(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    spins = parse.(Int,split(lines[1],","))
    wheels = [[] for _ in 1:length(spins)]
    for line in lines[3:end]
        for (i,wheel) in enumerate(wheels)
            startwheel = i * 4 - 3
            sym = line[startwheel:startwheel+2]
            if sym != "   "
                push!(wheel,sym)
            end
        end
    end
    for i in 1:length(wheels)
        spins[i] = spins[i] % length(wheels[i])
    end
    FruitMachine(spins,wheels)
end

function spin(fm::FruitMachine,n::Int)
    for _ in 1:n
        fm = spin(fm)
    end
    fm
end

function spin(fm::FruitMachine)
    wheels = deepcopy(fm.wheels)
    for i in 1:length(wheels)
        wheels[i] = vcat(wheels[i][fm.wheelmoves[i]+1:end],wheels[i][1:fm.wheelmoves[i]])
    end
    FruitMachine(fm.wheelmoves,wheels)
end

function line(fm::FruitMachine,n::Int)
    join([CircularArray(w)[1+fm.wheelmoves[i]*n] for (i,w) in enumerate(fm.wheels)]," ")
end

function line(fm::FruitMachine)
    join([w[1] for w in fm.wheels]," ")
end

function solve1()
    m = getmachine(1)
    line(m,100)
end
pt1 = solve1()
@show pt1

function eyepoints(fm::FruitMachine,n::Int)
    tot = 0
    for _ in 1:n
        fm = spin(fm)
        tot += eyepoints(fm)
    end
    tot
end
eyepoints(fm::FruitMachine) = eyepoints(line(fm::FruitMachine))
function eyepoints(l::String)
    eyes = join([i % 2 == 1 ? l[i] : "" for i in 1:length(l)])
    fd = freqdict(eyes)
    sum(v >= 3 ? v-2 : 0 for v in values(fd))
end

function findloop(fm::FruitMachine)
    spins = []
    while true
        nfm = spin(fm)
        s = findfirst(==(nfm),spins)
        if !isnothing(s)
            return s, length(spins)
        end
        push!(spins,nfm)
        fm = nfm
    end
end
function onesfm(fm::FruitMachine)
    nws = [[] for _ in fm.wheels]
    for i in 1:length(fm.wheels)
        j = 1
        inds = []
        while true
            push!(inds,j)
            push!(nws[i],fm.wheels[i][j])
            j = mod(j + fm.wheelmoves[i],1:length(fm.wheels[i]))
            j in inds && break
        end
    end
    FruitMachine(fill(1,length(nws)),nws)
end

function eyecountlarge(fm,spins)
    om = onesfm(fm)
    rep = lcm(length.(om.wheels))
    (spins ÷ rep) * eyepoints(om,rep) + eyepoints(om,(spins % rep))
end

solve2() = eyecountlarge(getmachine(2),202420242024)
pt2 = solve2()
@show pt2

dp = Dict{Tuple{Vector{Int},Int},Tuple{Int,Int}}()

eyepoints(fm,state) = eyepoints(join([w[i] for (w,i) in zip(fm.wheels,state)]," "))

function solveit(fm,state,n)
    haskey(dp,(state,n)) && return dp[(state,n)]
    e = eyepoints(fm,state)
    if n == 0
        return e,e
    end
    a = [solveit(fm,spin(state .+ i,fm),n-1) for i in -1:1]
    dp[state,n] = (e+maximum(getindex.(a,1)),e+minimum(getindex.(a,2)))
end
function spin(fmstate,fm::FruitMachine)
    [mod(f,1:length(fm.wheels[i])) for (i,f) in enumerate(fmstate .+ fm.wheelmoves)]
end

initstate(fm) = fill(1,length(fm.wheels))

function solve3()
    m = getmachine(3)
    a = solveit(m,initstate(m),256) .- eyepoints(m,initstate(m))
    join(a," ")
end

pt3 = solve3()
@show pt3