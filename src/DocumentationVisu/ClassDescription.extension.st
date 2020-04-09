Extension { #name : #ClassDescription }

{ #category : #'*DocumentationVisu' }
ClassDescription >> documentationInfo: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal3
		title: [ 'Documentation' ];
		initializeCanvas: [ 
			| data classes  |
			data := self allCallsOn.
			classes  := data collect: #methodClass as: Set.
			classes add: self.
			DocumentationRenderer new
				classes: classes;
				createCanvas].
]
