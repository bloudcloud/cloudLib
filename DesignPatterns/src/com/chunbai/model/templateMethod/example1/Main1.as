package com.chunbai.model.templateMethod.example1
{
	import flash.display.Sprite;
	
	public class Main1 extends Sprite
	{
		public function Main1()
		{
			var as_article:ArticleTemplate = new ASArticle();
			as_article.create();    //创建一篇as3文章
			
			var java_article:ArticleTemplate = new JavaArticle();
			java_article.create();    //创建一篇java文章
		}
		
	}
}
