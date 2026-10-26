include("../../helper.jl")

function solve(part=1,problem="p")
    lines = loadlines(part=part,problem=problem)
    boardlines,tokens = splitvect(lines,"")
    board = parsegrid(boardlines)
    
    if part == 1
        sum(solveit.(Ref(board),tokens,1:9))
    elseif part ==2
        sum(maximise.(Ref(board),tokens))
    elseif part == 3
        nslots = (size(board,2)+1)÷2
        ntokens = length(tokens)
        arr = fill(0,(ntokens,nslots))
        for t in 1:ntokens
            for slot in 1:nslots
                arr[t,slot] = solveit(board,tokens[t],slot)
            end
        end
        arr
    end
end
function maximise(board,token)
    slots = (size(board,2) + 1) ÷ 2
    maximum(solveit.(Ref(board),Ref(token),1:slots))
end
function solveit(board,token,slot)
    @info token, slot
    steps = size(board,1)
    y = slot * 2 - 1
    t = 1
    for x in 1:steps
        @info x, y
        if board[x,y] == '*'
            #bounce
            if token[t] == 'R'
                if y == size(board,2)
                    y -= 1
                else
                    y += 1
                end
            else
                if y == 1
                    y += 1
                else
                    y -= 1
                end
            end
            t += 1
        end
        x += 1
    end
    @info slot, (y+1)/2, (y + 1) - slot
    coinswon = max(0,(y + 1) - slot)
end

pt1 = solve()
pt2 = solve(2)
pt3 = solve(3)

#solved by inspection pt3
sum([23,27,10,23,24,10])
9+14+5+8