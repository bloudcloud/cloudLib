package utils.extend
{
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.resources.Geometry;
	
	public class IsoscelesTriangle extends Mesh
	{
		public function IsoscelesTriangle(radian:Number=Math.PI/2, height:Number=100, top:Material=null, bottom:Material=null)
		{
			geometry = new Geometry();
			var attributes:Array = new Array();
			attributes[0] = VertexAttributes.POSITION;
			attributes[1] = VertexAttributes.POSITION;
			attributes[2] = VertexAttributes.POSITION;
			attributes[3] = VertexAttributes.TEXCOORDS[0];
			attributes[4] = VertexAttributes.TEXCOORDS[0];
			attributes[5] = VertexAttributes.NORMAL;
			attributes[6] = VertexAttributes.NORMAL;
			attributes[7] = VertexAttributes.NORMAL;
			geometry.addVertexStream(attributes);
			var vertices:Array = [0,0,0,
				height, -Math.tan(radian/2)*height, 0,
				height, Math.tan(radian/2)*height, 0,
				0,0,0,
				height, Math.tan(radian/2)*height, 0,
				height, -Math.tan(radian/2)*height, 0];
			geometry.numVertices = vertices.length/3;
			geometry.setAttributeValues(VertexAttributes.POSITION, Vector.<Number>(vertices));
			geometry.indices = Vector.<uint>([0, 1, 2, 0, 2, 1]);
			this.addSurface(top, 0, 1);
			this.addSurface(bottom, 3, 1);
			this.calculateBoundBox();
		}
	}
}