package utils.lx.managers
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.graphics.codec.JPEGEncoder;
	
	import utils.Base64;
	import utils.lx.ListenerExtend;

	public class WebAPIParamDoorWindowMGR
	{
		/**

		 */		
		//本地地址
//		private static const urlAPI:String = "http://192.168.1.113:8080/api/Transform/GetJson";
		//张汉城本地地址
//		private static const urlAPI:String = "http://192.168.1.54:8080/api/Transform/GetJson";
		//服务器地址
//		private static const urlAPI:String = "http://125.88.152.119:8033/api/Transform/GetJson";
		private static const urlAPI:String = "http://www.lejia3d.com:8033/api/Transform/GetJson";
		
		/**
		 * 门窗拆单API调用地址
		 */
		private static const orderUrlAPI:String = "http://192.168.1.100:8036/Home/GetOpenWindowUnitUrl";
		//private static const orderUrlAPI:String = "http://119.23.29.127/Home/GetOpenWindowUnitUrl";
		private var request:URLRequest;
		
		public function WebAPIParamDoorWindowMGR()
		{
			
		}
		
		/**
		 * 型材调用获取json数据
		 * @param result 成功函数
		 * @param fault 失败函数
		 * @param data cad文件数据
		 * @param dataKey cad文件数据对应名称标签字段
		 * @param fileName 文件名
		 * @param fileNamekey 文件名对应名称标签字段
		 * 
		 */
		public function getJsonData(result:Function,fault:Function,data:ByteArray ,dataKey:String = "cadfile",fileName:String="",fileNamekey:String = "fileName"):void
		{
			togetherXingCai(data,urlAPI,result,fault,fileName);
		}
		
		/**
		 * 拆单调用获取json数据
		 * @param result
		 * @param fault
		 */			
		public function getOrderJsonData(result:Function,fault:Function,data:XML,Imgdata:BitmapData):void
		{
			togetherOrder(data,Imgdata,orderUrlAPI,result,fault);
		}
		
		/**
		 * 拆单 
		 * @param data
		 * @param url
		 * @param result
		 * @param fault
		 * 
		 */
		private function togetherOrder(data:XML,Imgdata:BitmapData,url:String,result:Function,fault:Function):void
		{
			var variable:URLVariables = new URLVariables();
			//截图Base64数据
			var jpg:JPEGEncoder = new JPEGEncoder();
			var ba:ByteArray = jpg.encode(Imgdata);
			var imgBase64Data:String = Base64.encodeByteArray(ba);
			variable.body = data.toString();
			variable.head = imgBase64Data;

			request = new URLRequest();
			request.url = url;
//			request.contentType = "application/json;charset=UTF-8";
			request.method = URLRequestMethod.POST;
			request.data = variable;
			
			var loader:URLLoader = new URLLoader();
			var complete:ListenerExtend = new ListenerExtend();
			loader.addEventListener(Event.COMPLETE,complete.concat(completeHandler,result));
			var error:ListenerExtend = new ListenerExtend();
			loader.addEventListener(IOErrorEvent.IO_ERROR,error.concat(ioerrorHandler,fault));
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandler);
			loader.load(request);
		}
		
		/**
		 * cad型材文件上传后端，返回型材围点json文件
		 * @param data cad型材二进制字节流文件
		 * @param url 后端API调用地址
		 * @param result 返回成功函数
		 * @param fault 返回失败函数
		 * 
		 */
		private function togetherXingCai(data:ByteArray,url:String,result:Function,fault:Function,fileName:String=""):void
		{
			var obj:Object={};
			obj.cadfile = Base64.encodeByteArray(data);
			obj.fileName = fileName;
			
			var variable:URLVariables = new URLVariables();
			variable.body = JSON.stringify(obj);
			var str:String = "";
			
			request = new URLRequest();
			request.url = url;
			//request.contentType = "application/json;charset=UTF-8";
			request.method = URLRequestMethod.POST;
			request.data = variable;
			
			var loader:URLLoader = new URLLoader();
			var complete:ListenerExtend = new ListenerExtend();
			loader.addEventListener(Event.COMPLETE,complete.concat(completeHandler,result));
			var error:ListenerExtend = new ListenerExtend();
			loader.addEventListener(IOErrorEvent.IO_ERROR,error.concat(ioerrorHandler,fault));
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandler);
			loader.load(request);
		}
		
		/**
		 * 返回成功 
		 * @param event
		 * @param result
		 * 
		 */
		private function completeHandler(event:Event,result:Function):void
		{
			if(result!=null)
			{
				result(event);
			}
			if(request)
				request = null;
		}
		
		/**
		 * 返回失败 
		 * @param event
		 * @param fault
		 * 
		 */
		private function ioerrorHandler(event:IOErrorEvent,fault:Function):void
		{
			if(fault!=null)
			{
				fault(event);
			}
			if(request)
				request = null;
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void
		{
			//print(event.toString());
		}

	}
}