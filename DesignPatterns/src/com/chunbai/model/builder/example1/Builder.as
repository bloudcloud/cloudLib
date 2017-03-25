package com.chunbai.model.builder.example1
{
	public class Builder
	{
		private static var _builder:Builder = null;
		private var bmanager:BuilderManager;
		
		public function Builder()
		{
			bmanager = new BuilderManager();
		}
		
		public static function instance():Builder
		{
			if(_builder == null)
			{
				_builder = new Builder();
			}
			return _builder;
		}
		
		public function getFood(str:String):IBuilderFood
		{
			switch (str)
			{
				case "good":
					return bmanager.makeFood(new BuilderGoodFood);
					break;
				case "best":
					return bmanager.makeFood(new BuilderBestFood);
					break;
				default:
					break;
			}
			return null;
		}
		
	}
}