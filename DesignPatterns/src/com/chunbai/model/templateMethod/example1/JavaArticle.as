package com.chunbai.model.templateMethod.example1
{
	public class JavaArticle extends ArticleTemplate
	{
		private var title:String = "java你好";
		private var author:String = "绝影java";
		private var content:String = "java你好的文章内容";
		
		public function JavaArticle()
		{
			
		}
		
		public override function createTitle():void
		{
			trace("创建java文章标题: " + this.title);
		}
		
		public override function createAuthor():void
		{
			trace("创建java文章作者: " + this.author);
		}
		
		public override function createContent():void
		{
			trace("创建java文章内容: " + this.content);
		}
		
		public override function publish():void
		{
			trace("java文章发布成功\r");
		}
		
	}    
}
