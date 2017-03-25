package com.chunbai.model.composite.example1
{
	
	public interface IElement
	{
		function iterator():IIterator;
		function addItem($item:IElement):void;
		function getParent():IElement;
		function setParent($param:IElement):void;
	}
}