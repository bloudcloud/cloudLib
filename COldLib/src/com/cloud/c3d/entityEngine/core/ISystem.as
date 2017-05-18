package com.cloud.c3d.entityEngine.core
{
	/**
	 * InterfaceName: package interfaces::ISystem
	 *
	 * Intro:	接口 ISystem
	 *
	 * @date: 2014-8-5
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer14
	 * @sdkVersion: AIR14.0
	 */
	internal interface ISystem
	{
		/**
		 * 添加实体对象 
		 * @param entity
		 * 
		 */		
		function addEntity(entity:IEntity):void;
		/**
		 * 启动系统运行
		 * 
		 */		
		function start():void;
		/**
		 * 停止系统运行 
		 * 
		 */		 
		function stop():void;
		/**
		 * 系统实时更新 
		 * 
		 */		
		function update():void;
	}
}