include("../../helper.jl")
using Colors

function getinput(part=1,problem="p",nreps=1)
    lines = loadlines(part=part,problem=problem)
    dirs = CircularArray(split(lines[1],""))
    grid = parsegrid(lines[3:end])
    dirs, grid
end

function rotgrid!(grid,dirs,nrep)
    for _ in 1:nrep
        for i in 1:((size(grid,1)-2)*(size(grid,2)-2))
            row = (i-1) ÷ (size(grid,2)-2) + 2
            col = CircularArray(1:size(grid,2)-2)[i] + 1
            ci = CartesianIndex(row,col)
            cis = CircularArray([CartesianIndex(-1,-1),CartesianIndex(-1,0),
            CartesianIndex(-1,1),CartesianIndex(0,1),
            CartesianIndex(1,1),CartesianIndex(1,0),
            CartesianIndex(1,-1),CartesianIndex(0,-1)])
            m = dirs[i] == "L" ? 1 : -1
            t = grid[ci + cis[m]]
            for i in 1:length(cis)
                if i == length(cis)
                    grid[ci + cis[m*i]] = t
                else
                    grid[ci + cis[m*i]] = grid[ci + cis[m*(i+1)]]
                end
            end
        end
    end
    grid
end

function solve1(part=1,problem="p",nreps=1)
    dirs, grid = getinput(part,problem,nreps)

    rotgrid!(grid,dirs,nreps)

    for row in eachrow(grid)
        println(join(row))
    end

    parse(Int,join(grid[2:end-1,2:end-1]))
end

pt1 = solve1(1)
@show pt1

function solve2(part=1,problem="p",nreps=1)
    dirs, grid = getinput(part,problem,nreps)

    rotgrid!(grid,dirs,nreps)

    for row in eachrow(grid)
        println(join(row))
    end

    write("2024/outputs/19p$part.out",join([join(row) for row in eachrow(grid)],"\n"))
end

pt2 = solve2(2,"p",100)

function solve3(part=1,problem="p",nreps=1)
    dirs, cgrid = getinput(part,problem,nreps)

    grid = collect(CartesianIndices(cgrid))

    # 129 is dirs length and so ensures same dirs are applied
    grid129 = rotgrid!(grid,dirs,129)

    # 1048576000 == 129 * 2^6 * 17 * 31 * 241 - 129*48 + 16
    ga = gridmult(gridmult(gridmult(gridpow2(grid129,6),17),31),241)
    gb = gridmult(ga,gridmult(grid129,48))
    rotgrid!(gb,dirs,16)

    write("2024/outputs/19p$part.out",join([join(row) for row in eachrow(cgrid[gb])],"\n"))
    print("See file `2024/outputs/19p$part.out`")
end

pt3 = solve3(3)