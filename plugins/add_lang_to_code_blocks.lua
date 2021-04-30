local langs = {
	cpp = 'C++',
	gas = 'GNU Assembly',
	ocaml = 'OCaml',
}

local function extract_lang(tag)
	local info_string = tag:as_info_string()
	if info_string == nil or info_string == "" then
		return nil, nil 
	end

	local words = info_string:gmatch('([^,]+)')
	local lang_code = words()
	local extra = {}

	for word in words do
		if lang_code == nil then
			lang_code = word
		else
			local key, value = word:match('^([^=]+)=?(.*)$')
			if value == "" then
				value = true
			end
			extra[key] = value
		end
	end

	local lang = langs[lang_code]
	if lang ~= nil then
		return lang, extra 
	end

	local first = lang_code:sub(1, 1)
	local rest = lang_code:sub(2)
	return first:upper() .. rest:lower(), extra 
end

return function(event)
	local tag = event:as_start_tag()
	if tag ~= nil then
		local lang, extra = extract_lang(tag)

		local class = 'code-lang'
		if extra ~= nil and extra['filename'] ~= nil then
			lang = extra['filename']
			class = 'code-filename'
		end

		if lang ~= nil then
			return {
				Event:html(
					'<figure class="code-wrapper"><figcaption class="' .. class .. '">'
					.. lang
					.. '</figcaption>'
				),
				event
			}
		end
	end

	local tag = event:as_end_tag()
	if tag ~= nil then
		if extract_lang(tag) ~= nil then
			return {
				event,
				Event:html('</figure>')
			}
		end
	end

	return { event }
end
