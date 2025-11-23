using HTTP
using Dates
using JSON3
using CircularArrays
using Nettle

#PATHS
getfilename(year,day,part=1,type="p") = "$year/inputs/$day$type$(part).txt"
getjuliafilename(year,day) = "$year/src/$(day).jl"
puzzleurl(year,day) = "https://everybody.codes/event/$year/quests/$day"
getsubmiturl(year,day,part) = puzzleurl(year,day) * "/part/$part/answer"
const templatefile = "puzzletemplate.jl"
const logfile = "log.txt"
const logdelim = " | "
include("private.jl")
const cookies = Dict("everybody-codes"=>sessioncookie)

function downloadinput(event,quest)
    url = "https://everybody-codes.b-cdn.net/assets/$event/$quest/input/$seed.json"
    r = HTTP.get(url;cookies=cookies)
    JSON3.read(String(r.body))
end

function downloaddescription(event,quest)
    url = "https://everybody-codes.b-cdn.net/assets/$event/$quest/description.json"
    r = HTTP.get(url;cookies=cookies)
    JSON3.read(String(r.body))
end

submit(answer::AbstractString,part::Int) = submit(answer,getyearday()...,part)
function submit(answer,year,day,part)
    body = Dict("answer"=>answer)
    r = HTTP.post(getsubmiturl(year,day,part);cookies=cookies,body=JSON3.write(body))
    String(r.body)
end

#=
This is suitable for use with https://github.com/faf0/AES.jl but it is
not the registered AES package.
The registered AES.jl package does not support 256bit AES.
I have used Nettle.jl instead as it is registered.

function downloadinput(event,quest,part)
    inputs = downloadinput(event,quest)
    keys = getkeys(event,quest)
    if !haskey(keys,"key$part")
        @warn "There is no key available for part $part yet"
    else
        key = collect(codeunits(keys["key$part"]))
        iv = collect(codeunits(keys["key$part"][1:16]))
        String(AES.AESCBC(hex2bytes(inputs[part]),key,iv,false))
    end
end=#

function downloadinput(event,quest,part)
    inputs = downloadinput(event,quest)
    decodepart(event,quest,part,inputs)
end

function decodepart(event,quest,part,inputs)
    keys = getkeys(event,quest)
    if !haskey(keys,"key$part")
        @warn "There is no key available for part $part yet"
    else
        key = collect(codeunits(keys["key$part"]))
        iv = collect(codeunits(keys["key$part"][1:16]))
        data = hex2bytes(inputs[part])
        keylength = length(key)*8
        dec = Decryptor("AES256", key)
        deciphertext = decrypt(dec, :CBC, iv, data)
        s = String(trim_padding_PKCS5(deciphertext))
        println("Part $part:\n$s")
        s
    end
end

function downloaddescription(event,quest,part)
    inputs = downloaddescription(event,quest)
    decodepart(event,quest,part,inputs)
end

saveexamples() = saveexamples(getyearday()...)
function saveexamples(event,quest)
    for part in 1:3
        saveexamples(event,quest,part)
    end
end
function saveexamples(event,quest,part)
    firsttype = 'e'
    path = getfilename(event,quest,part,firsttype)
    if !isfile(path)
        input = downloaddescription(event,quest,part)
        if !isnothing(input)
            em = eachmatch(r"<pre class=\"note\">(.+?)</pre>"s,input)
            if !isempty(em)
                i = 0
                for m in em
                    c = m.captures[1]
                    if startswith(c,r"\r?\n") && endswith(c,r"\r?\n")
                        c = strip(c)
                        type = firsttype + i
                        write(getfilename(event,quest,part,type),c)
                        i += 1
                    end
                end
            end
        end
    end
end
    
function saveinput(event,quest,part)
    path = getfilename(event,quest,part)
    if !isfile(path)
        input = downloadinput(event,quest,part)
        if !isnothing(input)
            write(path,input)
        end
    end
end

saveinputs() = saveinputs(getyearday()...)
function saveinputs(event,quest)
    for part in 1:3
        saveinput(event,quest,part)
    end
end

function getkeys(event,quest)
    url = "https://everybody.codes/api/event/$event/quest/$quest"
    r = HTTP.get(url;cookies=cookies)
    JSON3.read(String(r.body))
end

# FILE HANDLING
createfile() = createfile(year(now()),day(now()))
function createfile(year,day)
    filepath = getjuliafilename(year,day)
    if !isfile(filepath)
        mkpath(dirname(filepath))
        cp(templatefile,filepath)
    end
    #=for pt in 1:3
        filepath = getfilename(year,day,pt)
        if !isfile(filepath)
            write(filepath,"")
        end
    end=#
end

parselines(input) = split(strip(input),"\r\n")
loadlines(;part=1,problem="p") = loadlines(getyearday()...,part,problem)
loadlines(year,day,part=1,problem="p") = loadlines(getfilename(year,day,part,problem))
function loadlines(filename::String)
    lines = readlines(filename)
    while lines[end] == ""
        lines = lines[1:end-1]
    end
    lines
end

loadgrid(filename::String;type=Char,delim="") = parsegrid(loadlines(filename);type=type,delim=delim)
loadgrid(;part=1,problem="p",type=Char,delim="") = parsegrid(loadlines(;part=part,problem=problem);type=type,delim=delim)
function  parsegrid(linesin;type = Char,permute = true,delim="")
    maxline = maximum(length.(linesin))
    lines = rpad.(linesin,maxline," ")
    grid = hcat(split.(lines,delim)...)
    if type != Char
        grid = parse.(type,grid)
    else
        grid = getindex.(grid,1)
    end
    permute && return permutedims(grid,(2,1))
    grid
end

function gridtostring(grid)
    s = ""
    for r in eachrow(grid)
        s *= join(r) * "\n"
    end
    s
end

loadhashgrid(filename::String) =loadhashgrid(loadlines(filename))
loadhashgrid(;part=1,problem="p",kwargs...) = parsehashgrid(loadlines(;part=part,problem=problem);kwargs...)
function parsehashgrid(lines;truechar="#")
    @assert length(unique(length.(lines))) == 1
    (x -> x ==truechar).(hcat(split.(lines,"")...))'
end

function splitvect(a::Vector,delim)
    inds = vcat(0,findall(==(delim),a),length(a)+1)
    view.(Ref(a), (:).(inds[1:end-1].+1,inds[2:end].-1))
end

function getyearday()
    st = stacktrace()
    i = 1
    while occursin(r"helper.jl$",String(st[i].file))
        i += 1
    end
    year = match(r"\d\d\d\d",String(st[i].file)).match
    day = match(r"(\d+)[^\\]*.jl",String(st[i].file)).captures[1]
    year,day
end

# Frequency Dictionary
freqdict(str) = Dict([i => count(x->x==i,str) for i in str])

# DIRECTIONS
U = CartesianIndex(-1,0)
D = CartesianIndex(1,0)
L = CartesianIndex(0,-1)
R = CartesianIndex(0,1)

directions = CircularArray([R,D,L,U])
arrows = CircularArray(['>','v','<','^'])

# CARTESIAN INDICES NEIGHBOURS
neighbours(ci) = Ref(ci) .+ cartesiancube(length(ci))
adjacents(ci) = Ref(ci) .+ directions

function cartesiancube(dims,i=false)
    ret = CartesianIndices(Tuple(fill(-1:1,dims)))
    i || (ret = filter(x->x!=CartesianIndex(Tuple(fill(0,dims))),ret))
    ret
end

# CARTESIAN INDICES ROTATION
import Base.rotr90, Base.rot180
Base.rotr90(ci::CartesianIndex{2}) = CartesianIndex(ci[2],-ci[1])
Base.rotl90(ci::CartesianIndex{2}) = CartesianIndex(-ci[2],ci[1])
Base.rot180(ci::CartesianIndex{2}) = CartesianIndex(-ci[1],-ci[2])

circr45(ci::CartesianIndex{2}) = 
    if ci[1] == 0
        CartesianIndex(ci[2],ci[2])
    elseif ci[2] == 0
        CartesianIndex(ci[1],-ci[1])
    elseif ci[1] == ci[2]
        CartesianIndex(0,ci[2])
    else
        CartesianIndex(ci[1],0)
    end

circl45(ci::CartesianIndex{2}) =
    if ci[1] == 0
        CartesianIndex(-ci[2],ci[2])
    elseif ci[2] == 0
        CartesianIndex(ci[1],ci[1])
    elseif ci[1] == ci[2]
        CartesianIndex(ci[1],0)
    else
        CartesianIndex(0,ci[2])
    end


# UNIT RANGE SIMPLIFICATION
function simplify(a::Int64,b::Int64)
    a == b && return a\
    a == b + 1 && return b:a
    a + 1 == b && return a:b
    nothing
end
simplify(a::Int64,b::UnitRange) = simplify(b,a)
function simplify(a::UnitRange,b::Int64)
    b in a && return a
    a[1] == b + 1 && return b:a[2]
    a[end] == b - 1 && return a[1]:b
    nothing
end
function simplify(a::UnitRange,b::UnitRange)
    ret = min(a[1],b[1]):max(a[end],b[end])
    length(ret) <= length(a) + length(b) ? ret : nothing
end
function simplify(a::UnitRange,b::UnitRange)
    ret = min(a[1],b[1]):max(a[end],b[end])
    length(ret) <= length(a) + length(b) ? ret : nothing
end

function simplify(v)
    ranges = Any[v...]
    outranges=[]
    while !isempty(ranges)
        range = popfirst!(ranges)
        broke = false
        for (i,r) in enumerate(ranges)
            if !isnothing(simplify(range,r))
                ranges[i] = simplify(range,r)
                broke = true
                break
            end
        end
        if !broke
            push!(outranges,range)
        end
    end
    outranges
end