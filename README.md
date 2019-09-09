# Custom Coders

![swift >= 4.0](https://img.shields.io/badge/swift-%3E%3D4.0-brightgreen.svg)
![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![Linux](https://img.shields.io/badge/os-linux-green.svg?style=flat)
[![Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg?style=flat)](LICENSE.md)

Provides the base for creating custom coders as well as a few complete coders like PListEncoder and PListDecoder which are cross platform Property List Coders

### Coders

* **BasicOpenEncoder** - The base class for custom encoders.  This requires the the inherited class provide a method that takes in the in-memory encoding (single value, array, dictionary) that as been done and transforms it into the wanted results.  The encode method takes in any Encodable object
* **BasicOpenDecoder** - The base class for custom decoders. This requires that the inherited class provides a method that takes in the encoded input and returns the in-memory results (single value, array, dictionary).  The decode method return any Decodable object
* **BasicSemiClosedEncoder** - The base class for semi-closed custom encoders.  This requires the the inherited class provide a method that takes in the in-memory encoding (single value, array, dictionary) that as been done and transforms it into the wanted results.  The encode method takes in a specific object type
* **BasicSemiClosedDecoder** - The base class for closed custom decoders. This requires that the inherited class provides a method that takes in the encoded input and returns the in-memory results (single value, array, dictionary).  The decode method return a specific object type
* **BasicClosedEncoder** - The base class for closed custom encoders.  This requires the the inherited class provide a method that takes in the in-memory encoding (single value, array, dictionary) that as been done and transforms it into the wanted results.  The encode method takes in a specific object type
* **BasicClosedDecoder** - The base class for closed custom decoders. This requires that the inherited class provides a method that takes in the encoded input and returns the in-memory results (single value, array, dictionary).  The decode method return a specific object type
* **SimpleEncoder** - A simple class that allows for a developer to convert and object into its in-memory equivalent
* **PListEncoder/PListDecoder** - Custom Encoder/Decoder for Property Lists.  When not building on an ObjectC runtime (Non Apple device) type aliases are setup for PropertyListEncoder/PropertyListDecoder to the equivilant PList object

### Choice Enums

* **EncoderChoice** - Provides a programmatic way of choosing which encoder to use. This is nice when providing end users with the choice of what type file to encode to
  * **xmlPList** - Use PropertyListEncoder or PListEncoder for xml depending on platform
  * **binaryPList** - Use PropertyListEncoder or PListEncoder for binary depending on platform
  * **json** - Use the standard JSONEncoder
  * **other** - You can specify your own instance of an encoder

* **DecoderChoice** - Provides a programmatic way of choosing which decoder to use.
  * **plist** -  Use PropertyListDecoder or PListDecoder depending on platform
  * **json** - If swift < 4.2 and BasicDecoderChoice.usePatchedJSONDecoder enabled, will use BasicCodableHelperPatchedJSONDecoder otherwise will use standard JSONDecoder
  * **other** - You can specify your own instance of a decoder
  
  
## Dependencies

* **[Basic Codable Helpers](https://github.com/TheAngryDarling/SwiftBasicCodableHelpers.git)** - Package that provides basic helper methods on Encoder and Decoder containers
* **[Nillable](https://github.com/TheAngryDarling/SwiftNillable.git)** - Package used to identify nil/NSNull objects when stored in Any format
* **[SwiftClassCollection](https://github.com/TheAngryDarling/SwiftClassCollections.git)** - Package used to work with swift class based collections that are equivalent to Array and Dictionary

## Author

* **Tyler Anger** - *Initial work*  - [TheAngryDarling](https://github.com/TheAngryDarling)

## License

This project is licensed under Apache License v2.0 - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

Based on and in some cases copied/modified from [Swift Source Code](https://github.com/apple/swift/blob/master/stdlib/public/core/Codable.swift.gyb) to ensure similar standards when dealing with encoding/decoding.
