package preloadconfig
{
	public class DataParseType
	{
		/**引用*/
		protected var _configData:ConfigData;
		/**类型根节点数据*/
		protected var _rootNode:Object;
		protected var _platArg:Array;
		protected var _platSelectIndexArg:Array;
		
		public static const SLASH:String = "/";
		public static const JPG:String = ".JPG";
		
		public function DataParseType(configData:ConfigData)
		{
			_configData = configData;
			_platArg = [];
			_platSelectIndexArg = [];
		}
		
		public function initParse():void
		{
			
		}
		
		public function treeToPlat(value:Array,count:uint = 0):void
		{
			var arg:Array=[];
			for (var i:int=0; i < value.length; i++) {
				arg.push(value[i]);
			}
			_platArg.push(arg);
			if(_platSelectIndexArg.length<=count){
				_platSelectIndexArg.push(0);
			}
			var index:uint = _platSelectIndexArg[count];
			if (value[index].children.length > 0) {
				count++;
				treeToPlat(value[index].children as Array, count);
			}
		}
		
		public function get nodeJSON():Object
		{
			return _rootNode;
		}
	}
}