package extension.lrj.dict
{
	public class UIConstDict
	{
		public static const FLOOR_TILE:int = 1;//地砖
		public static const WALL_TILE:int = 2;//墙砖
		public static const FREE_TILE:int = 3;//自由铺
		public static const PARQUET:int = 4;//水刀拼花
		public static const WEATHERBOARDING:int = 5;//护墙板
		public static const BACKGROUND_WALL:int = 6;//背景墙
		public static const DOOR_WINDOW_DESIGN:int = 7; //门窗定制
		public static const WARDROBE_DESIGN:int = 8;//衣柜定制
		public static const KITCHEN_CABINET_DESIGN:int = 9;//橱柜定制
		public static const SETUP_OBJECT:int = 10;//物体
		public static const SETUP_FLOOR:int = 11;//地面
		public static const SETUP_WALL_FACE:int = 12;//墙面
		public static const SETUP_TOP:int = 13;//顶面
		public static const SETUP_TIAN:int = 14;//天
		public static const SETUP_MEN_KAN_SHI:int = 15;//门槛石
		public static const SETUP_TI:int = 16;//踢脚线
		public static const SETUP_CURTAIN:int = 17;//窗帘
		public static const SETUP_CEILING:int = 18;//吊顶
		public static const CASE_LIBRARY:int = 31;//方案库
		public static const ACCESSORIES_LIBRARY:int = 32;//配饰库
		public static const DOOR:int = 33;//门
		public static const WINDOW:int = 34;//窗
		/**
		 * 自由模型表面的砖块类型 
		 */		
		public static const FREE_SURFACETILE:int = 35;	
		/**
		 * 组合飘窗类型 
		 */		
		public static const BAY_WINDOW_COMBINE:int = 36;
		/**
		 * UI世界类型:打开功能模块界面 飘窗
		 */		
		public static const UIEVENT_OPENMODULE:String="UIEvent_OpenModule";
		/**
		 * 护墙板V形功能弹条
		 */		
		public static const VTYPE_POPBAR:int = 1;
		/**
		 * 斜墙角度功能弹条
		 */		
		public static const OBLIQUEWALL_POPBAR:int=2;
		
		/**
		 * 打开弹出条 
		 */		
		public static const UIEVENT_OPENPOPBAR:String="UIEvent_OpenPopBar";
		
		/**
		 * 打开、添加到舞台上
		 */
		public static const POPUP_OPEN:String = "PopUp_Open";
		
		/**
		 *  
		 */		
		public static const RIGHTMENU_LIBRARY:String = "RightMenu_Library";
		
		/**
		 *  
		 */		
		public static const RIGHTMENU_HANDLER:String = "RightMenu_Handler";
		
		/**
		 * 
		 */		
		public static const RIGHTMENU_CHANGE:String = "RightMenu_Change";
		
		/**
		 *  
		 */		
		public static const DOORWINDOW_BYWINDOW:String = "DoorWindow_ByWindow";
		
//		阳光房右边框打开门窗定制界面
		/**
		 * 
		 */		
		public static const OPEN_WINDOWSDOORMENU:String = "open_WindowsDoorMenu";
		
		/**
		 * 传mesh 
		 */		
		public static const SETBALCONYMESH:String = "SETBALCONYMESH";
		
		/**
		 * 传预览图  
		 */		
		public static const SHOWBIT:String = "SHOWBIT";
		
		/**
		 * 阳光房中间图片
		 */		
		public static const SUNROOMROOFCENTER_IMG:String = "setIMG"; 
		
		/**
		 * 封阳台中间图片 
		 */		
		public static const BALCONYCENTER_IMG:String = "BALCONYCENTER_IMG";
		
		/**
		 * 阳光房 封阳台 缩放 
		 */		
		public static const VIEW_ON_SIZE:String = "View_On_Size";
		
		/**
		 *  
		 */		
		public static const OPEN_TOOL_BAR:String = "open_Tool_Bar";
		
		/**
		 * 在阳光房或者封阳台关闭参数化窗
		 */		
		public static const CLOSE_PARAMWINDOW_IN_SUNROOM_BALCONY:String = "CLOSE_PARAMWINDOW_IN_SUNROOM_BALCONY";
		
		/**
		 * 阳光房打开弹出条
		 */
		public static const OPEN_SUNROOM_BAR:String = "open_Sunroom_Bar";

		/**
		 * 阳光房转角柱弹出条
		 */
		public static const OPEN_SUNROOM_DELETE_BAR:String = "open_Sunroom_Delete_Bar";
		
		/**
		 * 墙砖腰线
		 */
		public static const WALL_WAIST_LINE:String = "wall_Waist_Line";
		
		/**
		 * 定制门窗门把手
		 */
		public static const LOCK_HANDLE_BAR:String = "lock_Handle_Bar";
		
		/**
		 * 定制门窗转角料
		 */
		public static const CORNER_MC_BAR:String = "corner_MC_Bar";
		
		/**
		 * 本地保存
		 */
		public static const SAVE_EVENT:String = "save_Event";
//		public static const FREE_MODELING:String = "free_Modeling";	
		 
		/**
		 * 打开建模界面 
		 */		
		public static const ONOPEN_MODELING_VIEW:String = "On_Open_Modeling_View";
		
		/**
		 * 建模向右边框设置数据 
		 */		
		public static const FREE_MODELING_SETDATA:String = "free_Modeling_SetData";
		
		/**
		 * 建模得到右边框数据 
		 */		
		public static const FREE_MODELING_GETDATA:String = "free_Modeling_GetData";
		
		/**
		 * 自由建模尺寸
		 */		
		public static const FREE_MODELING_SIZE:String = "Free_Modeling_Size";
		
		/**
		 *	自由建模预览  
		 */		
		public static const FREE_MOELING_PREVIEW:String = "free_Modeling_Preview";
		
		/**
		 * 自由建模复制 
		 */		
		public static const FREE_MOELING_COPY:String = "free_Modeling_Copy";
		
		/**
		 * 自由建模右边框点击item 
		 */		
		public static const FREE_MOELING_ADDITEM:String = "free_Modeling_AddItem";
	
		/**
		 * 自由建模删除 
		 */		
		public static const FREE_MOELING_DELETE:String = "free_Modeling_Delete";
		
		/**
		 * 自由建模确定 
		 */		
		public static const FREE_MOELING_ENSURE:String = "free_Modeling_Ensure";
		
		/**
		 * 自由建模关闭 
		 */		
		public static const FREE_MOELING_CLOSE:String = "free_Modeling_Close";
		
		/**
		 * 右边框点击水刀拼花时打开左边面板(地砖墙砖右边框中)
		 */		
		public static const OPEN_WATERJET_PANEL:String = "open_WaterJet_Panel";
		
		/**
		 * 跳转到2d状态 
		 */		
		public static const CHANGE_TO_2D:String = "change_To_2D";
		
		/**
		 * 跳转到25d状态 
		 */		
		public static const CHANGE_TO_25D:String = "change_To_25";
		
		/**
		 *  跳转到3d状态
		 */		
		public static const CHANGE_TO_30D:String = "change_To_30";
		
		/**
		 * 
		 */		
		public static const POPUP_DOORWINDOW_BYWINDOW:String = "popUp_DoorWindow_ByWindow";
		
		/**
		 *自由铺关闭 
		 */
		public static const POPUP_FREETILEVIEW:String = "popUp_FreeTileView";
		
		/**
		 * 隐藏/显现弹出条
		 */
		public static const POPUP_HIDEORSHOW:String = "popUp_HideOrShow";
		
		/**
		 * 
		 */		
		public static const OPEN_SAVEBAR_EVENT:String = "Open_SaveBar_Event";
		
		/**
		 * 
		 */		
		public static const CLOSE_POPUPBAR:String = "close_PopUpBar";
		
		/**
		 * 
		 */		
		public static const MODELING_RAILING_EVENT:String = "modeling_Railing_Event";
		
		/**
		 * 墙砖区域砖
		 */
		public static const POPUP_WALLEDIT:String = "popUp_WallEdit";
		
		/**
		 * 单砖功能
		 */
		public static const DANZHUAN_TYPE:String = "danZhuan_Type"; 
		
		/**
		 * 水刀拼花 尺寸 
		 */		
		public static const SET_WATERJECT_SIZE:String = "Set_WaterJet_Size";
		
		/**
		 *  水刀拼花上传
		 */		
		public static const WATERJETMEDALLION_UPLOAD:String = "WaterJetMedallion_Upload";
		
		/**
		 * 保存默认名
		 */
		public static const POPUPSAVENAME:String = "PopUpSaveName";
		
		/**
		 * TipsToolView确定 
		 */		
		public static const TIPSVIEW_CONFIRM:String = "TipView_Confirm";
		
		/**
		 * 视角：左视
		 */		
		public static const VISUAL_LEFT:String = "Visual_Left";
		
		/**
		 * 视角：右视
		 */		
		public static const VISUAL_RIGHT:String = "Visual_Right";
		
		/**
		 * 视角：顶视
		 */		
		public static const VISUAL_TOP:String = "Visual_Top";
		
		/**
		 * 视角：俯视
		 */		
		public static const VISUAL_BOTTOM:String = "Visual_Bottom";
		
		/**
		 * 视角：复原 
		 */		
		public static const VISUAL_ORIGIN:String = "Visual_Origin";

		/**
		 *  视角：添加
		 */		
		public static const VISUAL_ADD:String = "Visual_Add";
		
		/**
		 * 视角：关闭 
		 */		
		public static const VISUAL_CLOSE:String = "Viual_Close";
		
		/**
		 * 添加场景后更新右边框 
		 */		
		public static const VISUAL_UPDATE:String = "Visual_Update";
		
		/**
		 * 视角右边框item点击 
		 */		
		public static const VISUAL_ITEM_CLICK:String = "Visual_Item_Click";
		
		/**
		 * 视角右边框item删除 
		 */		
		public static const VISUAL_ITEM_DELETE:String = "Visual_Item_Delete";
		
		public static const ROOF_TYPE:String = "Roof_Type";
		/**
		 * 基座
		 */
		public static const POPUP_BOTTOM:String = "PopUp_Bottom";
		/**
		 * 定制门窗护栏
		 */
		public static const POPUP_RAILING:String = "PopUp_Railing";
		/**
		 * 提示弹出条
		 */
		public static const TIPS_TOOLVIEW:String = "Tips_ToolView";
		
		/**
		 * 右边框打开/关闭时设置底边条的宽度 
		 */		
		public static const SET_BOTTOMBAR_WIDTH:String = "set_BottomBar_Width";
		
		/**
		 * 登录前点击更新说明打开更新说明 
		 */		
		public static const OPEN_UPDATE_VIEW:String = "open_Update_View";
		
		/**
		 * 打开预览界面 
		 */		
		public static const OPEN_PREVIEW_VIEW:String = "open_Preview_View";
		
		/**
		 * 关闭预览界面 
		 */		
		public static const CLOSE_PREVIEW_VIEW:String = "close_Preview_View";
		/**
		 * 预览界面剖面展示按钮 
		 */		
		public static const SHOW_PROFILE_VIEW:String = "show_Profile_View";
		
		/**
		 * 保存xml 
		 */		
		public static const XML_SAVE:String = "xml_Save";
		
		/**
		 * 打开房型界面 
		 */		
		public static const OPEN_HOMETYPE:String = "open_Home_Type";
		
		/**
		 * 关闭房型界面 
		 */		
		public static const CLOSE_HOMETYPE:String = "close_Home_Type";
		
		/**
		 * 房型界面 选择
		 */		
		public static const SELECT_HOMRTYPE:String = "select_Home_Type";
		
		/**
		 * 打开界面进行导入时点确定
		 */		
		public static const IMPORT_CLOSE_OPENVIEW:String = "close_OpenView";
		
		/**
		 * 户型生成房间 完毕 
		 */		
		public static const HOMECREATE_COMPLETE:String = "homeCreate_Complete";
		
		/**
		 * 开始设置主墙起始点和终点 
		 */		
		public static const LAYOUTMANAGER_INITCOMPLETE:String = "LayoutManager_InitComplete";
		
		/**
		 * 2D点击出图户型绘制完成 
		 */		
		public static const ON_2D_PRINTING:String = "On_2D_Printing";
		
		/**
		 * 分层界面需要打开 通知门窗准备数据 
		 */		
		public static const NOTIFICATION_LAYERINGVIEW_OPEN:String = "Notification_LayeringView_Open";
		
		/**
		 * 打开定制门窗分层界面
		 */		
		public static const ON_OPEN_LAYERINGVIEW:String = "On_Open_LayeringView";
		
		/**
		 * 更新分层界面图片 
		 */		
		public static const UPDATE_LAYERINGVIEW:String = "update_LayeringView";
		
		/**
		 * 关闭定制门窗分层界面
		 */		
		public static const ON_CLOSE_LAYERINGVIEW:String = "On_Close_LayeringView";
		
		/**
		 * 切角弹出条 
		 */		
		public static const ON_EDIT_CHAMFER:String = "on_Edit_Chamfer";
		
		public static const ON_EDIT_SUNROOM:String = "on_Edit_Sunroom";
		
		public static const ON_EDIT_BALCONY:String = "on_Edit_Balcony";
		
		public static const ON_EDIT_BAYWINDOW:String = "on_Edit_BayWindow";
		
		/**
		 *  
		 */		
		public static const BOTTOM_VILLA_OFFGROUND_EVENT:String = "bottom_Villa_OffGround_Event";
		
		public static const GET_VILLAFACADE_POPUPBARDATA_EVENT:String = "get_VillaFacade_PopupBarData_Event";
	
	}
}