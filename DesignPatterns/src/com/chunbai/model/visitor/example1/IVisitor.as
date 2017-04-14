package com.chunbai.model.visitor.example1
{
	
	/**
	 * 访问者角色接口
	 * */
	public interface IVisitor
	{
		function visit1($g:Gladiolus):void; 
		function visit2($r:Runuculus):void; 
		function visit3($c:Chrysanthemum):void;
		
	}
}