Data Encodings (dataenc): A collection of data encoding algorithms.
===================================================================

## Data encodings library

The data encodings library strives to provide implementations in Haskell of every major data encoding, and a few minor ones as well.  Currently the following encodings are implemented:

* Base16 (`Codec.Binary.Base16`)
* Base32 (`Codec.Binary.Base32`)
* Base32Hex (`Codec.Binary.Base32Hex`)
* Base64 (`Codec.Binary.Base64`)
* Base64Url (`Codec.Binary.Base64Url`)
* Base85 (`Codec.Binary.Base85`)
* Python string escaping (`Codec.Binary.PythonString`)
* Quoted-Printable (`Codec.Binary.QuotedPrintable`)
* URL encoding (`Codec.Binary.Url`)
* Uuencode (`Codec.Binary.Uu`)
* Xxencode (`Codec.Binary.Xx`)
* yEncode (`Codec.Binary.Yenc`)

In some cases the encodings also specify headers and footers for the encoded data. Implementation of that is left for the user of the library.

## The API

### Main API

The module <hask>Codec.Binary.DataEncoding</hask> provides a type that collects the functions for an individual encoding:

```haskell
data DataCodec = DataCodec {
    encode :: [Word8] -> String,
    decode :: String -> Maybe [Word8],
    decode' :: String -> [Maybe Word8],
    chop :: Int -> String -> [String],
    unchop :: [String] -> String
}
```

It also exposes instances of this type for each encoding:

```haskell
base16 :: DataCodec
base32 :: DataCodec
base32Hex :: DataCodec
base64 :: DataCodec
base64Url :: DataCodec
uu :: DataCodec
```

<b>NB</b> There is no instance for yEncoding since the functions in that module have slightly different type signatures.

### Secondary API

Each individual encoding module is also exposed and offers four functions:

```haskell
encode :: [Word8] -> String
decode :: String -> Maybe [Word8]
decode' :: String -> [Maybe Word8]
chop :: Int -> String -> [String]
unchop :: [String] -> String
```

## Description of the encodings

### Base16

Implemented as it's defined in [RFC 4648](http://tools.ietf.org/html/rfc4648).

Each four bit nibble of an octet is encoded as a character in the set 0-9,A-F.

### Base32

Implemented as it's defined in [RFC 4648](http://tools.ietf.org/html/rfc4648).

Five octets are expanded into eight so that only the five least significant bits are used.  Each is then encoded into a 32-character encoding alphabet.

### Base32Hex

Implemented as it's defined in [RFC 4648](http://tools.ietf.org/html/rfc4648).

Just like Base32 but with a different encoding alphabet.  Unlike Base64 and Base32, data encoded with Base32Hex maintains its sort order when the encoded data is compared bit wise.

### Base64

Implemented as it's defined in [RFC 4648](http://tools.ietf.org/html/rfc4648).

Three octets are expanded into four so that only the six least significant bits are used.  Each is then encoded into a 64-character encoding alphabet.

### Base64Url

Implemented as it's defined in [RFC 4648](http://tools.ietf.org/html/rfc4648).

Just like Base64 but with a different encoding alphabet.  The encoding alphabet is made URL and filename safe by substituting <tt>+</tt> and <tt>/</tt> for <tt>-</tt> and <tt>_</tt> respectively.

### Base85

Implementation as described in the [Wikipedia article](http://en.wikipedia.org/wiki/Ascii85).

### Python string escaping

Implementation of Python's string escaping.

### Quoted-Printable

Implemented as defined in [RFC 2045](http://tools.ietf.org/html/rfc2045).

### URL encoding

Implemented as defined in [RFC 3986](http://tools.ietf.org/html/rfc3986).

### Uuencode

Unfortunately uuencode is badly specified and there are in fact several differing implementations of it.  This implementation attempts to encode data in the same way as the `uuencode` utility found in [GNU's sharutils](http://www.gnu.org/software/sharutils).  The workings of `chop` and `unchop` also follow how sharutils split and unsplit encoded lines.

### Xxencode

Implemented as described in the [Wikipedia article](http://en.wikipedia.org/wiki/Xxencode).

### yEncoding

Implemented as it's defined in [the 1.3 draft](http://yence.sourceforge.net/docs/protocol/version1_3_draft.html).

## Downloading

The current release is available from [http://hackage.haskell.org/package/dataenc].

## Example of use

The package [omnicodec](http://hackage.haskell.org/cgi-bin/hackage-scripts/package/omnicodec) contains two command line tools for encoding and decoding data.

## Contributing

The source is hosted on [github](https://github.com/scrive/dataenc) and can be downloaded using git:

    git clone https://github.com/scrive/dataenc.git

