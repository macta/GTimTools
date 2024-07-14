"
I am a template suitable for capturing arbitrary values to later explore in a GTColumnView .

Instantiate an instance and use like this:
```
interestingThings := ValuesRecorder new. 

srcFiles allFiles do:[:f | 
   ""Do some operations""
   interestingFiles record: [ :r | r name: f basename; file: f]].
```

"
Class {
	#name : #ValuesRecorder,
	#superclass : #Object,
	#instVars : [
		'measures',
		'templateValues',
		'currentInvestigation',
		'capturedValues',
		'attributes'
	],
	#category : #GTimTools
}

{ #category : #accessing }
ValuesRecorder >> attributes [
	^attributes ifNil: [ attributes := Set new ]
]

{ #category : #accessing }
ValuesRecorder >> capturedValues [
	^capturedValues ifNil: [ capturedValues := OrderedCollection new ]
]

{ #category : #accessing }
ValuesRecorder >> gtDetailsFor: composite [
	<gtView>
	| list |
	list := composite columnedList
		title: 'Values';
		priority: 10;
		items: [ self capturedValues ];
		send: #yourself;
		yourself.
		
	self attributes do: [:each |
	  list column: each allButLast text: [:item | item valueFor: each ]].
	  
	^list
]

{ #category : #accessing }
ValuesRecorder >> record: aBlock [
	| investigation |
	[ 
	investigation := ValuesRecord new.
	aBlock value: investigation ]
		ensure: [ 
			self attributes addAll: investigation complete.
			self capturedValues add: investigation ]
]
