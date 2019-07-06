package preloadconfig.subDataParse
{
	import preloadconfig.ConfigData;
	import preloadconfig.DataParseType;
	import preloadconfig.subLoadConfig.LoadWindowDoor;

	public class DataParseWindowDoor extends DataParseType
	{
		//系列
		private var _seriesNode:Object;
		private var _seriesWindowDoorNodeArg:Array;
		private var _seriesTopNodeArg:Array;
		//安装方式
		private var _installationNode:Object;
		//排除[系列,安装方式]的门窗节点
		private var _doorWindowNode:Object;
		
		//方案-门型
		private var _caseDoor:Object;
		//方案-窗型
		private var _caseWindow:Object;
		//扇-门
		private var _fanDoor:Object;
		//扇-窗
		private var _fanWindow:Object;
		//附件-门
		private var _attachmentDoor:Object;
		//附件-窗
		private var _attachmentWindow:Object;
		//色板
		private var _palette:Object;
		
		//门型
		private var _doorTypeConfig:XML;
		//门扇
		private var _doorFanConfig:XML;
		//窗型
		private var _windowTypeConfig:XML;
		//窗扇
		private var _windowFanConfig:XML;
		//门附件
		private var _doorAttachmentConfig:XML;
		//窗附件
		private var _windowAttachmentConfig:XML;
		//色板
		private var _paletteConfig:XML;
		//玻璃
		private var _glassConfig:XML;
		//门框
		private var _doorFrameConfig:XML;
		//窗框
		private var _windowFrameConfig:XML;
		//梃
		private var _stickConfig:XML;
		//顶
		private var _topConfig:XML;
		
		private const SERIES:String = "系列";
		private const INSTALLTYPE:String = "安装方式";
		private const DOOR:String = "门";
		private const WINDOW:String = "窗";
		private const DOORWINDOW:String = DOOR+WINDOW;
		private const CASE:String = "方案";
		private const FAN:String = "扇";
		private const ATTACHMENT:String = "附件";
		private const PALETTE:String = "色板";
		private const TOP:String = "顶";
		private const GLASS:String = "玻璃";
		private const FRAME:String = "框";
		private const STICK:String = "梃";
		
		private var loadWindowDoor:LoadWindowDoor;
		
		public function DataParseWindowDoor(configData:ConfigData)
		{
			super(configData);
			loadWindowDoor = new LoadWindowDoor(this);
		}
		
		override public function initParse():void
		{
			var windowDoorXML:XML = _configData.xmlSearchNode(_configData.loadConfig.tree, _configData.configWindowDoorData as Array);
			_rootNode = _configData.xmlTransJSON(windowDoorXML);
			
			var temp:Object = _configData.findFromJSON(_rootNode,[DOORWINDOW]);
			
			_seriesNode = _configData.findFromJSON(temp,[DOORWINDOW,SERIES]);
			divideData();
			
			_installationNode = _configData.findFromJSON(temp,[DOORWINDOW,INSTALLTYPE]);
			
			_doorWindowNode = _configData.excludChildrenFromJSON(temp,[SERIES,INSTALLTYPE]);
			
			_caseDoor = _configData.findFromJSON(temp,[DOORWINDOW,CASE,"门型"]);
			
			_caseWindow = _configData.findFromJSON(temp,[DOORWINDOW,CASE,"窗型"]);
			
			_fanDoor = _configData.findFromJSON(temp,[DOORWINDOW,FAN,DOOR]);
			
			_fanWindow = _configData.findFromJSON(temp,[DOORWINDOW,FAN,WINDOW]);
			
			_attachmentDoor = _configData.findFromJSON(temp,[DOORWINDOW,ATTACHMENT,DOOR]);
			
			_attachmentWindow = _configData.findFromJSON(temp,[DOORWINDOW,ATTACHMENT,WINDOW]);
			
			_palette = _configData.findFromJSON(temp,[DOORWINDOW,PALETTE]);
			
			treeToPlat(_seriesNode[_configData.CHILDREN]);
			
		}
		
		private function combineCodeToURL(codeID:String,codeArgs:Array):Array
		{
			var arg:Array = [];
			var url:String = "LIBRARY/";
			for(var i:int = 0;i<codeArgs.length;i++)
			{
				url += codeID.toLocaleUpperCase()+DataParseType.SLASH+(codeArgs[i] as String).toLocaleUpperCase()+DataParseType.JPG;
				arg.push(url);
			}
			return arg;
		}
		
		//窗、门分一组，顶分一组
		private function divideData():void
		{
			_seriesWindowDoorNodeArg = [];
			_seriesTopNodeArg = [];
			var arg:Array = _seriesNode[_configData.CHILDREN];
			for (var i:int = 0; i < arg.length; i++) 
			{
				switch(arg[i][_configData.NAME])
				{
					case DOOR:
					case WINDOW:
						_seriesWindowDoorNodeArg.push(arg[i]);
						break;
					case TOP:
						_seriesTopNodeArg.push(arg[i]);
						break;
				}
			}
		}
		
		private function getDataByNodeName(nodeName:String):Array
		{
			switch(nodeName)
			{
				case DOOR:
				case WINDOW:
					return _seriesWindowDoorNodeArg;
				case TOP:
					return _seriesTopNodeArg;
			}
			return null;
		}
		
		private function findCodeFromPID(xml:XML, pid:String):Array
		{
			if (xml == null)
				return null;
			var arg:Array=[];
			for each (var children1:XML in xml.children())
			{
				for each (var children2:XML in children1.children())
				{
					var copypid:String=String(children2.@pid).toLocaleLowerCase();
					if (copypid == pid.toLocaleLowerCase())
					{
						arg.push(String(children1.@codes));
						break;
					}
				}
			}
			//再分解
			var value:String;
			var result:Array=[];
			for (var i:int=0; i < arg.length; i++)
			{
				value=arg[i] as String;
				result=result.concat(value.split("|"));
			}
			return result;
		}
		
		/**
		 * 解析config/paramWindowDoor下各个品牌的配置
		 */
		public function initParseBrand(xml:XML):void
		{
			_doorTypeConfig=xml.DoorType[0];
			_doorFanConfig=xml.DoorClip[0];
			_doorAttachmentConfig=xml.DoorAttachment[0];
			_windowTypeConfig=xml.WindowType[0];
			_windowFanConfig=xml.WindowClip[0];
			_windowAttachmentConfig=xml.WindowAttachment[0];
			_paletteConfig=xml.Palettes[0];
			_glassConfig=xml.Glasses[0];
			_doorFrameConfig=xml.DoorFrame[0];
			_windowFrameConfig=xml.WindowFrame[0];
			_stickConfig=xml.WoodenSticks[0];
			_topConfig=xml.Tops[0];
		}
		
		/**
		 * config/paramWindowDoor下各个品牌的配置根据类型和id得到相应的数据
		 */
		public function getMatchByTypeID(type:String, pid:String):Array
		{
			switch (type)
			{
				case DOOR:
					return findCodeFromPID(_doorTypeConfig, pid);
				case WINDOW:
					return findCodeFromPID(_windowTypeConfig, pid);
				case DOOR+FAN:
					return findCodeFromPID(_doorFanConfig, pid);
				case WINDOW+FAN:
					return findCodeFromPID(_windowFanConfig, pid);
				case DOOR+ATTACHMENT:
					return findCodeFromPID(_doorAttachmentConfig, pid);
				case WINDOW+ATTACHMENT:
					return findCodeFromPID(_windowAttachmentConfig, pid);
				case PALETTE:
					return findCodeFromPID(_paletteConfig, pid);
				case GLASS:
					return findCodeFromPID(_glassConfig, pid);
				case DOOR+FRAME:
					return findCodeFromPID(_doorFrameConfig, pid);
				case WINDOW+FRAME:
					return findCodeFromPID(_windowFrameConfig, pid);
				case STICK:
					return findCodeFromPID(_stickConfig, pid);
				case TOP:
					return findCodeFromPID(_topConfig, pid);
			}
			return null;
		}
	}
}