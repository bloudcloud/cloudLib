package com.chunbai.model.abstractFactory.example2
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;

	public class Main2 extends Sprite
	{
		private var _xmlReader:XmlReader;
		
		public function Main2()
		{
			_xmlReader = new XmlReader("D:/works/svn/first/code/client/workspace/ZzModel/src/com/chunbai/model/AbstractFactory/example2/test.xml");
			this.addEventListener(Event.ENTER_FRAME, readXmlData);
		}
		
		private function readXmlData(event:Event):void
		{
			if(_xmlReader.success)
			{
				var pa:ProductA;
				var pb:ProductB;
			    var xmlData:XML = _xmlReader.xmlData;
				var reflectFactory:ReflectFactory = new ReflectFactory();
				var n:int = xmlData.product.length();
				for(var i:int = 0; i < n; i++)
				{
				    var TempClass:Class = getDefinitionByName(xmlData.product[i].@className) as Class;
					var product:IProduct = new TempClass() as IProduct;
					reflectFactory.setProduct(product);
					reflectFactory.createProduct().doTask();
				}
				this.removeEventListener(Event.ENTER_FRAME, readXmlData);
			}
		}
		
	}
}