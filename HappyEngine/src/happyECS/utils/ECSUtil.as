package happyECS.utils
{
	import flash.utils.ByteArray;
	
	import happyECS.ecs.component.IHComponent;
	import happyECS.ecs.entity.IHEntity;
	import happyECS.module.IHModule;
	import happyECS.resources.CHashMap;

	/**
	 * 模块工具类
	 * @author cloud
	 * @2018-3-9
	 */
	public class ECSUtil
	{
		private static var _Instance:ECSUtil;
		
		public static function get Instance():ECSUtil
		{
			return _Instance ||= new ECSUtil();
		}
		/**
		 *  @private
		 *  Char codes for 0123456789ABCDEF
		 */
		private const _ALPHA_CHAR_CODES:Array = [48, 49, 50, 51, 52, 53, 54, 
			55, 56, 57, 65, 66, 67, 68, 69, 70];
		private const _DASH:int = 45;       // dash ascii
		private const _UIDBuffer:ByteArray = new ByteArray();       // static ByteArray used for UID generation to save memory allocation cost
		
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
		/**
		 * 将模块序列化成配置文件 
		 * @param module	模块对象
		 * @return *	配置文件
		 * 
		 */		
		public function serializeModuleToConfigue(module:IHModule):*
		{
			return null;
		}
		/**
		 * 将配置文件反序列化成模块对象 
		 * @param configue	配置文件
		 * @return IHModule	模块对象
		 * 
		 */		
		public function deSerializeModuleFromConfigue(configue:*):IHModule
		{
			return null;
		}
		/**
		 * 清空ECS系统的缓存哈希图
		 * @param map
		 * 
		 */
		public function clearECSHashMap(map:CHashMap):void
		{
			for(var i:int=map.keys.length-1; i>=0; i--)
			{
				var obj:Object=map.get(map.keys[i]);
				if(obj is IHEntity || obj is IHComponent)
				{
					obj.dispose();
				}
				map.remove(map.keys[i]);
			}
		}
	}
}