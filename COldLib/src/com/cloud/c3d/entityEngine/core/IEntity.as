package com.cloud.c3d.entityEngine.core
{
	/**
	 * InterfaceName: package interfaces::IEntity
	 *
	 * Intro:	接口 IEntity
	 *
	 * @date: 2014-8-5
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer14
	 * @sdkVersion: AIR14.0
	 */
	public interface IEntity
	{
		/**
		 * 添加组件 
		 * @param component
		 * 
		 */		
		function addComponent(component:IComponent):void;
		/**
		 * 添加自定义属性 
		 * @param key	属性名
		 * @param value	属性值
		 * 
		 */		
		function addProperty(key:String,value:*):void;
		/**
		 * 获取自定义属性 
		 * @param key	属性名
		 * @return *
		 * 
		 */		
		function getProperty(key:String):*;
		/**
		 * 更新实体 
		 * 
		 */		
		function update():void;
	}
}