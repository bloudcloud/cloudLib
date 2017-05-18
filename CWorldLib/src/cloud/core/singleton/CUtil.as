package cloud.core.singleton
{
	import flash.utils.ByteArray;

	/**
	 * 基础工具类
	 * @author cloud
	 */
	public class CUtil
	{
		private static var _instance:CUtil;
		
		public static function get instance():CUtil
		{
			return _instance ||= new CUtil(new SingletonEnforce());
		}
		
		/**
		 *  @private
		 *  Char codes for 0123456789ABCDEF
		 */
		private const _ALPHA_CHAR_CODES:Array = [48, 49, 50, 51, 52, 53, 54, 
			55, 56, 57, 65, 66, 67, 68, 69, 70];
		private const _DASH:int = 45;       // dash ascii
		private const _UIDBuffer:ByteArray = new ByteArray();       // static ByteArray used for UID generation to save memory allocation cost
		
		public function CUtil(enforcer:SingletonEnforce)
		{
		}
		/**
		 * 创建唯一ID字符串 
		 * @return String
		 * 
		 */		
		public function createUID():String
		{
			_UIDBuffer.position = 0;
			var i:int,j:int;
			
			for (i = 0; i < 8; i++)
			{
				_UIDBuffer.writeByte(_ALPHA_CHAR_CODES[int(Math.random() * 16)]);
			}
			
			for (i = 0; i < 3; i++)
			{
				_UIDBuffer.writeByte(_DASH);
				for (j = 0; j < 4; j++)
				{
					_UIDBuffer.writeByte(_ALPHA_CHAR_CODES[int(Math.random() * 16)]);
				}
			}
			
			_UIDBuffer.writeByte(_DASH);
			
			var time:uint = new Date().getTime(); // extract last 8 digits
			var timeString:String = time.toString(16).toUpperCase();
			// 0xFFFFFFFF milliseconds ~= 3 days, so timeString may have between 1 and 8 digits, hence we need to pad with 0s to 8 digits
			for (i = 8; i > timeString.length; i--)
				_UIDBuffer.writeByte(48);
			_UIDBuffer.writeUTFBytes(timeString);
			
			for (i = 0; i < 4; i++)
			{
				_UIDBuffer.writeByte(_ALPHA_CHAR_CODES[int(Math.random() * 16)]);
			}
			
			return _UIDBuffer.toString();
		}
	}
}