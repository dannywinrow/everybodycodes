include("../helper.jl")

function solve1(filename)
    hg = loadhashgrid(filename)
    hgcnt = similar(hg,Int)
    hgcnt .= hg

    function check(ci,hgcnt)
        if hgcnt[ci] > 0
            if all(!(n in CartesianIndices(hgcnt)) || hgcnt[n] >= hgcnt[ci] for n in adjacents(ci))
                hgcnt[ci] += 1
            end
        end
    end

    function dig(hgcnt)
        for ci in CartesianIndices(hgcnt)
            check(ci,hgcnt)
        end
        hgcnt
    end

    while (h = dig(copy(hgcnt))) != hgcnt
        hgcnt = h
    end

    sum(hgcnt)
end

pt1 = solve1(getfilename(2024,3,1))
@show pt1

pt2 = solve1(getfilename(2024,3,2))
@show pt2

function solve3(filename)
    hg = loadhashgrid(filename)
    hgcnt = similar(hg,Int)
    hgcnt .= hg

    function check(ci,hgcnt)
        if hgcnt[ci] > 0
            if all(n in CartesianIndices(hgcnt) && hgcnt[n] >= hgcnt[ci] for n in neighbours(ci))
                hgcnt[ci] += 1
            end
        end
    end

    function dig(hgcnt)
        for ci in CartesianIndices(hgcnt)
            check(ci,hgcnt)
        end
        hgcnt
    end

    while (h = dig(copy(hgcnt))) != hgcnt
        hgcnt = h
    end

    sum(hgcnt)
end

pt3 = solve3(getfilename(2024,3,3))
@show pt3