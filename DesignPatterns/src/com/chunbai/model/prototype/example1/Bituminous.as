package com.chunbai.model.prototype.example1
{
	import flash.utils.ByteArray;

	/**
	 * 柏油路
	 * */
	public class Bituminous extends AbstractRoad
	{
		public function Bituminous(strName:String, intLong:int)
		{
			roadName = strName;
			roadLong = intLong;
			type = "Bituminous";
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