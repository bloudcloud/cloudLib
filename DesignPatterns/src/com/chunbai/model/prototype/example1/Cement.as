package com.chunbai.model.prototype.example1
{
	import flash.utils.ByteArray;

	/**
	 * 水泥路
	 * */
	public class Cement extends AbstractRoad
	{
		public function Cement(strName:String, intLong:int)
		{
			roadName = strName;
			roadLong = intLong;
			type = "Cement";
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