# input
using LinearAlgebra
include("Utils.jl")
using .Utils
input = get_input(2024,4)
input = split.(input,"")
# part one
search_xmas(x) = sum(length.(findall.(r"XMAS",x)))
transpose_str(x) = permutedims(x, (2,1))
mat = mapreduce(permutedims, vcat, input)
rev_mat = mapreduce(permutedims, vcat, reverse.(input))
# look left and right
n_left = search_xmas(join.(eachrow(mat)))
n_right = search_xmas(reverse.(join.(eachrow(mat))))
# look up and down
n_up = search_xmas(join.(eachrow(transpose_str(mat))))
n_down = search_xmas(reverse.(join.(eachrow(transpose_str(mat)))))
# look diagonally
dim = size(mat)[1]
diags_1 = diag.([mat],(1-dim):(dim-1))
diags_2 = diag.([rev_mat],(1-dim):(dim-1))
n_diag_1 = search_xmas(join.(diags_1))
n_diag_2 = search_xmas(reverse.(join.(diags_1)))
n_diag_3 = search_xmas(join.(diags_2))
n_diag_4 = search_xmas(reverse.(join.(diags_2)))
println(n_left + n_right + n_up + n_down + n_diag_1 + n_diag_2 + n_diag_3 + n_diag_4)
# part two
global counter = 0
for i in 1:size(mat)[1]-2
    for j in 1:size(mat)[2]-2
        slice = mat[i:(i+2),j:(j+2)]
        slice_diag_1 = slice[1,1] * slice[2,2] * slice[3,3]
        slice_diag_2 = slice[1,3] * slice[2,2] * slice[3,1]
        if ((slice_diag_1== "MAS") | (slice_diag_1 == "SAM")) & ((slice_diag_2 == "MAS") | (slice_diag_2 == "SAM"))
            global counter = counter + 1
        end
    end
end
println(counter)