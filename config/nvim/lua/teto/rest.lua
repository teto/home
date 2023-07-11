
local start_time = 0

local on_start_request =  function (req)
  -- vim.loop.gettimeofday()
  -- vim.fn.reltime()
 start_time = vim.loop.now()
 print("starting request")
end

local on_stop_request =  function  (req)
 local duration = vim.loop.now() - start_time
 print("stopped request with duration of ", duration)
end

vim.api.nvim_create_autocmd("User", {
pattern = "RestStartRequest",
once = true,
  callback = on_start_request
   -- function(opts)
   --  print("IT STARTED")
   --  vim.pretty_print(opts)
   --  -- print("IT STARTED")
  -- end,
})

vim.api.nvim_create_autocmd("User", {
pattern = "RestStopRequest",
once = true,
  callback =  on_stop_request
  -- function(opts)
  --   print("IT STARTED")
  --   vim.pretty_print(opts)
  --   -- print("IT STARTED")
  -- end,
})
