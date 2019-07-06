package utils.lx.managers
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	
	import utils.lx.ListenerExtend;

	public class WebAPIUserMGR
	{
//		private static const Domain:String = "http://192.168.1.100:8016/";
		
		//private static const OrderCreat:String = "http://192.168.1.100:8078/OriginalOrder/CreateMCOrder";//通过json创建订单
//		private static const Domain:String = "http://www.lejia3d.com:8090/AccountAPI/";
		
		/**
		 * 大软件用户登录(临时统计)
		 */		
		private static const FlashLogin:String ="api/Account/FlashLogin";
		
		/**
		 * 添加产品:上传/调用(临时统计)
		 */		
		private static const AddProduct:String = "api/Product/AddProduct";
		
		/**
		 * 添加PPT/报价单(临时统计)
		 */		
		private static const AddQuotations:String = "api/Quotations/AddQuotations";
		
		/**
		 * 添加全景图或者效果图的统计数据(临时统计)
		 */		
		private static const AddDesignInfo:String = "api/Design/AddDesignInfo";
		
		/**
		 * 登陆 
		 */
		private static const UserLogin:String ="api/Account/UserLogin";
		
		private static const ChangePassword:String = "api/Account/ChangePassword";
		
		private var count:int =0;

		private var telecom:String = "";
		private var unicom:String = "";
		private var move:String = "";
		
		public function setIP(v1:String,v2:String,v3:String):void
		{
			telecom = v1;
			unicom = v2;
			move =v3;
		}
		
		public function WebAPIUserMGR()
		{
		}
		
		private function together(data:Object,url:String,result:Function,fault:Function):void
		{
			var hdr:URLRequestHeader = new URLRequestHeader("Content-type", "application/json");
//			var variable:URLVariables = new URLVariables();
//			variable.data = JSON.stringify(data);
			
			var request:URLRequest = new URLRequest();
			request.requestHeaders.push(hdr);
			request.url = url;
			request.method = URLRequestMethod.POST;
			request.data = JSON.stringify(data);
			
			var loader:URLLoader = new URLLoader();
			var complete:ListenerExtend = new ListenerExtend();
			loader.addEventListener(Event.COMPLETE,complete.concat(completeHandler,result));
			var error:ListenerExtend = new ListenerExtend();
			loader.addEventListener(IOErrorEvent.IO_ERROR,error.concat(ioerrorHandler,data,result,fault));
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandler);
			loader.load(request);
		}
		
		
		private function completeHandler(event:Event,result:Function):void
		{
			if(result!=null)
			{
				result(event);
			}
		}
		
		private function ioerrorHandler(event:IOErrorEvent,data:Object,result:Function,fault:Function):void
		{
			if(count<2)
			{
				userLogin(result,fault,data.userName,data.password);
				count++;
			}
			else if(fault!=null)
			{
				fault(event);
				count = 0;
			}
			
		}
		public function userLogin(result:Function,fault:Function,username:String,password:String):void
		{
			var data:Object = {};
			data.userName = username;
			data.password = password;
//			data.productVersionID = "e249332e-5a44-4b27-8056-fcc2a91a5842";
			together(data,typeIP(UserLogin),result,fault);
		}
		
		public function changePassword(result:Function,fault:Function,username:String,oldpassword:String,newpassword:String):void
		{
			var data:Object = {};
			data.username = username;
			data.oldpassword = oldpassword;
			data.newpassword = newpassword;
			together(data,typeIP(ChangePassword),result,fault);
		}
		
		private function typeIP(v:String):String
		{
			var ip:String = "";
			switch(count)
			{
				case 0:
				{
					ip = telecom+v;
				}
					break;
				case 1:
				{
					ip = unicom+v;
				}
					break;
				case 2:
				{
					ip = move+v;
				}
					break;
			}
			return ip;
		}
		
		/**
		 * 创建订单接口
		 * @param result
		 * @param fault
		 * @param json
		 */		
//		public function orderCreate(result:Function,fault:Function,json:String):void
//		{
//			together(json,OrderCreat,result,fault);
//		}
		
		/**
		 * 大软件用户登录(临时统计)
		 * @param result
		 * @param fault
		 * @param cellPhone
		 * @param password
		 * @param province
		 * @param city
		 * @param brandName
		 */			
		public function flashLogin(result:Function,fault:Function,username:String,password:String,cellPhone:String,province:String,city:String,brandName:String):void
		{
			var data:Object = {};
			data.userName = username;
			data.password = password;
			data.cellPhone=cellPhone;
			data.province = province;
			data.city = city;
			data.brandName = brandName;
			data.appSecret = "cAzRPUomjCadY3E243kbhmn2EAe4s5C5";
			together(data,typeIP(FlashLogin),result,fault);
		}
		
		/**
		 * 添加产品:上传/调用(临时统计)
		 * @param result
		 * @param fault
		 * @param token
		 * @param type 1为调用 2为上传
		 * @param productID
		 * @param productName
		 * @param accountID
		 */		
		public function addProduct(result:Function, fault:Function, token:String, type:String, productID:String, productName:String, accountID:String):void
		{
			var data:Object = {};
			data.Token = token;
			data.Type = type;
			data.ProductID = productID;
			data.ProductName = productName;
			data.AccountID = accountID;
			together(data,typeIP(AddProduct),result,fault);
		}
		
		/**
		 * 添加PPT/报价单(临时统计)
		 * @param result
		 * @param fault
		 * @param token
		 * @param accountID
		 * @param type 1为PPT,2为报价单
		 * @param title 方案名称
		 * @param url 链接地址
		 */		
		public function addQuotations(result:Function,fault:Function,token:String,accountID:String,type:String,title:String,url:String):void
		{
			var data:Object = {};
			data.Token = token;
			data.AccountID = accountID;
			data.Type = type;
			data.Title = title;
			data.URL = url;
			together(data,typeIP(AddQuotations),result,fault);
		}
		
		/**
		 * 添加全景图或者效果图的统计数据(临时统计)
		 * @param result
		 * @param fault
		 * @param token
		 * @param accountID
		 * @param UserCode
		 * @param type 1为效果图,2为全景图
		 * @param designName 方案名称
		 * @param url
		 */		
		public function addDesignInfo(result:Function,fault:Function,token:String,accountID:String,userCode:String,type:String,designName:String,url:String):void
		{
			var data:Object = {};
			data.Token = token;
			data.AccountID = accountID;
			data.UserCode = userCode;
			data.Type = type;
			data.DesignName = designName;
			data.URL = url;
			together(data,typeIP(AddDesignInfo),result,fault);
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void
		{
			switch(event.status)
			{
				case 500:
					break;
			}
		}
	}
}