package com.utils
{
	import com.engine.AwayEngine;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.assets.AssetType;
	import away3d.loaders.Loader3D;
	import away3d.loaders.misc.AssetLoaderContext;
	import away3d.loaders.parsers.Parsers;

	public class PowerLoader
	{

		public static function loadFile(url:String,loadFunc:Function = null,...args):void{
			initFile(url,loadFunc,args);
		}
		/**
		 * 将二进制数据转换成视图
		 */		
		public static function convertByte(byte:ByteArray,
										   loadFunc:Function = null,...args):void{
			initByte(byte,loadFunc,args);
		}
		
		private static function initByte(byte:ByteArray,loadFunc:Function,
										 args:Array):void
		{
			var data:Object = getFile(byte);
			if(data != null){
				loadComplete(data,loadFunc,args);
			}else{
				loadImage2(byte,loadFunc,args);
				loadProgress();
			}
		}
		/**
		 * 将二进制数据加载成视图
		 * @param url
		 * @param loadFunc
		 * @param args
		 */		
		private static function loadImage2(byte:ByteArray,loadFunc:Function,args:Array):void
		{
			if(urlDic[byte] !== undefined){
				loader = urlDic[byte];
			}else{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onAssetsComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
				//				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onAssetsProgress);
				loader.loadBytes(byte);
			}
			pushLoader(loader,byte,loadFunc,args);
		}
		
		
		/**
		 * 加载普通数据
		 * @param url
		 * @param loadFunc
		 * @param args
		 */		
		public static function loadUrl(urlRequest:URLRequest,dataFormat:String,
									   loadFunc:Function = null,...args):void{
			var data:Object = getFile(urlRequest.url);
			if(data != null){
				loadComplete(data,loadFunc,args);
			}else{
				var url:String = urlRequest.url;
				if(urlDic[url] !== undefined){
					loader = urlDic[url];
				}else{
					var loader:URLLoader = new URLLoader();
					loader.dataFormat = dataFormat;
					loader.addEventListener(Event.COMPLETE,onUrlComplete);
					loader.addEventListener(IOErrorEvent.IO_ERROR,onError);
					loader.load(urlRequest);
					loadProgress();
				}
				pushLoader(loader,url,loadFunc,args);
			}
		}
		/**
		 * 以二进制数据方式加载目标
		 * @param url
		 * @param loadFunc
		 * @param args
		 */		
		public static function loadByte(url:String,loadFunc:Function = null,...args):void{
			var data:Object = getFile(url);
			if(data != null){
				loadComplete(data,loadFunc,args);
			}else{
				loadData(url,loadFunc,args,true);
			}
		}
		
		private static function initFile(url:String,loadFunc:Function,args:Array):void
		{
			var data:Object = getFile(url);
			if(data != null){
				loadComplete(data,loadFunc,args);
			}else{
				checkFile(url,loadFunc,args);
			}
		}
		
		private static var assetLoaderContext:AssetLoaderContext;
		private static var urlDic:Dictionary = new Dictionary(true);//key:url,value:loader
		private static var loadDic:Dictionary = new Dictionary(true);//key:loader,value:Vector.<LoadVo>
		private static function checkFile(url:String, loadFunc:Function, args:Array):void
		{
//			if(urlDic == null)urlDic = new Dictionary(true);
//			if(loadDic == null)loadDic = new Dictionary(true);
			var tempUrl:String = url.toLocaleLowerCase();
			if(tempUrl.lastIndexOf('.png') > 0 || tempUrl.lastIndexOf('.jpg') > 0 || 
				tempUrl.lastIndexOf('.gif') > 0){//加载材质数据
				loadImage(url,loadFunc,args);
 			}else if(tempUrl.lastIndexOf('.mtl') > 0)
			{
				loadMtl(url,loadFunc,args);
			}else if(args[0] is AssetLoaderContext)
			{
				assetLoaderContext = args[0];
				loadData(url,loadFunc,args);
			}else{
				assetLoaderContext = null;
				loadData(url,loadFunc,args);
			}
			loadProgress();
		}
		/**
		 * 注册帧循环 每帧监听加载进度
		 */		
		private static function loadProgress():void
		{
//			if(loadDispatcher.hasEventListener(ProgressEvent.PROGRESS))
			AwayEngine.addLoop(onLoop);
		}
		/**
		 * 抛出全部加载完成事件
		 */		
		private static function endProgress():void{
			AwayEngine.removeLoop(onLoop);
			setTimeout(endDispatch,3000);
		}
		
		private static function endDispatch():void
		{
			for each (var loader:Object in urlDic) 
			{
				return;//再次确认是否还有剩余 如果下一个已经开始了就停止抛出
			}
			if(loadDispatcher.hasEventListener(Event.COMPLETE))
				loadDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			
		}
		
		/**
		 * 注册加载进度事件:ProgressEvent.PROGRESS
		 * @param func
		 */		
		public static function addProgressEvent(func:Function):void{
			loadDispatcher.addEventListener(ProgressEvent.PROGRESS,func);
		}
		public static function removeProgressEvent(func:Function):void{
			loadDispatcher.removeEventListener(ProgressEvent.PROGRESS,func);
		}
		/**
		 * 注册全部加载完成事件:Event.COMPLETE
		 * @param func
		 */		
		public static function addCompleteEvent(func:Function):void{
			loadDispatcher.addEventListener(Event.COMPLETE,func);
		}
		public static function removeCompleteEvent(func:Function):void{
			loadDispatcher.removeEventListener(Event.COMPLETE,func);
		}
		
		private static var loadDispatcher:EventDispatcher = new EventDispatcher();
		private static function onLoop(e:Event):void
		{
			var bytesLoaded:Number = 0;
			var bytesTotal:Number = 0;
			var loaderCount:int;
			for each (var loader:Object in urlDic) 
			{
				if(loader is Loader){
					bytesLoaded += (loader as Loader).contentLoaderInfo.bytesLoaded;
					bytesTotal += (loader as Loader).contentLoaderInfo.bytesTotal;
				}else{
					bytesLoaded += (loader as URLLoader).bytesLoaded;
					bytesTotal += (loader as URLLoader).bytesTotal;
				}
				loaderCount ++;
			}
			if(loaderCount == 0){//全部加载完毕
				endProgress();
			}else{
				var pe:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
				pe.bytesLoaded = bytesLoaded;
				pe.bytesTotal = bytesTotal;
				loadDispatcher.dispatchEvent(pe);
			}
		}
		
		/**
		 * 先检查是否已经开始加载了 如果已经开始加载 就无需再加载 直接传入回调函数即可 等一起加载结束后回调
		 * @param url
		 * @param loadFunc
		 * @param args
		 */		
		private static function loadImage(url:String, loadFunc:Function, args:Array):void
		{
			if(urlDic[url] !== undefined){
				loader = urlDic[url];
			}else{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onAssetsComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
//				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onAssetsProgress);
				loader.load(new URLRequest(url));
			}
			pushLoader(loader,url,loadFunc,args);
		}
		/**
		 *加载车型贴图配置文件 
		 * @param url
		 * @param loadFunc
		 * @param args
		 */		
		private static function loadMtl(url:String, loadFunc:Function, args:Array):void
		{
			if(urlDic[url] !== undefined){
				loader = urlDic[url];
			}else{
				var loader:URLLoader = new URLLoader();
				loader.dataFormat = URLLoaderDataFormat.BINARY;
				loader.addEventListener(Event.COMPLETE,onMtlComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR,onError);
				loader.load(new URLRequest(url));
			}
			pushLoader(loader,url,loadFunc,args);
		}
		
		private static function onError(e:IOErrorEvent):void
		{
			var loader:Object;
			if(e.target is LoaderInfo){
				loader = (e.target as LoaderInfo).loader;
				(loader as Loader).unloadAndStop();
			}else{
				loader = e.target as URLLoader;
			}
			var loadVector:Vector.<LoadVo> = loadDic[loader];
			var url:Object = loadVector[0].url;
			trace('加载地址有误:' + url + '\n错误信息:' + e);
			exit(loader);
		}

		private static function loadData(url:String, loadFunc:Function, args:Array,
										 isByte:Boolean = false):void
		{
			if(urlDic[url] !== undefined){
				loader = urlDic[url];
			}else{
				var loader:URLLoader = new URLLoader();
				loader.dataFormat = URLLoaderDataFormat.BINARY;
				if(isByte)loader.addEventListener(Event.COMPLETE,onUrlComplete);
				else loader.addEventListener(Event.COMPLETE,onAssetsComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR,onError);
//				loader.addEventListener(ProgressEvent.PROGRESS,onAssetsProgress);
				loader.load(new URLRequest(url));
				loadProgress();
			}
			pushLoader(loader,url,loadFunc,args);
		}
		/**
		 * 普通的数据文件加载
		 * @param e
		 */		
		private static function onUrlComplete(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE,onUrlComplete);
			var loader:Object = e.target as URLLoader;
			var asset:Object = (loader as URLLoader).data;
			dispose(loader,asset);
		}
		
		private static function onMtlComplete(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE,onMtlComplete);
			var loader:Object = e.target as URLLoader;
			var asset:Object = (loader as URLLoader).data;
			dispose(loader,asset);
		}
		
		private static var urlLoaderDic:Dictionary;
		private static function onAssetsComplete(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE,onAssetsComplete);
			var loader:Object;
			var asset:Object;
			if(e.target is LoaderInfo){
				loader = (e.target as LoaderInfo).loader;
				asset = (loader as Loader).content;
				(loader as Loader).unloadAndStop();
				dispose(loader,asset);
			}else{
				loader = e.target as URLLoader;
				asset = (loader as URLLoader).data;
				if(urlLoaderDic == null) urlLoaderDic = new Dictionary(true);
				Parsers.enableAllBundled();
				var loader3D:Loader3D = new Loader3D();
				loader3D.loadData(asset,assetLoaderContext);
				loader3D.addEventListener(AssetEvent.ASSET_COMPLETE, assetComplete);
				loader3D.addEventListener(LoaderEvent.RESOURCE_COMPLETE, resourceComplete);
				urlLoaderDic[loader3D] = loader;
			}
		}
		
		private static var _meshList:Mesh;
		private static var assetLoader:URLLoader;
		private static var assetLoader3D:Loader3D;
		private static function assetComplete(e:AssetEvent):void
		{
			assetLoader3D = e.target as Loader3D;
			assetLoader = urlLoaderDic[assetLoader3D];
			if(e.asset.assetType == AssetType.MESH)
			{
				var asset:Mesh = e.asset as Mesh;
//				if(assetLoaderContext != null)
//				{
//					if(_meshList == null) _meshList = new Mesh(null);
//					_meshList.addChild(asset);
//				}else
//				{
//					dispose(assetLoader,asset);
//				}
				if(_meshList == null) _meshList = new Mesh(null);
				_meshList.addChild(asset);
			}
		}
		
		private static function resourceComplete(e:LoaderEvent):void
		{
			delete urlLoaderDic[assetLoader3D];
			if(_meshList != null)
			{
				dispose(assetLoader,_meshList);
			}
			assetLoader3D.dispose();
			_meshList = null;
		}
		
		/**
		 * 目标地址有误 直接跳出
		 * @param loader
		 */		
		private static function exit(loader:Object):void{
			var loadVector:Vector.<LoadVo> = loadDic[loader];
			var url:Object = loadVector[0].url;
			delete loadDic[loader];
			delete urlDic[url];
			loader = null;
			loadVector.length = 0;
			loadVector = null;
		}
		
		private static function dispose(loader:Object,asset:Object):void{
			var loadVector:Vector.<LoadVo> = loadDic[loader];
			var url:Object = loadVector[0].url;
			ResourceBox.setResource(url,asset);
			
			delete loadDic[loader];
			delete urlDic[url];
			loader = null;
			for each (var lvo:LoadVo in loadVector) 
			{
				loadComplete(asset,lvo.loadFunc,lvo.args);
			}
			loadVector.length = 0;
			loadVector = null;
		}
		
		/**
		 * 存入和本loader(2D or 3D)相关联的回调函数和参数
		 * @param loader
		 */		
		private static function pushLoader(loader:Object,
										   url:Object, loadFunc:Function, args:Array):void
		{
			var loadVector:Vector.<LoadVo> = loadDic[loader];
			if(loadVector == null){
				loadVector = loadDic[loader] = new Vector.<LoadVo>();
			}
			loadVector.push(new LoadVo(url,loadFunc,args));
			urlDic[url] = loader;
		}
		
		private static function loadComplete(data:Object,loadFunc:Function, args:Array):void
		{
			if(args != null){ //如果传入第三个参数
				args.unshift(data);
				loadFunc.apply(null,args);//如果第三个参数传入 也将自己作为参数传出
			}else{
				loadFunc(data);
			}
		}
		
		private static function getFile(url:Object):Object
		{
			if(ResourceBox.cotainKey(url))return ResourceBox.getResource(url);
			return null;
		}
	}
}
import flash.utils.Dictionary;

class ResourceBox
{
	/**
	 * 通过Dictionary保存图片序列bitmapData标签为图片url
	 * 主要实现 存最新图片序列 检查已有的图片序列 取目标图片序列
	 */		
	private static var resource:Dictionary = new Dictionary(true);
	
	/**
	 * 存入目标资源
	 * @param url 目标资源地址
	 * @param data 目标资源（图片序列BitmapData 或 影片MovieClip）
	 */		
	public static function setResource(url:Object , data:* ):void{
		resource[url] = data;
	}
	
	/**
	 * 检查目标资源地址对应的目标资源是否已经在素材管理器里面存在
	 * data的值即不是null也不是undefined表示存在才为true
	 * @param url 目标资源地址
	 * @return 是否有
	 */		
	public static function cotainKey(url:Object):Boolean{
		if(resource[url] !== undefined && resource[url] != null){
			return true; //发现该种子对应的数据确实有的
		}
		return false;
	}
	
	/**
	 * 取得目标资源地址对应的目标资源
	 * @param url 目标资源地址
	 * @return 目标资源
	 */		
	public static function getResource(url:Object):*{
		return resource[url];
	}
}
class LoadVo
{
	public function LoadVo(url:Object, loadFunc:Function, args:Array):void{
		this.url = url;
		this.loadFunc = loadFunc;
		this.args = args;
	}
	
	public var url:Object;
	public var loadFunc:Function;
	public var args:Array;
}