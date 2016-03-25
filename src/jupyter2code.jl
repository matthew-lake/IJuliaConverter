using JSON

systemLineSep = @windows ? "\r\n" : "\n"

function jupyter2code(filenameIn::AbstractString, filenameOut::AbstractString; 
		linewidth=80, tabwidth=4)
	open(filenameIn, "r") do f
		result = jupyter2code(f, filenameOut, linewidth=linewidth, 
			tabwidth=tabwidth)
	end
end

function jupyter2code(fileIn::IO, filenameOut::AbstractString; linewidth=80, 
		tabwidth=4)
	json = JSON.parse(fileIn)

	output = ""

	for cell in json["cells"]
		if cell["cell_type"] == "code"
			# If list of strings, join together with no seperator as per docs
			# (If not a list, then this will have no impact)
			content = join(cell["source"])
			contentLineSep = length(matchall(r"\r\n", content)) > 0 ? "\r\n" : "\n"
			# Change to system newlines if needed
			if contentLineSep != systemLineSep
				content = join(split(content, contentLineSep), systemLineSep)
			end
			output *= content * systemLineSep^2
		elseif cell["cell_type"] == "markdown"
			# If list of strings, join together with no seperator as per docs
			# (If not a list, then this will have no impact)
			content = join(cell["source"])
			contentLineSep = length(matchall(r"\r\n", content)) > 0 ? "\r\n" : "\n"
			# Change to system newlines if needed
			if contentLineSep != systemLineSep
				content = join(split(content, contentLineSep), systemLineSep)
			end
			# Split into lines, prepend a hash to each line, join and add blank line
			output *= join(map(prepend_hash, split(content, systemLineSep)), 
				systemLineSep)	* systemLineSep^2
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

function splitlines(lines::Array{AbstractString, 1}, linewidth::Int, 
		tabwidth::Int)
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
