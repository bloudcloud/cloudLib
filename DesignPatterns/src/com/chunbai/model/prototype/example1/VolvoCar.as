package com.chunbai.model.prototype.example1
{
	import flash.utils.ByteArray;

	/**
	 * Volvo
	 * */
	public class VolvoCar extends AbstractCar
	{
		public function VolvoCar()
		{
			oilBox = "Volvo's OilBox";
			wheel = "Volvo's Wheel";
			body = "Volvo's Body";
		}
		
		override public function run():String
		{
			return "Volvo is running";
		}
		
		
		
		override public function stop():String
		{
			return "Volvo is stoped";
		}
		
		override public function clone():Object
		{
			return cloneObject(this);
		}
		
		/**
		 * 二进制深层次克隆方法
		 * */
		public function cloneObject($obj:Object):Object
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject($obj);
			byteArray.position = 0;
			return(byteArray.readObject());
		}
		
	}
}