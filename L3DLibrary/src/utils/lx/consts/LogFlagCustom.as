package utils.lx.consts
{
	public class LogFlagCustom
	{
		public static const LoadResource:String = "加载资源";
		
		public static const OnMouseDownCommand2D:String="2D鼠标按下时Command2D";
		
		public static const OnMouseMoveCommand2D:String="2D鼠标移动时Command2D";
		
		public static const OnMouseUpCommand2D:String="2D鼠标提起时Command2D";
		
		public static const OnMouseDownCommand3D:String="3D鼠标按下时Command3D";
		
		public static const OnMouseMoveCommand3D:String="3D鼠标移动时Command3D";
		
		public static const OnMouseUpCommand3D:String="3D鼠标提起时Command3D";
		
		public static const OnRightMouseDownCommand2D:String="2D鼠标右键按下时Command2D";
		
		public static const OnRightMouseUpCommand2D:String="2D鼠标右键提起时Command2D";
		
		public static const Model:String = "模型检测";
		
		public static const Tiling:String = "铺砖检测";
		
		public static const VRMode:String = "打印VRMode";
		
		public static const Mesh:String = "打印Mesh";
		
		public static const VRDebug:String = "VR场景生成的调试";
		
		public static const VIEW_SCENE2D:String = "显示2D场景";
		
		public static const SceneInit:String = "场景初始化";
		
		public static const DrawPingMianGuang:String = "画平面光";
		
		public static const Render:String = "渲染";
		
		public static const VRMesh:String = "VR材质";
		
		public static const OutputImage:String = "出图";
		
		//总池
		private static const preLogFlagArg:Array = 
			[
				LoadResource,
				OnMouseDownCommand2D,
				OnMouseMoveCommand2D,
				OnMouseUpCommand2D,
				OnMouseDownCommand3D,
				OnMouseMoveCommand3D,
				OnMouseUpCommand3D,
				OnRightMouseDownCommand2D,
				OnRightMouseUpCommand2D,
				Model,
				Tiling,
				VRMode,
				VIEW_SCENE2D,
				SceneInit,
				DrawPingMianGuang,
				Render,
				VRDebug,
				VRMesh,
				OutputImage
			];
		
		//实际使用
		public static const logFlagArg:Array = 
			[
				OutputImage
			];
		
		private static const LogConfig:Object =
			{
				switchState: true,
				preLogFlags: preLogFlagArg,
				logFlags: logFlagArg,
				logLevels: []
			};
		
		public static function getLogConfig():Object
		{
			return LogConfig;
		}
	}
}