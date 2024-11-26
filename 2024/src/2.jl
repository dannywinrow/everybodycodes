include("../../helper.jl")


function solve1(filename)
    runicwords, inscription = loadinputs(filename)
    sum(length(findall(w,inscription[1])) for w in runicwords)
end
function loadinputs(filename)
    p1in = readlines(filename)
    runicwords = split(p1in[1][7:end],",")
    inscriptions = p1in[3:end]
    runicwords, inscriptions
end
pt1 = solve1(getfilename(2024,2,1))
@show pt1

findalloverlap(f,s) = filter(x->s[x] == f,[i:i+length(f)-1 for i in 1:length(s)-length(f)+1])

function runicsymbols(words::Array, line::AbstractString)
    symbols = fill(false,length(line))
    for word in words
        symbols = runicsymbols(word,line,symbols)
    end
    symbols
end

function runicsymbols(word::AbstractString, line::AbstractString, symbols::Array{Bool}=fill(false,length(line)))
    @assert length(line) == length(symbols)
    r = findalloverlap(word,line)
    for rng in r
        symbols[rng] .= true
    end
    r = findalloverlap(reverse(word),line)
    for rng in r
        symbols[rng] .= true
    end
    symbols
end

function solve2(filename)
    runicwords, inscriptions = loadinputs(filename)
    sum(sum.(runicsymbols.(Ref(runicwords),inscriptions)))
end

pt2 = solve2(getfilename(2024,2,2))
@show pt2

function runicsymbols(words::Array, grid::Matrix{Char})
    symbols = fill(false,size(grid))
    for word in words
        symbols = runicsymbols(word,grid,symbols)
    end
    symbols
end

findalloverlap(word::AbstractString,grid::Matrix{Char}) = 
    filter(rng->join(CircularArray(grid)[rng]) in [word,reverse(word)],
        [ci:ci+d*(length(word)-1) for ci in CartesianIndices(grid) for d in [D,R]])

function runicsymbols(word::AbstractString, grid::Matrix{Char}, symbols::Array{Bool}=fill(false,size(grid)))
    @assert size(grid) == size(symbols)
    s = CircularArray(symbols)
    r = findalloverlap(word,grid)
    filter!(cis -> all(1 <= ci[1] <= size(grid,1) for ci in cis),r)
    for rng in r
        s[rng] .= true
    end
    symbols
end

using Crayons

function highlight(inscription,bitarr)
    for (ri,rb) in zip(eachrow(inscription),eachrow(bitarr))
        for (i,b) in zip(ri,rb)
            print(Crayon(bold=b),i)
        end
        println()
    end
end

function solve3(filename)
    runicwords, inscriptions = loadinputs(filename)
    inscription = parsegrid(inscriptions)
    bitarr = runicsymbols(runicwords,inscription)
    highlight(inscription,bitarr)
    sum(bitarr)
end

pt3ex = solve3(getfilename(2024,2,3,"ex"))
pt3 = solve3(getfilename(2024,2,3))
@show pt3