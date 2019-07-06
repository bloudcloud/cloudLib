package clapboardCode.models
{
	/**
	 *不同版本板件名字配置 
	 * @author Debugger
	 * 
	 */	
	public class WallBoardConfig
	{
		public static const MAIN_BOARD:String = "main_board";//主板
		public static const TOP_BOARD:String = "top_board";//顶线
		public static const BOTTOM_BOARD:String = "bottom_board";//地线
		public static const BELT_BOARD:String = "belt_Board";//腰线
		public static const LINE_BOARD:String = "line_board";//嵌板线
		public static const CORNER_BOARD:String = "corner_board";//绞花
		public static const ADD_BOARD:String = "add_board";//添加部件
		public static const CHANGE_BOARD_COLOR:String = "change_board_color";//更换色板
		public static const SOLUTION_PLAN:String = "solution_plan";//添加方案
		/**
		 *根据名字判断对应的功能模块 
		 * @param name
		 * @return 
		 * 
		 */
		public static function getBoardSetFunc(name:String):String
		{
			var type:String;
			switch(name)
			{
				case "定制":
					type = WallBoardConfig.ADD_BOARD;
					break;
				case "石材":
				case "色卡":
					type = WallBoardConfig.CHANGE_BOARD_COLOR;
					break;
				case "方案":
					type = WallBoardConfig.SOLUTION_PLAN;
					break;
				case "面板":
					type = WallBoardConfig.MAIN_BOARD;
					break;
			}
			return type;
		}
		/**
		 *根据名字判断对应添加的部件 
		 * @param name
		 * @return 
		 * 
		 */		
		public static function getWallBoardType(name:String):String
		{
			var type:String;
			switch(name)
			{
				case "面板":
					type = WallBoardConfig.MAIN_BOARD;
					break;
				case "地脚线":
				case "踢脚线":
					type = WallBoardConfig.BOTTOM_BOARD;
					break;
				case "腰线":
				case "中线":
					type = WallBoardConfig.BELT_BOARD;
					break;
				case "顶线":
					type = WallBoardConfig.TOP_BOARD;
					break;
				case "嵌板线":
				case "线条":
				case "边线":
					type = WallBoardConfig.LINE_BOARD;
					break;
				case "角花":
					type = WallBoardConfig.CORNER_BOARD;
					break;
				default:
					type = WallBoardConfig.MAIN_BOARD;
					break;
			}
			return type;
		}
	}
}