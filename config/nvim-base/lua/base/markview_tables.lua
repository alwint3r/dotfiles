-- Keep Markview's normal table rendering when it succeeds. If it skips a
-- wrapped table, retry its full layout without changing the buffer contents.
return function(buffer, item)
	local markdown = require('markview.renderers.markdown')
	local window = require('markview.utils').buf_getwin(buffer)
	if not window or not vim.wo[window].wrap then
		return markdown.table(buffer, item)
	end

	local first = { item.range.row_start, item.range.col_start }
	local last = { item.range.row_end, 0 }
	local marks_before = vim.api.nvim_buf_get_extmarks(buffer, markdown.ns, first, last, {})
	markdown.table(buffer, item)
	local marks_after = vim.api.nvim_buf_get_extmarks(buffer, markdown.ns, first, last, {})
	if #marks_after > #marks_before then
		return
	end

	-- The upstream width guard has no configuration switch. Use the existing
	-- nowrap renderer for this synchronous call only, then restore wrapping
	-- and the view. Suppress OptionSet to avoid recursive rendering and other
	-- plugins reacting to this temporary change. Wide rows may still wrap
	-- imperfectly; this is a best-effort layout, not browser-style cell wrapping.
	local view = vim.api.nvim_win_call(window, vim.fn.winsaveview)
	local eventignore = vim.o.eventignore
	vim.opt.eventignore:append('OptionSet')
	local rendered, render_error = pcall(function()
		vim.wo[window].wrap = false
		markdown.table(buffer, item)
	end)
	local restored, restore_error = pcall(function()
		vim.wo[window].wrap = true
		vim.api.nvim_win_call(window, function()
			vim.fn.winrestview(view)
		end)
	end)
	vim.o.eventignore = eventignore

	if not restored then
		error(restore_error)
	end
	if not rendered then
		error(render_error)
	end
end
