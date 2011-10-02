module Paths_hist (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName
  ) where

import Data.Version (Version(..))
import System.Environment (getEnv)

version :: Version
version = Version {versionBranch = [0,0], versionTags = []}

bindir, libdir, datadir, libexecdir :: FilePath

bindir     = "/Users/alevy/Library/Haskell/ghc-7.0.3/lib/hist-0.0/bin"
libdir     = "/Users/alevy/Library/Haskell/ghc-7.0.3/lib/hist-0.0/lib"
datadir    = "/Users/alevy/Library/Haskell/ghc-7.0.3/lib/hist-0.0/share"
libexecdir = "/Users/alevy/Library/Haskell/ghc-7.0.3/lib/hist-0.0/libexec"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = catch (getEnv "hist_bindir") (\_ -> return bindir)
getLibDir = catch (getEnv "hist_libdir") (\_ -> return libdir)
getDataDir = catch (getEnv "hist_datadir") (\_ -> return datadir)
getLibexecDir = catch (getEnv "hist_libexecdir") (\_ -> return libexecdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
