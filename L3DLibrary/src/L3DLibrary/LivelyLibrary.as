package L3DLibrary
{
	import flash.display.DisplayObject;
	import flash.display.Stage3D;
	import flash.events.EventDispatcher;
	
	import mx.core.FlexGlobals;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import alertMsg.L3DAlert;
	
	import extension.cloud.a3d.resources.CBitmapTextureResource;
	import extension.cloud.dict.CL3DConstDict;
	import extension.cloud.singles.CL3DModuleUtil;
	
	import utils.lx.managers.GlobalManager;

	public class LivelyLibrary extends EventDispatcher
	{
		public static var DebugEnabled:Boolean = false;
		private static var currentMaterial:L3DMaterialInformations = null;
		private static var company:String = "";
		private static var _SceneBrand:String = "";
		public static var SceneCode:String = "";
		SceneBrand = Brand.ZhuoMa;
		public static const OurBrand:String = "乐家";
		public static var VarBrand:String = "";
		public static var sceneID:String = "";
		public static var sceneNum:int = 0;
		public static var currentUserCode:String = "";
		public static var StandardPrior:Boolean = false;
		public static var OnShowDialog:Boolean = false;
		private static var currentEdition:int = DecorationNormalEdition;
		private static var showMessageFun:Function = null;
		public static const DecorationNormalEdition:int = 0;
		public static const DecorationAdvanceEdition:int = 1;
		public static const DecorationSpecialEdition:int = 2;
		public static const CurtainEdition:int = 3;
		public static const TilingEdition:int = 4;
		public static const DoorWindowEdition:int = 5;
		public static const StoneEdition:int = 6;
		public static const MixEdition:int = 7; //乐家设计
		public static const WardrobeEdition:int = 8;
		/**
		 * 主项目运行模式,参考CL3DConstDict类中的RUNTIME系列类型值
		 */		
		private static var _runtimeMode:int;
		private static var sceneBakeLightTexture:CBitmapTextureResource = null;
		private static var sceneHighLightTexture:CBitmapTextureResource = null;
		public static var sceneUserCode:String = "";
		//发布统一登录版本为true
		public static var onlyLogin:Boolean = true;
		public static var CurtainBrandIndex:int = 0;
		/**
		 * 纹理强制模式,参考CL3DConstDict类中的FORCE系列类型值
		 */		
		public static var TextureForceMode:int=CL3DConstDict.FORCE_NORMAL;
		/**
		 * 是否是新版墙体模块 
		 */		
		public static var IsNewWallModule:Boolean=true;
		
		public static function get RuntimeMode():int
		{
			return _runtimeMode;
		}
		public static function set RuntimeMode(value:int):void
		{
			_runtimeMode=value;
		}
		
		public function LivelyLibrary()
		{
		}
		
		public static function set SceneBrand(value:String):void
		{
			//cloud 2018.2.10 GIA的brand是小写，所以存的SceneCode也要小写
			_SceneBrand = value.toLowerCase();
			SceneCode = Brand.getCode(value);
		}
		
		public static function get SceneBrand():String
		{
			return _SceneBrand;
		}
		
		public static function Setup():void
		{
			L3DLibraryWebService.SetupWebService();
			L3DPPTWebService.SetupWebService();
		}
		
		public static function get Enabled():Boolean
		{
			return L3DLibraryWebService.WebServiceEnable;
		}
		
		public static function get CurrentMaterial():L3DMaterialInformations
		{
			return currentMaterial;	
		}
		
		public static function set CurrentMaterial(v:L3DMaterialInformations):void
		{
			currentMaterial = v;
		}
		
		public static function get Company():String
		{
			if(company==null||company.length==0){
				company = OurBrand;
			}
			return company;
		}
		
		public static function set Company(v:String):void
		{
			company = v == null || v.length == 0 ? Brand.LeJia : v.toUpperCase();
		}
		
		public static function get CurrentEdition():int
		{
			return currentEdition;
		}
		
		public static function set CurrentEdition(v:int):void
		{
			currentEdition = v;
		}
		
		public static function SceneBakeLightTexture(stage3D:Stage3D):CBitmapTextureResource
		{
			if(sceneBakeLightTexture == null)
			{
				sceneBakeLightTexture=CL3DModuleUtil.Instance.getBitmapTextureResourceInstance(0xAAAAAA,CL3DConstDict.SUFFIX_LIGHT,CL3DConstDict.PREFIX_FILL);
				sceneBakeLightTexture.isSystemMode = true;
				if(stage3D)
				{
					sceneBakeLightTexture.upload(stage3D.context3D);
				}
			}
			return sceneBakeLightTexture;
		}
		
		public static function SceneHighLightTexture(stage3D:Stage3D):CBitmapTextureResource
		{
			if(sceneHighLightTexture == null)
			{
				sceneHighLightTexture=CL3DModuleUtil.Instance.getBitmapTextureResourceInstance(L3DMesh.HighLightColor,CL3DConstDict.SUFFIX_LIGHT,CL3DConstDict.PREFIX_FILL);
				sceneHighLightTexture.isSystemMode = true;
				if(stage3D)
				{
					sceneHighLightTexture.upload(stage3D.context3D);
				}
			}
			return sceneHighLightTexture;
		}
		
		public static function SetupShowMessageFun(fun:Function):void
		{
			showMessageFun = fun;		
		}
		
		public static function ShowMessage(text:String, type:int = 0, delay:Number = 1000):void
		{
			if(text == null || text.length == 0)
			{
				return;
			}
			
			if(showMessageFun == null)
			{
//				Alert.show(text, type == 0 ? "提示" : (type == 1 ? "错误" : "警告"));
				var l3dAlert:L3DAlert = new L3DAlert();
				l3dAlert.showAlert(text, type ,FlexGlobals.topLevelApplication as DisplayObject);
			}
			else
			{
				showMessageFun(text,type,delay);
			}
		}
		
		/**
		 * 非允许下，禁止调用此方法，远程写日志影响渲染服务 liuxin20171027
		 */
		public static function WriteLogInformation(text:String):void
		{
			return;
			if(text == null || text.length == 0)
			{
				return;
			}
			
//			var atObj:AsyncToken = L3DLibraryWebService.LibraryService.WriteLogInformation(text);
//			var rpObj:mx.rpc.Responder = new mx.rpc.Responder(WriteLogInformationResult, WriteLogInformationFault);
//			atObj.addResponder(rpObj);

//			lrj 2017/12/7 
			GlobalManager.Instance.serviceMGR.writeLogInformation(WriteLogInformationResult, WriteLogInformationFault, text);
		}
		
		private static function WriteLogInformationResult(reObj:ResultEvent):void
		{

		}
		
		private static function WriteLogInformationFault(feObj:FaultEvent):void
		{

		}
		
	/*	public static function get CurtainBrandIndex():int
		{
			if(L3DLogin.CurrentUser == null)
			{
				return 0;
			}
			
			switch(L3DLogin.CurrentUser.Company)
			{
				case "绎尚":
				{
					return 1;
				}
					break;
				default:
				{
					return 0;
				}
					break;
			}
		} */
	}
}