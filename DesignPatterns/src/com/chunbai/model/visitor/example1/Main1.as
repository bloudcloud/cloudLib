package com.chunbai.model.visitor.example1
{
	import com.chunbai.model.iterator.IteratorTest;
	
	/**
	 * 实例不准确
	 * 在这里你能看到访问者模式执行的流程： 
　　 * 首先在客户端先获得一个具体的访问者角色 
　　 * 遍历对象结构，对每一个元素调用accept方法，将具体访问者角色传入 
　　 * 这样就完成了整个过程，对象结构角色在这里才组装上
	 * */
	public class Main1
	{
		private var _array:Array;
		private var _sval:IVisitor;
		
		public function Main1()
		{
			_array = new Array();
			for(var i:int = 0; i < 10; i++)
			{
				_array.push(FlowerGenerator.newFlower()); 
			}
			test();
		}
		
		
		public function test():void
		{
		    _sval = new StringVal();
		    for(var i:int = 0; i < 10; i++)
			{
				_array[i].accept(_sval);
				trace(_sval);
		    }
		}
		
	}
}