package com.chunbai.model.composite.example1
{
	
	/**
	 * 组合元素
	 * */
	public class Directory extends AbstractFileSystemItem
	{
		private var _items:Array;
		
		public function Directory()
		{
			_items = new Array();
		}
		
		override public function addItem($item:IFileSystemItem):void
		{
		    _items.push($item);
		}
		
		override public function removeItem($item:IFileSystemItem):void
		{
		    var i:int = 0;
			var n:int = _items.length;
			for(i; i < n; i++)
			{
			    if(_items[i] == $item)
				{
				    _items.splice(i, 1);
					break;
				}
			}
		}
		
		override public function iterator():IIterator
		{
		    return new ArrayIterator(_items);
		}
		
	}
}