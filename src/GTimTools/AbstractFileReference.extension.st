Extension { #name : #AbstractFileReference }

{ #category : #'*GTimTools' }
AbstractFileReference >> contentsDecoded [
	| encoding |
	encoding := [ self
			binaryReadStreamDo: [ :in | (ZnCharacterEncoder tmDetectEncoding: in upToEnd) identifier ] ]
			on: ZnCharacterEncodingError
			do: [ :ex | ex return: 'utf8lossy' ].
			
	^ self readStreamEncoded: encoding do: [ :stream | stream contents ]
]
