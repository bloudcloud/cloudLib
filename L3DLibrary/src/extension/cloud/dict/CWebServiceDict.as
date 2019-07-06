package extension.cloud.dict
{
	/**
	 * web服务接口方法定义类
	 * @author cloud
	 */
	public class CWebServiceDict
	{
		/**
		 * 发送注册用户信息请求 参数：0.用户注册信息Object
		 */		
		public static const REQUEST_REGISTER_USER:String="RegisterUser";
		/**
		 * 发送登录请求 参数：0.用户名String	1.密码String
		 */		
		public static const REQUEST_LOGIN_USER:String = "LoginUser";
		/**
		 * 发送获取默认放样型材的请求 参数：0.品牌名称
		 */		
		public static const REQUEST_TOITEMSXML:String="ToItemsXML";
		/**
		 * 发送下载商品中的链接数据请求 参数： 0.商品的链接数据的URL
		 */		
		public static const REQUEST_DOWNLOAD:String = "Download";
		/**
		 * 发送计算投影图片转换围点数据的请求 参数:0.投影位图字节流对象
		 */		
		public static const REQUEST_COMPUABNORMALXMLDATA:String="CompuAbnormalXmlData";
		/**
		 *  发送下载用户自定义材质的路径XML数据的请求	参数：0.用户code	1.节点名称
		 */		
		public static const REQUEST_DOWNLOAD_USERSPACE_MATERIALS_URLXML:String="DownloadUserSpaceMaterialsURLXML";
		/**
		 *  发送下载资源（图片，模型等）的请求      参数: 0.下载路径
		 */		
		public static const REQUEST_DOWNLOADMATERIAL:String="DownloadMaterial";
		/**
		 *  发送通过code下载商品信息的请求请求    参数: 0.searchCode 1.type
		 */		
		public static const REQUEST_GETVIEWDETAILBUFFERFROMCODE:String="GetViewDetailBufferFromCode";
		/**
		 *  发送通过url下载商品信息的请求    参数: 0.url 1.type 0-全图 1-100px*100px 2-200px*200px 3-None
		 */		
		public static const REQUEST_DOWNLOADMATERIALDETAILBUFFER:String="DownloadMaterialDetailBuffer";
		/**
		 *  发送请求下载商品对应的场景顶视图数据    参数: 0.url 
		 */		
		public static const REQUEST_DOWNLOADMATERIALTOPVIEWBUFFER:String="DownloadMaterialTopviewBuffer";
		/**
		 *  发送请求下载用户文件目录xml    参数: 0.filename 
		 */		
		public static const REQUEST_DOWNLOADUSERFILECONTENTSXML:String="DownloadUserFileContentsXML";
		/**
		 *  发送请求getUserSpaceViewDetailBufferFromCode    参数: 0.userCode 1.code 2.type 
		 */		
		public static const REQUEST_GETUSERSPACEVIEWDETAILBUFFERFROMCODE:String="GetUserSpaceViewDetailBufferFromCode";
		/**
		 *  发送请求searchMaterialViewDetailBufferPro    参数: 0.text 1.mode 2.type 3.catalog 4.pid
		 */		
		public static const REQUEST_SEARCHMATERIALVIEWDETAILBUFFERPRO:String="SearchMaterialViewDetailBufferProII";
		
		/**
		 *  右边框发送请求searchMaterialViewDetailBufferPro    参数: 0.text 1.mode 2.type 3.catalog 4.pid
		 */		
		public static const REQUEST_RIGHTMRNUSEARCHMATERIALVIEWDETAILBUFFERPRO:String="SearchMaterialViewDetailBufferProIII";
		
		/**
		 *  发送请求searchUserSpaceMaterialViewDetailBuffer    参数: 0.userCode 1.code 2.type
		 */		
		public static const REQUEST_SEARCHUSERSPACEMATERIALVIEWDETAILBUFFER:String="SearchUserSpaceMaterialViewDetailBuffer";
		
		/**
		 *  发送请求更新用户密码    参数: 0.用户输入  1.旧密码  2.新密码
		 */		
		public static const REQUEST_UPDATEUSERPASSWORD:String = "UpdateUserPassWord";
		
		/**
		 *  发送请求发送密码到用户手机    参数: 0.手机号码
		 */		
		public static const REQUEST_SENDPASSWORDMESSAGETOUSERPHONE:String = "SendPassWordMessageToUserPhone";
		
		/**
		 *  发送请求loadCurtainProjectBuffer    参数: 0.projectCode 1.mainClothCode
		 */		
		public static const REQUEST_LOADCURTAINPROJECTBUFFER:String = "LoadCurtainProjectBuffer";
		
		/**
		 *  发送请求insertExcelData    参数: 0.fileName 1.sheetIndex 2.json
		 */		
		public static const REQUEST_INSERTEXCELDATA:String = "InsertExcelData";
		
		/**
		 *  发送请求searchCurtainProjectXMLFromProjectName    参数: 0.projectName
		 */		
		public static const REQUEST_SEARCHCURTAINPROJECTXMLFROMPROJECTNAME:String = "SearchCurtainProjectXMLFromProjectName";
		
		/**
		 *  发送请求LoadCurtainProjectDataBuffer    参数: 0.url 1.type
		 */		
		public static const REQUEST_LOADCURTAINPROJECTDATABUFFER:String = "LoadCurtainProjectDataBuffer";
		
	 	
		public function CWebServiceDict()
		{
		}
	}
}