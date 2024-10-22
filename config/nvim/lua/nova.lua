
local M = {}

-- TODO move this to repl
-- ghci> import Data.Time
-- ghci> a = UTCTime (fromGregorian 2023 10 5) (secondsToDiffTime 0)

function M.mkManifest(uuid)
  return vim.base64.encode ([[ {
   "resources": {}, "projectId": "00000000-1111-2222-3333-444444444444"
  } ]])
end
return M
