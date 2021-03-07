return function(event)
	local html = event:as_html()
	if html ~= nil
	   and html:find("^%s*<!%-%-[^-].-%-%->%s*$") == 1
	   and html:find("<!%-%- more %-%->") == nil
	then
		return { }
	end

	return { event }
end
