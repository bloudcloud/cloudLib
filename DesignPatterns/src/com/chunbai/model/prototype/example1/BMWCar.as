package com.chunbai.model.prototype.example1
{
	import flash.utils.ByteArray;

	/**
	 * 宝马
	 * */
	public class BMWCar extends AbstractCar
	{
		public function BMWCar()
		{
			oilBox = "BMW's OilBox";
			wheel = "BMW's Wheel";
			body = "BMW's body";
		}
		
		override public function run():String
		{
			return "BORA is running";
		}
		
		override public function stop():String
		{
			return "BORA is stoped";
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