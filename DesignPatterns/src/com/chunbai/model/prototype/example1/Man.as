package com.chunbai.model.prototype.example1
{
	import flash.utils.ByteArray;

	public class Man extends AbstractDriver
	{
		public function Man(strName:String, intAge:int)
		{
			sex = "Male";
			name = strName;
			age = intAge;
		}
		
		override public function drive():String
		{
			return name + " is drive";
		}
		
		override public  function clone():Object
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