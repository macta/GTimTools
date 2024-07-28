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
		'isRecording',
		'capturedValues',
		'attributes',
		'defaultAttribute'
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
ValuesRecorder >> defaultAttribute [
	^ defaultAttribute ifNil: [ defaultAttribute := self attributes anyOne ]
]

{ #category : #accessing }
ValuesRecorder >> defaultAttribute: anObject [
	defaultAttribute := anObject
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
						label: eachItem allButLast;
						action: [ :aButtonElement | 
							self defaultAttribute: eachItem.
							 ] ];
					
				yourself].
		
	self attributes do: [:each |
	  list column: each allButLast text: [:item | item valueFor: each ]].
	  
	^list
]

{ #category : #accessing }
ValuesRecorder >> isRecording [
	^ isRecording
]

{ #category : #accessing }
ValuesRecorder >> isRecording: anObject [
	isRecording := anObject
]

{ #category : #accessing }
ValuesRecorder >> record: aBlock [
	| investigation |
	[ 
	investigation := ValuesRecord for: self.
	self isRecording: true.
	aBlock value: investigation ]
		ensure: [ 
			self isRecording: false.
			self attributes addAll: investigation complete.
			self capturedValues add: investigation ]
]
