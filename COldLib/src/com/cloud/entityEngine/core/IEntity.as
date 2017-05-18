package com.cloud.entityEngine.core
{
	/**
	 *  实体接口
	 * @author cloud
	 * 
	 */	
	internal interface IEntity
	{
		/**
		 * 添加属性 
		 * @param nstr	属性名
		 * @param value	属性值
		 * 
		 */		
		function addProperty(nstr:String,value:*):void;
		/**
		 * 获取属性 
		 * @param nstr	属性名
		 * @return *
		 * 
		 */		
		function getProperty(nstr:String):*;
		/**
		 * 添加组件 
		 * @param nstr	组件名
		 * @param component	组件实例
		 * 
		 */		
		function addComponent(nstr:String,component:Component):void;
		/**
		 * 更新实体 
		 * 
		 */
		function update():void;
	}
}