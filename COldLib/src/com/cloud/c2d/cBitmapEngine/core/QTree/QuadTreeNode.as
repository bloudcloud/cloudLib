package com.cloud.c2d.cBitmapEngine.core.QTree
{
	import flash.geom.Rectangle;

	/**
	 * Classname : public class QuadTreeNode
	 * 
	 * Date : 2013-10-18
	 * 
	 * author :cloud
	 * 
	 * company :青岛羽翎珊动漫科技有限公司
	 */
	/**
	 * 实现功能: 四叉树节点
	 * 
	 */
	public class QuadTreeNode
	{
		/**
		 * 节点存储的最大对象数量 
		 */		
		private static var _MAX_OBJECTS:int = 10;
		/**
		 * 节点的最大深度 
		 */		
		private static var _MAX_LEVELS:int = 5;
		/**
		 * 节点的深度 
		 */		
		private var _level:int;
		/**
		 * 节点存储的对象数组 
		 */		
		private var _objects:Array;
		/**
		 * 节点数组 
		 */		
		private var _nodes:Vector.<QuadTreeNode>;
		/**
		 * 父节点 
		 */		
		private var _parentNode:QuadTreeNode;		
		/**
		 * 节点范围 
		 */		
		private var _bound:NodeRect;
		/**
		 * 范围的中点x坐标 
		 */		
		private var _xMidPoint:Number;
		/**
		 * 范围的中点y坐标 
		 */		
		private var _yMidPoint:Number;
		/**
		 * 节点的所属象限索引
		 */		
		private var _index:int;
		/**
		 * 是否属于顶部区域 
		 */		
		private var _isTopQuad:Boolean;
		/**
		 * 是否属于底部区域 
		 */		
		private var _isBottomQuad:Boolean;
		/**
		 * 是否属于左侧区域 
		 */		
		private var _isLeftQuad:Boolean;
		/**
		 * 是否属于右侧区域 
		 */		
		private var _isRightQuad:Boolean;
		/**
		 * 构造四叉树节点 
		 * @param level		节点深度
		 * @param bound		节点所属范围
		 * @param parent		父节点
		 * @param index		节点所属象限索引
		 * 
		 */		
		public function QuadTreeNode($level:int, $bound:NodeRect, $parentNode:QuadTreeNode = null, $index:int = -1)
		{
			_level = $level;
			_bound = $bound;
			_parentNode = $parentNode;
			_index = $index;
			_xMidPoint = _bound.x + _bound.width * .5;
			_yMidPoint = _bound.y + _bound.height * .5;
			_objects = [];
			_nodes = new Vector.<QuadTreeNode>(4);
			
			setQuadrant();
		}
		/**
		 * 设置节点所属区域 
		 * 
		 */		
		private function setQuadrant():void
		{
			if(_parentNode)
			{
				if(_index == 0)
				{
					_isTopQuad = true;
					_isRightQuad = true;
				}
				else if(_index == 1)
				{
					_isTopQuad = true;
					_isLeftQuad = true;
				}
				else if(_index == 2)
				{
					_isBottomQuad = true;
					_isLeftQuad = true;
				}
				else if(_index == 3)
				{
					_isBottomQuad = true;
					_isRightQuad = true;
				}
			}
		}
	}
}