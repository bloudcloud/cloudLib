package com.chunbai.model.visitor.example1
{
	
	/**
	 * 这是一个对象生成器，这不是一个完整的对象结构，这里仅仅是模拟对象结构中的元素
	 * */
	public class FlowerGenerator
	{
		public function FlowerGenerator()
		{
			
		}
		
		public static function newFlower():IFlower
		{ 
		    switch (int(Math.random()))
			{
			    case 0: 
					return new Gladiolus();
					break;
			　　case 1: 
				    return new Runuculus();
					break;
			　　case 2: 
				    return new Chrysanthemum();
					break;
				default:
					return null;
				    break;
		　　}
		}
		
	}
}