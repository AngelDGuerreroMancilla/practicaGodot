extends Node

signal muertes_actualizado

var muertes: int 
var nivel: int

func sumar_muerte():
	muertes+= 1
	muertes_actualizado.emit()
