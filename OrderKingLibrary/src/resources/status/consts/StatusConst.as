package resources.status.consts
{
	public class StatusConst
	{
		public static const Render:String = mergeName("Render");
		
		private static function mergeName(value:String):String
		{
			return "StatusConst_"+value;
		}
	}
}