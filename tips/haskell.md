CABAL_HELPER_DEBUG=1


>>= vs >>
>> will discard the returned value
    removeSubflow socket token >>= inspectAnswers >> putStrLn "Finished announcing"

ghc-pkg -f /home/teto/netlink-hs find-module System.Linux.Netlink

pour savoir d'ou le pkg est importe:
	ghc-pkg find-module System.Linux.Netlink

Fun website
https://haskell-code-explorer.mfix.io/package/optparse-applicative-0.14.2.0/show/Options/Applicative/BashCompletion.hs

https://ghcguide.haskell.jp/8.4.3/users_guide/packages.html#package-databases

in ghci :

:show paths



Generate database with:
$ ghc-pkg -v -f /home/teto/netlink-hs  recache


How to configure cabal ?
https://www.haskell.org/cabal/users-guide/installing-packages.html
$ cabal user-config update
