package extension.wl.models
{
	public class LabelModel
	{
		public var labelKey:String;
		public var labelValue:String;
		
		public static const LENGTH_EVENT:String = "length_event";//长度
		public static const WIDTH_EVENT:String = "width_event";//宽度
		public static const HEIGHT_EVENT:String = "height_event";//高度
		public static const OFFGROUND_EVENT:String = "offGround_event";//离地高
		public static const DEEP_EVENT:String = "deep_event";//深度、厚度、飘距
		public static const HORIZONTAL_EVENT:String = "horizontal_event";//行
		public static const VERTICALITY_EVENT:String = "verticality_event";//列
		public static const LEFTLENGTH_EVENT:String = "leftLength_event";//左长、左宽
		public static const RIGHTLENGTH_EVENT:String = "rightLength_event";//右长、右宽
		public static const ANGLE_EVENT:String = "angle_event";//角度
		public static const OTHER_EVENT:String = "label_event";//其他、层高、砖缝宽、均匀布灯
		
		public static const INPUT_EVENT:String = "input_event"; //输入文字
		
		public function LabelModel()
		{
			
		}
		/**
		 * 创建一个label数据模型对象
		 * 通过key作为逻辑指向关系
		 * 实现配置化动态获取外部数值
		 * @param key 逻辑关系
		 * @param value 数值
		 * @return 数据对象
		 * 
		 */		
		public static function buildLabelModel(key:String,value:String):LabelModel
		{
			var labelModel:LabelModel = new LabelModel();
			labelModel.labelKey = key;
			labelModel.labelValue = value;
			return labelModel;
		}
		
	}
}