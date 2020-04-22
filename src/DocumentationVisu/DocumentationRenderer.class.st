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
	shapes := cls methods, cls class methods collect: [ :met | self boxMethodFor: met ].
	clsName := cls name asLowercase.
	maxClsMax := maxClsMax max: cls comment size. 
	
	com := RSComposite new
		propertyAt: #size put: cls comment size;
		model: cls;
		draggable;
		popup;
		withBorder;
		addAll: shapes;
		yourself.
	('*example*' match: clsName)
		ifTrue: [ com color: (Color blue alpha: 0.3) ].
	(cls isTestCase)
		ifTrue: [ com color: (Color green alpha: 0.3) ].
	^ com 
]

{ #category : #rendering }
DocumentationRenderer >> boxMethodFor: met [
	| size color |
	size := (met ast comments inject: 0 into: [ :s :comment | s + comment contents size ]).
	maxMetMax := maxMetMax max: size.
	color := Color lightGray.
	('*example*' match: met selector) 
		ifTrue: [ color:= Color blue ].
	('test*' match: met selector) 
		ifTrue: [ color:= Color green ].
	^ RSBox new
		model: met;
		propertyAt: #size put: size;
		color: color;
		popup;
		width: size +1;
		height: met linesOfCode;
		withBorder
]

{ #category : #accessing }
DocumentationRenderer >> classes: aCollection [
	classes := aCollection
]

{ #category : #rendering }
DocumentationRenderer >> createCanvas [
	| canvas  label  |
	canvas := RSCanvas new @ RSCanvasController.
	canvas := RSCanvas new.
	canvas @ RSCanvasController. 
	
	label := RSLabeled new highlightable.
	
	maxClsMax := 0.
	maxMetMax := 0. 
	canvas addAll: (classes collect: [ :cls | (self boxClassFor: cls) @ label ]).

	self 
		setScales: canvas;
		createHierarchyFor: canvas.
	canvas @ RSHierarchyPacker.
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

{ #category : #examples }
DocumentationRenderer >> example01Basic [
	<script: '(RPackage organizer packageNamed: ''Collections-Abstract'') inspect'>

]

{ #category : #examples }
DocumentationRenderer >> example02Basic [
	<script: '(RPackage organizer packageNamed: ''Collections-Sequenceable'') inspect'>

]

{ #category : #rendering }
DocumentationRenderer >> setScales: canvas [ 
	| clsS metS |
	clsS := NSScale linear
		domain: { 0. maxClsMax};
		range: { Color veryLightGray alpha: 0.3. Color black }.
	metS := NSScale sqrt
		domain: { 1. maxMetMax};
		range: {5. 50}.
	canvas nodes do: [ :s | 
		s shapes do: [ :child | 
			child width: (metS scale: (child propertyAt: #size) ). ].
		
		s border 
			width: 2;
			color: (clsS scale: (s propertyAt: #size)).
		RSGridLayout on: s shapes.
		s 
			adjustToChildren;
			padding: 10 ].
]
