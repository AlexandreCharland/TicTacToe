
# Verify the length and the player number of the JAN
function VerifyLength(leftPart::AbstractString, rightPart::AbstractString)
    if ((length(leftPart) + length(rightPart) + 1) != 23)
        return false
    else
	    if ((length(leftPart) >= 10) && (length(rightPart) <= 12))
            if (leftPart[-1] == "0" || leftPart[-1] == "1")
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
    leftOccurrences = Dict(c => count(x -> x == c, leftPart) for c in '0':'9')

    # Count occurrences on the right side
    rightOccurrences = Dict(c => count(x -> x == c, rightPart) for c in '0':'9')

    # Verification
    for c in '0':'9'
        totalOccurences = leftOccurrences[c] + rightOccurrences[c]
        if (totalOccurences != 2)
            return false
        end
    end
    return true
end

function VerifySuperiority(leftPart::AbstractString)
    string = leftPart[1:end-1]
    numbers = ExtractNumbers(string)
    for i in 1:length(numbers)-1
        if div(numbers[i], 2) >= div(numbers[i+1], 2)
            return false
        end
    end
    return true
end

# Take a string and return an array of the numbers contained in the string
function ExtractNumbers(string::AbstractString)
    numbers = matchall(r"\d+", string)
    return parse.(Int, numbers)
end