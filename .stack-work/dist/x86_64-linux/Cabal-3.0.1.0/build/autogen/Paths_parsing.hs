{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_parsing (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/jack/Documents/haskell-projects/parsing/.stack-work/install/x86_64-linux/a1837304c9bac7c83d988250740a23073f6c051ca349c16f33bba71172d8f77e/8.8.4/bin"
libdir     = "/home/jack/Documents/haskell-projects/parsing/.stack-work/install/x86_64-linux/a1837304c9bac7c83d988250740a23073f6c051ca349c16f33bba71172d8f77e/8.8.4/lib/x86_64-linux-ghc-8.8.4/parsing-0.1.0.0-IyFAkxPFPwIDavpcn3nXgx"
dynlibdir  = "/home/jack/Documents/haskell-projects/parsing/.stack-work/install/x86_64-linux/a1837304c9bac7c83d988250740a23073f6c051ca349c16f33bba71172d8f77e/8.8.4/lib/x86_64-linux-ghc-8.8.4"
datadir    = "/home/jack/Documents/haskell-projects/parsing/.stack-work/install/x86_64-linux/a1837304c9bac7c83d988250740a23073f6c051ca349c16f33bba71172d8f77e/8.8.4/share/x86_64-linux-ghc-8.8.4/parsing-0.1.0.0"
libexecdir = "/home/jack/Documents/haskell-projects/parsing/.stack-work/install/x86_64-linux/a1837304c9bac7c83d988250740a23073f6c051ca349c16f33bba71172d8f77e/8.8.4/libexec/x86_64-linux-ghc-8.8.4/parsing-0.1.0.0"
sysconfdir = "/home/jack/Documents/haskell-projects/parsing/.stack-work/install/x86_64-linux/a1837304c9bac7c83d988250740a23073f6c051ca349c16f33bba71172d8f77e/8.8.4/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "parsing_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "parsing_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "parsing_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "parsing_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "parsing_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "parsing_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
