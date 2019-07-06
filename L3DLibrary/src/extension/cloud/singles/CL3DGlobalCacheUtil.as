package extension.cloud.singles
{
	import flash.geom.Matrix3D;
	import flash.system.Capabilities;

	/**
	 * 全局业务缓存工具类
	 * @author	cloud
	 * @date	2018-6-27
	 */
	public class CL3DGlobalCacheUtil
	{
		private static var _Instance:CL3DGlobalCacheUtil;
		
		public static function get Instance():CL3DGlobalCacheUtil
		{
			return _Instance||=new CL3DGlobalCacheUtil(new SingletonEnforce());
		}
		/**
		 * 默认像素转毫米的比例值 
		 */		
		private const _DefaultPix2mm:Number=0.2645833333333333;
		
		/**
		 * 场景界面中的坐标系3D矩阵 
		 */		
		public const SceneAxisDefaultMatrix3D:Matrix3D=new Matrix3D(Vector.<Number>([
			1,0,0,0,
			0,0,1,0,
			0,1,0,0,
			0,0,0,1
		]));
		/**
		 * 套线默认标准型材，单位厘米（右手坐标系，XZ平面，法线是Y轴） 
		 */		
		public const CoverSectionPoints:Vector.<Number>=Vector.<Number>([0,0,-10,0,0,0,10,0,0]);
			
		private var _pix2mmRatio:Number=0;
		private var _mm2pixRatio:Number=0;
		/**
		 * 获取像素转毫米的比例值 
		 * @return Number
		 * 
		 */		
		public function get pix2mmRatio():Number
		{
			if(_pix2mmRatio==0)
			{
				_pix2mmRatio=Capabilities.screenDPI==0?_DefaultPix2mm:1/Capabilities.screenDPI*25.4;
			}
			return _pix2mmRatio;
		}
		/**
		 * 获取毫米转像素的比例值
		 * @return Number
		 * 
		 */		
		public function get mm2pixRatio():Number
		{
			if(_mm2pixRatio==0)
			{
				_mm2pixRatio=Capabilities.screenDPI==0?1/_DefaultPix2mm:Capabilities.screenDPI/25.4;
			}
			return _mm2pixRatio;
		}
		/**
		 * 舞台的显示宽度 
		 */		
		public var screenWidth:int;
		/**
		 * 舞台的显示高度 
		 */		
		public var screenHeight:int;
		/**
		 * 墙板最小缩放比
		 */		
		public var clapboardMinScale:Number=0;
		/**
		 * 场景坐标缩放值(毫米转厘米的比例) 
		 */		
		public function get sceneScaleRatio():Number
		{
			return .1;
		}
		public function CL3DGlobalCacheUtil(enforcer:SingletonEnforce)
		{
			
		}
	}
}