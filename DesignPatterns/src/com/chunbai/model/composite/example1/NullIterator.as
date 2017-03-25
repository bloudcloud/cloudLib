package com.chunbai.model.composite.example1
{
	
	/**
	 * 
	 * */
	public class NullIterator implements IIterator
	{
		public function NullIterator()
		{
			
		}
		
		public function hasNext():Boolean
		{
		    return false;
		}
		
		public function next():Object
		{
		    return null;
		}
		
		public function reset():void
		{
		    
		}
		
	}
}