"
I am baseline for documentation based on roassal3
"
Class {
	#name : #BaselineOfDocumentationVisu,
	#superclass : #BaselineOf,
	#category : #BaselineOfDocumentationVisu
}

{ #category : #baselines }
BaselineOfDocumentationVisu >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			spec baseline: 'Roassal3'with: [ 
				spec repository: 'github://ObjectProfile/Roassal3' ].
			
			spec package: #'DocumentationVisu' with: [ spec requires: #('Roassal3') ].
				
			spec 
				group: 'default' with: #('DocumentationVisu') ].

		
	







]
