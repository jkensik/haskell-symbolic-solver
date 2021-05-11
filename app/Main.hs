{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE DataKinds #-}


module Main where

-- for the Read instance
import Text.Read.Lex
import Text.ParserCombinators.ReadPrec
import GHC.Read

import Debug.Trace

import Data.Char
import Control.Monad
import Control.Monad.Identity (Identity)
import System.Environment (getArgs)
import Text.Parsec

import Lib

newtype Operator = Operator (forall a . Num a => (a -> a -> a))

instance Read Operator where
  readPrec = do Symbol x <- lexP
                case x of
                  "-"     -> return $ Operator (-)
                  "\8211" -> return $ Operator (-)
                  "+"     -> return $ Operator (+)
                  _       -> pfail
                  
instance Show Operator where
  show (Operator x) = case x 0 1 of
                            -1 -> "-"
                            1  -> "+"
                            _  -> "unknown Operator"


data Algebra where
  Num       :: (Num a, Show a) => a -> Algebra
  Variable  :: String -> Algebra
  Operation :: Operator -> Algebra
  Statement :: String -> Algebra       -- = or <= or >=
  Parens    :: [Algebra] -> Algebra

instance Show Algebra where
  show x = case x of
             Num       a -> show a
             Variable  a -> show a
             Operation a -> show a
             Statement a -> show a
             Parens    a -> join $ map show a

number :: Stream s m Char => ParsecT s u m Algebra
number =  do x <- many1 digit
             return $ Num $ read x

variable :: Stream s m Char => ParsecT s u m Algebra
variable = do x <- many1 letter
              return $ Variable x

operator :: Stream s m Char => ParsecT s u m Algebra
operator = do x <- oneOf "-+\8211" <* parserTrace "test"
              return $ Operation $ read [x]

statement :: Stream s m Char => ParsecT s u m Algebra
statement = do x <- oneOf "="
               return $ Statement $ [x]

  
parenthesis :: Stream s m Char => ParsecT s u m Algebra  -- abstract this function
parenthesis = do char '('
                 parserTrace "test"
                 x <- (many1 $ noneOf ")") <* parserTrace "test1"
                 return $ trace (show x) ()
                 char ')'
                 parserTrace "test"
                 y <- return $ parse parseWithStructure "paren" x
                 parserTrace "I"
                 return $ Parens $ content y
          where
            content = either (\_ -> []) id

parseAlgebra :: Stream s m Char => ParsecT s u m Algebra
parseAlgebra =  do x <- withSpace parenthesis <|> withSpace variable <|> withSpace number <|> withSpace statement <|> withSpace operator
                   return x

parseWithStructure :: Stream s m Char => ParsecT s u m [Algebra]
parseWithStructure =  many1 $ withSpace parseAlgebra

main :: IO ()
main = do args <- getArgs
          if (args !! 0) == "True" --read file
            then 
                (readFile (args !! 1) >>= return . show . readLines) >>= putStrLn
            else
                do putStrLn $ show . fst . readLines $ args !! 2 -- cmd args
                   putStrLn $ show . snd . readLines $ args !! 2
  
readLines :: Stream s Identity Char => s -> ([Algebra],String)
readLines input = case parse (many1 $ parseWithStructure) "algebra" input of
    Left err -> ([Parens []], show err)
    Right val -> ( join val, "value found")


withSpace :: Stream s m Char => ParsecT s u m a -> ParsecT s u m a
withSpace p = do  optional spaces
                  x <- p
                  optional spaces
                  return x
