"
I am collection of key/value pairs that record a useful interaction that can be explored in a GtView via a `ValuesRecorder`.
"
Class {
	#name : #ValuesRecord,
	#superclass : #Object,
	#instVars : [
		'isRecording',
		'templateValues'
	],
	#category : #GTimTools
}

{ #category : #accessing }
ValuesRecord >> complete [
	"Finish recording values and return captured keys suitable for an InvestigationTemplate view"
	
	isRecording := false.
	^templateValues keys
]

{ #category : #accessing }
ValuesRecord >> doesNotUnderstand: aMessage [
	isRecording ifFalse: [ ^ super doesNotUnderstand: aMessage ].
	aMessage numArgs = 1
		ifTrue: [ self templateValues at: aMessage selector put: aMessage argument ]
		ifFalse: [ self error: 'Template messages must have a single argument' ]
]

{ #category : #accessing }
ValuesRecord >> gtDetailsFor: aView [
	<gtView>
	
	^aView columnedList
		title: 'Details';
		priority: 60;
		items: [ self templateValues associations ];
		column: 'attribute' text: [:v | v key allButLast ];
		column: 'value' text: #value;
		send: #value;
		yourself.
		
	
]

{ #category : #accessing }
ValuesRecord >> initialize [
	super initialize.
	isRecording := true.
]

{ #category : #accessing }
ValuesRecord >> templateValues [
	^templateValues ifNil: [templateValues := Dictionary new]
]

{ #category : #accessing }
ValuesRecord >> valueFor: aSelector [
	^self templateValues at: aSelector ifAbsent: [ nil ]
]
