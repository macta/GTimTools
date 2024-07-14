Class {
	#name : #InvestigationTemplate,
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
InvestigationTemplate >> attributes [
	^attributes ifNil: [ attributes := Set new ]
]

{ #category : #accessing }
InvestigationTemplate >> capturedValues [
	^capturedValues ifNil: [ capturedValues := OrderedCollection new ]
]

{ #category : #accessing }
InvestigationTemplate >> gtValuesFor: composite [
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
InvestigationTemplate >> record: aBlock [
	| investigation |
	[ 
	investigation := InvestigationResult new.
	aBlock value: investigation ]
		ensure: [ 
			self attributes addAll: investigation complete.
			self capturedValues add: investigation ]
]
