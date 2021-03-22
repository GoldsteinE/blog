local function extract_destination(tag)
	if tag ~= nil then
		local image = tag:as_image()
		if image ~= nil then
			local link_type = image:type()
			if link_type == "Inline" or link_type == "Autolink" then
				return image:destination()
			end
		end
	end
end

return function(event)
	local tag = event:as_start_tag()
	local dest = extract_destination(tag)
	if dest ~= nil then
		return {
			Event:html(
				'<a href="'
				.. dest
				.. '" class="image-link" target="_blank">'
			),
			event,
		}
	end

	tag = event:as_end_tag()
	dest = extract_destination(tag)
	if dest ~= nil then
		return {
			event,
			Event:html('</a>'),
		}
	end

	return { event }
end
