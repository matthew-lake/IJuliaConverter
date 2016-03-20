using JSON

function jupyter2code(filenameIn, filenameOut)
	json = JSON.parsefile(filenameIn)

	output = ""

	for cell in json["cells"]
		if cell["cell_type"] == "code"
			output *= join(cell["source"]) * "\n\n"
		elseif cell["cell_type"] == "markdown"
			output *= join(map(prependHash, cell["source"])) * "\n\n"
		end
	end

	f = open(filenameOut, "w")
	write(f, output)
	close(f)
end

function prependHash(str)
	if str[1] == '#'
		return "#" * str 
	else
		return "# " * str
	end
end

jupyter2code(ARGS[1], split(ARGS[1], '/')[end] * ".jl")
