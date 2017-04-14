package com.chunbai.model.memento.example1
{
	
	/**
	 * 备忘录
	 * */
	public class Memento
	{
		private var _state:String;
		
		public function Memento(state:String)
		{
			this._state = state;
		}
		
		public function get state():String
		{
			return _state;
		}
		
	}
}