package com.chunbai.model.memento.example1
{
	
	public class Main1
	{
		private var _originator:Originator;    //发起者
		private var _caretaker:Caretaker;
		
		public function Main1()
		{
			_originator = new Originator();
			_originator.state = "On";
			_originator.show();
			
			//保存状态，由于封装可以隐藏Originator的实现细节
			_caretaker = new Caretaker();
			_caretaker.memento = _originator.createMemento();
			
			//Originator改变了状态属性为Off
			_originator.state = "Off";
			_originator.show();
			
			//恢复原初始状态
			_originator.setMemento(_caretaker.memento);
			_originator.show();
		}
		
	}
}