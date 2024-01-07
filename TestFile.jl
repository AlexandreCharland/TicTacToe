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

# Use a regular expression to find all numeric sequences in the string
matches = eachmatch(r"\d+", input_string)

# Filter out the empty strings and convert the remaining strings to an array
result = [match.match for match in matches]
print(length(split("a05b05c1d1e2f2g3h3i440/", "/")))
# Print the result
#println("Left side occurrences: ", left_occurrences)
#println("Right side occurrences: ", right_occurrences)
