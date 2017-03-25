package com.chunbai.model.state.example1
{
	
	public class Main1
	{
		public function Main1()
		{
			var player:Player = new Player();
			player.shot();    //正常下投篮
			player.setState(new NonormalState());
			player.shot();    //不正常下投篮
			player.setState(new SuperState());
			player.shot();    //超常下投篮
		}
		
	}
}