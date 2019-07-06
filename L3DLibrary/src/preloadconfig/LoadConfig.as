package preloadconfig
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import spark.components.Alert;
	
	import L3DLibrary.LivelyLibrary;
	import L3DLibrary.L3DRootNode;
	

	/**
	 * 加载各个品牌的配置文件
	 * @author Debugger
	 */	
	public class LoadConfig
	{
		private var urlloader:URLLoader;
		private var request:URLRequest;
		private const viewFixURL:String = "configs/nodes/";
		private var url:String = "";
		private var _configData:ConfigData;
		private static var isInit:Boolean;
		private static var isConfigDataComplete:Boolean;
		private var _tree:XML;
		
		public function LoadConfig()
		{
			if(isInit){
				throw new Error("LoadConfig仅有唯一实例");
			}
			isInit = true;
			_configData = new ConfigData(this);
			L3DRootNode.instance.addEventListener(Event.COMPLETE,xmlDownloadCompleteHandler);
			
			urlloader = new URLLoader();
			request = new URLRequest();
			//先加载默认配置
			request.url = viewFixURL+"defaultNode.json";
			urlloader.addEventListener(Event.COMPLETE,loaderComplete1Handler);
			urlloader.addEventListener(IOErrorEvent.IO_ERROR,ioerror1Handler);
			urlloader.load(request);
		}
		
		private function loaderComplete1Handler(event:Event):void
		{
			urlloader.removeEventListener(Event.COMPLETE,loaderComplete1Handler);
			urlloader.removeEventListener(IOErrorEvent.IO_ERROR,ioerror1Handler);
			_configData.setDefaultData(JSON.stringify(urlloader.data));
			urlloader.close();
			urlloader.addEventListener(Event.COMPLETE,loaderComplete2Handler);
			urlloader.addEventListener(IOErrorEvent.IO_ERROR,ioerror2Handler);
			//再加载品牌配置
			request.url = viewFixURL+LivelyLibrary.SceneCode+".json";
			urlloader.load(request);
		}
		
		private function loaderComplete2Handler(event:Event):void
		{
			urlloader.removeEventListener(Event.COMPLETE,loaderComplete2Handler);
			urlloader.removeEventListener(IOErrorEvent.IO_ERROR,ioerror2Handler);
			_configData.replaceBrandData(transToJSON(urlloader.data as String));
			urlloader.close();
			isConfigDataComplete = true;
			initData();
		}
		
		private function transToJSON(data:String):Object
		{
			return JSON.parse(data);
		}
		
		//树节点加载完毕
		private function xmlDownloadCompleteHandler(event:Event):void
		{
			initData();
		}
		
		private function initData():void
		{
			if(!isConfigDataComplete || !L3DRootNode.instance.enabled)
			{
				return;
			}
			_tree = L3DRootNode.instance.rootXML;
			
			_configData.initNodeData();
		}
		
		private function ioerror1Handler(event:IOErrorEvent):void
		{
			Alert.show("加载defaultNode.json失败");
		}
		
		private function ioerror2Handler(event:IOErrorEvent):void
		{
			urlloader.removeEventListener(Event.COMPLETE,loaderComplete2Handler);
			urlloader.removeEventListener(IOErrorEvent.IO_ERROR,ioerror2Handler);
			urlloader.close();
			isConfigDataComplete = true;
			initData();
		}
		
		public function get configData():ConfigData
		{
			return _configData;
		}
		
		public function get tree():XML
		{
			return _tree;
		}
	}
}