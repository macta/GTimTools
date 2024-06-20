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

{ #category : #accessing }
BaselineOfGTimTools >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'GTimTools' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]
