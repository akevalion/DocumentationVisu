Extension { #name : #RPackage }

{ #category : #'*DocumentationVisu' }
RPackage >> documentationInfo: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal3
		title: [ 'Documentation' ];
		initializeCanvas: [ 
			DocumentationRenderer new
				classes: self definedClasses;
				createCanvas ].
]
