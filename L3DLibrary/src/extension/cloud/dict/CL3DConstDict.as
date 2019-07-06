package extension.cloud.dict
{
	/**
	 * 主项目静态常量声明类
	 * @author cloud
	 */
	public class CL3DConstDict
	{
		/**
		 * 字符串连接符 
		 */		
		public static const STRING_LINKSYMBOL:String = "_";
		/**
		 * 房间符号 
		 */		
		public static const ROOM_SYMBOL:String = "room";
		/**
		 * 墙体符号 
		 */		
		public static const WALL_SYMBOL:String="Wall";
		/**
		 * 地面符号 
		 */		
		public static const FLOOR_SYMBOL:String="floor";
		/**
		 * 天花符号 
		 */		
		public static const CEILING_SYMBOL:String="ceiling";
		/**
		 * 默认墙高 
		 */		
		public static const DEFAULT_WALL_HEIGHT:uint=2800;
		/**
		 * 默认墙宽 
		 */		
		public static const DEFAULT_WALL_WIDTH:uint=240;
		/**
		 * 模块类型：主场景 
		 */		
		public static const MODULETYPE_MAINSCENE:int = 0;
		/**
		 * 模块类型：铺砖 
		 */		
		public static const MODULETYPE_TILING:int = 1;
		/**
		 * 模块类型：门窗 
		 */		
		public static const MODULETYPE_DOORWINDOW:int = 2;
		/**
		 * 模块类型：装修 
		 */		
		public static const MODULETYPE_DECORATION:int = 3;
		/**
		 * 模块类型：建模 
		 */		
		public static const MODULETYPE_BUILDMESH:int = 4;
		/**
		 * 强制模式：不使用 
		 */		
		public static const FORCE_NORMAL:int = 0;
		/**
		 * 强制模式：缩小 
		 */		
		public static const FORCE_MINIFY:int = 1;
		/**
		 * 运行模式:普通 
		 */		
		public static const RUNTIME_NORMAL:int = 0;
		/**
		 * 运行模式:高速 
		 */		
		public static const RUNTIME_HIGH:int = 1;
		/**
		 * 运行模式:极速 
		 */		
		public static const RUNTIME_EXTREME:int = 2;
		/**
		 * 运行模式:高清
		 */		
		public static const RUNTIME_SIMPLE:int = 3;
		/**
		 * 位图最大512尺寸模式 
		 */		
		public static const SIZE_BITMAP_512_MODE:int = 0;
		/**
		 * 位图最大256尺寸模式 
		 */		
		public static const SIZE_BITMAP_256_MODE:int = 1;
		/**
		 * 位图最大128尺寸模式 
		 */		
		public static const SIZE_BITMAP_128_MODE:int = 2;
		/**
		 * 位图最大64尺寸模式 
		 */		
		public static const SIZE_BITMAP_64_MODE:int = 3;
		
		/**
		 * 前缀类型：参数化门窗纯色填充 
		 */		
		public static const PREFIX_WINDOWFILL:String="windowFill_"
		/**
		 * 前缀类型：主项目建模普通纯色填充 
		 */		
		public static const PREFIX_FILL:String="fill_";
		/**
		 * 前缀类型：主项目建模带透明度的普通纯色填充 
		 */		
		public static const PREFIX_TRANSPARENT_FILL:String="transparnetFill_";
		/**
		 * 前缀类型：环境 
		 */		
		public static const PREFIX_ENVIRONMENT:String="env_";
		
		/**
		 * 后缀类型：默认 
		 */		
		public static const SUFFIX_DEFAULT:String="_default";
		/**
		 * 后缀类型：材质 
		 */		
		public static const SUFFIX_MATERIAL:String="_material";
		/**
		 * 后缀类型：反射 
		 */		
		public static const SUFFIX_DIFFUSE:String="_diffuse";
		/**
		 * 后缀类型：灯光
		 */		
		public static const SUFFIX_LIGHT:String="_light";
		/**
		 * 后缀类型：法线
		 */		
		public static const SUFFIX_NORMAL:String="_normal";
		/**
		 *	后缀类型：不透明度 
		 */		
		public static const SUFFIX_OPACITY:String="_opacity";
		/**
		 * 后缀类型：高斯
		 */		
		public static const SUFFIX_GLOSS:String="_gloss";
		/**
		 * 后缀类型：镜面反射 
		 */		
		public static const SUFFIX_SPECULAR:String="_specular";
		/**
		 * 默认墙砖厚度 
		 */		
		public static const DEFAULT_WALLTILE_THICKNESS:int = 12;
		/**
		 * 默认护墙板厚度 
		 */		
		public static const DEFAULT_CLAPBOARD_THICKNESS:int = 8;
		/**
		 * 内墙模型 
		 */		
		public static const TYPE_WALL_IN:String = "wall_in";
		/**
		 * 外墙模型 
		 */		
		public static const TYPE_WALL_OUT:String = "wall_out";
		/**
		 * 墙顶面模型 
		 */		
		public static const TYPE_WALL_TOP:String = "wall_top";
		/**
		 * 地面模型 
		 */		
		public static const TYPE_FLOOR:String = "floor";
		/**
		 * 天花吊顶模型 
		 */		
		public static const TYPE_CEILING_TOP:String = "ceilingTop";
		/**
		 * 模型面砖 
		 */		
		public static const TYPE_TILE_SURFACE:String = "tileSurface";
		/**
		 * 墙砖 
		 */		
		public static const TYPE_TILE_WALL:String = "tileWall";
		/**
		 * 墙砖包边 
		 */		
		public static const TYPE_TILE_WALL_BODY:String="tileWallBody";
		/**
		 * 墙板模型 
		 */		
		public static const TYPE_CLAPBOARD_BODY:String="clapboardBody";
		/**
		 * 墙板边缘模型 
		 */		
		public static const TYPE_CLAPBOARD_EDGE:String="clapboardEdge";
		/**
		 *  櫥櫃台面
		 */		
		public static const TYPE_CAP_BOARD_TOP:String = "capboardTop";
		/**
		 * 地砖 
		 */		
		public static const TYPE_TILE_FLOOR:String = "tileFloor";
		/**
		 * 砖缝 
		 */		
		public static const TYPE_TILE_GAP:String = "tileGap";
		/**
		 * 砖槽 
		 */		
		public static const TYPE_TILE_SLOT:String = "tileSlot";
		/**
		 * 砖槽填充物 
		 */		
		public static const TYPE_TILE_SLOTFILL:String = "tileSlotFill";
		/**
		 * 砖倒角 
		 */		
		public static const TYPE_TILE_CHAMFER:String = "tileChamfer";
		/**
		 * 房间碰角 
		 */		
		public static const TYPE_COLLISION_ROOM:String = "collisionRoom";
		/**
		 * 模型包边
		 */		
		public static const TYPE_COVERMESH:String = "coverMesh";
		/**
		 * 门槛石类型 
		 */		
		public static const TYPE_THRESHOLD:String = "DoorThreshold";
		/**
		 * 窗与内墙的缝隙 
		 */		
		public static const TYPE_WINDOWWALLGAP_IN:String = "windowWallGapIn";
		/**
		 * 窗与外墙的缝隙 
		 */		
		public static const TYPE_WINDOWWALLGAP_OUT:String = "windowWallGapOut";
		/**
		 * 鼠标样式：普通 
		 */	
		public static const TYPE_MOUSECURSOR_NORMAL:int=0;
		/**
		 * 护墙板通用区域板名称 
		 */		
		public static const NAME_WEATHERBOARD_RECTANGLE_BOARD:String="嵌板";
		/**
		 * 护墙板通用单元板名称 
		 */		
		public static const NAME_WEATHERBOARD_UNIT_BOARD:String="墙板";
		/**
		 * 护墙板米洛西区域板名称
		 */		
		public static const NAME_MILUOXI_RECTANGLE_BOARD:String="扣板";
		/**
		 * 铺砖腰线区域的属性名称
		 */		
		public static const FAMILY_TILE_WAIST3D:String = "腰线";
		/**
		 * 普通区域 
		 */		
		public static const REGION_TYPE_NORMAL:int= 0;
		/**
		 * 遮挡区域 
		 */		
		public static const REGION_TYPE_HOLE:int=1;
		/**
		 * 自由区域 
		 */		
		public static const REGION_TYPE_FREE:int=2;
		/**
		 * 护墙板模型普通模式
		 */		
		public static const WEATHERBOARD_MESHMODE_NORMAL:int=0;
		/**
		 * 护墙板模型V形倒角模式 
		 */		
		public static const WEATHERBOARD_MESHMODE_V:int = 1;
		
		/**
		 * 类名:L3DMesh 
		 */		
		public static const CLASSNAME_L3DMESH:String="L3DMesh";
		/**
		 * 类名:CPlane3D
		 */		
		public static const CLASSNAME_CPLANE3D:String="CPlane3D";
		/**
		 * 	命令：改变鼠标样式
		 */		
		public static const COMMAND_CHANAGE_MOUSECURSOR:String="changeMouseCursor";
		/**
		 * 坐标模式:屏幕坐标类型 
		 */		
		public static const POSITIONMODE_SCREEN:int = 1;
		/**
		 * 坐标模式:2D场景类型 
		 */		
		public static const POSITIONMODE_SCENE2D:int=2;
		/**
		 * 坐标模式:3D场景类型 
		 */		
		public static const POSITIONMODE_SCENE3D:int=3;
		/**
		 * 房间类型:客餐厅 
		 */		
		public static const ROOMTYPE_PARLOUR:int=1;
		/**
		 * 房间类型:卧室
		 */		
		public static const ROOMTYPE_BEDROOM:int=2;
		/**
		 * 房间类型:厨房
		 */		
		public static const ROOMTYPE_KITCHEN:int=3;
		/**
		 * 房间类型:卫生间 
		 */		
		public static const ROOMTYPE_WASHROOM:int=4;
		/**
		 *  房间类型:阳台
		 */		
		public static const ROOMTYPE_BALCONY:int=5;
		/**
		 * 房间类型：特殊阳台 
		 */		
		public static const ROOMTYPE_SPECAIL_BALCONY:int=6;
		/**
		 * 房间类型:	阳光房 
		 */		
		public static const ROOMTYPE_SUNROOM:int=7;
		/**
		 * 屋顶类型：无 
		 */		
		public static const ROOFTYPE_NONE:int=0;
		/**
		 * 屋顶类型：平顶 
		 */		
		public static const ROOFTYPE_FLAT:int=1;
		/**
		 * 屋顶类型：坡顶 
		 */		
		public static const ROOFTYPE_SLOPE:int=2;
	}
}