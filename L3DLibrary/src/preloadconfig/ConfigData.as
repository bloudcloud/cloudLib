package preloadconfig
{
	import L3DLibrary.LivelyLibrary;
	
	import preloadconfig.subDataParse.DataParseWindowDoor;

	public class ConfigData
	{
		public const Node:String = "nodes";
		/**[配置文件]门窗目录节点常量*/
		public const Node_windowdoor:String="windowdoor";
		/**[配置文件]地砖目录节点常量*/
		public const Node_tilefloor:String="tilefloor";
		/**[配置文件]墙砖目录节点常量*/
		public const Node_tilewall:String="tilewall";
		/**[配置文件]模型目录节点常量*/
		public const Node_model:String="model";
		
		private const AT:String = "@";
		
		public const ID:String = "id";
		
		private const LABEL:String = "label";
		
		public const NAME:String = "name";
		
		public const CHILDREN:String = "children";
		
		private const xmlAttribute:Array=[ID,LABEL];
		private const xmlAttributeReplace:Array=[ID,NAME];
		
		private var _loadConfig:LoadConfig;
		private var _defaultData:Object;
		//节点Key遍历若干大类名称[门窗、地砖、墙砖、模型]
		private var nodes:Array = [Node_windowdoor,Node_tilefloor,Node_tilewall,Node_model];
		
		private var _parseWindowDoor:DataParseWindowDoor;
		
		public function ConfigData(loadConfig:LoadConfig)
		{
			_loadConfig = loadConfig;
			initInstance();
		}
		
		public function setDefaultData(value:Object):void
		{
			_defaultData = value;
		}
		
		/**
		 * 用品牌的替换默认的参数配置
		 * @param value
		 */		
		public function replaceBrandData(value:Object):void
		{
			//特殊节点替换默认节点
			for (var i:int = 0; i < nodes.length; i++) 
			{
				if(value[Node].hasOwnProperty(nodes[i]))
				{
					_defaultData[Node][nodes[i]] = value[Node][nodes[i]];
				}
			}
		}
		
		/**[配置文件]门窗的节点*/
		public function get configWindowDoorData():Object
		{
			return _defaultData[Node][Node_windowdoor];
		}
		
		/**[配置文件]地砖的节点*/
		public function get configTileFloorData():Object
		{
			return _defaultData[Node][Node_tilefloor];
		}
		
		/**[配置文件]墙砖的节点*/
		public function get configTileWallData():Object
		{
			return _defaultData[Node][Node_tilewall];
		}
		
		/**[配置文件]模型的节点*/
		public function get configModelData():Object
		{
			return _defaultData[Node][Node_model];
		}
		
		public function get loadConfig():LoadConfig
		{
			return _loadConfig;
		}
		
		public function xmlSearchNode(xml:XML, nodeKeywords:Array, attribute:String=LABEL, index:int=0):XML {
			const key:String=attribute;
			if (index <= nodeKeywords.length - 1) {
				xml=xml.children().(@[key] == nodeKeywords[index])[0];
				if (xml != null) {
					xml=xmlSearchNode(xml, nodeKeywords, attribute, index + 1);
				} else {
					return null;
				}
			} else {
				return xml;
			}
			return xml;
		}
		
		public function findFromJSON(json:Object,nodeKeywords:Array,keyword:String=NAME,childrenKeyword:String=CHILDREN):Object
		{
			var value:String;
			var arg:Array = [];
			arg.push(json);
			var temp:Object;
			var count:uint;
			var isFind:Boolean;
			for (var k:int = 0; k < nodeKeywords.length; k++) 
			{
				isFind = false;
				value = nodeKeywords[k];
				for (var i:int = 0; i < arg.length; i++) 
				{
					temp = arg[i];
					if(temp[keyword]==value)
					{
						isFind = true;
						count++;
						arg = temp[childrenKeyword] as Array;
						break;
					}
				}
				if(!isFind)
				{
					break;
				}
			}
			
			if(count!=nodeKeywords.length)
			{
				temp = null;
			}
			return temp;
		}
		
		public function xmlTransJSON(xml:XML, parentID:String = null):Object {
			if(!xml){
				return null;
			}
			
			var obj:Object={};
			for (var i:int=0; i < xmlAttribute.length; i++) {
				obj[xmlAttributeReplace[i]]=xml[AT + xmlAttribute[i]].toString();
			}
			if(parentID!=null){
				obj.parentID=parentID;
			}
			
			if(obj.hasOwnProperty(ID)){
				parentID = obj.id;
			}
			
			var arg:Array=[];
			for each (var children:XML in xml.children()) {
				arg.push(xmlTransJSON(children, parentID));
			}
			obj.children=arg;
			
			return obj;
		}
		
		public function excludChildrenFromJSON(json:Object,excludChildren:Array,childrenKeyword:String=CHILDREN,excludKeyword:String=NAME):Object
		{
			if(json && json.hasOwnProperty(childrenKeyword) && json[childrenKeyword] is Array && json[childrenKeyword].length>0 && excludChildren)
			{
				var excludValue:String;
				while(excludChildren.length>0)
				{
					excludValue=excludChildren[0];
					for (var i:int = 0; i < json[childrenKeyword].length; i++) 
					{
						if(json[childrenKeyword][i][excludKeyword] == excludValue)
						{
							json[childrenKeyword].removeAt(i);
							break;
						}
					}
					excludChildren.shift();
				}
			}
			return json;
		}
		
		private function initInstance():void
		{
			//cloud 2018.2.28
			switch(LivelyLibrary.CurrentEdition)
			{
				case LivelyLibrary.DoorWindowEdition:
					_parseWindowDoor = new DataParseWindowDoor(this);
					break;
			}
		}
		
		/**
		 * 门窗、地砖、墙砖
		 * 节点初始化
		 */
		public function initNodeData():void
		{
			//cloud 2018.2.28
			switch(LivelyLibrary.CurrentEdition)
			{
				case LivelyLibrary.DoorWindowEdition:
					_parseWindowDoor.initParse();
					break;
			}
		}
	}
}