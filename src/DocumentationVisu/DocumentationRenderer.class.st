"
I render classes packages for experimental documentaion
"
Class {
	#name : #DocumentationRenderer,
	#superclass : #Object,
	#instVars : [
		'classes',
		'maxClsMax',
		'maxMetMax'
	],
	#category : #DocumentationVisu
}

{ #category : #rendering }
DocumentationRenderer >> boxClassFor: cls [
	| shapes clsName com |
	shapes := cls methods, cls class methods collect: [ :met | | size |
		size := (met ast comments inject: 0 into: [ :s :comment | s + comment contents size ]).
		maxMetMax := maxMetMax max: size.
		RSBox new
			model: met;
			attributeAt: #size put: size;
			size: 10;
			withBorder;
			draggable].
	RSGridLayout on: shapes.
	clsName := cls name asLowercase.
	maxClsMax := maxClsMax max: cls comment size. 
	
	com := RSComposite new
		attributeAt: #size put: cls comment size;
		model: cls;
		draggable;
		withBorder;
		shapes: shapes;
		padding: 10;
		yourself.
	('*example*' match: clsName)
		ifTrue: [ com color: (Color blue alpha: 0.3) ].
	('*test*' match: clsName)
		ifTrue: [ com color: (Color green alpha: 0.3) ].
	^ com 
]

{ #category : #accessing }
DocumentationRenderer >> classes: aCollection [
	classes := aCollection
]

{ #category : #rendering }
DocumentationRenderer >> createCanvas [
	| canvas popup label metPopup clsS metS  |
	canvas := RSCanvas new @ RSCanvasController.
	canvas := RSCanvas new.
	canvas @ RSCanvasController. 
	
	popup := RSPopup text: [ :cls | cls name, String cr, cls comment ].
	label := RSLabeled new highlightable.
	metPopup := RSPopup new.
	
	maxClsMax := 0.
	maxMetMax := 0. 
	canvas addAll: (classes collect: [ :cls | (self boxClassFor: cls)
		addInteraction: popup;
		addInteraction: label ]).

	self createHierarchyFor: canvas.
	clsS := NSScale linear
		domain: { 0. maxClsMax};
		range: { 0. 3 }.
	metS := NSScale linear
		domain: { 0. maxMetMax };
		range: {Color white. Color green}.
	canvas nodes do: [ :s | 
		s border width: (clsS scale: (s attributeAt: #size)).
		s shapes do: [ :child | 
			child color: (metS scale: (child attributeAt: #size) ).
			child addInteraction: metPopup ] ].
	^ canvas
]

{ #category : #rendering }
DocumentationRenderer >> createHierarchyFor: canvas [
	RSEdgeBuilder orthoVertical
		canvas: canvas;
		shapes: canvas nodes;
		attachPoint: (RSVerticalAttachPoint new startOffset: 5);
		markerStart: (RSShapeFactory triangle
			color: Color white;
			withBorder;
			size: 10);
			connectFrom: #superclass.

	RSTreeLayout new 
		verticalGap: 50;
		horizontalGap: 10;
		on: canvas nodes.
]
