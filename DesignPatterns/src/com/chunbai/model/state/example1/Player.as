package com.chunbai.model.state.example1
{
	
	/**
	 * 我们来一个环境，一个运动员,正常情况下是正常状态
	 * */
	public class Player
	{
		private var _state:IState = new NormalState();
		
		public function Player()
		{
			
		}
		
		
		public function setState($state:IState):void
		{
			_state = $state;
		}
		
		public function shot():void
		{
			_state.shot();    //这里我感觉是创建型模式的适配器模式，对象适配器。应该就是这样，
		}
		
	}
}