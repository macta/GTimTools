"
I am collection of key/value pairs that record a useful interaction that can be explored in a GtView via a `ValuesRecorder`.
"
Class {
	#name : #ValuesRecord,
	#superclass : #Object,
	#instVars : [
		'templateValues',
		'recorder'
	],
	#category : #GTimTools
}

{ #category : #accessing }
ValuesRecord class >> for: aRecorder [
	^self new
		initialize: aRecorder;
		yourself
]

{ #category : #accessing }
ValuesRecord >> complete [
	"Finish recording values and return captured keys suitable for an InvestigationTemplate view"
	
	isRecording := false.
	^templateValues keys
]

{ #category : #accessing }
ValuesRecord >> defaultValue [ 
 	^self valueFor: recorder defaultAttribute
]

{ #category : #accessing }
ValuesRecord >> defaultViewFor: r [
	| pragmas views |
	
	pragmas := ((r class withAllSuperclasses) flatCollect: [ :c | c pragmas ])
			select: [ :p | p key = #gtView ].

	views := pragmas
			collect: [ :p | 
				r
					perform: p method selector
					withEnoughArguments: {GtPhlowEmptyView new.
							Dictionary new} ].

	^ (views detectMin: [ :v| v priority ]) 
]

{ #category : #accessing }
ValuesRecord >> defaultViewSymbol [

	^self defaultViewFor:  self defaultValue
]

{ #category : #accessing }
ValuesRecord >> doesNotUnderstand: aMessage [
	self isRecording ifFalse: [ ^ super doesNotUnderstand: aMessage ].
	aMessage numArgs = 1
		ifTrue: [ self templateValues at: aMessage selector put: aMessage argument ]
		ifFalse: [ self error: 'Template messages must have a single argument' ]
]

{ #category : #accessing }
ValuesRecord >> gtCompositeViewFor: aView [
	"<gtView>"
	| views |
	
	self templateValues ifEmpty: [^aView empty ].
	
	views := self templateValues associations collect: [:v | 
		(self defaultViewFor: v value) 
			title:  (v key allButLast); 
			yourself].
	
	^ aView composite
		title: 'Composite';
		views: views
		
		
	
]

{ #category : #accessing }
ValuesRecord >> gtDetailsFor: aView [
	<gtView>
	
	self templateValues ifEmpty: [^aView empty ].
	
	^aView columnedList
		title: 'Values';
		priority: 10;
		items: [ self templateValues associations ];
		column: 'attribute' text: [:v | v key allButLast ] width: 100;
		column: 'value' text: #value;
		send: #value;
		yourself.
		
		
	
]

{ #category : #accessing }
ValuesRecord >> gtFocusFor: aView [
	"<gtView>"
	
	self templateValues ifEmpty: [^aView empty ].
	
	^ self defaultViewSymbol
		title: 'Focus';
		priority: 50;
		yourself
		
		
	
]

{ #category : #accessing }
ValuesRecord >> gtViewsInContext: aContext [
	| generatedViews defaultViews |
	
	generatedViews := self templateValues associations
			collect: [ :v | 
				(self defaultViewFor: v value)
					title: v key allButLast capitalized;
					yourself ].

	defaultViews := super gtViewsInContext: aContext.
	
	^ (OrderedCollection with: defaultViews first)
		addAll: generatedViews;
		addAll: defaultViews allButFirst;
		yourself
]

{ #category : #accessing }
ValuesRecord >> initialize: aRecorder [
	recorder := aRecorder
]

{ #category : #accessing }
ValuesRecord >> isRecording [
	^recorder isRecording
]

{ #category : #accessing }
ValuesRecord >> templateValues [
	^templateValues ifNil: [templateValues := Dictionary new]
]

{ #category : #accessing }
ValuesRecord >> valueFor: aSelector [
	^self templateValues at: aSelector ifAbsent: [ nil ]
]
