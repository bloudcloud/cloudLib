package com.chunbai.model.memento.example1
{
	
	/**
	 * 管理者类
	*/
	public class Caretaker
	{
		private var _memento:Memento;
		
		public function get memento():Memento
		{
			return _memento;
		}
		
		public function set memento(value:Memento):void
		{
			_memento = value;
		}
		
	}
}