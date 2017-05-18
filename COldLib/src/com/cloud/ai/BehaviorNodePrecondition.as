package com.cloud.ai
{
	/**
	 * ClassName: package com.cloud.ai::BehaviorNodePrecondition
	 *
	 * Intro:	行为树节点的条件类
	 *
	 * @date: 2014-7-15
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer14
	 * @sdkVersion: AIR14.0
	 */
	public class BehaviorNodePrecondition
	{
		
		public function BehaviorNodePrecondition()
		{
			
		}
		
		public function externalCondition(input:BehaviorNodeInputParam):Boolean
		{
			return false;
		}
	}
}