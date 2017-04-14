package com.chunbai.model.observer.example3
{
	import flash.display.Sprite;
	import flash.text.TextField;

	public class AsGriphics
	{
		private static var _instance:AsGriphics;
		
		private var _qiya:TextField;
		private var _shidu:TextField;
		private var _wendu:TextField;
		private var _sprite:Sprite;
		
		public function AsGriphics()
		{
			_qiya = new TextField();
			_shidu = new TextField();
			_wendu = new TextField();
			
			_sprite = new Sprite();
			_sprite.graphics.beginFill(0xFF0000, 1);
			_sprite.graphics.drawCircle(50, 50, 10);
			_sprite.graphics.endFill();
		}
		
		public static function get instance():AsGriphics
		{
		    if(_instance == null)
			{
				_instance = new AsGriphics();
			}
			return _instance;
		}
		
		public function get qiya():TextField
		{
		    return _qiya;
		}
		
		public function get shidu():TextField
		{
			return _shidu;
		}
		
		public function get wendu():TextField
		{
			return _wendu;
		}
		
		public function get sprite():Sprite
		{
			return _sprite;
		}
		
	}
}