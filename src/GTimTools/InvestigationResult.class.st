Class {
	#name : #InvestigationResult,
	#superclass : #Object,
	#instVars : [
		'isRecording',
		'templateValues'
	],
	#category : #GTimTools
}

{ #category : #accessing }
InvestigationResult >> complete [
	isRecording := false.
	^templateValues keys
]

{ #category : #accessing }
InvestigationResult >> doesNotUnderstand: aMessage [
	isRecording ifFalse: [ ^ super doesNotUnderstand: aMessage ].
	aMessage numArgs = 1
		ifTrue: [ self templateValues at: aMessage selector put: aMessage argument ]
		ifFalse: [ self error: 'Template messages must have a single argument' ]
]

{ #category : #accessing }
InvestigationResult >> gtValuesFor: composite [
	<gtView>
	
	^composite columnedList
		title: 'Values';
		priority: 60;
		items: [ self templateValues associations ];
		column: 'attribute' text: [:v | v key allButLast ];
		column: 'value' text: #value;
		send: #value;
		yourself.
		
	
]

{ #category : #accessing }
InvestigationResult >> initialize [
	super initialize.
	isRecording := true.
]

{ #category : #accessing }
InvestigationResult >> templateValues [
	^templateValues ifNil: [templateValues := Dictionary new]
]

{ #category : #accessing }
InvestigationResult >> valueFor: aSelector [
	^self templateValues at: aSelector ifAbsent: [ nil ]
]
