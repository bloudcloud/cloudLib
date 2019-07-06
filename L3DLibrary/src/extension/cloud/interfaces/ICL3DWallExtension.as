package extension.cloud.interfaces
{
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	/**
	 * 业务墙体扩展
	 * @author	cloud
	 * @date	2018-7-6
	 */
	public interface ICL3DWallExtension
	{
		/**
		 * 获取该墙体是否属于有效墙体 
		 * @return Boolean
		 * 
		 */		
		function get Exist():Boolean;
		/**
		 * 获取所在房间的ID 
		 * @return String
		 * 
		 */		
		function get roomID():String;
		/**
		 * 获取墙体数据ID 
		 * @return String
		 * 
		 */		
		function get wallID():String;
		/**
		 * 设置墙体ID 
		 * @param value
		 * 
		 */		
		function set wallID(value:String):void;
		/**
		 *  获取相连的同房间内墙体对象集合
		 * @return Vector.<ICL3DWallExtension>
		 * 
		 */		
		function get innerConnectWalls():Vector.<ICL3DWallExtension>;
		/**
		 * 设置相连的同房间内墙体对象集合
		 * @param value
		 * 
		 */		
		function set innerConnectWalls(value:Vector.<ICL3DWallExtension>):void;
		/**
		 * 获取相连的同房间外墙体对象集合
		 * @return Vector.<ICL3DWallExtension>
		 * 
		 */		
		function get outterConnectWalls():Vector.<ICL3DWallExtension>;
		/**
		 * 设置相连的同房间外墙体对象集合 
		 * @param value
		 * @return Vector.<ICL3DWallExtension>
		 * 
		 */		
		function set outterConnectWalls(value:Vector.<ICL3DWallExtension>):void;
		/**
		 * 获取墙体顶面围点集合 
		 * @return Vector.<Vector3D>
		 * 
		 */		
		function get topRoundPoints():Vector.<Vector3D>;
		/**
		 * 获取墙体内围点集合 
		 * @return Vector3D
		 * 
		 */		
		function get innerRoundPoints():Vector.<Vector3D>;
		/**
		 * 设置墙体内围点集合 
		 * @param value
		 * 
		 */		
		function set innerRoundPoints(value:Vector.<Vector3D>):void;
		/**
		 *  获取墙体外围点集合
		 * @return Vector.<Vector3D>
		 * 
		 */		
		function get outterRoundPoints():Vector.<Vector3D>;
		/**
		 * 设置墙体外围点集合 
		 * @param value
		 * 
		 */		
		function set outterRoundPoints(value:Vector.<Vector3D>):void;
		/**
		 * 获取与起点相连的墙体对象
		 * @return Vector.<ICL3DWallExtension>
		 * 
		 */		
		function get prevWall():ICL3DWallExtension;
		/**
		 * 设置与起点相连的墙体对象集合 
		 * @param value 
		 * 
		 */		
		function set prevWall(value:ICL3DWallExtension):void;
		/**
		 * 获取与终点相连的墙体对象
		 * @return ICL3DWallExtension
		 * 
		 */		
		function get nextWall():ICL3DWallExtension;
		/**
		 * 设置与终点相连的墙体对象
		 * @param value 
		 * 
		 */		
		function set nextWall(value:ICL3DWallExtension):void;
		/**
		 * 获取墙中点坐标
		 * @return Vector3D
		 * 
		 */		
		function get Center():Vector3D;
		/**
		 * 获取墙厚度
		 * @return Number
		 * 
		 */		
		function get Thickness():Number;
		/**
		 * 设置墙的厚度
		 * @param value
		 * 
		 */		
		function set Thickness(value:Number):void;
		/**
		 * 墙的2D顶视围点坐标集合
		 * @return Vector.<Point>
		 * 
		 */		
		function get Points2D():Vector.<Point>;
		/**
		 * 获取墙体的高度
		 * @return Number
		 * 
		 */		
		function get wallHeight():Number;
		/**
		 *	设置墙体高度
		 * @param value
		 * 
		 */		
		function set wallHeight(value:Number):void;
		/**
		 * 获取是否是房间的外墙 
		 * @return Boolean
		 * 
		 */		
		function get isRoomOutterWall():Boolean;
		/**
		 * 设置是否是房间的外墙 
		 * @param value
		 * 
		 */		
		function set isRoomOutterWall(value:Boolean):void;
//		/**
//		 * 通过坐标值集合设置墙体的2D坐标点集（转换出的2D点集合属于旧墙体规则） 
//		 * @param point2Ds
//		 * 
//		 */		
//		function setPoint2DsByNumbers(point2Ds:Vector.<Number>):void;
		/**
		 * 获取起点3D坐标
		 * @return Vector3D
		 * 
		 */
		function get start3D():Vector3D;
		/**
		 * 设置起点3D坐标 
		 * @param value
		 * 
		 */		
		function set start3D(value:Vector3D):void;
		/**
		 * 获取终点3D坐标
		 * @return Vector3D
		 * 
		 */		
		function get end3D():Vector3D;
		/**
		 * 设置终点3D坐标 
		 * @param value
		 * 
		 */		
		function set end3D(value:Vector3D):void;
		/**
		 * 获取3D方向向量
		 * @return Vector3D
		 * 
		 */		
		function get direction3D():Vector3D;
		/**
		 * 获取3D法向向量
		 * @return Vector3D
		 * 
		 */		
		function get normal3D():Vector3D;
		/**
		 * 获取当前墙体是否属于共享墙体
		 * @return Boolean
		 * 
		 */		
		function get isShared():Boolean;
		/**
		 * 设置当前墙体是否属于共享墙体 
		 * @param value
		 * 
		 */		
		function set isShared(value:Boolean):void;
		/**
		 * 获取所属房间ID
		 * @return String
		 * 
		 */		
		function get ownerID():String;
		/**
		 * 设置所属房间的ID 
		 * @param value
		 * 
		 */		
		function set ownerID(value:String):void;
		/**
		 * 是否属于段墙 
		 * @return Boolean
		 * 
		 */		
		function get isBroken():Boolean;
		/**
		 * 获取是否是房间的围墙
		 * @return Boolean
		 * 
		 */		
		function get isRoomOutline():Boolean;
		/**
		 * 设置是否是房间的围墙 
		 * @param value 
		 * 
		 */		
		function set isRoomOutline(value:Boolean):void;
		/**
		 * 获取当前墙体是否有墙洞
		 * @return Boolean
		 * 
		 */		
		function get hasHole():Boolean;
		/**
		 * 更新墙体边缘点数据 
		 * 
		 */		
		function updateSidePoints():void;
		/**
		 * 更新顶面围点数据 
		 * 
		 */		
		function updateTopRoundPoints():void;
		/**
		 * 添加墙洞围点数据
		 * @param holePoints	墙洞围点坐标集合
		 * @param matrix		墙洞围点坐标系矩阵
		 * @param isInner	是否是内墙洞
		 * 
		 */		
		function addHole(hole3DPoints:Vector.<Number>,matrix:Matrix3D,isInner:Boolean):void;
		/**
		 * 根据两个端点数据确定墙洞，并移除对应墙洞围点数据集合
		 * @param pos1
		 * @param pos2
		 */		
		function removeHole(pos1:Vector3D,pos2:Vector3D):void;
		/**
		 * 获取墙洞的围点数据 
		 * @return Vector.<Number>
		 * 
		 */		
		function getHoles(isInner:Boolean):Array;
		/**
		 * 获取墙体线性变换矩阵
		 * @return Matrix3D
		 * 
		 */		
		function GetWallMatrix():Matrix3D;
		/**
		 * 销毁墙体数据
		 */		
		function dispose():void;
	}
}