package com.chunbai.model.templateMethod.example1
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 抽象类
	 * */
	public class ArticleTemplate
	{
		public function ArticleTemplate()
		{
			//保证抽象类不被直接实例化
			if(getDefinitionByName(getQualifiedClassName(this)) == ArticleTemplate)
			{
				throw new Error("Abstract Method, Can't Be Instantiated!");
			}
		}
		
		/**
		 * 模板方法 Template Method，使用final关键字保证不被子类覆盖
		 * */
		public final function create():void
		{
			createTitle();
			createAuthor();
			createContent();
			publish();
		}
		
		/**
		 * (抽象方法)创建标题
		 * */
		public function createTitle():void
		{
			throw new Error("Abstract Method, Only For Override!");
		}
		
		/**
		 * (抽象方法)创建作者
		 * */
		public function createAuthor():void
		{
			throw new Error("Abstract Method, Only For Override!");
		}
		
		/**
		 * (抽象方法)创建内容
		 * */
		public function createContent():void
		{
			throw new Error("Abstract Method, Only For Override!");
		}
		
		/**
		 * (抽象方法)发布文章
		 * */
		public function publish():void
		{
			throw new Error("Abstract Method, Only For Override!");
		}
		
	}    
}
