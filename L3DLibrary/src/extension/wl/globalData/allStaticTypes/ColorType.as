package extension.wl.globalData.allStaticTypes
{
	
	public class ColorType
	{
		public static const White:uint = 0xffffff;
		public static const Black:uint = 0x000000;
		public static const Grey:uint = 0xcccccc;
		public static const Red:uint = 0xff0000;
		public static const Green:uint = 0x00ff00;
		public static const Blue:uint = 0x0000ff;
		public static const Yellow:uint = 0xffff00;
		public static const LightBlue:uint = 0x00ffff;
		public static const Pink:uint = 0xff00ff;
		
		public static const BlackMlx:uint = 0x292929;
		public static const BrownMlx:uint = 0xb99178;
		
		public static const YellowLively:uint = 0xFDDC3F;
		public static const GreenLively:uint = 0x00dcca;
		public static const DarkGreyLively:uint = 0x404040;
		public static const LightGreyLively:uint = 0xf0f1f3;
		
		public static const BlueLively:uint = 0x15d4e0;//4
		public static const DeepBlueLively:uint = 0x14AAB3;//4
		public static const LightGreySvg:uint = 0x666666;//4
		public static const LightGreyLabel:uint = 0x888888;//4
		public static const LightGreyBackGround:uint = 0xf2f2f2;//4
		
		public function ColorType()
		{
			
		}
		
		public static function colorHandler(style:int,status:int):Object
		{
			var colorObj:Object = {};
			colorObj.viewOut = DarkGreyLively;//灰底
			colorObj.itemOut = White;//白字
			colorObj.viewOver = YellowLively;//黄底
			colorObj.itemOver = Black;//黑字
			switch(style)
			{
				case 0:
					return null;
					break;
				case 2:
					switch(status)
					{
						case 0:
							colorObj.viewOut = White;//白底
							colorObj.itemOut = Black;//黑字
							colorObj.viewOver = GreenLively;//蓝底
							colorObj.itemOver = White;//白字
							break;
						case 1:
							colorObj.viewOut = White;//白底
							colorObj.itemOut = Black;//黑字
							colorObj.viewOver = White;//白底
							colorObj.itemOver = GreenLively;//蓝字
							break;
					}
					break;
				case 3:
					switch(status)
					{
						case 0:
							colorObj.viewOut = BlackMlx;//米洛西黑底
							colorObj.itemOut = White;//白字
							colorObj.viewOver = BrownMlx;//米洛西棕色底
							colorObj.itemOver = BlackMlx;//白字
							break;
						case 1:
							colorObj.viewOut = BlackMlx;//米洛西黑底
							colorObj.itemOut = White;//白字
							colorObj.viewOver = BlackMlx;//黑底
							colorObj.itemOver = BrownMlx;//米洛西棕色字
							break;
					}
					break;
				case 4:
					switch(status)
					{
						case 0:
							colorObj.viewOut = White;//白底
							colorObj.itemOut = LightGreySvg;//svg浅灰
							colorObj.viewOver = BlueLively;//蓝底
							colorObj.itemOver = White;//白字
							break;
						case 1:
							colorObj.viewOut = White;//白底
							colorObj.itemOut = LightGreySvg;//svg浅灰
							colorObj.viewOver = White;//白底
							colorObj.itemOver = BlueLively;//蓝字
							break;
						case 2://popup
							colorObj.viewOut = LightGreyBackGround;//浅灰
							colorObj.itemOut = LightGreySvg;//svg深灰
							colorObj.viewOver = GreenLively;//绿
							colorObj.itemOver = White;//白
							break;
						case 3:
							colorObj.viewOut = BlueLively;//蓝底
							colorObj.itemOut = White;//svg浅灰
							colorObj.viewOver = DeepBlueLively;//深蓝底
							colorObj.itemOver = White;//蓝字
							break;
						case 4:
							colorObj.viewOut = White;//白底
							colorObj.itemOut = Black;//黑
							colorObj.viewOver = White;//白底
							colorObj.itemOver = BlueLively;//蓝字
							break;
						case 5://popup2
							colorObj.viewOut = LightGreyBackGround;//浅灰
							colorObj.itemOut = LightGreySvg;//svg深灰
							colorObj.viewOver = LightGreyBackGround;//浅灰
							colorObj.itemOver = GreenLively;//白
							break;
					}
					break;
			}
			return colorObj;
		}
		
	}
}