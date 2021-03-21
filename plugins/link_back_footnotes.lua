return function(event)
	local backref = event:as_footnote_reference()
	if backref ~= nil then
		return {
			Event:html('<a id="back-' .. backref .. '"></a>'),
			event,
		}
	end

	local tag = event:as_end_tag()
	if tag ~= nil then
		local footnote_definition = tag:as_footnote_definition()
		if footnote_definition ~= nil then
			local link_tag = Tag:link("Inline", "#back-" .. footnote_definition, "Back")
			local link_start = Event:tag_start(link_tag)
			local link_text = Event:text('[назад]')
			local link_end = Event:tag_end(link_tag)
			return {
				link_start,
				link_text,
				link_end,
				event,
			}
		end
	end

	return { event }
end
