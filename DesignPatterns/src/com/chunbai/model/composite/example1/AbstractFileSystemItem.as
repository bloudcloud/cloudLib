package com.chunbai.model.composite.example1
{
	
	/**
	 * 抽象类
	 * */
	public class AbstractFileSystemItem implements IFileSystemItem
	{
		protected var _parent:IFileSystemItem;
		protected var _name:String;
		
		public function AbstractFileSystemItem()
		{
			
		}
		
		public function iterator():IIterator
		{
		    return null;
		}
		
		public function addItem($item:IFileSystemItem):void
		{
		    
		}
		
		public function removeItem($item:IFileSystemItem):void
		{
		    
		}
		
		public function getName():String
		{
		    return _name;
		}
		
		public function setName($name:String):void
		{
		    _name = $name;
		}
		
		public function getParent():IFileSystemItem
		{
		    return _parent;
		}
		
		public function setParent($parent:IFileSystemItem):void
		{
		     _parent = $parent;
		}
		
	}
}