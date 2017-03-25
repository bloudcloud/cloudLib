package com.chunbai.model.composite.example1
{
	
	public interface IFileSystemItem
	{
		function iterator():IIterator;
		function addItem($item:IFileSystemItem):void;
		function removeItem($item:IFileSystemItem):void;
		function getName():String;
		function setName($name:String):void;
		function getParent():IFileSystemItem;
		function setParent($parent:IFileSystemItem):void;
		
	}
}