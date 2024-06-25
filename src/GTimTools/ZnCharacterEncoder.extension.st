Extension { #name : #ZnCharacterEncoder }

{ #category : #'*GTimTools' }
ZnCharacterEncoder class >> tmDetectEncoding: bytes [
	"Return one of my instances capable of decoding bytes.
	This is done by successively trying known encodings in a specific order.
	If no one is found, signal ZnCharacterEncodingError.
	This is a heuristic and unreliable [https://en.wikipedia.org/wiki/Charset_detection]."

	"Use a stable ordered candidates list, utf8 is the standard default, then attempt utf16 to avoid mojibake via iso88591 which is a reasonable default"
	
	^self tmDetectEncoding: bytes prioritising: #(utf8 utf16 iso88591)
]

{ #category : #'*GTimTools' }
ZnCharacterEncoder class >> tmDetectEncoding: bytes prioritising: stableEncodings [
	"Return one of my instances capable of decoding bytes.
	This is done by successively trying known encodings in a specific order.
	If no one is found, signal ZnCharacterEncodingError.
	This is a heuristic and unreliable [https://en.wikipedia.org/wiki/Charset_detection]."

	| candidates |
	
	"Duplicates in the candidates are fine, as its the first to succeed that wins"
	candidates := stableEncodings, ZnByteEncoder knownEncodingIdentifiers, self knownEncodingIdentifiers .
	
	"Try each and return the first one that succeeeds."
	candidates do: [ :identifier | | encoder |
		encoder := self newForEncoding: identifier.
		[ ^ encoder decodeBytes: bytes; yourself ] on: ZnCharacterEncodingError do: [ ] ].
	ZnCharacterEncodingError signal: 'No suitable encoder found'
]
