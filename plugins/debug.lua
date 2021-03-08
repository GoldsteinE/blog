local write = io.write
local indent = '  '
local indent_level = 0

function show_tag(tag)
	if tag:is_paragraph() then
		write("paragraph")
	end

	if tag:is_heading() then
		local level = tag:as_heading()
		write("heading " .. tostring(level))
	end

	if tag:is_blockquote() then
		write("blockquote")
	end

	if tag:is_code_block() then
		local info_string = tag:as_info_string()
		if info_string == nil then
			write("indented code block")
		else
			write("fenced code block")
			if info_string ~= "" then
				write(": " .. info_string)
			end
		end
	end

	if tag:is_list() then
		local start = tag:as_list_start()
		if start == nil then
			write("unordered list")
		else
			write("ordered list")
			if start ~= 1 then
				write(": starting with " .. tostring(start))
			end
		end
	end

	if tag:is_item() then
		write("list item")
	end

	if tag:is_footnote_definition() then
		write("footnote definition: " .. tag:as_footnote_definition())
	end

	if tag:is_table() then
		write("table, alignments: ")
		for _, alignment in ipairs(tag:as_table_alignments()) do
			write(alignment .. " ")
		end
	end

	if tag:is_table_head() then
		write("table head")
	end

	if tag:is_table_row() then
		write("table row")
	end
	
	if tag:is_table_cell() then
		write("table cell")
	end

	if tag:is_emphasis() then
		write("emphasis")
	end

	if tag:is_strong() then
		write("strong")
	end
	
	if tag:is_strikethrough() then
		write("strikethrough")
	end

	if tag:is_link() then
		local link = tag:as_link()
		local title = link:title()
		write("link: " .. link:type(), " to '" .. link:destination() .. "'")

		if title ~= "" then
			write(", title '" .. title .. "'")
		end
	end

	if tag:is_image() then
		local link = tag:as_image()
		local title = link:title()
		write("image: " .. link:type(), " to '" .. link:destination() .. "'")

		if title ~= "" then
			write(", title '" .. title .. "'")
		end
	end
end

return function(event)
	if event:is_end_tag() then
		write(indent:rep(indent_level - 1))
	else
		write(indent:rep(indent_level))
	end

	if event:is_start_tag() then
		write("start: ")
		show_tag(event:as_start_tag())
		indent_level = indent_level + 1
	end

	if event:is_end_tag() then
		write("end: ")
		show_tag(event:as_end_tag())
		indent_level = indent_level - 1
	end

	if event:is_text() then
		write('text: r#"' .. event:as_text() .. '"#')
	end

	if event:is_code() then
		write('code: r#"' .. event:as_code() .. '"#')
	end

	if event:is_html() then
		write('html: r#"' .. event:as_html() .. '"#')
	end

	if event:is_footnote_reference() then
		write('html: r#"' .. event:as_footnote_reference() .. '"#')
	end

	if event:is_soft_break() then
		write('soft break')
	end

	if event:is_hard_break() then
		write('hard break')
	end

	if event:is_rule() then
		write('rule')
	end

	if event:is_task_list_marker() then
		write('task list marker: ')
		if event:as_task_list_marker() then
			write('checked')
		else
			write('unchecked')
		end
	end

	write('\n')
	return { event }
end
