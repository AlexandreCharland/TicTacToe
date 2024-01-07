
# Verify the length and the player number of the JAN
function VerifyLength(leftPart::AbstractString, rightPart::AbstractString)
    if ((length(leftPart) + length(rightPart) + 1) != 23)
        return false
    else
	    if ((length(leftPart) >= 10) && (length(rightPart) <= 12))
            if (leftPart[end] == '0' || leftPart[end] == '1')
                return true
            else
                return false
            end
	    else
	        return false
	    end
    end
end

# This method verify that there is exactly two occurences of the same piece.
function CountOccurrences(leftPart1::AbstractString, rightPart::AbstractString)
    # Remove the player number
    leftPart = leftPart1[1:end-1]

    # Count occurrences on the left side
    leftOccurrences = Dict(c => count(x -> x == c, leftPart) for c in '0':'5')

    # Count occurrences on the right side
    rightOccurrences = Dict(c => count(x -> x == c, rightPart) for c in '0':'5')

    #println(leftOccurrences, rightOccurrences)

    # Verification
    for c in '0':'5'
        totalOccurences = leftOccurrences[c] + rightOccurrences[c]
        if (totalOccurences != 2)
            return false
        end
    end
    return true
end

# Verify if the 
function VerifySuperiority(leftPart::AbstractString)
    string = leftPart[1:end-1]
    numbers = ExtractNumbers(string)
    for group in numbers
        if (length(group) >= 2)
            for i in 1:length(group)-1
                if div(parse(Int, group[i]), 2) >= div(parse(Int, group[i+1]), 2)
                    return false
                end
            end
        end
    end
    return true
end

# Take a string and return an array of the numbers contained in the string
function ExtractNumbers(string::AbstractString)
    numbers = eachmatch(r"\d+", string)
    result = [ match.match for match in numbers]
    return result
end