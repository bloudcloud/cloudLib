package com.chunbai.model.composite.example1
{
	
	/**
	 * 叶子元素
	 * */
	public class File extends AbstractFileSystemItem
	{
		public function File()
		{
			
		}
		
		override public function iterator():IIterator
		{
		    return new NullIterator();
		}
		
	}
}