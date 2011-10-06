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
isWord = any isAlpha

countWords :: Ord a => [a] -> Map.Map a Int
countWords ws = foldl addOccurance Map.empty ws where
  addOccurance m word = Map.insert word (count + 1) m where
    count | Map.member word m = m Map.! word
          | otherwise = 0

histogramLine :: Int -> Int -> (String, Int) -> String
histogramLine max_key_length max_count (key, count) = key ++ nchars " " ' ' (max_key_length - length key) ++
                          nchars "" '#' ((80 - max_key_length - 1) *
                                            count `div` max_count) where
  nchars str c n | n <= 0 = str -- Append n of c to str
                 | otherwise = nchars (c:str) c (n - 1)

histogramPairs text = reverse $ sortBy compareCounts $ Map.toList $ countWords ws where
                        ws = filter isWord $ map normalize (words text)
                        compareCounts (_, count1) (_, count2) = compare count1 count2

main = do args <- getArgs
          text <- if length args > 0 then readFile $ head args
                 else getContents
          -- Process pairs into [(word, count)]
          let pairs = histogramPairs text
          let max_key_length = maximum $ map (length . fst) pairs
          let max_count = maximum $ map snd pairs
          -- And output results
          mapM_ (putStrLn . histogramLine max_key_length max_count) pairs
