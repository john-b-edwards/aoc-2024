# input
include("Utils.jl")
using .Utils
input = get_input(2024,21)
NUM_KEYPAD = ['7' '8' '9';'4' '5' '6';'1' '2' '3';' ' '0' 'A']
DIR_KEYPAD = [' ' '^' 'A';'<' 'v' '>']
DIRECTIONS = CartesianIndex.([(0,1),(-1,0),(0,-1),(1,0)])
inbounds(G, v) = (v[1] > 0) & (v[1] <= size(G)[1]) & (v[2] > 0) & (v[2] <= size(G)[2])
# part one
function find_paths(d1, d2, pad)
    d1_ndx, d2_ndx = findfirst(x->x==d1,pad),findfirst(x->x==d2,pad)
    dist = d2_ndx - d1_ndx
    x, y = dist[2], dist[1]
    horz = cat(repeat('>',abs(x) * (x > 0)),repeat('<',abs(x) * (x < 0)),dims = 1)
    vert = cat(repeat('^',abs(y) * (y < 0)),repeat('v',abs(y) * (y > 0)),dims = 1)
    if (x > 0) & (pad[CartesianIndex(d2_ndx[1],d1_ndx[2])] != ' ')
        return [join(vert) * join(horz) * "A"]
    elseif pad[CartesianIndex(d1_ndx[1],d2_ndx[2])] != ' '
        return [join(horz) * join(vert) * "A"]
    else
        return [join(vert) * join(horz) * "A"]
    end
end
function tally_paths(path, pad)
    routes = Dict()
    start = 'A'
    for x in path
        for y in find_paths(start, x, pad)
            routes[y] = get(routes, y, 0) + 1
        end
        start = x
    end
    return routes
end
function find_complexity(key, robots = 3)
    paths = tally_paths(key,NUM_KEYPAD)
    for n in 1:(robots-1)
        new_routes = Dict()
        for (x, y) in paths
            for (w, z) in tally_paths(x, DIR_KEYPAD)
                new_routes[w] = get(new_routes, w, 0) + z * y
            end
        end
        paths = new_routes
    end
    return parse(Int64,join(filter(!isnothing, tryparse.(Int64, split(key,""))))) * 
        sum([length(x) * y for (x,y) in paths])
end
println(sum(find_complexity.(input, [3])))
# part two
println(sum(find_complexity.(input, [26])))