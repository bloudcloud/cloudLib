package extension.wl.globalData.allStaticTypes
{
	public class LivelyType
	{
		
		public static var HomePage:String = "http://www.lejia3d.com";
		public static var HomePageIP:String = "";
		public static var HomePageTest:String = "";
		public static var PanoramaWebPort:String = ":3810";//全景图web
		public static var LivelyPort:String = ":3820";//接单王端口
		public static var LivelyUrl:String = "http://www.lejia3d.com:3820";//带端口
		public static var LivelyAddress:String = "";//用于接单王的WebService连接
		public static var PptPort:String = ":3830";//导出PPT服务端口
		public static var PptAddress:String = "";//用于导出PPT的WebService连接
		
		public static var NewVisionPort:String = ":4540";//新视界
		public static var NewVision2Port:String = ":4542";//新视界
		//订单编辑H5
		public static var OrderEdit_Port:String = ":8090";
		public static var OrderEdit_Local:String = "http://192.168.1.117:8023";//id=orderID&target=1
		public static var OrderEdit_Page:String = "/store.html#/editOrder?";//
		//订单管理系统
		public static var OrderSystem_Port:String = ":8086";
		public static var OrderSystem_Local:String = "http://192.168.1.125:8086";
		public static var OrderSystem_Create:String = "/OriginalOrder/Create";
		
		/**
		 * 版本管理
		 * 0装修类型； 1统一铺砖类型； 2统一门窗类型； 3统一石材类型、链石； 4统一衣柜； 5统一硅藻泥、涂虫； 6统一护墙板；7统一水电、瑞家；8统一橱柜；9统一定制；   99乐家设计类型； 
		 * 当unifiedType为0的时候判断customType
		 */		
		private static var _unifiedType:int = 0;
		/**
		 * 定制版本
		 * 0乐家、评测、整装全模块、随意居、乐居华庭； 1伊莎莱、绎尚； 2橙家、装修； 3米洛西； 4； 5新空间；6慕思； 7音联邦； 8爱空间； 9大自然木门； 10名匠；11时尚神句子、时尚；
		 */		
		public static var customType:int = 1;
		/**
		 * 字体字号管理
		 */		
		public static var Font:String = "宋体";
		public static const TitleSize:int = 24;
		public static const BigSize:int = 20;
		public static const Size:int = 16;
		public static const SmallSize:int = 14;
		
		[Bindable]
		public static var LivelyStyle:int = 4;//风格
		[Bindable]
		public static var backgroundColor:uint = 0xffffff;//风格背景色
		[Bindable]
		public static var libraryTipsColor:uint = 0xf0f1f3;//library提示背景颜色
		[Bindable]
		public static var svgTipsColor:uint = 0xf0f1f3;//svg提示背景颜色
		
		public static var LivelyStatus:Boolean = false;//暂时没用
		
		public function LivelyType()
		{
			
		}
		
		public static function get unifiedType():int
		{
			return _unifiedType;
		}
		
		public static function set unifiedType(value:int):void
		{
			_unifiedType = value;
		}
		
		public static function get currentStyle():int
		{
			return LivelyStyle;
		}
		
		public static function set currentStyle(v:int):void
		{
			LivelyStyle = v;
			
			switch(v)
			{
				case 3:
					currentBackgroundColor = ColorType.BlackMlx;
					currentLibraryTipsColor = ColorType.BlackMlx;
					currentSvgTipsColor = ColorType.White;
					break;
				case 4:
					currentBackgroundColor = ColorType.White;
					currentLibraryTipsColor = ColorType.LightGreyBackGround;
					currentSvgTipsColor = ColorType.LightGreyBackGround;
					break;
				default:
					currentBackgroundColor = ColorType.White;
					currentLibraryTipsColor = ColorType.LightGreyLively;
					currentSvgTipsColor = ColorType.LightGreyLively;
					break;
			}
		}
		
		public static function sizeLabelWidth(v:int):int
		{
			var width:int = 50;
			switch(v)
			{
				case 1:
					width = 20;
					break;
				case 2:
					width = 36;
					break;
				case 3:
					width = 51;
					break;
				case 4:
					width = 69;
					break;
				case 5:
					width = 85;
					break;
			}
			return width;
		}
		
		public static function bigSizeLabelWidth(v:int):int
		{
			var width:int = 50;
			switch(v)
			{
				case 1:
					width = 25;
					break;
				case 2:
					width = 43;
					break;
				case 3:
					width = 63;
					break;
				case 4:
					width = 85;
					break;
				case 5:
					width = 109;
					break;
			}
			return width;
		}
		
		public static function set currentBackgroundColor(v:uint):void
		{
			backgroundColor = v;
		}
		
		public static function set currentLibraryTipsColor(v:uint):void
		{
			libraryTipsColor = v;
		}
		
		public static function set currentSvgTipsColor(v:uint):void
		{
			svgTipsColor = v;
		}
		
	}
}