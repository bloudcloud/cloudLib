package extension.wl.utils
{
	import flash.utils.ByteArray;

	public class ObjectUtils
	{
		public function ObjectUtils()
		{
			
		}
		/**
		 * object克隆
		 * @param source:Object 目标对象
		 * @return 克隆对象
		 * 
		 */		
		public static function clone(source:Object):*
		{
			var myBA:ByteArray=new ByteArray();
			myBA.writeObject(source);
			myBA.position=0;
			return (myBA.readObject());
		}
		/**
		 * json条件截取
		 * 按照keywords数组中的元素顺序，每次截取json对象的children节点数组中对象name为该元素的对象，作为新对象返回。直到keywords数组全部遍历或某个元素检索失败为止
		 * @param json:Object 目标json对象
		 * @param keywords:Array 检索条件数组，元素为纯字符串
		 * @return 条件检索后新的json对象
		 * 
		 */		
		public static function jsonSearchNode(json:Object, keywords:Array):Object
		{
			var key:String=keywords.shift();
			
			if (json.name == key )
			{
				if (json.children.length > 0 && keywords.length > 0)
				{
					json=jsonSearchNode(json, keywords);
					return json;
				}
			}
			
			for (var i:int=0; i < json.children.length; i++)
			{
				var obj:Object = json.children[i];
				if(obj == null)
				{
					continue;
				}
				if (obj.name == key)
				{
					json=json.children[i];
					if (json.children.length > 0 && keywords.length > 0)
						json=jsonSearchNode(json, keywords);
					break;
				}
			}
			return json;
		}
		/**
		 * @param xml
		 * @param attribute
		 * @param index
		 * @param keywords
		 * @return newXML
		 */
		public static function xmlSearchNode(xml:XML, attribute:String, keywords:Array, index:int=0):XML
		{
			const key:String=attribute;
			if (index <= keywords.length - 1)
			{
				xml=xml.children().(@[key] == keywords[index])[0];
				if (xml != null)
				{
					xml=xmlSearchNode(xml, attribute, keywords, index + 1);
				}
				else
				{
					return null;
				}
			}
			else
			{
				return xml;
			}
			return xml;
		}
		/**
		 * json条件节点删除
		 * @param json
		 * @param excludeKeys
		 * @return 
		 * 
		 */		
		public static function jsonDeleteNode(json:Object, keywords:Array):Object
		{
			var keyLen:int = keywords.length;
			var children:Array = json.children as Array;
			for (var i:int=0; i < keyLen; i++)
			{
				var key:String = keywords[i];
				var childLen:int = children.length;
				for (var j:int=0; j < childLen; j++)
				{
					if (children[j].name == key)
					{
						children.removeAt(j);
						break;
					}
				}
			}
			return json;
		}
		
		/**
		 * 删除不需要显示的数据：isNotShow为1的节点
		 * @param json:Object
		 * 
		 */		
		public static function jsonRemoveNotShow(json:Object):void
		{
			var childLen:int = json.children.length;
		
			if(childLen == 0 || json.isNotShow == "1")
			{
				return;
			}
			
			var arr:Array = [];
			for(var i:int = 0; i < childLen; i++)
			{
				if(json.children[i].isNotShow == "1")	
				{
					arr.push(json.children[i].name);
				}
				else
				{
					jsonRemoveNotShow(json.children[i])
				}
			}
			
			json = jsonDeleteNode(json, arr);
		}
		
	}
}