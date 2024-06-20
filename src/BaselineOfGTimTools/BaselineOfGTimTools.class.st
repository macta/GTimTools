Class {
	#name : #BaselineOfGTimTools,
	#superclass : #BaselineOf,
	#category : #BaselineOfGTimTools
}

{ #category : #baseline }
BaselineOfGTimTools >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'GTimTools'
		]
]
