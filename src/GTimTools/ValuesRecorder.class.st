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
		'capturedValues',
		'attributes'
	],
	#category : #GTimTools
}

{ #category : #accessing }
ValuesRecorder >> addRecord: aRecord [
	self attributes addAll: aRecord names.
	^self capturedValues add: aRecord
]

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
		
		
	list actionDropdownButtonIcon: BrGlamorousVectorIcons target 
		tooltip: 'Set focus item' 
		content: [ :aButton | |l| (l := BrSimpleList new)
				items: self attributes asOrderedCollection;
				itemStencil: [
					BrButton new
						vFitContent;
						aptitude: BrGlamorousLabelAptitude new + BrGlamorousListItemAptitude 
						 ];

				itemDataBinder: [ :eachButton :eachItem :eachIndex | 
					eachButton 
						label: eachItem ;
						action: [ :aButtonElement | 
							self defaultAttribute: eachItem.
							 ] ];
					
				yourself].
		
	self attributes do: [:each |
	  list column: each text: [:item | item valueFor: each ]].
	  
	^list
]

{ #category : #accessing }
ValuesRecorder >> record: associationsArray [
	^self addRecord: (ValuesRecord for: associationsArray)
]
