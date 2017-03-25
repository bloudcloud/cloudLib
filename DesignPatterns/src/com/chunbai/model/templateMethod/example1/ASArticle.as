package com.chunbai.model.templateMethod.example1
{
	public class ASArticle extends ArticleTemplate
	{
		private var title:String = "as爱";
		private var author:String = "麦肯as";
		private var content:String = "as爱的具体内容";
		
		public function ASArticle()
		{
			
		}
		
		public override function createTitle():void
		{
			trace("创建as爱文章标题: " + this.title);
		}
		
		public override function createAuthor():void
		{
			trace("创建as爱文章作者: " + this.author);
		}
		
		public override function createContent():void
		{
			trace("创建as爱文章内容: " + this.content);
		}
		
		public override function publish():void
		{
			trace("as爱文章发布成功\r");
		}
		
	}    
}
