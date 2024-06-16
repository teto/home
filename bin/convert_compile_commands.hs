{-# LANGUAGE OverloadedStrings #-}

import Control.Applicative
import Control.Monad
import Data.Aeson
import Data.Aeson.TH
import Data.ByteString.Lazy
import qualified Data.ByteString.Lazy.Char8 as BL

-- import Text.JSON

data Toto = Toto
    { directory :: String
    , command :: String
    , file :: String
    }
    deriving (Show, Eq)

instance FromJSON Toto where
    parseJSON (Object v) =
        Toto
            <$> v .: "directory"
            <*> v .: "command"
            <*> v .: "file"
    parseJSON _ = mzero

-- dumpEntries :: [Toto] -> IO ()
-- dumpEntries [] = return
-- dumpEntries n = do
--   dumpEntry $ Prelude.head n
--   dumpEntries $ Prelude.tail n
--   return

-- updateCommand :: String -> String
-- updateCommand n = "-E" ++ (command n)

dumpEntry :: Toto -> Toto
-- dumpEntry n = n { command = "-E" ++ command n }
-- replace the first word by firstword " -E " tail
dumpEntry n = n{command = Prelude.head (words $ command n) ++ " -E " ++ unwords (Prelude.tail $ words $ command n)}

main :: IO ()
main = do
    -- IO bytestring
    content <- Data.ByteString.Lazy.readFile "build/compile_commands.json"
    -- unpack converts to
    -- decodeEither
    let r = eitherDecode content :: (Either String [Toto])
    case r of
        Left err -> Prelude.putStrLn err
        Right e -> print $ dumpEntry $ Prelude.head e
    -- let r = decode content
    -- case r of
    --   Nothing -> Prelude.putStrLn "Error"
    --   Just r -> Prelude.putStrLn r
    -- let a = decode "{\"name\":\"Joe\",\"age\":12}" :: Maybe Person
    -- let a = decode {
    -- "directory": "/home/teto/neovim2/build",
    -- "command": "/usr/bin/cc  -DINCLUDE_GENERATED_DECLARATIONS -D_GNU_SOURCE -Iconfig -I../src -isystem ../.deps/usr/include -Isrc/nvim/auto -Iinclude -I../.deps/usr/include/luajit-2.0   -Wconversion -DNVIM_MSGPACK_HAS_FLOAT32 -g   -Wall -Wextra -pedantic -Wno-unused-parameter -Wstrict-prototypes -std=gnu99 -Wvla -fstack-protector-strong -fdiagnostics-color=auto -o src/nvim/CMakeFiles/test-includes-version-h.dir/auto/version.h.test-include.c.o   -c /home/teto/neovim2/build/src/nvim/auto/version.h.test-include.c",
    -- "file": "/home/teto/neovim2/build/src/nvim/auto/version.h.test-include.c"
    -- }
    Prelude.putStrLn "hello"
