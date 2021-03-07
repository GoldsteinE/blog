local langs = {
	cpp = 'C++'
}

local function extract_lang(tag)
	local info_string = tag:as_info_string()
	if info_string == nil or info_string == "" then
		return nil
	end

	local lang = langs[info_string]
	if lang ~= nil then
		return lang
	end

	local first = info_string:sub(1, 1)
	local rest = info_string:sub(2)
	return first:upper() .. rest:lower()
end

return function(event)
	local tag = event:as_start_tag()
	if tag ~= nil then
		local lang = extract_lang(tag)
		if lang ~= nil then
			return {
				Event:html(
					'<figure class="code-wrapper"><figcaption class="code-lang">'
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
