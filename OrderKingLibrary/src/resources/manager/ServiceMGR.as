package resources.manager
{
	import flash.utils.ByteArray;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.WebService;
	
	import core.L3DLibraryWebService;
	import core.ListenerExtend;
	import core.datas.L3DMaterialInformations;
	
	import resources.task.IRPCRequestTaskData;
	import resources.task.L3DRPCRequestTaskData;

	public class ServiceMGR
	{
		private var _serviceDatasQueue:Vector.<IRPCRequestTaskData>;
		
		public function ServiceMGR()
		{
			_serviceDatasQueue=new Vector.<IRPCRequestTaskData>();
		}
		
		private function responder(success:Function,fault:Function):Responder
		{
			return new Responder(success,fault);
		}
		private function get webService():WebService
		{
			return L3DLibraryWebService.LibraryService;
		}
		
		private function doRequest(taskData:L3DRPCRequestTaskData):void
		{
			var atObj:AsyncToken = webService[taskData.requestName].apply(null,taskData.requestParams);
			var rpObj:Responder = responder(onRequessSuccessCallback, onRequessFaultCallback);
			atObj.addResponder(rpObj);
		}
		private function onRequessSuccessCallback(reObj:ResultEvent):void
		{
			var taskData:L3DRPCRequestTaskData=_serviceDatasQueue.pop() as L3DRPCRequestTaskData;
			if(taskData.successCallback!=null)
			{
				taskData.successCallback(reObj.result);
			}
			taskData.clear();
			if(_serviceDatasQueue.length>0)
			{
				//异步调用队列不为空，继续执行异步调用
				doRequest(_serviceDatasQueue[_serviceDatasQueue.length-1] as L3DRPCRequestTaskData);
			}
		}
		private function onRequessFaultCallback(feObj:FaultEvent):void
		{
			var taskData:L3DRPCRequestTaskData=_serviceDatasQueue[_serviceDatasQueue.length-1] as L3DRPCRequestTaskData;
			if(taskData.faultCallback!=null)
			{
				taskData.faultCallback();
			}
			doRequest(taskData);
		}
		/**
		 * 添加一个请求任务 
		 * @param success	请求成功后要执行的调用函数
		 * @param fault	请求失败后要执行的调用函数
		 * @param name	请求的协议名称
		 * @param params	发出请求时，需要发送的请求参数数组
		 * @return Boolean	是否添加成功
		 * 
		 */		
		public function addRequestTask(success:Function,fault:Function,name:String,...params):Boolean
		{
			_serviceDatasQueue.push(new L3DRPCRequestTaskData(success,fault,name,params));
			return true;
		}
		/**
		 * 执行所有请求任务 
		 * 
		 */		
		public function excuteRequestTask():void
		{
			if(_serviceDatasQueue.length>0)
			{
				//异步调用队列不为空，继续执行异步调用
				doRequest(_serviceDatasQueue[_serviceDatasQueue.length-1] as L3DRPCRequestTaskData);
			}
		}
		/****************************************************************************/
		/**
		 * 用户登录
		 * @param success
		 * @param fault
		 * @param username 用户名
		 * @param password 登录密码
		 * 
		 */		
		/*public function loginUser(success:Function,fault:Function,username:String, password:String):void
		{
			var atObj:AsyncToken = webService.LoginUser(username,password);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}*/
		
		/*************************************************************************/

		/**
		 * LoadCurtainCombineBuffer 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param combineCode:String
		 * 
		 */		
		//LoadCurtainCombineBuffer (function 1)
		//GlobalManager.Instance.serviceMGR.loadCurtainCombineBuffer(xxxResult,xxxFault, xxx);
		public function loadCurtainCombineBuffer(success:Function, fault:Function, combineCode:String):void
		{
			var atObj:AsyncToken = webService.LoadCurtainCombineBuffer(combineCode);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}

		/**
		 * SendPassWordMessageToUserPhone 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param phone:String
		 * 
		 */		
		//SendPassWordMessageToUserPhone (function 17)
		//GlobalManager.Instance.serviceMGR.sendPassWordMessageToUserPhone(xxxResult,xxxFault, xxx);
		public function sendPassWordMessageToUserPhone(success:Function, fault:Function, phone:String):void
		{
			var atObj:AsyncToken = webService.SendPassWordMessageToUserPhone(phone);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}

		/**
		 * GetUniqueSceneNumber 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * 
		 */		
		//GetUniqueSceneNumber (function 19)
		//GlobalManager.Instance.serviceMGR.getUniqueSceneNumber(xxxResult,xxxFault, xxx);
		public function getUniqueSceneNumber(success:Function, fault:Function):void
		{
			var atObj:AsyncToken = webService.GetUniqueSceneNumber();
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}

		/**
		 * InsertData 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param templeName:String
		 * @param prefixionName:String
		 * @param sheetIndex:int
		 * @param json:String
		 * 
		 */		
		//InsertData (function 21)
		//GlobalManager.Instance.serviceMGR.insertData(xxxResult,xxxFault, xxx);
		public function insertData(success:Function, fault:Function, templeName:String, prefixionName:String, sheetIndex:int, json:String):void
		{
			var atObj:AsyncToken = webService.InsertData(templeName, prefixionName, sheetIndex, json);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * ImportMosaicCAD 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param buffer:ByteArray
		 * @param dxfMode:Boolean
		 * 
		 */		
		//ImportMosaicCAD (function 23)
		//GlobalManager.Instance.serviceMGR.importMosaicCAD(xxxResult,xxxFault, xxx);
		public function importMosaicCAD(success:Function, fault:Function, buffer:ByteArray, dxfMode:Boolean):void
		{
			var atObj:AsyncToken = webService.ImportMosaicCAD(buffer, dxfMode);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * NetGetContourXmlData 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param buffer:ByteArray
		 * 
		 */		
		//NetGetContourXmlData (function 27)
		//GlobalManager.Instance.serviceMGR.netGetContourXmlData(xxxResult,xxxFault, xxx);
		public function netGetContourXmlData(success:Function, fault:Function, buffer:ByteArray):void
		{
			var atObj:AsyncToken = webService.NetGetContourXmlData(buffer);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * CompuAbnormalXmlData 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param buffer:ByteArray
		 * 
		 */		
		//CompuAbnormalXmlData (function 29)
		//GlobalManager.Instance.serviceMGR.compuAbnormalXmlData(xxxResult,xxxFault, xxx);
		public function compuAbnormalXmlData(success:Function, fault:Function, buffer:ByteArray):void
		{
			var atObj:AsyncToken = webService.CompuAbnormalXmlData(buffer);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * WriteLogInformation 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param text:String
		 * 
		 */		
		//WriteLogInformation (function 31)
		//GlobalManager.Instance.serviceMGR.writeLogInformation(xxxResult,xxxFault, xxx);
		public function writeLogInformation(success:Function, fault:Function, text:String):void
		{
			var atObj:AsyncToken = webService.WriteLogInformation(text);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * GetSketchBitmapBuffer 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param buffer:ByteArray
		 * 
		 */		
		//GetSketchBitmapBuffer (function 83)
		//GlobalManager.Instance.serviceMGR.getSketchBitmapBuffer(xxxResult, xxxFault, xxx);
		public function getSketchBitmapBuffer(success:Function, fault:Function, buffer:ByteArray):void
		{
			var atObj:AsyncToken = webService.GetSketchBitmapBuffer(buffer);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * ExInRec 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param xml:String
		 * 
		 */		
		//ExInRec (function 87)
		//GlobalManager.Instance.serviceMGR.exInRec(xxxResult,xxxFault, xxx);
		public function exInRec(success:Function, fault:Function, xml:String):void
		{
			var atObj:AsyncToken = webService.ExInRec(xml);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * TileCS 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param xml:String
		 * 
		 */		
		//TileCS (function 89)
		//GlobalManager.Instance.serviceMGR.tileCS(xxxResult,xxxFault, xxx);
		public function tileCS(success:Function, fault:Function, xml:String):void
		{
			var atObj:AsyncToken = webService.TileCS(xml);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * Triangluate方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param xml:String
		 * 
		 */		
		//Triangluate (function 95)
		//GlobalManager.Instance.serviceMGR.triangluate(xxxResult,xxxFault, xxx);
		public function triangluate(success:Function, fault:Function, xml:String):void
		{
			var atObj:AsyncToken = webService.Triangluate(xml);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * Webservice方法 PolygonsClipper 多边形切割运算
		 * <p>方法中含有异步调用</p>
		 * <p>GlobalManager.Instance.serviceMGR.polygonsClipper</p>
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param xml:String xml包含flag
		 * <p>0代表是切掉在區域外圍的砖</p>
		 * <p>1代表切掉区域相交的砖</p>
		 * <p>2代表区域相交的地方挖掉返回围点</p>
		 * <p>3代表合并区域</p>
		 */		
		//PolygonsClipper (function 97)
		//GlobalManager.Instance.serviceMGR.polygonsClipper(xxxResult,xxxFault, xxx);
		public function polygonsClipper(success:Function, fault:Function, xml:String):void
		{
			var atObj:AsyncToken = webService.PolygonsClipper(xml);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * UpdateUserPassWord 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param userName:String
		 * @param oriPassWord:String
		 * @param newPassWord:String
		 * 
		 */		
		//UpdateUserPassWord (function 119)
		//GlobalManager.Instance.serviceMGR.updateUserPassWord(xxxResult,xxxFault, xxx);
		public function updateUserPassWord(success:Function, fault:Function, userName:String, oriPassWord:String, newPassWord:String):void
		{
			var atObj:AsyncToken = webService.UpdateUserPassWord(userName, oriPassWord, newPassWord);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * CreateQueue 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param userCode:String
		 * @param userName:String
		 * @param company:String
		 * @param authority:int
		 * @param renderMode:int
		 * @param buffer:ByteArray
		 * @param unCompressMode:int
		 * 
		 */		
		//CreateQueue (function 121)
		//GlobalManager.Instance.serviceMGR.createQueue(xxxResult,xxxFault, xxx);
		public function createQueue(success:Function, fault:Function, userCode:String, userName:String, company:String, authority:int, renderMode:int, buffer:ByteArray, unCompressMode:int):void
		{
			var atObj:AsyncToken = webService.CreateQueue(userCode, userName, company, authority, renderMode, buffer, unCompressMode);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * GetQueueCount 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * 
		 */		
		//GetQueueCount (function 124)
		//GlobalManager.Instance.serviceMGR.getQueueCount(xxxResult,xxxFault);
		public function getQueueCount(success:Function, fault:Function):void
		{
			var atObj:AsyncToken = webService.GetQueueCount();
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * 下载渲染完成后的图
		 * @param success:Function
		 * @param fault:Function
		 * @param code:String L3DLogin.CurrentUser.RenderCode
		 */		
		//DownloadRenderedData (function 132)
		//GlobalManager.Instance.serviceMGR.downloadRenderedData(xxxResult,xxxFault, xxx);
		public function downloadRenderedData(success:Function, fault:Function, code:String):void
		{
			var atObj:AsyncToken = webService.DownloadRenderedData(code);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * CheckIsFinish方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param code:String
		 * 
		 */		
		//CheckIsFinish (function 136)
		//GlobalManager.Instance.serviceMGR.checkIsFinish(xxxResult,xxxFault, xxx);
		public function checkIsFinish(success:Function, fault:Function, code:String):void
		{
			var atObj:AsyncToken = webService.CheckIsFinish(code);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * 生成二维码
		 * @param success:Function
		 * @param fault:Function
		 * @param code:String L3DLogin.CurrentUser.UserCode
		 */		
		//GetUserImageLastURL(function 137)
		//GlobalManager.Instance.serviceMGR.getUserImageLastURL(xxxResult,xxxFault, xxx);
		public function getUserImageLastURL(success:Function, fault:Function, code:String):void
		{
			var atObj:AsyncToken = webService.GetUserImageLastURL(code);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * UploadImageSceneInfoToLastURL 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param code:String
		 * @param buffer:ByteArray
		 * 
		 */		
		//UploadImageSceneInfoToLastURL (function 142)
		//GlobalManager.Instance.serviceMGR.uploadImageSceneInfoToLastURL(xxxResult,xxxFault, xxx);
		public function uploadImageSceneInfoToLastURL(success:Function, fault:Function, code:String, buffer:ByteArray):void
		{
			var atObj:AsyncToken = webService.UploadImageSceneInfoToLastURL(code, buffer);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * GetUserImagePreviewFilesXML 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param code:String
		 * 
		 */		
		//GetUserImagePreviewFilesXML (function 144)
		//GlobalManager.Instance.serviceMGR.getUserImagePreviewFilesXML(xxxResult,xxxFault, xxx);
		public function getUserImagePreviewFilesXML(success:Function, fault:Function, code:String):void
		{
			var atObj:AsyncToken = webService.GetUserImagePreviewFilesXML(code);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * UploadView360SceneInfoToLastURL 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param code:String
		 * @param buffer:ByteArray
		 * 
		 */		
		//UploadView360SceneInfoToLastURL (function 148)
		//GlobalManager.Instance.serviceMGR.uploadView360SceneInfoToLastURL(xxxResult,xxxFault, xxx);
		public function uploadView360SceneInfoToLastURL(success:Function, fault:Function, code:String, buffer:ByteArray):void
		{
			var atObj:AsyncToken = webService.UploadView360SceneInfoToLastURL(code, buffer);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * GetUserView360PreviewFilesXML 方法
		 * 
		 * @param success:Function
		 * @param fault:Functionb
		 * @param code:String
		 * 
		 */		
		//GetUserView360PreviewFilesXML (function 150)
		//GlobalManager.Instance.serviceMGR.getUserView360PreviewFilesXML(xxxResult,xxxFault, xxx);
		public function getUserView360PreviewFilesXML(success:Function, fault:Function, code:String):void
		{
			var atObj:AsyncToken = webService.GetUserView360PreviewFilesXML(code);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * DownloadFullImageBufferFromPrevewFileName方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param filename:String
		 * 
		 */		
		//DownloadFullImageBufferFromPrevewFileName (function 152)
		//GlobalManager.Instance.serviceMGR.downloadFullImageBufferFromPrevewFileName(xxxResult,xxxFault, xxx);
		public function downloadFullImageBufferFromPrevewFileName(success:Function, fault:Function, filename:String):void
		{
			var atObj:AsyncToken = webService.DownloadFullImageBufferFromPrevewFileName(filename);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
			
		/**
		 * GetImageSceneInfoFromLastURL方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param code:String
		 * 
		 */		
		//GetImageSceneInfoFromLastURL (function 160)
		//GlobalManager.Instance.serviceMGR.getImageSceneInfoFromLastURL(xxxResult,xxxFault, xxx);
		public function getImageSceneInfoFromLastURL(success:Function, fault:Function, code:String):void
		{
			var atObj:AsyncToken = webService.GetImageSceneInfoFromLastURL(code);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * DownloadPicturesLinkedSceneInfomationBuffer 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param url:String
		 * 
		 */		
		//DownloadPicturesLinkedSceneInfomationBuffer (function 162)
		//GlobalManager.Instance.serviceMGR.downloadPicturesLinkedSceneInfomationBuffer(xxxResult,xxxFault, xxx);
		public function downloadPicturesLinkedSceneInfomationBuffer(success:Function, fault:Function, url:String):void
		{
			var atObj:AsyncToken = webService.DownloadPicturesLinkedSceneInfomationBuffer(url);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * DownloadFileBuffer 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param filename:String
		 * 
		 */		
		//DownloadFileBuffer (function 170)
		//GlobalManager.Instance.serviceMGR.downloadFileBuffer(xxxResult,xxxFault, xxx);
		public function downloadFileBuffer(success:Function, fault:Function, filename:String):void
		{
			var atObj:AsyncToken = webService.DownloadFileBuffer(filename);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * RemoveFile 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param filename:Function
		 * 
		 */		
		//RemoveFile (function 172)
		//GlobalManager.Instance.serviceMGR.removeFile(xxxResult,xxxFault, xxx);
		public function removeFile(success:Function, fault:Function, filename:String):void
		{
			var atObj:AsyncToken = webService.RemoveFile(filename);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * CheckFileExist 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param userCode:String
		 * @param name:String
		 * 
		 */		
		//CheckFileExist (function 174)
		//GlobalManager.Instance.serviceMGR.checkFileExist(xxxResult,xxxFault, xxx);
		public function checkFileExist(success:Function, fault:Function, userCode:String, name:String):void
		{
			var atObj:AsyncToken = webService.CheckFileExist(userCode, name);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * CopyFile 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param oriUserName:String
		 * @param destUserName:String
		 * @param name:String
		 * 
		 */		
		//CopyFile (function 176)
		//GlobalManager.Instance.serviceMGR.copyFile(xxxResult,xxxFault, xxx);
		public function copyFile(success:Function, fault:Function, oriUserName:String, destUserName:String, name:String):void
		{
			var atObj:AsyncToken = webService.CopyFile(oriUserName, destUserName, name);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * SaveFile 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param userCode:String
		 * @param name:String
		 * @param xml:String
		 * @param previewBuffer:ByteArray
		 * 
		 */		
		//SaveFile (functio 177)
		//GlobalManager.Instance.serviceMGR.saveFile(xxxResult, xxxFault, xxx);
//		public function saveFile(success:Function, fault:Function, userCode:String, name:String, xml:String, previewBuffer:ByteArray):void
//		{
//			if(xml == null || xml.length == 0)
//			{
//				return;
//			}
//			var xmlBuffer:ByteArray = new ByteArray();
//			L3DModel.WriteString(xmlBuffer, xml);
//			xmlBuffer.compress();
//			var atObj:AsyncToken = webService.SaveFileBinary(userCode, name, xmlBuffer, previewBuffer);
//			var rpObj:Responder = responder(success, fault);
//			atObj.addResponder(rpObj);
//		}
		
		/**
		 * 代替SaveFile
		 * @param success
		 * @param fault
		 * @param userCode
		 * @param name
		 * @param xml
		 * @param previewBuffer
		 */		
//		public function saveFileBinary(success:Function,fault:Function,userCode:String,name:String,xml:String, previewBuffer:ByteArray):void
//		{
//			if(xml == null || xml.length == 0)
//			{
//				return;
//			}
//			var xmlBuffer:ByteArray = new ByteArray();
//			L3DModel.WriteString(xmlBuffer, xml);
//			xmlBuffer.compress();
//			var atObj:AsyncToken = webService.SaveFileBinary(userCode, name, xmlBuffer, previewBuffer);
//			var rpObj:Responder = responder(success, fault);
//			atObj.addResponder(rpObj);
//		}
		
		/**
		 * SaveFileForDatas方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param userCode:String
		 * @param name:String
		 * @param xml:String
		 * @param previewBuffer:ByteArray
		 * 
		 */		
		//SaveFileForDatas (function 181)
		//GlobalManager.Instance.serviceMGR.saveFileForDatas(xxxResult, xxxFault, xxx);
//		public function saveFileForDatas(success:Function, fault:Function, userCode:String, name:String, xml:String, previewBuffer:ByteArray):void
//		{
//			var xmlBuffer:ByteArray = new ByteArray();
//			L3DModel.WriteString(xmlBuffer, xml);
//			xmlBuffer.compress();
//			var atObj:AsyncToken = webService.SaveFileForDatasBinary(userCode, name, xmlBuffer, previewBuffer);
//			var rpObj:Responder = responder(success, fault);
//			atObj.addResponder(rpObj);
//		}
		
		/**
		 * GetUserFileNamesXML 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param code:String
		 * 
		 */		
		//GetUserFileNamesXML (function 183)
		//GlobalManager.Instance.serviceMGR.getUserFileNamesXML(xxxResult, xxxFault, xxx);
		public function getUserFileNamesXML(success:Function, fault:Function, code:String):void
		{
			var atObj:AsyncToken = webService.GetUserFileNamesXML(code);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * DownloadUserFilePreviewBuffer 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param filename:String
		 * 
		 */		
		//DownloadUserFilePreviewBuffer (function 185)
		//GlobalManager.Instance.serviceMGR.downloadUserFilePreviewBuffer(xxxResult, xxxFault, xxx);
		public function downloadUserFilePreviewBuffer(success:Function, fault:Function, filename:String):void
		{
			var atObj:AsyncToken = webService.DownloadUserFilePreviewBuffer(filename);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * DownloadRoomFilePreviewBuffer方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param buffer:ByteArray
		 * 
		 */		
		//DownloadRoomFilePreviewBuffer (function 189)
		//GlobalManager.Instance.serviceMGR.downloadRoomFilePreviewBuffer(xxxResult, xxxFault, xxx);
		public function downloadRoomFilePreviewBuffer(success:Function, fault:Function, buffer:ByteArray):void
		{
			var atObj:AsyncToken = webService.DownloadRoomFilePreviewBuffer(buffer);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * DownloadUserFileContentsXML方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param filename:String
		 * 
		 */		
		//DownloadUserFileContentsXML (function 191)
		//GlobalManager.Instance.serviceMGR.downloadUserFileContentsXML(xxxResult, xxxFault, xxx);
		public function downloadUserFileContentsXML(success:Function, fault:Function, filename:String):void
		{
			var atObj:AsyncToken = webService.DownloadUserFileContentsXML(filename);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * DownloadRoomFileContentsXML 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param buffer:ByteArray
		 * 
		 */		
		//DownloadRoomFileContentsXML (function 193)
		//GlobalManager.Instance.serviceMGR.downloadRoomFileContentsXML(xxxResult, xxxFault, xxx);
		public function downloadRoomFileContentsXML(success:Function, fault:Function, buffer:ByteArray):void
		{
			if(buffer == null || buffer.length == 0)
			{
				return;
			}
			buffer.compress();
			var atObj:AsyncToken = webService.DownloadRoomFileContentsXMLBinary(buffer);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * DownloadRoomFileContentsXMLBinary 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param buffer:ByteArray
		 * 
		 */		
		//DownloadRoomFileContentsXML (function 193)
		//GlobalManager.Instance.serviceMGR.downloadRoomFileContentsXML(xxxResult, xxxFault, xxx);
		public function downloadRoomFileContentsXMLBinary(success:Function, fault:Function, buffer:ByteArray):void
		{
			if(buffer == null || buffer.length == 0)
			{
				return;
			}
			buffer.compress();
			var atObj:AsyncToken = webService.DownloadRoomFileContentsXMLBinary(buffer);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * GetUserImageURL 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param userName:String
		 * @param path:String
		 * @param sceneBrand:String
		 * 
		 */		
		//GetUserImageURL (function 197)
		//GlobalManager.Instance.serviceMGR.getUserImageURL(xxxResult, xxxFault, xxx);
		public function getUserImageURL(success:Function, fault:Function, userName:String, path:String, sceneBrand:String):void
		{
			var atObj:AsyncToken = webService.GetUserImageURL(userName, path, sceneBrand);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * GetUserView360URL 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param userName:String
		 * @param path:String
		 * @param sceneCode:String
		 * 
		 */		
		//GetUserView360URL (function 199)
		//GlobalManager.Instance.serviceMGR.getUserView360URL(xxxResult, xxxFault, xxx);
		public function getUserView360URL(success:Function, fault:Function, userName:String, path:String, sceneCode:String):void
		{
			var atObj:AsyncToken = webService.GetUserView360URL(userName, path, sceneCode);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		//GetUserView360URLFromSphereMap (function 205)
		//GlobalManager.Instance.serviceMGR.getUserView360URLFromSphereMap(xxxResult, xxxFault, xxx);
		/**
		 * GetUserView360URLFromSphereMap（主项目里，默认值参数没有使用）
		 * @param success
		 * @param fault
		 * @param userName
		 * @param viewName
		 * @param buffer
		 * @param sceneCode
		 * @param hotPoints
		 * @param mode
		 * @param accompany
		 * 
		 */		
		public function getUserView360URLFromSphereMap(success:Function, fault:Function, userName:String, viewName:String, buffer:ByteArray, sceneCode:String, hotPoints:String="", mode:int=0, accompany:String=""):void
		{
			var atObj:AsyncToken = webService.GetUserView360URLFromSphereMap(userName, viewName, buffer, sceneCode);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * SubmitPostPictureURL 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param userCode:String
		 * @param buffer:ByteArray
		 * @param brand:String
		 * @param workID:String
		 * @param roomID:String
		 * 
		 */		
		//SubmitPostPictureURL (function 211)
		//GlobalManager.Instance.serviceMGR.submitPostPictureURL(xxxResult, xxxFault, xxx);
		public function submitPostPictureURL(success:Function, fault:Function, userCode:String, buffer:ByteArray, brand:String, workID:String, roomID:String):void
		{
			var atObj:AsyncToken = webService.SubmitPostPictureURL(userCode, buffer, brand, workID, roomID);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * IntegralValidation 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param sceneCode:String
		 * @param userCode:String
		 * 
		 */		
		//IntegralValidation (function 213)
		//GlobalManager.Instance.serviceMGR.integralValidation(xxxResult, xxxFault, xxx);
		public function integralValidation(success:Function, fault:Function, sceneCode:String, userCode:String):void
		{
			var atObj:AsyncToken = webService.IntegralValidation(sceneCode, userCode);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * 一处调用参数不匹配 
		 * @param success
		 * @param fault
		 * @param userCode
		 * @param jsonString
		 * @param sceneCode
		 * 
		 */		
		//UpdateBudgetInfo (function 215)
		//GlobalManager.Instance.serviceMGR.updateBudgetInfo(xxxResult, xxxFault, xxx);
		public function updateBudgetInfo(success:Function, fault:Function, userCode:String, jsonString:String, sceneCode:String):void
		{
			var atObj:AsyncToken = webService.UpdateBudgetInfo(userCode, jsonString, sceneCode);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * GetFavouriteCodesXML 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param userCode:String
		 * 
		 */		
		//GetFavouriteCodesXML (function 217)
		//GlobalManager.Instance.serviceMGR.getFavouriteCodesXML(xxxResult, xxxFault, xxx);
		public function getFavouriteCodesXML(success:Function, fault:Function, userCode:String):void
		{
			var atObj:AsyncToken = webService.GetFavouriteCodesXML(userCode);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		//here
		/**
		 * AddFavouriteCode 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param userCode:String
		 * @param materialCode:String
		 * 
		 */		
		//AddFavouriteCode (function 219)
		//GlobalManager.Instance.serviceMGR.addFavouriteCode(xxxResult, xxxFault, xxx);
		public function addFavouriteCode(success:Function, fault:Function, userCode:String, materialCode:String):void
		{
			var atObj:AsyncToken = webService.AddFavouriteCode(userCode, materialCode);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}

		/**
		 * 
		 * RemoveFavouriteCode 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param userCode:String
		 * @param materialCode:String
		 * 
		 */		
		//RemoveFavouriteCode (function 221)
		//GlobalManager.Instance.serviceMGR.removeFavouriteCode(xxxResult, xxxFault, xxx);
		public function removeFavouriteCode(success:Function, fault:Function, userCode:String, materialCode:String):void
		{
			var atObj:AsyncToken = webService.RemoveFavouriteCode(userCode, materialCode);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * ClearFavouriteCodes 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param userCode:String
		 * 
		 */		
		//ClearFavouriteCodes (function 223)
		//GlobalManager.Instance.serviceMGR.clearFavouriteCodes(xxxResult, xxxFault, xxx);
		public function clearFavouriteCodes(success:Function, fault:Function, userCode:String):void
		{
			var atObj:AsyncToken = webService.ClearFavouriteCodes(userCode);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * InsertExcelData 方法 
		 *  
		 * @param success:Function
		 * @param fault:Function
		 * @param fileName:String
		 * @param sheetIndex:String
		 * @param json:Stirng
		 * 
		 */		
		//InsertExcelData (function 225)
		//GlobalManager.Instance.serviceMGR.insertExcelData(xxxResult, xxxFault, xxx);
		public function insertExcelData(success:Function, fault:Function, fileName:String, sheetIndex:int, json:String):void
		{
			var atObj:AsyncToken = webService.InsertExcelData(fileName, sheetIndex, json);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * importJPG 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param imgBuffer:ByteArray
		 * @param ftBuffer:ByteArray
		 * 
		 */		
		//ImportJPG (function 227)
		//GlobalManager.Instance.serviceMGR.importJPG(xxxResult, xxxFault, xxx);
		public function importJPG(success:Function, fault:Function, imgBuffer:ByteArray, ftBuffer:ByteArray):void
		{
			var atObj:AsyncToken = webService.ImportJPG(imgBuffer, ftBuffer);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * PreviewJPG 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param imgBuffer:ByteArray
		 * @param ftBuffer:ByteArray
		 * 
		 */				
		//PreviewJPG (function 229)
		//GlobalManager.Instance.serviceMGR.previewJPG(xxxResult, xxxFault, xxx);
		public function previewJPG(success:Function, fault:Function, imgBuffer:ByteArray, ftBuffer:ByteArray):void
		{
			var atObj:AsyncToken = webService.PreviewJPG(imgBuffer, ftBuffer);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * loadCurtainProjectBuffer 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param projectCode:String
		 * @param mainClothCode:Stirng
		 * 
		 */		
		//LoadCurtainProjectBuffer (function 233)
		//GlobalManager.Instance.serviceMGR.loadCurtainProjectBuffer(xxxResult, xxxFault, xxx);
		public function loadCurtainProjectBuffer(success:Function, fault:Function, projectCode:String, mainClothCode:String):void
		{
			var atObj:AsyncToken = webService.LoadCurtainProjectBuffer(projectCode, mainClothCode);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * SearchCurtainProjectXMLFromProjectName 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param projectName:String
		 * 
		 */		
		//SearchCurtainProjectXMLFromProjectName (function 237)
		//GlobalManager.Instance.serviceMGR.searchCurtainProjectXMLFromProjectName(xxxResult, xxxFault, xxx);
		public function searchCurtainProjectXMLFromProjectName(success:Function, fault:Function, projectName:String):void
		{
			var atObj:AsyncToken = webService.SearchCurtainProjectXMLFromProjectName(projectName);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * SearchCurtainProjectXMLFromMainClothName 方法
		 * 
		 * @param success:Function
		 * @param fault:Function 
		 * @param mainClothName:String
		 * 
		 */		
		//SearchCurtainProjectXMLFromMainClothName (function 239)
		//GlobalManager.Instance.serviceMGR.searchCurtainProjectXMLFromMainClothName(xxxResult, xxxFault, xxx);
		public function searchCurtainProjectXMLFromMainClothName(success:Function, fault:Function, mainClothName:String):void
		{
			var atObj:AsyncToken = webService.SearchCurtainProjectXMLFromMainClothName(mainClothName);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * LoadCurtainProjectDataBuffer 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param url:Stirng
		 * 
		 */		
		//LoadCurtainProjectDataBuffer (function 243)
		//GlobalManager.Instance.serviceMGR.loadCurtainProjectDataBuffer(xxxResult, xxxFault, xxx);
		public function loadCurtainProjectDataBuffer(success:Function, fault:Function, url:String, type:int = 1):void
		{
			var listener:ListenerExtend = new ListenerExtend();
			var atObj:AsyncToken = webService.LoadCurtainProjectDataBuffer(url);
			var rpObj:Responder = responder(listener.concat(loadCurtainProjectDataBufferResult,success,type), fault);
			atObj.addResponder(rpObj);
		}
		
		private function loadCurtainProjectDataBufferResult(reObj:ResultEvent,success:Function,type:int):void
		{
			var buffer:ByteArray=reObj.result as ByteArray;
			if (buffer != null && buffer.length > 0) {
				var projectCode:String = loadCurtainProjectDataBufferReadString(buffer);
				var projectName:String = loadCurtainProjectDataBufferReadString(buffer);
				var mainClothCode:String = loadCurtainProjectDataBufferReadString(buffer);
				
				if(mainClothCode == null || mainClothCode.length == 0 || !L3DLibraryWebService.WebServiceEnable)
				{	
					return;
				}
				
//				var loadingMaterial:L3DMaterialInformations = new L3DMaterialInformations();
//				loadingMaterial.addEventListener(L3DLibraryEvent.DownloadMaterialInfo, SearchMaterialInfoHandler);
//				//type： 0：全图 1：100 2：200 3：None
//				loadingMaterial.SearchMaterialInformation(mainClothCode,1);
				
				
//				searchCode = code;
//				searchType = type;
//				var atObj:AsyncToken = L3DLibraryWebService.LibraryService.GetViewDetailBufferFromCode(mainClothCode, type);
//				var rpObj:mx.rpc.Responder = new mx.rpc.Responder(SearchMaterialInformationResult, SearchMaterialInformationFault);
//				atObj.addResponder(rpObj);
				
				//lrj 2017/12/8 
				var listener:ListenerExtend = new ListenerExtend();
				GlobalManager.Instance.serviceMGR.getViewDetailBufferFromCode(listener.concat(loadCurtainProjectDataBufferSearchResult,success,mainClothCode,type), listener.concat(loadCurtainProjectDataBufferSearchFault,mainClothCode, type), mainClothCode, type);
			}
		}
		
		private function loadCurtainProjectDataBufferSearchResult(reObj:ResultEvent,success:Function,code:String,type:int):void
		{
			var buffer:ByteArray = reObj.result as ByteArray;
			//如果存在
			if(buffer != null && buffer.length > 0)
			{
				var information:L3DMaterialInformations = new L3DMaterialInformations(buffer, "");				
				if(success!=null)
				{
					success(information.name,information.previewBuffer);
				}
			}
			//如果不存在
			else
			{
//				var atObj:AsyncToken = L3DLibraryWebService.LibraryService.GetUserSpaceViewDetailBufferFromCode(L3DLibrary.L3DLibrary.sceneUserCode, searchCode, searchType);
//				var rpObj:mx.rpc.Responder = new mx.rpc.Responder(SearchUserSpaceMaterialInformationResult, SearchUserSpaceMaterialInformationFault);
//				atObj.addResponder(rpObj);
				
				//lrj 2017/12/8 
				var listener:ListenerExtend = new ListenerExtend();
//				GlobalManager.Instance.serviceMGR.getUserSpaceViewDetailBufferFromCode(listener.concat(searchUserSpaceMaterialInformationResult,success), searchUserSpaceMaterialInformationFault, L3DLibrary.L3DLibrary.sceneUserCode, code, type);
			}			
		}			
		
		private function loadCurtainProjectDataBufferSearchFault(feObj:FaultEvent,success:Function,code:String,type:int):void
		{
//			var atObj:AsyncToken = L3DLibraryWebService.LibraryService.GetUserSpaceViewDetailBufferFromCode(L3DLibrary.L3DLibrary.sceneUserCode, searchCode, searchType);
//			var rpObj:mx.rpc.Responder = new mx.rpc.Responder(SearchUserSpaceMaterialInformationResult, SearchUserSpaceMaterialInformationFault);
//			atObj.addResponder(rpObj);
			
			//lrj 2017/12/8 
			var listener:ListenerExtend = new ListenerExtend();
//			GlobalManager.Instance.serviceMGR.getUserSpaceViewDetailBufferFromCode(listener.concat(searchUserSpaceMaterialInformationResult,success), searchUserSpaceMaterialInformationFault, L3DLibrary.L3DLibrary.sceneUserCode, code, type);
			
			//	var event:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.DownloadMaterialInfo);
			//	event.MaterialInformation = null;
			//	dispatchEvent(event);
		}
		
		private function searchUserSpaceMaterialInformationResult(reObj:ResultEvent,success:Function):void
		{
			var buffer:ByteArray = reObj.result as ByteArray;
			if(buffer != null && buffer.length > 0)
			{
				var information:L3DMaterialInformations = new L3DMaterialInformations(buffer, "");	
				if(success!=null)
				{
					success(information.name,information.previewBuffer);
				}
			}
		}			
		
		private function searchUserSpaceMaterialInformationFault(feObj:FaultEvent):void
		{
			
		}
		
		private function loadCurtainProjectDataBufferReadString(buffer:ByteArray):String
		{
			if(buffer == null)
			{
				return "";
			}
			
			var length:int = buffer.readInt();
			if(length == 0)
			{
				return "";
			}
			
			var textBuffer:ByteArray = new ByteArray();
			buffer.readBytes(textBuffer,0,length);
			textBuffer.position = 0;
			
			return textBuffer.readUTFBytes(textBuffer.length);
		}
		
		/**
		 * GetAllUniqueCurtainProjectXML 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * 
		 */		
		//GetAllUniqueCurtainProjectXML (function 247)
		//GlobalManager.Instance.serviceMGR.getAllUniqueCurtainProjectXML(xxxResult, xxxFault);
//		public function getAllUniqueCurtainProjectXML(success:Function, fault:Function):void
//		{
//			var brandIndex:int = L3DLibrary.L3DLibrary.CurtainBrandIndex;
//			var atObj:AsyncToken = webService.GetAllUniqueCurtainProjectXML(brandIndex);
//			var rpObj:Responder = responder(success, fault);
//			atObj.addResponder(rpObj);
//		}
		
		/**
		 * GetCurtainProjectXMLFromProjectCode 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param projectCode:String
		 * 
		 */		
		//GetCurtainProjectXMLFromProjectCode (function 251)
		//GlobalManager.Instance.serviceMGR.getCurtainProjectXMLFromProjectCode(xxxResult, xxxFault, xxx);
		public function getCurtainProjectXMLFromProjectCode(success:Function, fault:Function, projectCode:String):void
		{
			var atObj:AsyncToken = webService.GetCurtainProjectXMLFromProjectCode(projectCode);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * GetCurtainProjectXMLFromMainClothCode 方法
		 * 
		 * @param success:Funciton
		 * @param fault:Function
		 * @param mainClothCode:String
		 * 
		 */		
		//GetCurtainProjectXMLFromMainClothCode (function 253)
		//GlobalManager.Instance.serviceMGR.getCurtainProjectXMLFromMainClothCode(xxxResult, xxxFault, xxx);
		public function getCurtainProjectXMLFromMainClothCode(success:Function, fault:Function, mainClothCode:String):void
		{
			var atObj:AsyncToken = webService.GetCurtainProjectXMLFromMainClothCode(mainClothCode);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * DownloadCurtainMaterialsRootNodeXML 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * 
		 */		
		//DownloadCurtainMaterialsRootNodeXML (function 257)
		//GlobalManager.Instance.serviceMGR.downloadCurtainMaterialsRootNodeXML(xxxResult, xxxFault);
//		public function downloadCurtainMaterialsRootNodeXML(success:Function, fault:Function):void
//		{
//			var brandIndex:int = L3DLibrary.L3DLibrary.CurtainBrandIndex;
//			var atObj:AsyncToken = webService.DownloadCurtainMaterialsRootNodeXML(brandIndex);
//			var rpObj:Responder = responder(success, fault);
//			atObj.addResponder(rpObj);
//		}
		
		/**
		 * GetAllCurtainCombinesBuffer 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * 
		 */		
		//GetAllCurtainCombinesBuffer (function 262)
		//GlobalManager.Instance.serviceMGR.getAllCurtainCombinesBuffer(xxxResult, xxxFault, xxx);
//		public function getAllCurtainCombinesBuffer(success:Function, fault:Function):void
//		{
//			var brandIndex:int = L3DLibrary.L3DLibrary.CurtainBrandIndex;
//			var atObj:AsyncToken = webService.GetAllCurtainCombinesBuffer(brandIndex);
//			var rpObj:Responder = responder(success, fault);
//			atObj.addResponder(rpObj);
//		}
		
		/**
		 * Upload 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param buffer:ByteArray
		 * @param filename:String
		 * 
		 */		
		//Upload (function 266)
		//GlobalManager.Instance.serviceMGR.upload(xxxResult, xxxFault, xxx);
		public function upload(success:Function, fault:Function, buffer:ByteArray, filename:String):void
		{
			var atObj:AsyncToken = webService.Upload(buffer, filename);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * Download 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param filename:String
		 * 
		 */		
		//Download (function 268)
		//GlobalManager.Instance.serviceMGR.download(xxxResult, xxxFault, xxx);
		public function download(success:Function, fault:Function, filename:String):void
		{
			var atObj:AsyncToken = webService.Download(filename);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * DownloadRootNodeXML 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * 
		 */		
		//DownloadRootNodeXML (function 278)
		//GlobalManager.Instance.serviceMGR.downloadRootNodeXML(xxxResult, xxxFault);
		public function downloadRootNodeXML(success:Function, fault:Function):void
		{
			var atObj:AsyncToken = webService.DownloadRootNodeXML();
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * DownloadUserSpaceMaterialsURLXML 方法
		 * 
		 * @param success:Funciton
		 * @param fault:Function
		 * @param userCode:String
		 * @param nodeName:String
		 * 
		 */		
		//DownloadUserSpaceMaterialsURLXML (function 286)
		//GlobalManager.Instance.serviceMGR.downloadUserSpaceMaterialsURLXML(xxxResult, xxxFault, xxx);
		public function downloadUserSpaceMaterialsURLXML(success:Function, fault:Function, userCode:String, nodeName:String):void
		{
			var atObj:AsyncToken = webService.DownloadUserSpaceMaterialsURLXML(userCode, nodeName);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * UploadUserSpaceMaterial 方法
		 * 
		 * 传满参数时为上传砖、拼花（图片）
		 * 传四个参数时为上传模型
		 * @param success
		 * @param fault
		 * @param userCode
		 * @param buffer
		 * @param code
		 * @param name
		 * @param brand
		 * @param spec
		 * @param mode
		 * @param family
		 * @param nodeName
		 * @param xml
		 * 
		 */		
		//UploadUserSpaceMaterial (function 292)
		//GlobalManager.Instance.serviceMGR.uploadUserSpaceMaterial(xxxResult, xxxFault, xxx);
		public function uploadUserSpaceMaterial(success:Function, fault:Function, userCode:String, buffer:ByteArray, code:String, name:String, brand:String, spec:String, mode:int, family:String, nodeName:String, xml:String):void
		{
			var atObj:AsyncToken = webService.UploadUserSpaceMaterial(userCode, buffer, code, name, brand, spec, mode, family, nodeName, xml);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * RemoveUserSpaceMaterial 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param userCode:String
		 * @param code:String
		 * @param nodeName:String
		 * 
		 */		
		//RemoveUserSpaceMaterial (function 296)
		//GlobalManager.Instance.serviceMGR.removeUserSpaceMaterial(xxxResult, xxxFault, xxx);
		public function removeUserSpaceMaterial(success:Function, fault:Function, userCode:String, code:String, nodeName:String):void
		{
			var atObj:AsyncToken = webService.RemoveUserSpaceMaterial(userCode, code, nodeName);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * 通过节点ID下载url列表
		 * @param success:Function
		 * @param fault:Function
		 * @param nodeName:String
		 */		
		//DownloadNodeURLXML (function 300)
		//GlobalManager.Instance.serviceMGR.downloadNodeURLXML(xxxResult, xxxFault, xxx);
		public function downloadNodeURLXML(success:Function, fault:Function, nodeName:String):void
		{
			var atObj:AsyncToken = webService.DownloadNodeURLXML(nodeName);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * 通过URL下载材质
		 * @param success
		 * @param fault
		 * @param url 材质的地址
		 * @param type 0-全图 1-100px*100px 2-200px*200px 3-None
		 */		
		//DownloadMaterialDetailBuffer (function 308)
		//GlobalManager.Instance.serviceMGR.downloadMaterialDetailBuffer(xxxResult, xxxFault, xxx);
		public function downloadMaterialDetailBuffer(success:Function, fault:Function, url:String, type:int):void
		{
			var atObj:AsyncToken = webService.DownloadMaterialDetailBuffer(url, type);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * 通过材质code下载材质
		 * @param success:Function
		 * @param fault:Function
		 * @param code:Stirng
		 * @param type:int
		 */		
		//GetViewDetailBufferFromCode (function 312)
		//GlobalManager.Instance.serviceMGR.getViewDetailBufferFromCode(xxxResult, xxxFault, xxx);
		public function getViewDetailBufferFromCode(success:Function, fault:Function, code:String, type:int):void
		{
			var atObj:AsyncToken = webService.GetViewDetailBufferFromCode(code, type);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * GetUserSpaceViewDetailBufferFromCode 方法
		 * 
		 * @param success:Funciton
		 * @param fault:Function
		 * @param userCode:String
		 * @param code:String
		 * @param type:int
		 * 
		 */		
		//GetUserSpaceViewDetailBufferFromCode (function 314)
		//GlobalManager.Instance.serviceMGR.getUserSpaceViewDetailBufferFromCode(xxxResult, xxxFault, xxx);
		public function getUserSpaceViewDetailBufferFromCode(success:Function, fault:Function, userCode:String, code:String, type:int):void
		{
			var atObj:AsyncToken = webService.GetUserSpaceViewDetailBufferFromCode(userCode, code, type);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * SearchMaterialViewDetailBufferPro 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param text:Stirng
		 * @param mode:int
		 * @param type:int
		 * @param catalog:int
		 * @param pid:String
		 * 
		 */		
		//SearchMaterialViewDetailBufferPro (function 328)
		//GlobalManager.Instance.serviceMGR.searchMaterialViewDetailBufferPro(xxxResult, xxxFault, xxx);
		public function searchMaterialViewDetailBufferPro(success:Function, fault:Function, text:String, mode:int, type:int, catalog:int, pid:String):void
		{
			var atObj:AsyncToken = webService.SearchMaterialViewDetailBufferPro(text, mode, type, catalog, pid);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 *	有一个调用参数不匹配 
		 * @param success
		 * @param fault
		 * @param text
		 * @param mode
		 * @param type
		 * 
		 */		
		//SearchMaterialViewDetailBuffer (function 330)
		//GlobalManager.Instance.serviceMGR.searchMaterialViewDetailBuffer(xxxResult, xxxFault, xxx);
		public function searchMaterialViewDetailBuffer(success:Function, fault:Function, text:String, mode:int, type:int):void
		{
			var atObj:AsyncToken = webService.SearchMaterialViewDetailBuffer(text, mode, type);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * SearchUserSpaceMaterialViewDetailBuffer 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param userCode:String
		 * @param code:String
		 * @param type:int
		 * 
		 */		
		//SearchUserSpaceMaterialViewDetailBuffer (function 332)
		//GlobalManager.Instance.serviceMGR.searchUserSpaceMaterialViewDetailBuffer(xxxResult, xxxFault, xxx);
		public function searchUserSpaceMaterialViewDetailBuffer(success:Function, fault:Function, userCode:String, code:String, type:int):void
		{
			var atObj:AsyncToken = webService.SearchUserSpaceMaterialViewDetailBuffer(userCode, code, type);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * SearchRoomViewDetailBuffer 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param text:String
		 * 
		 */		
		//SearchRoomViewDetailBuffer (function 336)
		//GlobalManager.Instance.serviceMGR.searchRoomViewDetailBuffer(xxxResult, xxxFault, xxx);
		public function searchRoomViewDetailBuffer(success:Function, fault:Function, text:String):void
		{
			var atObj:AsyncToken = webService.SearchRoomViewDetailBuffer(text);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * 下载商品对应的场景顶视图数据
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param url:String
		 * 
		 */		
		//DownloadMaterialTopviewBuffer (function 338)
		//GlobalManager.Instance.serviceMGR.downloadMaterialTopviewBuffer(xxxResult, xxxFault, xxx);
		public function downloadMaterialTopviewBuffer(success:Function, fault:Function, url:String):void
		{
			var atObj:AsyncToken = webService.DownloadMaterialTopviewBuffer(url);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * 
		 * @param success
		 * @param fault
		 * @param buffer
		 * @param code
		 * @param name
		 * @param brand
		 * @param spec
		 * @param mode
		 * @param family String 改为 int?
		 * @param nodeName
		 * @param xml
		 * 
		 */		
		//UploadUserMaterial (functoion 346)
		//GlobalManager.Instance.serviceMGR.uploadUserMaterial(xxxResult, xxxFault, xxx);
		public function uploadUserMaterial(success:Function, fault:Function, buffer:ByteArray, code:String, name:String, brand:String, spec:String, mode:int, family:String, nodeName:String, xml:String):void
		{
			var atObj:AsyncToken = webService.UploadUserMaterial(buffer, code, name, brand, spec, mode, family, nodeName, xml);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * DownloadMaterial 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param url:Stirng
		 * 
		 */		
		//DownloadMaterial (function 350)
		//GlobalManager.Instance.serviceMGR.downloadMaterial(xxxResult, xxxFault, xxx);
		public function downloadMaterial(success:Function, fault:Function, url:String):void
		{
			var atObj:AsyncToken = webService.DownloadMaterial(url);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * LoadRoom 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param buffer:ByteArray
		 * 
		 */		
		//LoadRoom (function 358)
		//GlobalManager.Instance.serviceMGR.loadRoom(xxxResult, xxxFault, xxx);
		public function loadRoom(success:Function, fault:Function, buffer:ByteArray):void
		{
			var atObj:AsyncToken = webService.LoadRoom(buffer);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * ExportWorkingDraw 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param xmlContent:String
		 * 
		 */		
		//ExportWorkingDraw (function 362)
		//GlobalManager.Instance.serviceMGR.exportWorkingDraw(xxxResult, xxxFault, xxx);
		public function exportWorkingDraw(success:Function, fault:Function, xmlContent:String):void
		{
			var atObj:AsyncToken = webService.ExportWorkingDraw(xmlContent);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * ExportMosaic 方法
		 * 
		 * @param success:Funciton
		 * @param fault:Function
		 * @param xmlContent:String
		 * 
		 */		
		//ExportMosaic (function 364)
		//GlobalManager.Instance.serviceMGR.exportMosaic(xxxResult, xxxFault, xxx);
		public function exportMosaic(success:Function, fault:Function, xmlContent:String):void
		{
			var atObj:AsyncToken = webService.ExportMosaic(xmlContent);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * ToItemsXML方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param sceneCode:String有一个调用没传参数
		 * 
		 */		
		//ToItemsXML (function 370)
		//GlobalManager.Instance.serviceMGR.toItemsXML(xxxResult, xxxFault, xxx);
		public function toItemsXML(success:Function, fault:Function, sceneCode:String=""):void
		{
			var atObj:AsyncToken = webService.ToItemsXML(sceneCode);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * GetLinkedProjectDetailXML方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param code:String
		 * @param projectPlace:String
		 * @param roomName:String
		 * @param comboName:String
		 * 
		 */		
		//GetLinkedProjectDetailXML (function 372)
		//GlobalManager.Instance.serviceMGR.getLinkedProjectDetailXML(xxxResult, xxxFault, xxx);
		public function getLinkedProjectDetailXML(success:Function, fault:Function, code:String, projectPlace:String, roomName:String, comboName:String):void
		{
			var atObj:AsyncToken = webService.GetLinkedProjectDetailXML(code, projectPlace, roomName, comboName);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * GetRelativeProjectDetailXML 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param name:Stirng
		 * @param projectPlace:String
		 * @param roomName:String
		 * @param comboName:String
		 * 
		 */		
		//GetRelativeProjectDetailXML (function 374)
		//GlobalManager.Instance.serviceMGR.getRelativeProjectDetailXML(xxxResult, xxxFault, xxx);
		public function getRelativeProjectDetailXML(success:Function, fault:Function, name:String, projectPlace:String, roomName:String, comboName:String):void
		{
			var atObj:AsyncToken = webService.GetRelativeProjectDetailXML(name, projectPlace, roomName, comboName);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * SearchProjectDetailXMLFromProjectCode方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param code:String
		 * 
		 */		
		//SearchProjectDetailXMLFromProjectCode (function 376)
		//GlobalManager.Instance.serviceMGR.searchProjectDetailXMLFromProjectCode(xxxResult, xxxFault, xxx);
		public function searchProjectDetailXMLFromProjectCode(success:Function, fault:Function, code:String):void
		{
			var atObj:AsyncToken = webService.xxx(code);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * GetSystemProjectDetailsXML 方法
		 * 
		 * @param success:Function
		 * @param fault:Functionb
		 * @param comboName:String
		 * 
		 */		
		//GetSystemProjectDetailsXML (function 378)
		//GlobalManager.Instance.serviceMGR.getSystemProjectDetailsXML(xxxResult, xxxFault, xxx);
		public function getSystemProjectDetailsXML(success:Function, fault:Function, comboName:String):void
		{
			var atObj:AsyncToken = webService.GetSystemProjectDetailsXML(comboName);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * GetExtendProjectDetailsXML 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param roomName:String
		 * @param comboName:String
		 * @param keyWord:String
		 * 
		 */		
		//GetExtendProjectDetailsXML (function 380)
		//GlobalManager.Instance.serviceMGR.getExtendProjectDetailsXML(xxxResult, xxxFault, xxx);
		public function getExtendProjectDetailsXML(success:Function, fault:Function, roomName:String, comboName:String, keyWord:String):void
		{
			var atObj:AsyncToken = webService.GetExtendProjectDetailsXML(roomName, comboName, keyWord);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * DownloadRemoteCustomerDatasXML 方法
		 * 
		 * @param success:Function
		 * @param fault:Funcrion
		 * @param phaseStatus:int
		 * 
		 */		
		//DownloadRemoteCustomerDatasXML (function 390)
		//GlobalManager.Instance.serviceMGR.downloadRemoteCustomerDatasXML(xxxResult, xxxFault, xxx);
		public function downloadRemoteCustomerDatasXML(success:Function, fault:Function, phaseStatus:int):void
		{
			var atObj:AsyncToken = webService.DownloadRemoteCustomerDatasXML(phaseStatus);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * GetUniqueID 方法
		 * 
		 * @param success:Function
		 * @param fault:Function 
		 * 
		 */		
		//GetUniqueID (function 392)
		//GlobalManager.Instance.serviceMGR.getUniqueID(xxxResult, xxxFault);
		public function getUniqueID(success:Function, fault:Function):void
		{
			var atObj:AsyncToken = webService.GetUniqueID();
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * 普通登陆方法
		 * @param success:Function
		 * @param fault:Function
		 * @param name:String
		 * @param password:String
		 */		
		//LoginUser (function 410)
		//GlobalManager.Instance.serviceMGR.loginUser(xxxResult, xxxFault, xxx);
		public function loginUser(success:Function, fault:Function, name:String, password:String):void
		{
			var atObj:AsyncToken = webService.LoginUser(name, password);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * 特殊登陆方法（金意陶）
		 * 
		 * @param success:Funciton
		 * @param fault:Function
		 * @param name:String
		 * @param password:String
		 * @param company:String
		 * @param mobileMode:Boolean
		 * 
		 */		
		//LoginFromCustomSystem (function 414)
		//GlobalManager.Instance.serviceMGR.loginFromCustomSystem(xxxResult, xxxFault, xxx);
		public function loginFromCustomSystem(success:Function, fault:Function, name:String, password:String, company:String, mobileMode:Boolean):void
		{
			var atObj:AsyncToken = webService.LoginFromCustomSystem(name, password, company, mobileMode);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * GetUserLoginTime 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param userName:String
		 * 
		 */		
		//GetUserLoginTime (function 420)
		//GlobalManager.Instance.serviceMGR.getUserLoginTime(xxxResult, xxxFault, xxx);
		public function getUserLoginTime(success:Function, fault:Function, userName:String):void
		{
			var atObj:AsyncToken = webService.GetUserLoginTime(userName);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * RegisterUser 方法
		 * 
		 * @param success:Function
		 * @param fault:Function 
		 * @param buffer:ByteArray
		 * 
		 */		
		//RegisterUser (function 422)
		//GlobalManager.Instance.serviceMGR.registerUser(xxxResult, xxxFault, xxx);
		public function registerUser(success:Function, fault:Function, buffer:ByteArray):void
		{
			var atObj:AsyncToken = webService.RegisterUser(buffer);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * GetUserInfo 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param userName:String
		 * @param passWord:String
		 * 
		 */		
		//GetUserInfo (function 426)
		//GlobalManager.Instance.serviceMGR.getUserInfo(xxxResult, xxxFault, xxx);
		public function getUserInfo(success:Function, fault:Function, userName:String, passWord:String):void
		{
			var atObj:AsyncToken = webService.GetUserInfo(userName, passWord);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		/**
		 * GetUserInfoFromCustomSystem 方法
		 * 
		 * @param success:Function
		 * @param fault:Function
		 * @param name:String
		 * @param password:String
		 * @param company:String
		 * 
		 */		
		//GetUserInfoFromCustomSystem (function 428)
		//GlobalManager.Instance.serviceMGR.getUserInfoFromCustomSystem(xxxResult, xxxFault, xxx);
		public function getUserInfoFromCustomSystem(success:Function, fault:Function, name:String, password:String, company:String):void
		{
			var atObj:AsyncToken = webService.GetUserInfoFromCustomSystem(name, password, company);
			var rpObj:Responder = responder(success, fault);
			atObj.addResponder(rpObj);
		}
		
		
		
		//import utils.lx.managers.GlobalManager;
		
		//invoke
		//GlobalManager.Instance.serviceMGR.xxx(xxxResult, xxxFault, xxx);
		
		//template
		/*
		public function xxxx(success:Function, fault:Function, xxx):void
		{
		var atObj:AsyncToken = webService.xxx(xxx);
		var rpObj:Responder = responder(success, fault);
		atObj.addResponder(rpObj);
		}
		*/	
	}
}