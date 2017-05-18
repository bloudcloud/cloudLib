package com.cloud.c2d.utils
{
	public interface IMap
	{
		function put(k:*,v:*):Object;
		function remove(k:*):Object;
		function clear():void;
	}
}