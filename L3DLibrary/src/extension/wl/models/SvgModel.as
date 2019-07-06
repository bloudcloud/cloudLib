package extension.wl.models
{
	public class SvgModel
	{
		public var source:String = "";
		public var tip:String = "";
		public var SVG_EVENT:String = "";
		public var info:Object = null;
		
		public function SvgModel()
		{
			
		}
		/**
		 * 创建一个svg数据模型对象
		 * @param source 资源路径
		 * @param tip 提示
		 * @param event 事件
		 * @param info 信息
		 * @return 数据对象
		 * 
		 */		
		public static function buildSvgModel(source:String,tip:String,event:String,info:Object = null):SvgModel
		{
			var svgModel:SvgModel = new SvgModel();
			svgModel.source = source;
			svgModel.tip = tip;
			svgModel.SVG_EVENT = event;
			svgModel.info = info;
			return svgModel;
		}
		
	}
}