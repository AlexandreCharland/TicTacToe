function count_occurrences(input_string::AbstractString)
    parts = split(input_string, '/')

    length(parts) == 2 || throw(ArgumentError("Input string should contain exactly one '/'"))

    left_part1, right_part = parts[1], parts[2]
    left_part = left_part1[1:end-1]

    left_occurrences = Dict(c => count(x -> x == c, left_part) for c in '0':'9')

    right_occurrences = Dict(c => count(x -> x == c, right_part) for c in '0':'9')

    return left_occurrences, right_occurrences
end

# Example usage:
input_string = "abc054d3e1f00g1h3i1/00134455"
left_occurrences, right_occurrences = count_occurrences(input_string)

arr = [0, 3, 4]
zipped = zip(arr[1:2], arr[2:end])
#println("Left side occurrences: ", left_occurrences)
#println("Right side occurrences: ", right_occurrences)
println(zipped)