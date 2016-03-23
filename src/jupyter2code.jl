using JSON

function jupyter2code(filenameIn::AbstractString, filenameOut::AbstractString, 
		linewidth::Int, tabwidth::Int)
	open(filenameIn, "r") do f
		result = jupyter2code(f, filenameOut)
	end
end

function jupyter2code(fileIn::IO, filenameOut::AbstractString, linewidth::Int, 
		tabwidth::Int)
	json = JSON.parse(fileIn)

	output = ""

	for cell in json["cells"]
		if cell["cell_type"] == "code"
			output *= join(cell["source"]) * "\n\n"
		elseif cell["cell_type"] == "markdown"
			# If list of strings, join together with no seperator as per docs
			# (If not a list, then this will have no impact)
			content = join(cell["source"])
			# Split the string into lines using '\n', then prepend a hash to 
			# each line, then join and readd '\n'
			# TODO address line seperator issue
			output *= join(map(prepend_hash, split(content, '\n')), '\n') * "\n\n"
		end
	end

	f = open(filenameOut, "w")
	write(f, output)
	close(f)
end

function prepend_hash(str::AbstractString)
	if str == ""
		return "# "
		# TODO make this intelligent - i.e it should be blank if it's the last 
		# in the comment block
	elseif str[1] == '#'
		# Don't add a space if the line already starts with a hash 
		return "#" * str 	
	else
		return "# " * str
	end
end

function splitlines(lines::Array{AbstractString, 1}, linewidth::Int, tabwidth::Int)
	result = Array{AbstractString, 1}()
	leftover = ""
	for line in lines
		combined = prepend_hash(leftover * line)
		if length(replace(combined, '\t', " "^tabwidth)) <= linewidth
			push!(result, combined)
		else
			push!(result, combined[1:80])
			leftover = combined[81:end]
		end
	end
	return result
end
