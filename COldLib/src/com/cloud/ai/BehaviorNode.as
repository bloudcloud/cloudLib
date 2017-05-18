package com.cloud.ai
{
	/**
	 * ClassName: package com.cloud.ai::BehaviorNode
	 *
	 * Intro:	行为树节点
	 *
	 * @date: 2014-7-15
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer14
	 * @sdkVersion: AIR14.0
	 */
	public class BehaviorNode
	{
		public static var CHILD_MAXNUM:int = 16;
		
		protected var _parentNode:BehaviorNode;
		protected var _childNodes:Vector.<BehaviorNode>;
		protected var _externalCondition:BehaviorNodePrecondition;
		
		public function BehaviorNode()
		{
			_childNodes = new Vector.<BehaviorNode>(CHILD_MAXNUM);
		}
		/**
		 * 执行内部条件判断 
		 * @param input	输入参数
		 * @return Boolean
		 * 
		 */		
		protected function doEvaluate(input:BehaviorNodeInputParam):Boolean
		{
			return true;
		}
		/**
		 * 外部条件判断 
		 * @param input	输入参数
		 * @return Boolean
		 * 
		 */		
		public function evaluate(input:BehaviorNodeInputParam):Boolean
		{
			return !_externalCondition || _externalCondition.externalCondition(input);
		}
	}
}