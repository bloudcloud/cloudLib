package com.chunbai.model.memento.example1
{
	
	/**
	 * 发起人
	 * */
	public class Originator
	{
		private var _state:String;
		
		public function get state():String
		{
			return _state;
		}
		
		public function set state(value:String):void
		{
			_state = value;
		}
		
		public function createMemento():Memento
		{
			return new Memento(_state);
		}
		
		public function setMemento(memento:Memento):void
		{
			_state = memento.state;
		}
		
		public function show():void
		{
			trace("State = " + _state);
		}
		
	}
}