package com.chunbai.model.iterator.example1
{
	public class Main1
	{
		public function Main1()
		{
			var arrayCollection:ArrayCollection = new ArrayCollection();
			arrayCollection.addElement("欧冠比赛");
			arrayCollection.addElement("巴塞罗那");
			arrayCollection.addElement("AC米兰");
			var arrayIterator:IIterator = arrayCollection.iterator(ArrayCollection.ARRAYITERATOR);
			while(arrayIterator.hasNext())
			{
			    trace(arrayIterator.next());
			}
		}
		
	}
}