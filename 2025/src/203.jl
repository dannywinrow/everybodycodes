include("../../helper.jl")

mutable struct Die
    faces
    seed
    state
    pulse
    rolln
end

copy(die::Die) = Die(die.faces,die.seed,die.state,die.pulse,die.rolln)

function parseline(line)
    m = match(r"(?:faces|values)=\[(.+)\] seed=(.+)",line)
    faces = parse.(Int,split(m[1],","))
    seed = parse.(Int,m[2])
    Die(faces,seed,1,seed,1)
end

function roll!(die::Die)
    spin = die.rolln * die.pulse
    die.state = mod(die.state + spin,1:length(die.faces))
    face = die.faces[die.state]
    die.pulse = (die.pulse + spin) % die.seed + 1 + die.rolln + die.seed
    die.rolln += 1
    face
end
function solveit(dies)
    t = 0
    i = 0
    while t < 10000
        rolls = roll!.(dies)
        t += sum(rolls)
        i += 1
        if i <= 10 || i % 10 == 0
            #@info i, rolls, sum(rolls), t
        end
    end
    i
end

function finishrolls(die,racetrack)
    pos = 1
    i = 0
    while pos <= length(racetrack)
        roll = roll!(die)
        i += 1
        if roll == racetrack[pos]
            pos += 1
        end
    end
    i
end
function solveit2(dies,racetrack)
    finishes = finishrolls.(dies,Ref(racetrack))
    join(sortperm(finishes),",")
end

function solve(part=1,problem="p";image=false)
    lines = loadlines(part=part,problem=problem)
    if part == 1
        solveit(parseline.(lines))
    elseif part == 2
        dielines, racetracklines = splitvect(lines,"")
        dies = parseline.(dielines)
        racetrack = parse.(Int,[x for x in racetracklines[1]])
        solveit2(dies,racetrack)
    else
        dielines, racetracklines = splitvect(lines,"")
        dies = parseline.(dielines)
        racetrack = parsegrid(racetracklines) .- '0'
        #return die, racetrack
        grid = solveit3alt2(dies,racetrack)
        if image
            display(Gray.(grid))
        end
        sum(grid)

        #solveit3alt(dies,racetrack)
    end
end
function displaygrid(grid)
    s = ""
    for r in eachrow(grid)
        s *= join((x-> x ? 'X' : ' ').(r))*"\n"
    end
    s
    print(s)
    write("s.txt",s)
end
function solveit3(dies,racetrack)
    grid = fill(false,size(racetrack))
    for die in dies
        @info "Running die", die
        grid = grid .| solve3die(copy(die),racetrack)
    end
    grid
end
function solve3die(die,racetrack)
    faces = [roll!(die) for _ in 1:30000]
    face = faces[1]
    grid = fill(false,size(racetrack))
    for pos in findall(==(face),racetrack)
        allpaths!(grid,faces,2,pos,racetrack)
    end
    grid
end

function solveit3alt(dies,racetrack)
    seen = Set()
    racetrackdict = [findall(==(x),racetrack) for x in 1:9]
    for die in dies
        positions = racetrackdict[roll!(die)]
        while length(positions) > 0
            union!(seen,positions)
            face = roll!(die)
            positions = [
                position + d
                for position in positions
                for d in directions
                if position + d in racetrackdict[face]
            ]
        end

    end
    length(seen)
end


function solveit3alt2(dies,racetrack)
    rt = fill(0,size(racetrack) .+ (2,2))
    grid = fill(false,size(rt))
    rt[2:end-1,2:end-1] .= racetrack
    moves = [directions...,CartesianIndex(0,0)]
    for die in dies
        #@info die
        positions = findall(==(roll!(die)),rt)
        while length(positions) > 0
            grid[positions] .= true
            face = roll!(die)
            positions = unique(
                position + m
                for position in positions
                for m in moves
                if rt[position + m] == face
            )
            #@assert all(rt[positions] .== face)
            #@info length(positions)
        end
    end
    grid
end

function checkbounds(racetrack,ci::CartesianIndex)
    X,Y = size(racetrack)
    1 <= ci[1] <= X && 1 <= ci[2] <= Y
end

function allpaths!(grid,rolls,rolln,pos,racetrack)
    face = rolls[rolln]
    grid[pos] = true
    r, c = size(racetrack)
    #@info r, c
    p = 0
    if pos[1] != 1 && racetrack[pos + U] == face
        grid[pos + U] = true
        allpaths!(grid,rolls,rolln+1,pos + U,racetrack)
        p += 1
    end
    if pos[1] != r && racetrack[pos + D] == face
        grid[pos + D] = true
        allpaths!(grid,rolls,rolln+1,pos + D,racetrack)
                p += 1
    end
    if pos[2] != 1 && racetrack[pos + L] == face
        grid[pos + L] = true
        allpaths!(grid,rolls,rolln+1,pos + L,racetrack)
                p += 1
    end
    if pos[2] != c && racetrack[pos + R] == face
        grid[pos + R] = true
        allpaths!(grid,rolls,rolln+1,pos + R,racetrack)
                p += 1
    end
    if face == racetrack[pos]
        allpaths!(grid,rolls,rolln+1,pos,racetrack)
                p += 1
    end
end

pt1 = solve()
pt1 = solve(1,"e")
pt2 = solve(2)
pt2 = solve(2,"e")
pt3e = solve(3,"e")

pt3 = solve(3)

using Colors
using ImageShow

pt3 = solve(3; image = true)

using BenchmarkTools
@benchmark solve(3)
