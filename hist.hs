-- CSE 240H Lab 1 - Word Count & Histogram

import Data.Char
import Data.List
import qualified Data.Map as Map
import Text.Regex
import System.Environment

normalize :: String -> String
normalize word = map toLower (strip_cruft word) where
  strip_cruft word' = subRegex (mkRegex "[^a-zA-Z]*(.*[a-zA-Z])[^a-zA-Z]*") word' "\\1"

isWord :: String -> Bool
isWord str = any isAlpha str

addOccurance :: Ord a => a -> Map.Map a Int -> Map.Map a Int
addOccurance word m = Map.insert word (count + 1) m where
  count | Map.member word m = m Map.! word
        | otherwise = 0

countWords :: Ord a => [a] -> Map.Map a Int
countWords ws = foldr addOccurance Map.empty ws where

histogram :: Int -> Int -> (String, Int) -> IO ()
histogram max_key_length max_count (key, count) = putStrLn line_from_key_count where
  line_from_key_count = key ++ nchars " " ' ' (max_key_length - length key) ++
                          nchars "" '#' ((80 - max_key_length - 1) *
                                            count `div` max_count)
  nchars str c n | n <= 0 = str
                 | otherwise = nchars (c:str) c (n - 1)

compareCounts :: (String, Int) -> (String, Int) -> Ordering
compareCounts (_, count1) (_, count2) = compare count1 count2

main = do args <- getArgs
          let contents | length args > 0 = readFile $ head args
                       | otherwise = getContents
          text <- contents
          let ws = filter isWord $ map normalize (words text)
          let counts = countWords ws
          let max_key_length = maximum (map length (Map.keys counts))
          let max_count = maximum (Map.elems counts)
          let pairs =  reverse $ sortBy compareCounts $ Map.toList counts
          mapM (histogram max_key_length max_count) pairs
