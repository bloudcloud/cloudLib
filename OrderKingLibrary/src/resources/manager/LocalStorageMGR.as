package resources.manager
{
	import flash.net.SharedObject;

	public class LocalStorageMGR
	{
		private const UserInfo:String = "UserInfo";
		public function LocalStorageMGR()
		{
		}
		
		public function get username():String
		{
			return SharedObject.getLocal(UserInfo).data.username as String;
		}
		
		public function set username(value:String):void
		{
			SharedObject.getLocal(UserInfo).data.username = value;
		}
		
		public function get password():String
		{
			return SharedObject.getLocal(UserInfo).data.password as String;
		}
		
		public function set password(value:String):void
		{
			SharedObject.getLocal(UserInfo).data.password = value;
		}
	}
}