package core.dict
{
	/**
	 * 主项目静态常量声明类
	 * @author cloud
	 */
	public class CL3DConstDict
	{
		/**
		 * 强制模式：不使用 
		 */		
		public static const FORCE_NORMAL:int = 0;
		/**
		 * 强制模式：缩小 
		 */		
		public static const FORCE_MINIFY:int = 1;
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
		 * 墙砖 
		 */		
		public static const TYPE_TILE_WALL:String = "tileWall";
		/**
		 * 墙砖包边 
		 */		
		public static const TYPE_TILE_WALL_BODY:String="tileWallBody";
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
		
		public static const FAMILY_TILE_WAIST3D:String = "腰线";
	}
}