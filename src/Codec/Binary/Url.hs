-- |
-- Module    : Codec.Binary.Url
-- Copyright : (c) 2009 Magnus Therning
-- License   : BSD3
--
-- URL encoding, sometimes referred to as URI encoding or percent encoding.
-- Implemented based on RFC 3986 (<http://tools.ietf.org/html/rfc3986>).
--
-- Further documentation and information can be found at
-- <http://www.haskell.org/haskellwiki/Library/Data_encoding>.

module Codec.Binary.Url
    ( encode
    , decode
    , decode'
    , chop
    , unchop
    ) where

import qualified Data.Map as M
import Data.Char(ord)
import Data.Word(Word8)

import Codec.Binary.Util(toHex,fromHex)

_unreservedChars = (zip [65..90] "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        ++ (zip [97..122] "abcdefghijklmnopqrstuvwxyz")
        ++ (zip [48..57] "0123456789")
        ++ [(45, '-'), (95, '_'), (46, '.'), (126, '~')]

encodeMap :: M.Map Word8 Char
encodeMap = M.fromList _unreservedChars

decodeMap :: M.Map Char Word8
decodeMap = M.fromList [(b, a) | (a, b) <- _unreservedChars]

-- {{{1 encode
-- | Encode data.
encode :: [Word8]
    -> String
encode [] = ""
encode (o:os) = case (M.lookup o encodeMap) of
    Just c -> c : encode os
    Nothing -> ('%' : toHex o) ++ encode os

-- {{{1 decode
-- | Decode data (lazy).
decode' :: String
    -> [Maybe Word8]
decode' [] = []
decode' ('%':c0:c1:cs) = fromHex [c0, c1] : decode' cs
decode' (c:cs)
    | c /= '%' = (Just $ fromIntegral $ ord c) : decode' cs
    | otherwise = [Nothing]

-- | Decode data (strict).
decode :: String
    -> Maybe [Word8]
decode = sequence . decode'

-- {{{1 chop
-- | Chop up a string in parts.
chop :: Int     -- ^ length of individual lines
    -> String
    -> [String]
chop n = let
        _n = max 1 n
        _chop [] = []
        _chop cs = take _n cs : (_chop $ drop _n cs)
    in _chop

-- {{{1 unchop
-- | Concatenate the strings into one long string
unchop :: [String]
    -> String
unchop = foldr (++) ""