local M = {}

local state = {
    enabled = false,
}

M.state = state

function M.getEnabled()
    return M.state.enabled
end
function M.setEnabled(enabled)
    M.state.enabled = enabled
end

return M
