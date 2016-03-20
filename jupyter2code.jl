using JSON

function jupyter2code(filenameIn::AbstractString, filenameOut::AbstractString, 
		linewidth::Int)
	open(filenameIn, "r") do f
		result = jupyter2code(f, filenameOut)
	end
end

function jupyter2code(fileIn::IO, filenameOut::AbstractString, linewidth::Int)
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
			output *= join(map(prependHash, split(content, '\n')), '\n') * "\n\n"
		end
	end

	f = open(filenameOut, "w")
	write(f, output)
	close(f)
end

function prependHash(str)
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

jupyter2code(ARGS[1], split(ARGS[1], '/')[end] * ".jl", 80)
