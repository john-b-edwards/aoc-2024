# input
include("Utils.jl")
using .Utils
input = get_input(2024,15)
input_1 = [x for x in input if x[1] == '#']
input_1 = split.(input_1,"")
input_1 = mapreduce(permutedims, vcat, input_1)
input_1 = [string(i) for i in input_1]
input_1_stored = copy(input_1)
input_2 = split(join([x for x in input if x[1] != '#']),"")
# part one
move_dict = Dict("^"=>CartesianIndex(-1,0),">"=>CartesianIndex(0,1),"v"=>CartesianIndex(1,0),"<"=>CartesianIndex(0,-1))
function process_move(mat, point, direction)
    to_move, to_check, checked = [point], [point + move_dict[direction]], []
    new_mat = copy(mat)
    while to_check != []
        v = pop!(to_check)
        if mat[v] == "#"
            return mat
        elseif (mat[v] == "]") & !in(v, checked)
            push!.([to_move], [v, v + CartesianIndex(0,-1)])
            push!.([to_check], [v, v + CartesianIndex(0,-1), v + move_dict[direction]])
        elseif (mat[v] == "[") & !in(v, checked)
            push!.([to_move], [v, v + CartesianIndex(0,1)])
            push!.([to_check], [v, v + CartesianIndex(0,1), v + move_dict[direction]])
        elseif (mat[v] != ".") & !in(v, checked)
            push!(to_move, v)
            push!(to_check, v + move_dict[direction])
        end
        push!(checked, v)
    end
    for p in unique(to_move)
        new_mat[p + move_dict[direction]] = mat[p]
        if !in(p - move_dict[direction], to_move) new_mat[p] = "." end
    end
    new_mat[point] = "."
    return new_mat
end
function calc_gps_score(mat)
    return sum([100 * (x[1]-1) + (x[2]-1) for x in findall(x->x in ["O","["], mat)])
end

robot = findfirst(x->x=="@", input_1)
for move in input_2
    global input_1 = process_move(input_1, robot, move)
    global robot = findfirst(x->x=="@", input_1)
end
println(calc_gps_score(input_1))
# part two
input_1 = copy(input_1_stored)
newmat = fill(" ", size(input_1)[1], size(input_1)[2] .* 2)
for i in 1:size(input_1)[2], j in 1:size(input_1)[1]
    if input_1[i,j] == "#" newmat[i,(2j-1):(2j)] = ["#","#"]
    elseif input_1[i,j] == "O" newmat[i,(2j-1):(2j)] = ["[","]"]
    elseif input_1[i,j] == "." newmat[i,(2j-1):(2j)] = [".","."]
    elseif input_1[i,j] == "@" newmat[i,(2j-1):(2j)] = ["@","."] end
end
robot = findfirst(x->x=="@", newmat)
for move in input_2
    global newmat = process_move(newmat, robot, move)
    global robot = findfirst(x->x=="@", newmat)
end
println(calc_gps_score(newmat))