local target = ""
local last_events = {}

return function(event)
	-- On heading start, initialize last_events and consume input event
	local tag = event:as_start_tag()
	if tag ~= nil and tag:is_heading() then
		table.insert(last_events, event)
		return { }
	end

	-- On heading end, produce linkified header and return all consumed events
	tag = event:as_end_tag()
	if tag ~= nil and tag:is_heading() then
		local link_start = Event:html('<a href="' .. target .. '" class="header-link">')
		local link_end = Event:html('</a>')
		local events = last_events
		table.insert(events, 1, link_start)
		table.insert(events, event)
		table.insert(events, link_end)

		target = ""
		last_events = {}

		return events
	end

	-- If there is `{#target}` in text, extract `#target
	local text = event:as_text()
	if text ~= nil then
		local new_target = text:match('{(#[^"]-)}')
		if new_target ~= nil then
			target = new_target
		end
	end

	-- If we're consuming events, keep doing it
	if #last_events ~= 0 then
		table.insert(last_events, event)
		return { }
	end

	return { event }
end
