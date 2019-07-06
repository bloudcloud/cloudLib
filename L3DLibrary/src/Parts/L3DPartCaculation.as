package Parts 
{
	import flash.display.BitmapData;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import L3DLibrary.L3DLibraryEvent;
	import L3DLibrary.L3DMaterialInformations;
	
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.materials.LightMapMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.resources.TextureResource;
	
	public class L3DPartCaculation extends EventDispatcher
	{	
		private var windowLength:int = 2200;
		private var windowHeight:int = 2800;
		private var partCode:String = "";
		private var dataURL:String = "";
		private var x:Number = 0;
		private var y:Number = 0;
		private var z:Number = 0;
		private var width:int = 50;
		private var height:int = 50;
		private var deltaX:int = 0;
		private var deltaY:int = 0;
		private var heightRatio:Number = 0.23;
		private var widthDivision:Number = 3.0;
		private var sideOffDistance:int = 150;
		private var topOffDistance:int = 200;
		private var widthDelta:int = 0;
		private var heightDelta:int = 0;
		private var layer:int = 0;
		private var maxWidth:int = 4500;
		private var minWdith:int = 0;
		private var maxHeight:int = 4000;
		private var minHeight:int = 0;
		private var isWanlian:Boolean = false;
		private var wanlianMaxWidth:int = 2000;
		private var arrayMode:int = L3DPartArrayMode.None;
		private var adhereToPartCode:String = "";
		private var maxWanlianWidth:int = 2000;
		private var minWindowLength:int = 1500;
		private var maxWindowLength:int = 6000;
		private var minWindowHeight:int = 2000;
		private var maxWindowHeight:int = 4500;
		private var partMesh:L3DMesh = null;
		private var arrayPartIDs:Vector.<String> = new Vector.<String>();
		private var combinedMesh:L3DMesh = null;
	    private var isArraiedPart:Boolean = false;
		private var isMirrored:Boolean = false;
		private var isKeepSizeArrayMode:Boolean = false;
		private var isSpaceArrayMode:Boolean = false;	    	
		private var arraySpace:int = 0;
		private var arrayCount:int = 0;
		private var actuallyArrayCount:int = 0;
		private var materialCode:String = "";
		private var materialSize:String = "";
		private var wanlianDelta:int = 0;
		private static var scale2D:Number = 0.25;
		private static var thicknessScale:Number = 1;
		private static var maxThickness:Number = 200;
		private static var maxLianshenWidth:int = 1200;
		private var stage3D:Stage3D = null;
	//	private var module:L3DPartCaculation = null;
		private var module:L3DPartsModule = null;
		private var loadCompleteFun:Function = null;
		private var hadMadeCombintion:Boolean = false;
	//	private var currentCompuSubsetIndex:int = 0;
		private var checkPartCode:String = "";
		private var loadMaterialCodes:Vector.<String> = new Vector.<String>();
		private var loadMaterialSizes:Vector.<String> = new Vector.<String>();
		private var loadMaterialSubsetNames:Vector.<String> = new Vector.<String>();
		private var dynamicCode:String = "";
		private var dynamicName:String = "";
		private var dynamicURL:String = "";
		private var hadSearchedPartCode:Boolean = false;
		private static const DownloadDataURLBuffer:String = "DownloadDataURLBuffer";
		
		public function L3DPartCaculation(partMesh:L3DMesh, combinedMesh:L3DMesh)
		{
			CombinedMesh = combinedMesh;	
			PartMesh = partMesh;
		}
		
		public function get Exist():Boolean
		{
			return partMesh != null && partCode != null && partCode.length > 0;
		}
		
		public function get PartCode():String
		{
			return partCode;
		}
		
		public function set PartCode(v:String):void
		{
			partCode = v;
		}
		
		public function get WindowLength():int
		{
			return windowLength;
		}
		
		public function set WindowLength(v:int):void
		{
			windowLength = v;
		}
		
		public function get WindowHeight():int
		{
			return windowHeight;
		}
		
		public function set WindowHeight(v:int):void
		{
			windowHeight = v;
		}
		
		public function get MinWindowLength():int
		{
			return minWindowLength;
		}
		
		public function set MinWindowLength(v:int):void
		{
			minWindowLength = v;
		}
		
		public function get MaxWindowLength():int
		{
			return maxWindowLength;
		}
		
		public function set MaxWindowLength(v:int):void
		{
			maxWindowLength = v;
		}
		
		public function get MinWindowHeight():int
		{
			return minWindowHeight;
		}
		
		public function set MinWindowHeight(v:int):void
		{
			minWindowHeight = v;
		}
		
		public function get MaxWindowHeight():int
		{
			return maxWindowHeight;
		}
		
		public function set MaxWindowHeight(v:int):void
		{
			maxWindowHeight = v;
		}
		
		public function get PartMesh():L3DMesh
		{
			return partMesh;
		}
		
		public function set PartMesh(v:L3DMesh):void
		{
			partMesh = v;
			if(partMesh != null)
			{
				partCode = partMesh.Code;
				if(partCode == null)
				{
					partCode = partCode == null ? "" : partCode.toUpperCase();
				}
				partMesh.x = SideOffDistance + partMesh.Length / 2 - windowLength / 2;
				partMesh.y = 0;
				partMesh.z = TopOffDistance * -1;
				partMesh.layer = layer;
				if(combinedMesh != null && !combinedMesh.contains(partMesh))
				{
					combinedMesh.addChild(partMesh);
				}
			}
		}
		
		public function get CombinedMesh():L3DMesh
		{
			return combinedMesh;
		}
		
		public function set CombinedMesh(v:L3DMesh):void
		{
			combinedMesh = v;
		}
		
		public function get MaterialCode():String
		{
			return materialCode;
		}
		
		public function set MaterialCode(v:String):void
		{
			materialCode = v;
		}
		
		public function get MaterialSize():String
		{
			return materialSize;
		}
		
		public function set MaterialSize(v:String):void
		{
			materialSize = v;
		}
		
		public function get ArrayPartIDs():Vector.<String>
		{
			if(arrayPartIDs == null)
			{
				arrayPartIDs = new Vector.<String>();
			}
			return arrayPartIDs;
		}
		
		public function get HeightRatio():Number
		{
			return heightRatio;
		}
		
		public function set HeightRatio(v:Number):void
		{
			v = v < 0.01?0.01:(v > 1?1:v);
			heightRatio = v;
		}
		
		public function get X():int
		{
			return x;	
		}
		
		public function get Y():int
		{
			return y;	
		}
		
		public function get Z():int
		{
			return z;	
		}
		
		public function get DeltaX():int
		{
		    return deltaX;	
		}
		
		public function set DeltaX(v:int):void
		{
			deltaX = v;
		}
		
		public function get DeltaY():int
		{
			return deltaY;
		}
		
		public function set DeltaY(v:int):void
		{
			deltaY = v;
		}
		
		public function Amend():Boolean
		{
		    if(!Exist)
			{
				return false;
			}
			
			width = partMesh.Length;
			height = partMesh.Height;
			
			return true;
		}
		
		public function get Width():int
		{
			switch (arrayMode)
			{
				case L3DPartArrayMode.None:
				case L3DPartArrayMode.AutoArray:
				case L3DPartArrayMode.LeftLianshen:
				case L3DPartArrayMode.RightLianshen:
				case L3DPartArrayMode.BothSideLianshen:
				case L3DPartArrayMode.Attaching:
				case L3DPartArrayMode.Guagan:
				case L3DPartArrayMode.AutoSide:
				{
					return width;
				}
					break;
				default:
				{
					var w:Number = windowHeight * heightRatio / widthDivision + widthDelta;
					if (w < 0.01)
					{
						return 0.0;
					}						
					return w;
				}
					break;
			}
		}
		
		public function set Width(v:int):void
		{
			if(!Exist || isArraiedPart)
			{
				return;
			}
			
			v = v < 1 ? 1 : (v > 20000 ? 20000 : v);
			
			switch (arrayMode)
			{
				case L3DPartArrayMode.None:
				case L3DPartArrayMode.AutoArray:
				case L3DPartArrayMode.LeftLianshen:
				case L3DPartArrayMode.RightLianshen:
				case L3DPartArrayMode.BothSideLianshen:
				case L3DPartArrayMode.Attaching:
				case L3DPartArrayMode.Guagan:
				case L3DPartArrayMode.AutoSide:
				{
					width = v;
				}
					break;
				default:
				{
					widthDelta = v - (windowHeight * heightRatio / widthDivision);
					
					if(!isArraiedPart)
					{
						switch(arrayMode)
						{
							case L3DPartArrayMode.FullArray:
							{
								var count:int = ArrayCount;
								var arrayWidth:int = Width;
								var arrayHeight:int = Height;
								if(arrayWidth >= 10 && arrayHeight >= 10)
								{
									var arrayLength:Number = windowLength - sideOffDistance * 2;
									var length:Number = arrayLength / Number(count);
									var s:Number = Number(ArraySpace);
									if(length >= 10)
									{
										partMesh.x = sideOffDistance - windowLength / 2 + arrayWidth / 2;
										var x:Number = partMesh.x;
										for(var i:int = 0;i< ArrayPartIDs.length;i++)
										{
											var mesh:L3DMesh = null;
											var arrayPartID:String = ArrayPartIDs[i];
											if(arrayPartID != null && arrayPartID.length > 0)
											{										
												for(var j:int = 0;j<combinedMesh.numChildren;j++)
												{
													var subObject:Object3D = combinedMesh.getChildAt(j);
													if(subObject != null && subObject is L3DMesh)
													{
														if(arrayPartID == (subObject as L3DMesh).UniqueID)
														{
															mesh = subObject as L3DMesh;
															break;
														}
													}
												}
											}
											if(mesh != null)
											{
												x += (s + arrayWidth);
												mesh.x = x;
												mesh.y = partMesh.y;
												mesh.z = partMesh.z;
												mesh.scaleX = partMesh.scaleX;
												mesh.scaleY = partMesh.scaleY;
												mesh.scaleZ = partMesh.scaleZ;
											}
										}
									}
								}
							}
								break;
							case L3DPartArrayMode.SideArray:
							{
								var arrayWidth:int = Width;
								var arrayHeight:int = Height;
								if(arrayWidth >= 10 && arrayHeight >= 10)
								{
									partMesh.x = sideOffDistance - windowLength / 2 + arrayWidth / 2;
									for(var i:int = 0;i< ArrayPartIDs.length;i++)
									{
										var mesh:L3DMesh = null;
										var arrayPartID:String = ArrayPartIDs[i];
										if(arrayPartID != null && arrayPartID.length > 0)
										{										
											for(var j:int = 0;j<combinedMesh.numChildren;j++)
											{
												var subObject:Object3D = combinedMesh.getChildAt(j);
												if(subObject != null && subObject is L3DMesh)
												{
													if(arrayPartID == (subObject as L3DMesh).UniqueID)
													{
														mesh = subObject as L3DMesh;
														break;
													}
												}
											}
										}
										if(mesh != null)
										{
											mesh.x = windowLength / 2 - sideOffDistance - arrayWidth / 2;
											mesh.y = partMesh.y;
											mesh.z = partMesh.z;
											mesh.scaleX = partMesh.scaleX;
											mesh.scaleY = partMesh.scaleY;
											mesh.scaleZ = partMesh.scaleZ;
										}
									}
								}
							}
								break;
						}
					}
				}
					break;
			}
			
			PartMesh.Length = v;
			
			var leftX:Number = PartMesh.x - v / 2;
			var rightX:Number = PartMesh.x + v / 2;
			var topZ:Number = PartMesh.z;
			var bottomZ:Number = PartMesh.z - height;
			
			if(leftX < -windowLength / 2)
			{
				PartMesh.x = v / 2 - windowLength / 2;				
			}
			if(rightX > windowLength / 2)
			{
				PartMesh.x = windowLength / 2 - v / 2;
			}
			if(topZ > 0)
			{
				PartMesh.z = 0;
			}
			if(bottomZ < -windowHeight)
			{
				PartMesh.z = height - windowHeight;
			}
		}
		
		public function get Height():int
		{
			switch(arrayMode)
			{
				case L3DPartArrayMode.None:
				case L3DPartArrayMode.AutoArray:
				case L3DPartArrayMode.LeftLianshen:
				case L3DPartArrayMode.RightLianshen:
				case L3DPartArrayMode.BothSideLianshen:
				case L3DPartArrayMode.Attaching:
				case L3DPartArrayMode.Guagan:
				{
					return height;
				}
					break;
				case L3DPartArrayMode.AutoSide:
				{
					return windowHeight - TopOffDistance;
				}
					break;
				default:
				{
					return windowHeight * heightRatio + heightDelta;
				}
					break;
			}  
		}		
		
		public function set Height(v:int):void
		{
			if(!Exist || isArraiedPart)
			{
				return;
			}
			
			v = v < 1 ? 1 : (v > 20000 ? 20000 : v);
			
			switch(arrayMode)
			{
				case L3DPartArrayMode.None:
				case L3DPartArrayMode.AutoArray:
				case L3DPartArrayMode.LeftLianshen:
				case L3DPartArrayMode.RightLianshen:
				case L3DPartArrayMode.BothSideLianshen:
				case L3DPartArrayMode.Attaching:
				case L3DPartArrayMode.Guagan:
				{
					height = v;			
				}
					break;
				case L3DPartArrayMode.AutoSide:
				{
					v = windowHeight - TopOffDistance;
				}
					break;
				default:
				{
					heightDelta = v - windowHeight * heightRatio;
				}
					break;
			} 
			
			PartMesh.Height = v;
			
			if(!isArraiedPart)
			{
				for(var i:int = ArrayPartIDs.length - 1;i>=0;i--)
				{
					var arrayPartID:String = ArrayPartIDs[i];
					if(arrayPartID != null && arrayPartID.length > 0)
					{
						var mesh:L3DMesh = null;
						for(var j:int = 0;j<combinedMesh.numChildren;j++)
						{
							var subObject:Object3D = combinedMesh.getChildAt(j);
							if(subObject != null && subObject is L3DMesh)
							{
								if(arrayPartID == (subObject as L3DMesh).UniqueID)
								{
									mesh = subObject as L3DMesh;
									break;
								}
							}
						}
						if(mesh != null)
						{
							mesh.Height = v;
						}
					}
				}
			}
			
			var leftX:Number = PartMesh.x - width / 2;
			var rightX:Number = PartMesh.x + width / 2;
			var topZ:Number = PartMesh.z;
			var bottomZ:Number = PartMesh.z - v;
			
			if(leftX < -windowLength / 2)
			{
				PartMesh.x = width / 2 - windowLength / 2;				
			}
			if(rightX > windowLength / 2)
			{
				PartMesh.x = windowLength / 2 - width / 2;
			}
			if(topZ > 0)
			{
				PartMesh.z = 0;
			}
			if(bottomZ < -windowHeight)
			{
				PartMesh.z = v - windowHeight;
			}
		}
		
		public function get IsWanlian():Boolean
		{
			return isWanlian;
		}
		
		public function set IsWanlian(v:Boolean):void
		{
			isWanlian = v;
		}
		
		public function get WanlianDelta():int
		{
			return wanlianDelta;
		}
		
		public function SetupWanlianDelta(v:int, stage3D:Stage3D):void
		{
			wanlianDelta = 0;
			if(v <= 1000 && v >= -1000)
			{
				wanlianDelta = v;
			}

			switch(arrayMode)
		    {
			    case L3DPartArrayMode.LeftLianshen:
				{
					if(isWanlian)
					{
						SetupLeftLianshen();
					}
				}
					break;
				case L3DPartArrayMode.RightLianshen:
				{
					if(isWanlian)
					{
						SetupRightLianshen(stage3D);
					}
				}
					break;
				case L3DPartArrayMode.Guagan:
				{
					SetupGuagan();
				}
					break;
		    }
		}
		
		public function get IsKeepSizeArrayMode():Boolean
		{
		    return isKeepSizeArrayMode;	
		}
		
		public function set IsKeepSizeArrayMode(v:Boolean):void
		{
			isKeepSizeArrayMode = v;	
		}
		
		public function get IsSpaceArrayMode():Boolean
		{
			return isSpaceArrayMode;
		}
		
		public function set IsSpaceArrayMode(v:Boolean):void
		{
			isSpaceArrayMode = v;
		}

		public function SetupPosition(v:Vector3D):Boolean
		{
			if(!Exist || isArraiedPart)
			{
				return false;
			}	
		
			var width:Number = Width;
			var height:Number = Height;
			
			var leftX:Number = v.x - width / 2;
			var rightX:Number = v.x + width / 2;
			var topZ:Number = v.z;
			var bottomZ:Number = v.z - height;
			
			if(leftX < -windowLength / 2)
			{
				v.x = width / 2 - windowLength / 2;				
			}
			if(rightX > windowLength / 2)
			{
				v.x = windowLength / 2 - width / 2;
			}
			if(topZ > 0)
			{
				v.z = 0;
			}
			if(bottomZ < -windowHeight)
			{
				v.z = height - windowHeight;
			}
			
			if(int(partMesh.x) != int(v.x))
			{
				ClearArray();
			}
			
			partMesh.x = v.x;
			partMesh.z = v.z;
			
			sideOffDistance = partMesh.x + windowLength / 2 - width / 2;
			topOffDistance = partMesh.z * -1;
			
			if(!isArraiedPart)
			{
				for(var i:int = ArrayPartIDs.length - 1;i>=0;i--)
				{
					var arrayPartID:String = ArrayPartIDs[i];
					if(arrayPartID != null && arrayPartID.length > 0)
					{
						var mesh:L3DMesh = null;
						for(var j:int = 0;j<combinedMesh.numChildren;j++)
						{
							var subObject:Object3D = combinedMesh.getChildAt(j);
							if(subObject != null && subObject is L3DMesh)
							{
								if(arrayPartID == (subObject as L3DMesh).UniqueID)
								{
									mesh = subObject as L3DMesh;
									break;
								}
							}
						}
						if(mesh != null)
						{
							mesh.z = v.z;
						}
					}
				}
			}
			
			return true;
		}
		
		public function AmendForSizeChanged():void
		{
			if(partMesh != null)
			{
				partMesh.x = SideOffDistance - windowLength / 2 + width / 2;
				partMesh.z = TopOffDistance * -1;
				partMesh.scaleY = 1;
			}
		}
		
		public function get SideOffDistance():int
		{
			if(sideOffDistance < 0)
			{
				sideOffDistance = 0;
			}
			else if(sideOffDistance > windowLength - width / 2)
			{
				sideOffDistance = windowLength - width / 2;
			}
		    return sideOffDistance;	
		}
		
		public function set SideOffDistance(v:int):void
		{
			if(!Exist || isArraiedPart)
			{
				return;
			}
			
			ClearArray();
			
			sideOffDistance = v<0?0:(v > windowLength - width ? windowLength - width:v);			
			SetupPosition(new Vector3D(sideOffDistance - windowLength / 2 + width / 2, partMesh.y, partMesh.z));
		}
		
		public function get TopOffDistance():int
		{
			if(topOffDistance < 0)
			{
				topOffDistance = 0;
			}
			return topOffDistance;
		}
		
		public function set TopOffDistance(v:int):void
		{
			if(!Exist || isArraiedPart)
			{
				return;
			}
			
			topOffDistance = v<0?0:(v > (windowHeight - height)? (windowHeight - height):v);
			SetupPosition(new Vector3D(partMesh.x, partMesh.y, topOffDistance * -1));
			
			if(!isArraiedPart)
			{
				for(var i:int = ArrayPartIDs.length - 1;i>=0;i--)
				{
					var arrayPartID:String = ArrayPartIDs[i];
					if(arrayPartID != null && arrayPartID.length > 0)
					{
						var mesh:L3DMesh = null;
						for(var j:int = 0;j<combinedMesh.numChildren;j++)
						{
							var subObject:Object3D = combinedMesh.getChildAt(j);
							if(subObject != null && subObject is L3DMesh)
							{
								if(arrayPartID == (subObject as L3DMesh).UniqueID)
								{
									mesh = subObject as L3DMesh;
									break;
								}
							}
						}
						if(mesh != null)
						{
							mesh.z = partMesh.z;
						}
					}
				}
			}
		}
		
		public function ResetPosition():Boolean
		{
			if(!Exist || isArraiedPart)
			{
				return false;
			}
			
			ClearArray();			
	
			partMesh.x = 0;
			partMesh.z = 0;
			
			sideOffDistance = partMesh.x + windowLength / 2;
			topOffDistance = partMesh.z * -1;
			
			return true;
		}
		
		public function ToCenterPosition():Boolean
		{
			if(!Exist || isArraiedPart)
			{
				return false;
			}
			
			ClearArray();				
			
			partMesh.x = 0;
			partMesh.z = height / 2 - windowHeight / 2;
			
			sideOffDistance = partMesh.x + windowLength / 2;
			topOffDistance = partMesh.z * -1;
			
			return true;
		}
		
		public function ToLeftPosition():Boolean
		{
			if(!Exist || isArraiedPart)
			{
				return false;
			}
			
			ClearArray();	
			
			var width:Number = Width;

			partMesh.x = width / 2 - windowLength / 2;
			
			sideOffDistance = partMesh.x + windowLength / 2;
			topOffDistance = partMesh.z * -1;
			
			return true;
		}
		
		public function ToRightPosition():Boolean
		{
			if(!Exist || isArraiedPart)
			{
				return false;
			}
			
			ClearArray();	
			
			var width:Number = Width;
			
			partMesh.x = windowLength / 2 - width / 2;
			
			sideOffDistance = partMesh.x + windowLength / 2;
			topOffDistance = partMesh.z * -1;
			
			return true;
		}
		
		public function ToTopPosition():Boolean
		{
			if(!Exist || isArraiedPart)
			{
				return false;
			}			
		
			partMesh.z = 0;
			
			sideOffDistance = partMesh.x + windowLength / 2;
			topOffDistance = partMesh.z * -1;
			
			if(!isArraiedPart)
			{
				for(var i:int = ArrayPartIDs.length - 1;i>=0;i--)
				{
					var arrayPartID:String = ArrayPartIDs[i];
					if(arrayPartID != null && arrayPartID.length > 0)
					{
						var mesh:L3DMesh = null;
						for(var j:int = 0;j<combinedMesh.numChildren;j++)
						{
							var subObject:Object3D = combinedMesh.getChildAt(j);
							if(subObject != null && subObject is L3DMesh)
							{
								if(arrayPartID == (subObject as L3DMesh).UniqueID)
								{
									mesh = subObject as L3DMesh;
									break;
								}
							}
						}
						if(mesh != null)
						{
							mesh.z = 0;
						}
					}
				}
			}
			
			return true;
		}
		
		public function ToBottomPosition():Boolean
		{
			if(!Exist || isArraiedPart)
			{
				return false;
			}
			
			partMesh.z = height - windowHeight;
			
			sideOffDistance = partMesh.x + windowLength / 2;
			topOffDistance = partMesh.z * -1;
			
			if(!isArraiedPart)
			{
				for(var i:int = ArrayPartIDs.length - 1;i>=0;i--)
				{
					var arrayPartID:String = ArrayPartIDs[i];
					if(arrayPartID != null && arrayPartID.length > 0)
					{
						var mesh:L3DMesh = null;
						for(var j:int = 0;j<combinedMesh.numChildren;j++)
						{
							var subObject:Object3D = combinedMesh.getChildAt(j);
							if(subObject != null && subObject is L3DMesh)
							{
								if(arrayPartID == (subObject as L3DMesh).UniqueID)
								{
									mesh = subObject as L3DMesh;
									break;
								}
							}
						}
						if(mesh != null)
						{
							mesh.z = height - windowHeight;
						}
					}
				}
			}
			
			return true;
		}
		
		public function Mirror(stage3D:Stage3D):Boolean
		{
			if(!Exist)
			{
				return false;
			}
			
			isMirrored = !isMirrored;
			var point:Vector3D = new Vector3D(partMesh.x, partMesh.y, partMesh.z);
			partMesh.Mirror(Vector3D.X_AXIS);
			partMesh.Align(3);
			partMesh.mirror = true;
			if(stage3D != null)
			{
			    UploadResources(partMesh, stage3D.context3D);
			}
			SetupPosition(point);
			
			if(!isArraiedPart)
			{
			    for(var i:int = ArrayPartIDs.length - 1;i>=0;i--)
			    {
				    var arrayPartID:String = ArrayPartIDs[i];
				    if(arrayPartID != null && arrayPartID.length > 0)
				    {
					    var mesh:L3DMesh = null;
					    for(var j:int = 0;j<combinedMesh.numChildren;j++)
					    {
						    var subObject:Object3D = combinedMesh.getChildAt(j);
						    if(subObject != null && subObject is L3DMesh)
						    {
							    if(arrayPartID == (subObject as L3DMesh).UniqueID)
							    {
								    mesh = subObject as L3DMesh;
								    break;
							    }
						    }
					    }
					    if(mesh != null)
					    {
							var point:Vector3D = new Vector3D(mesh.x, mesh.y, mesh.z);
						    mesh.caculation.Mirror(stage3D);
							mesh.x = point.x;
							mesh.y = point.y;
							mesh.z = point.z;
							mesh.scaleX = partMesh.scaleX;
							mesh.scaleY = partMesh.scaleY;
							mesh.scaleZ = partMesh.scaleZ;
					    }
				    }
			    }
			}
					
			return true;
		}
		
		public function get Layer():int
		{
			return layer;
		}
		
		public function set Layer(v:int):void
		{
			if(!Exist || isArraiedPart)
			{
				return;
			}
			
			v = v<0?0:(v>10?10:v);
			layer = v;
			if(partMesh != null)
			{
				partMesh.layer = v;
				for(var i:int = ArrayPartIDs.length - 1;i>=0;i--)
				{
					var arrayPartID:String = ArrayPartIDs[i];
					if(arrayPartID != null && arrayPartID.length > 0)
					{
						var mesh:L3DMesh = null;
						for(var j:int = 0;j<combinedMesh.numChildren;j++)
						{
							var subObject:Object3D = combinedMesh.getChildAt(j);
							if(subObject != null && subObject is L3DMesh)
							{
								if(arrayPartID == (subObject as L3DMesh).UniqueID)
								{
									mesh = subObject as L3DMesh;
									break;
								}
							}
						}
						if(mesh != null)
						{
							mesh.layer = v;
						}
					}
				}
				if(combinedMesh != null)
				{
					combinedMesh.AutoAmendLayers();
				}
			}
		}
		
		public function get IsArraiedPart():Boolean
		{
			return isArraiedPart;
		}
		
		public function get IsMirrored():Boolean
		{
			return isMirrored;
		}
		
		public function ClearArray():Boolean
		{
			if(!Exist || isArraiedPart || combinedMesh == null)
			{
				return false;
			}
			
            ClearArrayParts();
			
			arrayMode = L3DPartArrayMode.None;
			Width = width;
			Height = height;
			
			var leftX:Number = partMesh.x - width / 2;
			var rightX:Number = partMesh.x + width / 2;
			var topZ:Number = partMesh.z;
			var bottomZ:Number = partMesh.z - height;
			
			if(leftX < -windowLength / 2)
			{
				partMesh.x = width / 2 - windowLength / 2;				
			}
			if(rightX > windowLength / 2)
			{
				partMesh.x = windowLength / 2 - width / 2;
			}
			if(topZ > 0)
			{
				partMesh.z = 0;
			}
			if(bottomZ < -windowHeight)
			{
				partMesh.z = height - windowHeight;
			}
			
			sideOffDistance = partMesh.x + windowLength / 2 - width / 2;
			topOffDistance = partMesh.z * -1;
			
		//	isSpaceArrayMode = false;
		//	isKeepSizeArrayMode = false;
		//	isWanlian = false;
			arrayCount = 0;
			actuallyArrayCount = 0;
			arraySpace = 0;
			
			return true;
		}
		
		private function ClearArrayParts():Boolean
		{
			if(!Exist || isArraiedPart || combinedMesh == null)
			{
				return false;
			}
			
			for(var i:int = ArrayPartIDs.length - 1;i>=0;i--)
			{
				var arrayPartID:String = ArrayPartIDs[i];
				if(arrayPartID != null && arrayPartID.length > 0)
				{
					var mesh:L3DMesh = null;
					for(var j:int = 0;j<combinedMesh.numChildren;j++)
					{
						var subObject:Object3D = combinedMesh.getChildAt(j);
						if(subObject != null && subObject is L3DMesh)
						{
							if(arrayPartID == (subObject as L3DMesh).UniqueID)
							{
								mesh = subObject as L3DMesh;
								break;
							}
						}
					}
					if(mesh != null)
					{
						try
						{
						    combinedMesh.removeChild(mesh);
							mesh.Dispose(false);
						}
						catch(error:Error)
						{
							
						}
					}
				}
				ArrayPartIDs.pop();
			}
			
			return true;
		}
		
		public function BeginArray(mode:int, count:int, space:int, stage3D:Stage3D):Boolean
		{
			if(!Exist || isArraiedPart || combinedMesh == null)
			{
				return false;
			}
			
			if(mode < 0 || mode > L3DPartArrayMode.AutoSide)
			{
				return false;
			}
			
			ClearArray();
			
			arrayMode = mode;
			var hadMadeArraied:Boolean = false;
			switch(ArrayMode)
			{
				case L3DPartArrayMode.AutoArray:
				{
					hadMadeArraied = BeginAutoArray(count, stage3D);
				}
					break;
				case L3DPartArrayMode.FullArray:
				{
					hadMadeArraied = BeginFullArray(count, space, stage3D);
				}
					break;
				case L3DPartArrayMode.SideArray:
				{
					hadMadeArraied = BeginSideArray(count, stage3D);
				}
					break;
				case L3DPartArrayMode.LeftLianshen:
				{
					hadMadeArraied = SetupLeftLianshen();
				}
					break;
				case L3DPartArrayMode.RightLianshen:
				{
					hadMadeArraied = SetupRightLianshen(stage3D);
				}
					break;
				case L3DPartArrayMode.BothSideLianshen:
				{
					hadMadeArraied = SetupBothSideLianshen(stage3D);
				}
					break;
				case L3DPartArrayMode.Attaching:
				{
			//		hadMadeArraied = SetupAttaching(stage3D);
				}
					break;
				case L3DPartArrayMode.Guagan:
				{
					hadMadeArraied = SetupGuagan();
				}
					break;
				case L3DPartArrayMode.AutoSide:
				{
					hadMadeArraied = BeginAutoSide(count, stage3D);
				}
					break;
			}
			
			if(hadMadeArraied || count > 0)
			{
			    arrayMode = mode;
			}
			else
			{
				arrayMode = L3DPartArrayMode.None;
			}
			
			ResetAttachedParts(stage3D);
			
			return hadMadeArraied;
		}
		
		public function get ArrayCount():int
		{
			var count:int = 1;
			switch(ArrayMode)
			{
				case L3DPartArrayMode.AutoArray:
				case L3DPartArrayMode.AutoSide:
				{
					count = AutoArrayCount;
				}
					break;
				case L3DPartArrayMode.FullArray:
				{
					count = FullArrayCount;
				}
					break;
				case L3DPartArrayMode.SideArray:
				{
					count = SideArrayCount;
				}
					break;
			}
			return count;
		}
		
		public function set ArrayCount(v:int):void
		{
			switch(arrayMode)
			{
				case L3DPartArrayMode.AutoArray:
				case L3DPartArrayMode.AutoSide:
				{
					AutoArrayCount = v;
				}
					break;
				case L3DPartArrayMode.FullArray:
				{
					FullArrayCount = v;
				}
					break;
			}
		}
		
		public function get ArrayMode():int
		{
			return arrayMode;
    	}	
		
		public function set ArrayMode(v:int):void
		{
			arrayMode = v;
		}	
	
		private function get AutoArrayCount():int
		{
			if(width < 1)
			{
				return 0;
			}
			var v:Number = Number(windowLength - sideOffDistance * 2) / width;
			if (v < 0)
			{
				return 0;
			}
			if (v < 1)
			{
				return 1;
			}
			return int(v + 0.25);
		}
		
		private function set AutoArrayCount(v:int):void
		{
			if(v <= 0 || v > 100)
			{
				return;
			}

			width = Number(windowLength - sideOffDistance * 2) / Number(v);
		}
		
		private function BeginAutoArray(count:int, stage3D:Stage3D):Boolean
		{
			if(!Exist || isArraiedPart || combinedMesh == null || stage3D == null)
			{
				return false;
			}
			
			arrayCount = count;
			
			if(count > 0)
			{
			    AutoArrayCount = count;	
			}
			
			count = AutoArrayCount;
			if(count < 1)
			{
				return false;
			}
			
			if(AutoArrayCount == 1)
			{
				var length:Number = windowLength - SideOffDistance * 2;
				if(length < 10)
				{
					return false;
				}
				partMesh.x = 0;
				Width = length;
				partMesh.z = -TopOffDistance;
				if(height > windowHeight - TopOffDistance)
				{
					Height = windowHeight - TopOffDistance;
				}
			}
			else
			{
				var arrayLength:Number = windowLength - SideOffDistance * 2;
				var length:Number = arrayLength / Number(count);
				if(length < 10)
				{
					return false;
				}
				partMesh.x = SideOffDistance - windowLength / 2 + length / 2;
				Width = length;
				partMesh.z = -TopOffDistance;
				if(height > windowHeight - TopOffDistance)
				{
					Height = windowHeight - TopOffDistance;
				}
				var vmodel:L3DModel = new L3DModel();
				vmodel.Import(partMesh);
				for(var i:int = 1;i< count;i++)
				{
					var mesh:L3DMesh = vmodel.Export(stage3D, true, false);
					mesh.AutoRenewID();
					mesh.x = partMesh.x + length * i;
					mesh.y = partMesh.y;
					mesh.z = partMesh.z;
					mesh.Length = length;
					mesh.Height = height;
					mesh.caculation.isArraiedPart = true;
					combinedMesh.addChild(mesh);
					if(mesh.x > 0)
					{
						mesh.caculation.Mirror(stage3D);
						mesh.x = partMesh.x + length * i;
						mesh.y = partMesh.y;
						mesh.z = partMesh.z;
						mesh.scaleX = partMesh.scaleX;
						mesh.scaleY = partMesh.scaleY;
						mesh.scaleZ = partMesh.scaleZ;
						mesh.layer = partMesh.layer;
					}
					ArrayPartIDs.push(mesh.UniqueID);
				}
				vmodel.Clear();
			}
			
			actuallyArrayCount = count;
			
			if(count == 1)
			{
				actuallyArrayCount = 1;
				partMesh.x = 0;
				sideOffDistance = partMesh.x + windowLength / 2 - width / 2;
			}
			
			return true;
		}
		
		private function get FullArrayCount():int
		{
			var v:Number = Number(windowLength - SideOffDistance * 2) / (Number(windowHeight) * heightRatio);
			if (v < 0)
			{
				return 0;
			}
			if (v < 1)
			{
				return 1;
			}
			return int(v + 0.25);
		}
		
		private function set FullArrayCount(v:int):void
		{
			if (v <= 0 || v > 100)
			{
				return;
			}
			
			if(v <= 0 || v > 100)
			{
				return;
			}
			
			var width:int = Width;
			var height:int = Height;
			heightRatio = Number(windowLength - SideOffDistance * 2) / (Number(windowHeight) * Number(v));
			Height = height;
			Width = width;
		}
		
		private function BeginFullArray(count:int, space:int, stage3D:Stage3D):Boolean
		{
			if(!Exist || isArraiedPart || combinedMesh == null || stage3D == null)
			{
				return false;
			}
			
			arrayCount = count;
			
			if(count < 0)
			{
				count = FullArrayCount;
			}
			else if(count == 0)
			{
				FullArrayCount = (int)(Number(windowLength - SideOffDistance * 2) / Number(width) + 0.25);
			}
			else if(count == 1)
			{
				actuallyArrayCount = 1;
				partMesh.x = 0;
				sideOffDistance = partMesh.x + windowLength / 2 - width / 2;
				return true;
			}
			else
			{
				if(isSpaceArrayMode)
				{
					FullSpaceArrayCount = count;
				}
				else
				{
					FullArrayCount = count;
				}
			}
			
			Width = width;
			Height = height;
			count = FullArrayCount;
			if(count == 0)
			{
				return false;
			}
			else if(count == 1)
			{
				actuallyArrayCount = 1;
				partMesh.x = 0;
				sideOffDistance = partMesh.x + windowLength / 2 - width / 2;
				return true;
			}
			
			var arrayWidth:int = Width;
			var arrayHeight:int = Height;
			if(arrayWidth < 10 || arrayHeight < 10)
			{
			    return false;
			}			
			
			var arrayLength:Number = windowLength - SideOffDistance * 2;
			var length:Number = arrayLength / Number(count);
			var s:Number = Number(ArraySpace);
			if(length < 10)
			{
				return false;
			}			
			
			partMesh.x = SideOffDistance - windowLength / 2 + arrayWidth / 2;
			partMesh.z = -TopOffDistance;
			if(height > windowHeight - TopOffDistance)
			{
				Height = windowHeight - TopOffDistance;
			}
			var vmodel:L3DModel = new L3DModel();
			vmodel.Import(partMesh);
			var x:Number = partMesh.x;
			for(var i:int = 1;i< count;i++)
			{
				var mesh:L3DMesh = vmodel.Export(stage3D, true, false);
				if(mesh != null)
				{
					mesh.AutoRenewID();
				}
				x += (arrayWidth + s);
				mesh.x = x;
				mesh.y = partMesh.y;
				mesh.z = partMesh.z;
				mesh.scaleX = partMesh.scaleX;
				mesh.scaleY = partMesh.scaleY;
				mesh.scaleZ = partMesh.scaleZ;
				mesh.layer = partMesh.layer;
				mesh.caculation.isArraiedPart = true;
				combinedMesh.addChild(mesh);
				if(mesh.x > 0)
				{
					mesh.caculation.Mirror(stage3D);
					mesh.x = x;
					mesh.y = partMesh.y;
					mesh.z = partMesh.z;
					mesh.scaleX = partMesh.scaleX;
					mesh.scaleY = partMesh.scaleY;
					mesh.scaleZ = partMesh.scaleZ;
					mesh.layer = partMesh.layer;
				}
				ArrayPartIDs.push(mesh.UniqueID);
			}
			
			actuallyArrayCount = count;
			if(!isKeepSizeArrayMode)
			{
			    ArraySpace = space;
			}
			
			if(count == 1)
			{
				actuallyArrayCount = 1;
				partMesh.x = 0;
				sideOffDistance = partMesh.x + windowLength / 2 - width / 2;
			}
			
			vmodel.Clear();
			
			return true;
		}		
	
		private function get SideArrayCount():int
		{
			return 2;
		}
		
		private function BeginSideArray(count:int, stage3D:Stage3D):Boolean
		{
			if(!Exist || isArraiedPart || combinedMesh == null || stage3D == null)
			{
				return false;
			}
			
			Width = width;
			Height = height;
			var arrayWidth:int = Width;
			var arrayHeight:int = Height;
			if(arrayWidth < 10 || arrayHeight < 10)
			{
				return false;
			}	
			
			partMesh.x = SideOffDistance - windowLength / 2 + arrayWidth / 2;
			partMesh.z = -TopOffDistance;
			if(height > windowHeight - TopOffDistance)
			{
				Height = windowHeight - TopOffDistance;
			}
			var mesh:L3DMesh = partMesh.CloneMesh(stage3D);
			if(mesh != null)
			{
				mesh.AutoRenewID();
			}
			mesh.caculation.isArraiedPart = true;
			combinedMesh.addChild(mesh);
			mesh.caculation.Mirror(stage3D);
			mesh.x = windowLength / 2 - SideOffDistance - arrayWidth / 2;
			mesh.y = partMesh.y;
			mesh.z = partMesh.z;
			mesh.scaleX = partMesh.scaleX;
			mesh.scaleY = partMesh.scaleY;
			mesh.scaleZ = partMesh.scaleZ;
			mesh.layer = partMesh.layer;
			ArrayPartIDs.push(mesh.UniqueID);
			
			return true;
		}
		
		private function set FullSpaceArrayCount(v:int):void
		{
			if (v <= 1 || v > 100)
			{
				return;
			}
			
			var v:int = (v - 1) * 2;
			FullArrayCount = v;
		}
		
		private function SetupLeftLianshen():Boolean
		{
			if(!Exist || isArraiedPart || combinedMesh == null)
			{
				return false;
			}
			
			var w:Number = windowLength / 3;
			if(isWanlian)
			{
			    if(w > maxWanlianWidth)
			    {
			    	w = maxWanlianWidth;
			    }
			}
			else if(w > maxLianshenWidth)
			{
				w = maxLianshenWidth;
			}
			var h:Number = windowHeight;
			Width = w;
			Height = h;
			
			var v:Vector3D = new Vector3D(-windowLength / 2 + Width / 2, PartMesh.y, 0);
			SetupPosition(v);
			if(isWanlian)
			{
			    PartMesh.x -= wanlianDelta;
			}
			
			return true;
		}
		
		private function SetupRightLianshen(stage3D:Stage3D):Boolean
		{
			if(!Exist || isArraiedPart || combinedMesh == null)
			{
				return false;
			}
			
			var w:Number = windowLength / 3;
			if(isWanlian)
			{
				if(w > maxWanlianWidth)
				{
					w = maxWanlianWidth;
				}
			}
			else if(w > maxLianshenWidth)
			{
				w = maxLianshenWidth;
			}
			var h:Number = windowHeight;
			Width = w;
			Height = h;
			
			Mirror(stage3D);
			
			var v:Vector3D = new Vector3D(windowLength / 2 - Width / 2, PartMesh.y, 0);
			SetupPosition(v);
			if(isWanlian)
			{
			    PartMesh.x += wanlianDelta;
			}
			
			return true;
		}
		
		private function SetupBothSideLianshen(stage3D:Stage3D):Boolean
		{
			if(!Exist || isArraiedPart || combinedMesh == null)
			{
				return false;
			}
			
			var w:Number = windowLength / 3;
			if(isWanlian)
			{
			    if(w > maxWanlianWidth)
		    	{
			    	w = maxWanlianWidth;
		    	}
			}
			else if(w > maxLianshenWidth)
			{
				w = maxLianshenWidth;
			}
			var h:Number = windowHeight;
			Width = w;
			Height = h;
			
			var v:Vector3D = new Vector3D(-windowLength / 2 + Width / 2, PartMesh.y, 0);
			SetupPosition(v);
			
			var mesh:L3DMesh = partMesh.CloneMesh(stage3D);
			if(mesh == null)
			{
				return false;
			}

			mesh.AutoRenewID();
			mesh.caculation.isArraiedPart = true;
			combinedMesh.addChild(mesh);
			mesh.caculation.Mirror(stage3D);
			mesh.x = windowLength / 2 - Width / 2;
			mesh.y = partMesh.y;
			mesh.z = partMesh.z;
			mesh.scaleX = partMesh.scaleX;
			mesh.scaleY = partMesh.scaleY;
			mesh.scaleZ = partMesh.scaleZ;
			mesh.layer = partMesh.layer;
			ArrayPartIDs.push(mesh.UniqueID);
			
			return true;
		}
		
		private function SetupGuagan():Boolean
		{
			if(!Exist || isArraiedPart || combinedMesh == null)
			{
				return false;
			}
			
			var w:Number = windowLength;
	//		var h:Number = windowHeight;
			Width = w + wanlianDelta;
		//	Height = h;
			
			var v:Vector3D = new Vector3D(0, PartMesh.y, topOffDistance * -1);
		//	SetupPosition(v);
		//	Layer = 0;
			
			partMesh.x = v.x;
			partMesh.z = v.z;
			
			sideOffDistance = partMesh.x + windowLength / 2 - width / 2;
			topOffDistance = partMesh.z * -1;
			
			return true;
		}
		
		private function BeginAutoSide(count:int, stage3D:Stage3D):Boolean
		{
			if(!Exist || isArraiedPart || combinedMesh == null || stage3D == null)
			{
				return false;
			}
			
			arrayCount = count;
			
			if(count > 0)
			{
				AutoArrayCount = count;	
			}
			
			count = AutoArrayCount;
			if(count < 1)
			{
				return false;
			}
			
			if(AutoArrayCount == 1)
			{
				var length:Number = windowLength - SideOffDistance * 2;
				if(length < 10)
				{
					return false;
				}
				partMesh.x = 0;
				Width = length;
				partMesh.z = -TopOffDistance;
				partMesh.Height = Height;
			/*	if(height > windowHeight - TopOffDistance)
				{
					Height = windowHeight - TopOffDistance;
				} */
			}
			else
			{
				var arrayLength:Number = windowLength - SideOffDistance * 2;
				var length:Number = arrayLength / Number(count);
				if(length < 10)
				{
					return false;
				}
				partMesh.x = SideOffDistance - windowLength / 2 + length / 2;
				Width = length;
				partMesh.z = -TopOffDistance;
				partMesh.Height = Height;
				var vmodel:L3DModel = new L3DModel();
				vmodel.Import(partMesh);
				for(var i:int = 1;i< count;i++)
				{
					var mesh:L3DMesh = vmodel.Export(stage3D, true, false);
					mesh.AutoRenewID();
					mesh.x = partMesh.x + length * i;
					mesh.y = partMesh.y;
					mesh.z = partMesh.z;
					mesh.Length = length;
					mesh.Height = Height;
					mesh.caculation.isArraiedPart = true;
					combinedMesh.addChild(mesh);
					if(mesh.x > 0)
					{
						mesh.caculation.Mirror(stage3D);
						mesh.x = partMesh.x + length * i;
						mesh.y = partMesh.y;
						mesh.z = partMesh.z;
						mesh.scaleX = partMesh.scaleX;
						mesh.scaleY = partMesh.scaleY;
						mesh.scaleZ = partMesh.scaleZ;
						mesh.layer = partMesh.layer;
					}
					ArrayPartIDs.push(mesh.UniqueID);
				}
				vmodel.Clear();
			}
			
			actuallyArrayCount = count;
			
			if(count == 1)
			{
				actuallyArrayCount = 1;
				partMesh.x = 0;
				sideOffDistance = partMesh.x + windowLength / 2 - width / 2;
			}
			
			return true;
		}
		
		public function GetAdherePart():L3DPartCaculation
		{
			if(!Exist || isArraiedPart || combinedMesh == null || arrayMode != L3DPartArrayMode.Attaching)
			{
				return null;
			}
			
			if(adhereToPartCode == null || adhereToPartCode.length == 0)
			{
				return null;
			}
			
			var mesh:L3DMesh = null;
			
			for(var i:int = 0;i<combinedMesh.numChildren;i++)
			{
				var subObject:Object3D = combinedMesh.getChildAt(i);
				if(subObject != null && subObject is L3DMesh)
				{
					var subMesh:L3DMesh = subObject as L3DMesh;
					if(subMesh.caculation.Exist && !subMesh.caculation.isArraiedPart && subMesh.UniqueID != PartMesh.UniqueID && subMesh.Code.toUpperCase() != PartMesh.Code.toUpperCase())
					{
						if(subMesh.caculation.ArrayMode != L3DPartArrayMode.Attaching && subMesh.Code.toUpperCase() == adhereToPartCode.toUpperCase())
						{
							mesh = subMesh;
							break;
						}
					}
				}
			}
			
			return mesh.caculation;
		}
		
		public function GetAttachedParts():Vector.<L3DPartCaculation>
		{
			if(!Exist || isArraiedPart || combinedMesh == null || arrayMode == L3DPartArrayMode.Attaching)
			{
				return null;
			}
			
			var caculations:Vector.<L3DPartCaculation> = new Vector.<L3DPartCaculation>();
			
			for(var i:int = 0;i<combinedMesh.numChildren;i++)
			{
				var subObject:Object3D = combinedMesh.getChildAt(i);
				if(subObject != null && subObject is L3DMesh)
				{
					var arrMesh:L3DMesh = subObject as L3DMesh;
					if(arrMesh.caculation.Exist && !arrMesh.caculation.isArraiedPart && arrMesh.UniqueID != PartMesh.UniqueID && arrMesh.Code.toUpperCase() != PartMesh.Code.toUpperCase())
					{
						if(arrMesh.caculation.ArrayMode == L3DPartArrayMode.Attaching && arrMesh.caculation.adhereToPartCode.toUpperCase() == PartMesh.Code.toUpperCase())
						{
							caculations.push(arrMesh.caculation);					
						}
					}
				}
			}
			
            return caculations.length > 0 ? caculations : null;
		}
		
		public function ResetAttachedParts(stage3D:Stage3D):Boolean
		{
			if(!Exist || isArraiedPart || combinedMesh == null || arrayMode == L3DPartArrayMode.Attaching)
			{
				return false;
			}
			
			this.stage3D = stage3D;
			
			var hadMadeReset:Boolean = false;
			for(var i:int = 0;i<combinedMesh.numChildren;i++)
			{
				var subObject:Object3D = combinedMesh.getChildAt(i);
				if(subObject != null && subObject is L3DMesh)
				{
					var arrMesh:L3DMesh = subObject as L3DMesh;
					if(arrMesh.caculation.Exist && !arrMesh.caculation.isArraiedPart && arrMesh.UniqueID != PartMesh.UniqueID && arrMesh.Code.toUpperCase() != PartMesh.Code.toUpperCase())
					{
					    if(arrMesh.caculation.ArrayMode == L3DPartArrayMode.Attaching && arrMesh.caculation.adhereToPartCode.toUpperCase() == PartMesh.Code.toUpperCase())
					    {
							arrMesh.caculation.ClearArrayParts();
							if(isMirrored)
							{
								arrMesh.x = PartMesh.x - arrMesh.caculation.deltaX;
							}
							else
							{
								arrMesh.x = PartMesh.x + arrMesh.caculation.deltaX;
							}
							arrMesh.z = PartMesh.z + arrMesh.caculation.deltaY;
							arrMesh.caculation.Layer = Layer + 1;
							
							var count:int = 0;
							for(var j = 0;j<combinedMesh.numChildren;j++)
							{
								var subObject:Object3D = combinedMesh.getChildAt(j);
								if(subObject != null && subObject is L3DMesh)
								{
									var subMesh:L3DMesh = subObject as L3DMesh;
									if(subMesh.Code != null && subMesh.Code.length > 0 && subMesh.Code.toUpperCase() == PartMesh.Code.toUpperCase())
									{
										count++;
									}
								}
							}
							
							if(count > 1)
							{
								var vmodel:L3DModel = new L3DModel();
								vmodel.Import(arrMesh);
								for(var j = 0;j<combinedMesh.numChildren;j++)
								{
									var subObject:Object3D = combinedMesh.getChildAt(j);
									if(subObject != null && subObject is L3DMesh)
									{
										var subMesh:L3DMesh = subObject as L3DMesh;
										if(subMesh.Code != null && subMesh.Code.length > 0 && subMesh.Code.toUpperCase() == PartMesh.Code.toUpperCase())
										{
											if(subMesh.UniqueID != PartMesh.UniqueID)
											{
												var mesh:L3DMesh = vmodel.Export(stage3D, true, false);
												if(mesh != null)
												{
													mesh.AutoRenewID();
													if(subMesh.caculation.isMirrored == PartMesh.caculation.isMirrored)
													{
														mesh.x = subMesh.x + arrMesh.caculation.deltaX;
													}
													else
													{
														mesh.caculation.Mirror(stage3D);
														mesh.x = subMesh.x - arrMesh.caculation.deltaX;
													}
													mesh.y = arrMesh.y;
													mesh.z = subMesh.z + arrMesh.caculation.deltaY;
													mesh.scaleX = arrMesh.scaleX;
													mesh.scaleY = arrMesh.scaleY;
													mesh.scaleZ = arrMesh.scaleZ;
													mesh.layer = arrMesh.layer;
													mesh.caculation.isArraiedPart = true;
													combinedMesh.addChild(mesh);
													arrMesh.caculation.ArrayPartIDs.push(mesh.UniqueID);
												}
											}
										}
									}
								}
								vmodel.Clear();
							}
							
							hadMadeReset = true;							
					    }
					}
				}
			}
			
			if(hadMadeReset)
			{
				combinedMesh.AutoAmendLayers();
			}
			
			return true;
		}
		
		public function SetupPartAttaching(adhereCaculation:L3DPartCaculation, stage3D:Stage3D):Boolean
		{
			ClearArray();
			
			if(!Exist || isArraiedPart || combinedMesh == null)
			{
				arrayMode = L3DPartArrayMode.None;
				return false;
			}
			
			if(adhereCaculation == null || !adhereCaculation.Exist || adhereCaculation.IsArraiedPart || adhereCaculation.PartMesh.UniqueID == PartMesh.UniqueID || adhereCaculation.PartMesh.Code.toUpperCase() == PartMesh.Code.toUpperCase() || adhereCaculation.ArrayMode == L3DPartArrayMode.Attaching)
			{
				arrayMode = L3DPartArrayMode.None;
				return false;
			}
			
			var destMesh:L3DMesh = adhereCaculation.PartMesh;

			if(destMesh == null)
			{
				arrayMode = L3DPartArrayMode.None;
				return false;
			}
			
			arrayMode = L3DPartArrayMode.Attaching;
			
			adhereToPartCode = destMesh.Code.toUpperCase();
			if(destMesh.caculation.isMirrored)
			{
				deltaX = destMesh.x - partMesh.x;
			}
			else
			{
			    deltaX = partMesh.x - destMesh.x;
			}
			deltaY = partMesh.z - destMesh.z;
			
			Layer = adhereCaculation.Layer + 1;
			
			var count:int = 0;
			for(var i = 0;i<combinedMesh.numChildren;i++)
			{
				var subObject:Object3D = combinedMesh.getChildAt(i);
				if(subObject != null && subObject is L3DMesh)
				{
					var subMesh:L3DMesh = subObject as L3DMesh;
					if(subMesh.Code != null && subMesh.Code.length > 0 && subMesh.Code.toUpperCase() == adhereToPartCode)
					{
						count++;
					}
				}
			}
			
			if(count > 1)
			{
				var vmodel:L3DModel = new L3DModel();
				vmodel.Import(partMesh);
				for(var i = 0;i<combinedMesh.numChildren;i++)
				{
					var subObject:Object3D = combinedMesh.getChildAt(i);
					if(subObject != null && subObject is L3DMesh)
					{
						var subMesh:L3DMesh = subObject as L3DMesh;
						if(subMesh.Code != null && subMesh.Code.length > 0 && subMesh.Code.toUpperCase() == adhereToPartCode)
						{
							if(subMesh.UniqueID != destMesh.UniqueID)
							{
								var mesh:L3DMesh = vmodel.Export(stage3D, true, false);
								if(mesh != null)
								{
									mesh.AutoRenewID();
									if(subMesh.caculation.isMirrored == destMesh.caculation.isMirrored)
									{
									    mesh.x = subMesh.x + deltaX;
									}
									else
									{
										mesh.caculation.Mirror(stage3D);
										mesh.x = subMesh.x - deltaX;
									}
									mesh.y = partMesh.y;
									mesh.z = subMesh.z + deltaY;
									mesh.scaleX = partMesh.scaleX;
									mesh.scaleY = partMesh.scaleY;
									mesh.scaleZ = partMesh.scaleZ;
									mesh.layer = partMesh.layer;
									mesh.caculation.isArraiedPart = true;
									combinedMesh.addChild(mesh);
									ArrayPartIDs.push(mesh.UniqueID);
								}
							}
						}
					}
				}
				vmodel.Clear();
			}
			
			combinedMesh.AutoAmendLayers();
			
			return true;
		}
		
		public function get ArraySpace():int
		{
			switch(arrayMode)
			{
				case L3DPartArrayMode.None:
				case L3DPartArrayMode.AutoArray:					
				case L3DPartArrayMode.SideArray:
				case L3DPartArrayMode.LeftLianshen:
				case L3DPartArrayMode.RightLianshen:
				case L3DPartArrayMode.BothSideLianshen:
				case L3DPartArrayMode.AutoSide:
				{
					return 0;
				}
				break;	
				default:
				{
					var count:int = ArrayCount;
					if(count < 2)
				    {
					    return 0;
					}					
					var totalWidth:int = windowLength - sideOffDistance * 2;
					var totalPartsWidth:int = Width * count;
					return (totalWidth - totalPartsWidth) / (count - 1);
				}
				break;
			}
		}
		
		public function set ArraySpace(v:int):void
		{
			arraySpace = 0;
			switch (arrayMode)
			{
				case L3DPartArrayMode.None:
				case L3DPartArrayMode.AutoArray:
				case L3DPartArrayMode.SideArray:
				case L3DPartArrayMode.AutoSide:
				{					
					return;
				}
				break;
				default:
				{
					var count:int = ArrayCount;
					if (count < 2)
					{
						return;
					}
					Width = (windowLength - sideOffDistance * 2 - v * (count - 1)) / count;
					count = ArrayCount;
					if (count < 2)
					{
						return;
					}
					Width = (windowLength - sideOffDistance * 2 - v * (count - 1)) / count;
					arraySpace = v;
				}
				break;
			}
		}
		
	/*	public function GetMaterial(subsetIndex:int):TextureResource
		{
			if(!Exist)
			{
				return null;
			}
			
			if(subsetIndex < 0 || subsetIndex >= partMesh.numChildren)
			{
				return null;
			}
			
			var subObject:Object3D = PartMesh.getChildAt(subsetIndex);
			if(subObject == null || !(subObject is L3DMesh))
			{
				return null;
			}
			
			var mesh:L3DMesh = subObject as L3DMesh;
			var material:Material = mesh.getSurface(0).material;
			if(material is TextureMaterial)
			{
				return (material as TextureMaterial).diffuseMap;
			}
			else if(material is LightMapMaterial)
			{
				return (material as LightMapMaterial).diffuseMap;
			}
			else if(material is StandardMaterial)
			{
				return (material as StandardMaterial).diffuseMap;
			}

			return null;
		} */
		
		public function AutoCompuTextureSize(stage3D:Stage3D):void
		{
			if(!Exist || isArraiedPart)
			{
				return;
			}
			
			for(var i:int = 0; i<partMesh.numChildren; i++)
			{
				var subObject:Object3D = PartMesh.getChildAt(i);
				if(subObject == null || !(subObject is L3DMesh))
				{
					return;
				}
				
				var mesh:L3DMesh = subObject as L3DMesh;
				mesh.AutoAmendSizeForMaterialSize(stage3D);				
			}
			
			for(var i:int = ArrayPartIDs.length - 1;i>=0;i--)
			{
				var arrayPartID:String = ArrayPartIDs[i];
				if(arrayPartID != null && arrayPartID.length > 0)
				{
					var mesh:L3DMesh = null;
					for(var j:int = 0;j<combinedMesh.numChildren;j++)
					{
						var subObject:Object3D = combinedMesh.getChildAt(j);
						if(subObject != null && subObject is L3DMesh)
						{
							if(arrayPartID == (subObject as L3DMesh).UniqueID)
							{
								mesh = subObject as L3DMesh;
								break;
							}
						}
					}
					if(mesh != null)
					{
						for(var k:int = 0; k<mesh.numChildren; k++)
						{
							var subObject:Object3D = PartMesh.getChildAt(k);
							if(subObject == null || !(subObject is L3DMesh))
							{
								return;
							}							
							var subMesh:L3DMesh = subObject as L3DMesh;
							subMesh.MaterialSize = (partMesh.getChildAt(k) as L3DMesh).MaterialSize;
							subMesh.AutoAmendSizeForMaterialSize(stage3D);				
						}
					}
				}
			}
		}
		
		public function SetTextureSize(subsetIndex:int, width:int, height:int, rotation:int, deltaU:int, deltaV:int, mode:int, stage3D:Stage3D):void
		{
			if(width < 10 || width > 10000 || height < 10 || height > 10000)
			{
				return;
			}
			
			if(!Exist || isArraiedPart)
			{
				return;
			}
			
			if(subsetIndex < 0 || subsetIndex >= partMesh.numChildren)
			{
				return;
			}
			
			var subObject:Object3D = PartMesh.getChildAt(subsetIndex);
			if(subObject == null || !(subObject is L3DMesh))
			{
				return;
			}
			
			var mesh:L3DMesh = subObject as L3DMesh;
			mesh.MaterialSize = width.toString() + "X" + height.toString() + ":" + rotation.toString() + ":" + deltaU.toString() + ":" + deltaV.toString() + ":" + mode.toString();
			mesh.AutoAmendSizeForMaterialSize(stage3D);
			
			if(!isArraiedPart)
			{
				for(var i:int = ArrayPartIDs.length - 1;i>=0;i--)
				{
					var arrayPartID:String = ArrayPartIDs[i];
					if(arrayPartID != null && arrayPartID.length > 0)
					{
						var inmesh:L3DMesh = null;
						for(var j:int = 0;j<combinedMesh.numChildren;j++)
						{
							var subObject:Object3D = combinedMesh.getChildAt(j);
							if(subObject != null && subObject is L3DMesh)
							{
								if(arrayPartID == (subObject as L3DMesh).UniqueID)
								{
									inmesh = subObject as L3DMesh;
									break;
								}
							}
						}
						if(inmesh != null && subsetIndex < inmesh.numChildren)
						{
							var subObject:Object3D = inmesh.getChildAt(subsetIndex);
							if(subObject != null && subObject is L3DMesh)
							{
								var subMesh:L3DMesh = subObject as L3DMesh;
								subMesh.MaterialSize = mesh.MaterialSize;
								subMesh.AutoAmendSizeForMaterialSize(stage3D);
							}
						}
					}
				}
			}
		}
		
		public function GetTextureSize(subsetIndex:int):Array
		{
			if(!Exist)
			{
				return null;
			}
			
			if(subsetIndex < 0 || subsetIndex >= partMesh.numChildren)
			{
				return null;
			}
			
			var subObject:Object3D = PartMesh.getChildAt(subsetIndex);
			if(subObject == null || !(subObject is L3DMesh))
			{
				return null;
			}
			
			var width:int = 0;
			var height:int = 0;
			var rotation:Number = 0;
			var deltaU:Number = 0;
			var deltaV:Number = 0;
			var mode:int = 0;
			
			var mesh:L3DMesh = subObject as L3DMesh;
			if(mesh.MaterialSize != null && mesh.MaterialSize.length > 0 && mesh.MaterialSize.indexOf("X") > 0)
			{
				var sizeStr:String = "";
				if(mesh.MaterialSize.indexOf(":") > 0)
				{
					var rarr:Array = mesh.MaterialSize.split(":");
					if(rarr != null && rarr.length > 1)
					{
					    sizeStr = rarr[0];
					    rotation = parseFloat(rarr[1]);
					    if(rarr.length > 3)
					    {
						    deltaU = parseFloat(rarr[2]);
						    deltaV = parseFloat(rarr[3]);
							if(rarr.length > 4)
							{
								mode = parseInt(rarr[4]);
							}
					    }
					}
				}
				else
				{
					sizeStr = mesh.MaterialSize;
				}
				var arr:Array = sizeStr.split("X");
				if(arr == null || arr.length < 2)
				{
					var tarr:Array = new Array();
					tarr.push(500, 500, 0, 0, 0, 0);					
					return tarr;
				}
				
				width = parseInt(arr[0]);
				height = parseInt(arr[1]);
			}
			
			if(width < 10 || width > 10000 || height < 10 || height > 10000)
			{
				var tex:TextureResource = GetTexture(subsetIndex);
				if(tex != null && tex is L3DBitmapTextureResource)
				{
					width = (tex as L3DBitmapTextureResource).Width;
					height = (tex as L3DBitmapTextureResource).Height;
				}
			}
			
			if(width < 10 || width > 10000 || height < 10 || height > 10000)
			{
				width = 500;
				height = 500;
			}
			
			var varr:Array = new Array();
			varr.push(width, height, rotation, deltaU, deltaV, mode);
			
			return varr;
		}
		
		public function GetTexture(subsetIndex:int):TextureResource
		{
			if(!Exist || isArraiedPart)
			{
				return null;
			}
			
			if(subsetIndex < 0 || subsetIndex >= partMesh.numChildren)
			{
				return null;
			}

			var subObject:Object3D = PartMesh.getChildAt(subsetIndex);
			if(subObject == null || !(subObject is L3DMesh))
			{
				return null;
			}
			
			var mesh:L3DMesh = subObject as L3DMesh;
			var material:Material = mesh.getSurface(0).material;
			
			if(material is TextureMaterial)
			{
				return (material as TextureMaterial).diffuseMap;
			}
			else if(material is LightMapMaterial)
			{
				return (material as LightMapMaterial).diffuseMap;
			}
			else if(material is StandardMaterial)
			{
				return (material as StandardMaterial).diffuseMap;
			}

			return null;
		}
		
		public function SetupMaterial(code:String, subsetIndex:int, diffuse:TextureResource, stage3D:Stage3D):Boolean
		{
			if(code == null || code.length == 0 || diffuse == null)
			{
				return false;
			}
			
			if(!Exist || isArraiedPart)
			{
				return false;
			}
			
			if(subsetIndex < 0 || subsetIndex >= partMesh.numChildren)
			{
				return false;
			}
			
			var sizeWidth:int = 500;
			var sizeHeight:int = 500;
			
			var subObject:Object3D = PartMesh.getChildAt(subsetIndex);
			if(subObject != null && subObject is L3DMesh)
			{
				var mesh:L3DMesh = subObject as L3DMesh;
				var material:Material = mesh.getSurface(0).material;
				diffuse.upload(stage3D.context3D);
				if(material is TextureMaterial)
				{
					if((material as TextureMaterial).diffuseMap != null)
					{
						(material as TextureMaterial).diffuseMap.dispose();
						(material as TextureMaterial).diffuseMap = null;
					}
					(material as TextureMaterial).diffuseMap = diffuse;
				}
				else if(material is LightMapMaterial)
				{
					if((material as LightMapMaterial).diffuseMap != null)
					{
						(material as LightMapMaterial).diffuseMap.dispose();
						(material as LightMapMaterial).diffuseMap = null;
					}
					(material as LightMapMaterial).diffuseMap = diffuse;
				}
				else if(material is StandardMaterial)
				{
					if((material as StandardMaterial).diffuseMap != null)
					{
						(material as StandardMaterial).diffuseMap.dispose();
						(material as StandardMaterial).diffuseMap = null;
					}
					(material as StandardMaterial).diffuseMap = diffuse;
				}
				else
				{
					mesh.getSurface(0).material = new TextureMaterial(diffuse);
				}
				mesh.MaterialCode = code.toUpperCase();
				mesh.MaterialSize = "";
				if(diffuse is L3DBitmapTextureResource)
				{
					sizeWidth = (diffuse as L3DBitmapTextureResource).Width;
					sizeHeight = (diffuse as L3DBitmapTextureResource).Height;
				}
				SetTextureSize(subsetIndex, sizeWidth, sizeHeight, 0, 0, 0, 0, stage3D);
			}
			
			if(!isArraiedPart)
			{
				for(var i:int = ArrayPartIDs.length - 1;i>=0;i--)
				{
					var arrayPartID:String = ArrayPartIDs[i];
					if(arrayPartID != null && arrayPartID.length > 0)
					{
						var mesh:L3DMesh = null;
						for(var j:int = 0;j<combinedMesh.numChildren;j++)
						{
							var subObject:Object3D = combinedMesh.getChildAt(j);
							if(subObject != null && subObject is L3DMesh)
							{
								if(arrayPartID == (subObject as L3DMesh).UniqueID)
								{
									mesh = subObject as L3DMesh;
									break;
								}
							}
						}
						if(mesh != null && subsetIndex < mesh.numChildren)
						{
							var subObject:Object3D = mesh.getChildAt(subsetIndex);
							if(subObject != null && subObject is L3DMesh)
							{
								var subMesh:L3DMesh = subObject as L3DMesh;
								var material:Material = subMesh.getSurface(0).material;
								diffuse.upload(stage3D.context3D);
								if(material is TextureMaterial)
								{
									(material as TextureMaterial).diffuseMap = diffuse;
								}
								else if(material is LightMapMaterial)
								{
									(material as LightMapMaterial).diffuseMap = diffuse;
								}
								else if(material is StandardMaterial)
								{
									(material as StandardMaterial).diffuseMap = diffuse;
								}
								else
								{
									subMesh.getSurface(0).material = new TextureMaterial(diffuse);
								}
								subMesh.MaterialCode = code.toUpperCase();
								SetTextureSize(subsetIndex, sizeWidth, sizeHeight, 0, 0, 0, 0, stage3D);
							}
						}
					}
				}
			}
			
		//	materialCode = code.toUpperCase();
			
			return true;
		}
		
		public static function get Scale2D():Number
		{
			return scale2D;
		}
		
		public static function get ThicknessScale():Number
		{
			return thicknessScale;
		}
		
		public static function get MaxThickness():Number
		{
			return maxThickness;
		}
		
		private function ClearArrayPartIDs():void
		{
			if(arrayPartIDs == null)
			{
				arrayPartIDs = new Vector.<String>();
			}
			
			if(arrayPartIDs.length == 0)
			{
				return;
			}
			
			for(var i=arrayPartIDs.length - 1;i>=0;i--)
			{
				arrayPartIDs.pop();
			}
		}
		
		public function ToBuffer():ByteArray
		{
			var buffer:ByteArray = new ByteArray();
			
			buffer.writeInt(2016001);
			buffer.writeInt(windowLength);
			buffer.writeInt(windowHeight);
			var codeStr:String = partCode;
			if(PartMesh != null && PartMesh.url != null && PartMesh.url.length > 0)
			{
				codeStr += ":" + PartMesh.url
			}
			WriteString(buffer, codeStr);
			if(partMesh != null)
			{
				buffer.writeFloat(partMesh.x);
				buffer.writeFloat(partMesh.y);
				buffer.writeFloat(partMesh.z);
			}
			else
			{
				buffer.writeFloat(0);
				buffer.writeFloat(0);
				buffer.writeFloat(0);
			}
			buffer.writeInt(width);
			buffer.writeInt(height);
			buffer.writeInt(deltaX);
			buffer.writeInt(deltaY);
		    buffer.writeFloat(heightRatio);
			buffer.writeFloat(widthDivision);
			buffer.writeInt(sideOffDistance);
			buffer.writeInt(topOffDistance);
			buffer.writeInt(widthDelta);
			buffer.writeInt(heightDelta);
			buffer.writeInt(layer);
			buffer.writeInt(maxWidth);
			buffer.writeInt(minWdith);
			buffer.writeInt(maxHeight);
			buffer.writeInt(minHeight);
			buffer.writeBoolean(isWanlian);
			buffer.writeInt(wanlianMaxWidth);
			buffer.writeInt(arrayMode);
			WriteString(buffer, adhereToPartCode);
			buffer.writeInt(maxWanlianWidth);
			buffer.writeInt(minWindowLength);
			buffer.writeInt(maxWindowLength);
			buffer.writeInt(minWindowHeight);
			buffer.writeInt(maxWindowHeight);
			buffer.writeBoolean(isArraiedPart);
			buffer.writeBoolean(isMirrored);
			buffer.writeBoolean(isKeepSizeArrayMode);
			buffer.writeBoolean(isSpaceArrayMode);	
			buffer.writeInt(arraySpace);
			buffer.writeInt(arrayCount);
			buffer.writeInt(actuallyArrayCount);
			WriteString(buffer, materialCode);
			WriteString(buffer, materialSize);
			buffer.writeInt(wanlianDelta);
			if(ArrayPartIDs.length > 0)
			{
				buffer.writeInt(ArrayPartIDs.length);
				for(var i:int = 0;i < ArrayPartIDs.length;i++)
				{
					WriteString(buffer, ArrayPartIDs[i]);
				}
			}
			else
			{
				buffer.writeInt(0);
			}
			if(partMesh != null)
			{
				var numberMeshCount:int = 0;
				for(var i:int=0;i<partMesh.numChildren;i++)
				{
					var subObject:Object3D = partMesh.getChildAt(i);
					if(subObject != null && subObject is L3DMesh)
					{
						numberMeshCount++;
					}
				}
				buffer.writeInt(numberMeshCount);
				for(var i:int=0;i<partMesh.numChildren;i++)
				{
					var subObject:Object3D = partMesh.getChildAt(i);
					if(subObject != null && subObject is L3DMesh)
					{
						if((subObject as L3DMesh).caculation == null || (subObject as L3DMesh).caculation.IsArraiedPart)
						{
							continue;
						}
						var materialCode:String = (subObject as L3DMesh).MaterialCode;
						if(materialCode != null && materialCode.length > 0)
						{
							if((subObject as L3DMesh).numSurfaces > 0)
							{
								var inMaterial:Material = (subObject as L3DMesh).getSurface(0).material;
								if(inMaterial != null)
								{
									var indiffuse:TextureResource = null;
									if(inMaterial is LightMapMaterial)
									{
										indiffuse = (inMaterial as LightMapMaterial).diffuseMap;
									}
									else if(inMaterial is TextureMaterial)
									{
										indiffuse = (inMaterial as TextureMaterial).diffuseMap;
									}
									else if(inMaterial is StandardMaterial)
									{
										indiffuse = (inMaterial as StandardMaterial).diffuseMap;
									}
									if(indiffuse != null && indiffuse is L3DBitmapTextureResource)
									{
										if((indiffuse as L3DBitmapTextureResource).Url != null && (indiffuse as L3DBitmapTextureResource).Url.length > 0)
										{
											materialCode += ":" + (indiffuse as L3DBitmapTextureResource).Url;
										}
									}
								}
							}
						}

						WriteString(buffer, materialCode);
						WriteString(buffer, (subObject as L3DMesh).MaterialSize);
						WriteString(buffer, (subObject as L3DMesh).name.toUpperCase());
					}
				}
			}
			else
			{
				buffer.writeInt(0);
			}
			
			return buffer;
		}		

		public function FromBuffer(buffer:ByteArray):Boolean
		{
			if(buffer == null || buffer.length == 0)
			{
				return false;
			}		
			
			buffer.position = 0;
			var version:int = buffer.readInt();
			if(version != 2016001)
			{
				return FromBufferVersionZ(buffer);
			}
			windowLength = buffer.readInt();
			windowHeight = buffer.readInt();
			var codeStr:String = ReadString(buffer);
			if(codeStr == null || codeStr.length == 0)
			{
				return false;
			}
			if(codeStr.indexOf(":") > 0)
			{
				var tarr:Array = codeStr.split(":");
				if(tarr == null || tarr.length < 2)
				{
					return false;
				}
				partCode = tarr[0] as String;
				dataURL = tarr[1] as String;
			}
			else
			{
				partCode = codeStr;
			}
			x = buffer.readFloat();
			y = buffer.readFloat();
			z = buffer.readFloat();
			width = buffer.readInt();
			height = buffer.readInt();
			deltaX = buffer.readInt();
			deltaY = buffer.readInt();
			heightRatio = buffer.readFloat();
			widthDivision = buffer.readFloat();
			sideOffDistance = buffer.readInt();
			topOffDistance = buffer.readInt();
			widthDelta = buffer.readInt();
			heightDelta = buffer.readInt();
			layer = buffer.readInt();
			maxWidth = buffer.readInt();
			minWdith = buffer.readInt();
			maxHeight = buffer.readInt();
			minHeight = buffer.readInt();
			isWanlian = buffer.readBoolean();
			wanlianMaxWidth = buffer.readInt();
			arrayMode = buffer.readInt();
			adhereToPartCode = ReadString(buffer);
			maxWanlianWidth = buffer.readInt();
			minWindowLength = buffer.readInt();
			maxWindowLength = buffer.readInt();
			minWindowHeight = buffer.readInt();
			maxWindowHeight = buffer.readInt();
			isArraiedPart = buffer.readBoolean();
			isMirrored = buffer.readBoolean();
			isKeepSizeArrayMode = buffer.readBoolean();
			isSpaceArrayMode = buffer.readBoolean();	
			arraySpace = buffer.readInt();
			arrayCount = buffer.readInt();
			actuallyArrayCount = buffer.readInt();
			materialCode = ReadString(buffer);
			materialSize = ReadString(buffer);
			wanlianDelta = buffer.readInt();
			ClearArrayPartIDs();
			var count:int = buffer.readInt();
			if(count > 0)
			{
				for(var i:int=0;i<count;i++)
				{
					var arrayPartID:String = ReadString(buffer);
					if(arrayPartID != null && arrayPartID.length > 0)
					{
						ArrayPartIDs.push(arrayPartID);
					}
				}
			}
			loadMaterialCodes = new Vector.<String>();
			loadMaterialSizes = new Vector.<String>();
			loadMaterialSubsetNames = new Vector.<String>();
			count = buffer.readInt();
			if(count > 0)
			{
				for(var i:int=0;i<count;i++)
				{
					var materialCode:String = ReadString(buffer);
					loadMaterialCodes.push(materialCode);
					var materialSize:String = ReadString(buffer);
					loadMaterialSizes.push(materialSize);
					var materialSubsetName:String = ReadString(buffer);
					loadMaterialSubsetNames.push(materialSubsetName);
				}
			}
			
			return true;
		}
		
		public function FromBufferVersionD(buffer:ByteArray):Boolean
		{
			if(buffer == null || buffer.length == 0)
			{
				return false;
			}		
			
			buffer.position = 0;
			windowLength = buffer.readInt();
			windowHeight = buffer.readInt();
			partCode = ReadString(buffer);
			x = buffer.readFloat();
			y = buffer.readFloat();
			z = buffer.readFloat();
			width = buffer.readInt();
			height = buffer.readInt();
			deltaX = buffer.readInt();
			deltaY = buffer.readInt();
			heightRatio = buffer.readFloat();
			widthDivision = buffer.readFloat();
			sideOffDistance = buffer.readInt();
			topOffDistance = buffer.readInt();
			widthDelta = buffer.readInt();
			heightDelta = buffer.readInt();
			layer = buffer.readInt();
			maxWidth = buffer.readInt();
			minWdith = buffer.readInt();
			maxHeight = buffer.readInt();
			minHeight = buffer.readInt();
			isWanlian = buffer.readBoolean();
			wanlianMaxWidth = buffer.readInt();
			arrayMode = buffer.readInt();
			adhereToPartCode = ReadString(buffer);
			maxWanlianWidth = buffer.readInt();
			minWindowLength = buffer.readInt();
			maxWindowLength = buffer.readInt();
			minWindowHeight = buffer.readInt();
			maxWindowHeight = buffer.readInt();
			isArraiedPart = buffer.readBoolean();
			isMirrored = buffer.readBoolean();
			isKeepSizeArrayMode = buffer.readBoolean();
			isSpaceArrayMode = buffer.readBoolean();	
			arraySpace = buffer.readInt();
			arrayCount = buffer.readInt();
			actuallyArrayCount = buffer.readInt();
			materialCode = ReadString(buffer);
			wanlianDelta = buffer.readInt();
			ClearArrayPartIDs();
			var count:int = buffer.readInt();
			if(count > 0)
			{
				for(var i:int=0;i<count;i++)
				{
					var arrayPartID:String = ReadString(buffer);
					if(arrayPartID != null && arrayPartID.length > 0)
					{
						ArrayPartIDs.push(arrayPartID);
					}
				}
			}
			loadMaterialCodes = new Vector.<String>();
			loadMaterialSizes = new Vector.<String>();
			loadMaterialSubsetNames = new Vector.<String>();
			count = buffer.readInt();
			if(count > 0)
			{
				for(var i:int=0;i<count;i++)
				{
					var materialCode:String = ReadString(buffer);
					loadMaterialCodes.push(materialCode);
					var materialSize:String = ReadString(buffer);
					loadMaterialSizes.push(materialSize);
				}
			}
			
			return true;
		}
		
		public function FromBufferVersionZ(buffer:ByteArray):Boolean
		{
			if(buffer == null || buffer.length == 0)
			{
				return false;
			}		
			
			buffer.position = 0;
			windowLength = buffer.readInt();
			windowHeight = buffer.readInt();
			var codeStr:String = ReadString(buffer);
			if(codeStr == null || codeStr.length == 0)
			{
				return false;
			}
			if(codeStr.indexOf(":") > 0)
			{
				var tarr:Array = codeStr.split(":");
				if(tarr == null || tarr.length < 2)
				{
					return false;
				}
				partCode = tarr[0] as String;
				dataURL = tarr[1] as String;
			}
			else
			{
				partCode = codeStr;
			}
            x = buffer.readFloat();
			y = buffer.readFloat();
			z = buffer.readFloat();
			width = buffer.readInt();
			height = buffer.readInt();
			deltaX = buffer.readInt();
			deltaY = buffer.readInt();
			heightRatio = buffer.readFloat();
			widthDivision = buffer.readFloat();
			sideOffDistance = buffer.readInt();
			topOffDistance = buffer.readInt();
			widthDelta = buffer.readInt();
			heightDelta = buffer.readInt();
			layer = buffer.readInt();
			maxWidth = buffer.readInt();
			minWdith = buffer.readInt();
			maxHeight = buffer.readInt();
			minHeight = buffer.readInt();
			isWanlian = buffer.readBoolean();
			wanlianMaxWidth = buffer.readInt();
			arrayMode = buffer.readInt();
			adhereToPartCode = ReadString(buffer);
			maxWanlianWidth = buffer.readInt();
			minWindowLength = buffer.readInt();
			maxWindowLength = buffer.readInt();
			minWindowHeight = buffer.readInt();
			maxWindowHeight = buffer.readInt();
			isArraiedPart = buffer.readBoolean();
			isMirrored = buffer.readBoolean();
			isKeepSizeArrayMode = buffer.readBoolean();
			isSpaceArrayMode = buffer.readBoolean();	
			arraySpace = buffer.readInt();
			arrayCount = buffer.readInt();
			actuallyArrayCount = buffer.readInt();
			materialCode = ReadString(buffer);
			materialSize = ReadString(buffer);
			wanlianDelta = buffer.readInt();
			ClearArrayPartIDs();
			var count:int = buffer.readInt();
			if(count > 0)
			{
				for(var i:int=0;i<count;i++)
				{
					var arrayPartID:String = ReadString(buffer);
					if(arrayPartID != null && arrayPartID.length > 0)
					{
						ArrayPartIDs.push(arrayPartID);
					}
				}
			}
			loadMaterialCodes = new Vector.<String>();
			loadMaterialSizes = new Vector.<String>();
			loadMaterialSubsetNames = new Vector.<String>();
			count = buffer.readInt();
			if(count > 0)
			{
				for(var i:int=0;i<count;i++)
				{
					var materialCode:String = ReadString(buffer);
					loadMaterialCodes.push(materialCode);
					var materialSize:String = ReadString(buffer);
					loadMaterialSizes.push(materialSize);
				}
			}
			
			return true;
		}
		
		public function SetupLoadFunction(fun:Function):Boolean
		{
			if(fun == null)
			{
				return false;
			}
			
			loadCompleteFun = fun;
			return true;
		}
		
		public function ClearLoadFunction():void
		{		
			if(partMesh != null)
			{
				partMesh.visible = false;
			}
			loadCompleteFun = null;
		}
		
		public function get InnerArraySpace():int
		{
		    return arraySpace;	
		}
		
		public function get InnerArrayCount():int
		{
		    return arrayCount;	
		}
		
		public function get InnerActuallyArrayCount():int
		{
			return actuallyArrayCount;
		}
		
		public function get HadMadeCombintion():Boolean
		{
			return hadMadeCombintion;
		}		
		
		public function LoadPartModel(module:L3DPartsModule, stage3D:Stage3D):void
		{
			hadSearchedPartCode = false;
			
			if(module == null || stage3D == null || partCode == null || partCode.length == 0)
			{				
				L3DPartsModule.LoadingPartsMode = false;
				return;
			}
			
			this.module = module;
			this.stage3D = stage3D;
    		combinedMesh = module.CombinedMesh;
			ClearArrayPartIDs();
			hadMadeCombintion = false;
			windowLength = module.WindowLength;
			windowHeight = module.WindowHeight;
			maxWindowLength = module.MaxWindowLength;
			minWindowLength = module.MinWindowLength;
			maxWindowHeight = module.MaxWindowHeight;
			minWindowHeight = module.MinWindowHeight;
			
			var checkCode:String = partCode;
			checkPartCode = partCode;
			if(checkCode.indexOf("*") > 0)
			{
				var tarr:Array = checkCode.split("*");
				checkCode = tarr[0] as String;
			}
			
			if(dataURL != null && dataURL.length > 0)
			{
				var loadingMaterial:L3DMaterialInformations = new L3DMaterialInformations();
				loadingMaterial.addEventListener(L3DLibraryEvent.DownloadMaterialInfo, LoadMaterialInfoFromURL);
				loadingMaterial.LoadMaterialInformation(dataURL, 3);
			}
			else
			{
				var loadingMaterial:L3DMaterialInformations = new L3DMaterialInformations();
				loadingMaterial.addEventListener(L3DLibraryEvent.DownloadMaterialInfo, SearchMaterialInfoHandler);
				loadingMaterial.SearchMaterialInformation(checkCode, 3);
				hadSearchedPartCode = true;
			}
		}
		
		private function SearchMaterialInfoHandler(event:L3DLibraryEvent):void
		{
			var lm:L3DMaterialInformations = event.target as L3DMaterialInformations;
			lm.removeEventListener(L3DLibraryEvent.DownloadMaterialInfo, SearchMaterialInfoHandler);
			
			var lmaterial:L3DMaterialInformations = event.MaterialInformation;
			if(lmaterial == null || lmaterial.type != 4)
			{
				if(loadCompleteFun != null)
				{
					loadCompleteFun(this);
				}
				return;
			}
			
			lmaterial.addEventListener(L3DLibraryEvent.DownloadMaterial, LoadMaterialBufferCompleteHandler);
			lmaterial.DownloadMaterial();
		}
		
		private function LoadMaterialInfoFromURL(event:L3DLibraryEvent):void
		{
			var lm:L3DMaterialInformations = event.target as L3DMaterialInformations;
			lm.removeEventListener(L3DLibraryEvent.DownloadMaterialInfo, LoadMaterialInfoFromURL);
			
			var lmaterial:L3DMaterialInformations = event.MaterialInformation;
			if(lmaterial == null || lmaterial.type != 4)
			{
				var checkCode:String = partCode;
				checkPartCode = partCode;
				if(checkCode.indexOf("*") > 0)
				{
					var tarr:Array = checkCode.split("*");
					checkCode = tarr[0] as String;
				}
				var loadingMaterial:L3DMaterialInformations = new L3DMaterialInformations();
				loadingMaterial.addEventListener(L3DLibraryEvent.DownloadMaterialInfo, SearchMaterialInfoHandler);
				loadingMaterial.SearchMaterialInformation(checkCode, 3);
				hadSearchedPartCode = true;
				return;
			}
			
			lmaterial.addEventListener(L3DLibraryEvent.DownloadMaterial, LoadMaterialBufferCompleteHandler);
			lmaterial.DownloadMaterial();
		}
		
		private function LoadMaterialBufferCompleteHandler(event:L3DLibraryEvent):void
		{
			var material:L3DMaterialInformations = event.target as L3DMaterialInformations;
			material.removeEventListener(L3DLibraryEvent.DownloadMaterial, LoadMaterialBufferCompleteHandler);		
			
			dynamicCode = material.code;
			dynamicName = material.name;
			dynamicURL = material.url;
			
			var buffer:ByteArray = event.MaterialBuffer;
			
			if(buffer == null || buffer.length == 0)
			{
				if(!hadSearchedPartCode)
				{
					var checkCode:String = partCode;
					checkPartCode = partCode;
					if(checkCode.indexOf("*") > 0)
					{
						var tarr:Array = checkCode.split("*");
						checkCode = tarr[0] as String;
					}
					var loadingMaterial:L3DMaterialInformations = new L3DMaterialInformations();
					loadingMaterial.addEventListener(L3DLibraryEvent.DownloadMaterialInfo, SearchMaterialInfoHandler);
					loadingMaterial.SearchMaterialInformation(checkCode, 3);
					hadSearchedPartCode = true;
					return;
				}
				else
				{
					if(loadCompleteFun != null)
					{
						loadCompleteFun(this);
					}
					return;
				}
			}
			
			BuildFromBuffer(buffer);
		}
		
		private function BuildFromBuffer(buffer:ByteArray):void
		{
			if(buffer == null || buffer.length == 0)
			{
				if(loadCompleteFun != null)
				{
					loadCompleteFun(this);
				}
				L3DPartsModule.LoadingPartsMode = false;
				return;
			}
			
			var vmodel:L3DModel = L3DModel.FromBuffer(buffer);
			if(vmodel == null || !vmodel.Exist)
			{
				if(loadCompleteFun != null)
				{
					loadCompleteFun(this);
				}
				L3DPartsModule.LoadingPartsMode = false;
				return;
			}
			vmodel.mode = 5;
			var mesh:L3DMesh = vmodel.Export(stage3D, true, false);
			vmodel.Clear();
			if(mesh == null)
			{
				if(loadCompleteFun != null)
				{
					loadCompleteFun(this);
				}
				L3DPartsModule.LoadingPartsMode = false;
				return;
			}
			mesh.Code = dynamicCode;
			mesh.name = dynamicName;
			mesh.url = dynamicURL;
			if(isMirrored)
			{
				mesh.Mirror(Vector3D.X_AXIS);
				mesh.Align(3);
				mesh.mirror = true;
			}
			PartMesh = mesh;
			if(Height > windowHeight)
			{
				Height = windowHeight;
			}
			mesh.Length = Width;
			mesh.Height = Height;
			mesh.x = x;
			mesh.y = y;
			mesh.z = z;
			mesh.caculation.CombinedMesh = combinedMesh;
			mesh.layer = Layer;
			if(combinedMesh != null && !combinedMesh.contains(mesh))
			{
				combinedMesh.addChild(mesh);
			}
			mesh.caculation = this;	
			mesh.Code = checkPartCode;
			if(mesh.Name == null || mesh.Name.length == 0)
			{
				mesh.Name = checkPartCode;
			}
			AmendForSizeChanged();			
			
			if(loadMaterialCodes.length > 0)
			{
				if(loadMaterialSubsetNames.length == 0)
				{
					var loadCount:int = 0;
					for(var j:int = 0;j< partMesh.numChildren;j++)
					{
						var subObject:Object3D = partMesh.getChildAt(j);
						if(subObject != null && subObject is L3DMesh)
						{
							var subMesh:L3DMesh = subObject as L3DMesh;
							if(subMesh.caculation == null || subMesh.caculation.IsArraiedPart)
							{
								continue;
							}
							var loadMaterialCode:String = loadMaterialCodes[loadCount];
							if(loadMaterialCode != null && loadMaterialCode.indexOf(":") > 0)
							{
								var marr:Array = loadMaterialCode.split(":");
								if(marr == null || marr.length < 2)
								{
									continue;
								}
								subMesh.MaterialCode = marr[0] as String;
								var materialURL:String = marr[1] as String;
								subMesh.userData2 = materialURL;
							}
							else
							{
								subMesh.MaterialCode = loadMaterialCode;
							}
							//	subMesh.MaterialCode = loadMaterialCodes[loadCount];						
							if(loadMaterialSizes != null && loadCount < loadMaterialSizes.length)
							{
								subMesh.MaterialSize = loadMaterialSizes[loadCount];
							}
							else
							{
								subMesh.MaterialSize = "";
							}
							loadCount++;
							if(loadCount >= loadMaterialCodes.length)
							{
								break;
							}
						}
					}
				}
				else
				{
					for(var i:int = 0; i<loadMaterialCodes.length; i++)
					{
						var checkSubsetName:String = loadMaterialSubsetNames[i] == null ? "" : loadMaterialSubsetNames[i].toUpperCase();
						for(var j:int = 0;j< partMesh.numChildren;j++)
						{
							var subObject:Object3D = partMesh.getChildAt(j);
							if(subObject != null && subObject is L3DMesh)
							{
								var subMesh:L3DMesh = subObject as L3DMesh;
								if(subMesh.caculation == null || subMesh.caculation.IsArraiedPart)
								{
									continue;
								}
								var subsetName:String = subMesh.name == null ? "" : subMesh.name.toUpperCase();
								if(checkSubsetName == subsetName)
								{
									var loadMaterialCode:String = loadMaterialCodes[i];
									if(loadMaterialCode != null && loadMaterialCode.indexOf(":") > 0)
									{
										var marr:Array = loadMaterialCode.split(":");
										if(marr == null || marr.length < 2)
										{
											continue;
										}
										subMesh.MaterialCode = marr[0] as String;
										var materialURL:String = marr[1] as String;
										subMesh.userData2 = materialURL;
									}
									else
									{
										subMesh.MaterialCode = loadMaterialCode;
									}				
									if(loadMaterialSizes != null && i < loadMaterialSizes.length)
									{
										subMesh.MaterialSize = loadMaterialSizes[i];
									}
									else
									{
										subMesh.MaterialSize = "";
									}
									break;
								}
							}
						}
					}
				}
			}
			
			for(var k:int = 0;k< partMesh.numChildren;k++)
			{
				var subObject:Object3D = partMesh.getChildAt(k);
				if(subObject != null && subObject is L3DMesh)
				{
					var subMesh:L3DMesh = subObject as L3DMesh;
					if(subMesh.MaterialCode != null && subMesh.MaterialCode.length > 0)
					{
						var materialURL:String = subMesh.userData2 == null ? "" : subMesh.userData2 as String;
						if(materialURL.length > 0)
						{
							var loadingMaterial:L3DMaterialInformations = new L3DMaterialInformations();
							loadingMaterial.userData = subMesh;
							loadingMaterial.userData3 = false;
							loadingMaterial.addEventListener(L3DLibraryEvent.DownloadMaterialInfo, LoadTextureInfoFromURL);
							loadingMaterial.LoadMaterialInformation(dataURL, 3);
						}
						else
						{
							var loadingMaterial:L3DMaterialInformations = new L3DMaterialInformations();
							loadingMaterial.userData = subMesh;
							loadingMaterial.userData3 = true;
							loadingMaterial.addEventListener(L3DLibraryEvent.DownloadMaterialInfo, SearchTextureInfoHandler);
							loadingMaterial.SearchMaterialInformation(subMesh.MaterialCode, 3);
						}
			//			break;
					}
				}
			}
			
		//	if(!hadMadeMaterialCode)
		//	{
			if(loadCompleteFun != null)
			{
				loadCompleteFun(this);
			}
		//	}
		}
		
		private function LoadTextureInfoFromURL(event:L3DLibraryEvent):void
		{
			var lm:L3DMaterialInformations = event.target as L3DMaterialInformations;
			lm.removeEventListener(L3DLibraryEvent.DownloadMaterialInfo, LoadMaterialInfoFromURL);
			
			var lmaterial:L3DMaterialInformations = event.MaterialInformation;
			if(lmaterial == null || lmaterial.type == 4)
			{
				var loadingMaterial:L3DMaterialInformations = new L3DMaterialInformations();
				loadingMaterial.userData = lm.userData;
				loadingMaterial.userData3 = true;
				loadingMaterial.addEventListener(L3DLibraryEvent.DownloadMaterialInfo, SearchTextureInfoHandler);
				loadingMaterial.SearchMaterialInformation((loadingMaterial.userData as L3DMesh).MaterialCode, 3);
				return;
			}

			lmaterial.userData = lm.userData;
			lmaterial.userData3 = lm.userData3;
			lmaterial.addEventListener(L3DLibraryEvent.DownloadMaterial, LoadTextureBufferCompleteHandler);
			lmaterial.DownloadMaterial();
		}
		
		private function SearchTextureInfoHandler(event:L3DLibraryEvent):void
		{
			var lm:L3DMaterialInformations = event.target as L3DMaterialInformations;
			lm.removeEventListener(L3DLibraryEvent.DownloadMaterialInfo, SearchTextureInfoHandler);
			
			var lmaterial:L3DMaterialInformations = event.MaterialInformation;
			if(lmaterial == null || lmaterial.type == 4)
			{				
			//	var subObject:Object3D = PartMesh.getChildAt(currentCompuSubsetIndex);
				var subObject:Object3D = lm.userData as Object3D;
				if(subObject != null && subObject is L3DMesh)
				{
					var subMesh:L3DMesh = subObject as L3DMesh;
					var material:Material = subMesh.getSurface(0).material;
					var diffuse:L3DBitmapTextureResource = new L3DBitmapTextureResource(new BitmapData(16,16,false, 0xffffff), null, stage3D, false, 512);
					diffuse.upload(stage3D.context3D);
					if(material is TextureMaterial)
					{
						if((material as TextureMaterial).diffuseMap != null)
						{
							(material as TextureMaterial).diffuseMap.dispose();
							(material as TextureMaterial).diffuseMap = null;
						}
						(material as TextureMaterial).diffuseMap = diffuse;
					}
					else if(material is LightMapMaterial)
					{
						if((material as LightMapMaterial).diffuseMap != null)
						{
							(material as LightMapMaterial).diffuseMap.dispose();
							(material as LightMapMaterial).diffuseMap = null;
						}
						(material as LightMapMaterial).diffuseMap = diffuse;
					}
					else if(material is StandardMaterial)
					{
						if((material as StandardMaterial).diffuseMap != null)
						{
							(material as StandardMaterial).diffuseMap.dispose();
							(material as StandardMaterial).diffuseMap = null;
						}
						(material as StandardMaterial).diffuseMap = diffuse;
					}
					else
					{
						subMesh.getSurface(0).material = new TextureMaterial(diffuse);
					}
				}
				
				return;
			}
			
			lmaterial.userData = lm.userData;
			lmaterial.userData3 = lm.userData3;
			lmaterial.addEventListener(L3DLibraryEvent.DownloadMaterial, LoadTextureBufferCompleteHandler);
			lmaterial.DownloadMaterial();
		}
		
		private function LoadTextureBufferCompleteHandler(event:L3DLibraryEvent):void
		{
			var cmaterial:L3DMaterialInformations = event.target as L3DMaterialInformations;
			cmaterial.removeEventListener(L3DLibraryEvent.DownloadMaterial, LoadMaterialBufferCompleteHandler);
			
			var textureBuffer:ByteArray = event.MaterialBuffer;
			if(textureBuffer != null && textureBuffer.length > 0)
			{
				var subObject:Object3D = cmaterial.userData as Object3D;
				if(subObject != null && subObject is L3DMesh)
				{
					var subMesh:L3DMesh = subObject as L3DMesh;
					var material:Material = subMesh.getSurface(0).material;
					var diffuse:L3DBitmapTextureResource = new L3DBitmapTextureResource(null, textureBuffer, stage3D, false, 512);
					diffuse.Code = cmaterial.code;
					diffuse.ERPCode = cmaterial.ERPCode;
					diffuse.VRMMode = cmaterial.vrmMode;
					diffuse.RenderMode = cmaterial.renderMode;
					diffuse.Name = cmaterial.name;
					diffuse.Url = cmaterial.url;
					diffuse.upload(stage3D.context3D);
					if(material is TextureMaterial)
					{
						if((material as TextureMaterial).diffuseMap != null)
						{
							(material as TextureMaterial).diffuseMap.dispose();
							(material as TextureMaterial).diffuseMap = null;
						}
						(material as TextureMaterial).diffuseMap = diffuse;
					}
					else if(material is LightMapMaterial)
					{
						if((material as LightMapMaterial).diffuseMap != null)
						{
							(material as LightMapMaterial).diffuseMap.dispose();
							(material as LightMapMaterial).diffuseMap = null;
						}
						(material as LightMapMaterial).diffuseMap = diffuse;
					}
					else if(material is StandardMaterial)
					{
						if((material as StandardMaterial).diffuseMap != null)
						{
							(material as StandardMaterial).diffuseMap.dispose();
							(material as StandardMaterial).diffuseMap = null;
						}
						(material as StandardMaterial).diffuseMap = diffuse;
					}
					else
					{
						subMesh.getSurface(0).material = new TextureMaterial(diffuse);
					}
				}
			}
			else
			{	
				var hadSearchMaterial:Boolean = cmaterial.userData3 as Boolean;
				if(hadSearchMaterial)
				{
					var subObject:Object3D = cmaterial.userData as Object3D;
					if(subObject != null && subObject is L3DMesh)
					{
						var subMesh:L3DMesh = subObject as L3DMesh;
						var material:Material = subMesh.getSurface(0).material;
						var diffuse:L3DBitmapTextureResource = new L3DBitmapTextureResource(new BitmapData(16,16,false, 0xffffff), null, stage3D, false, 512);
						diffuse.upload(stage3D.context3D);
						if(material is TextureMaterial)
						{
							if((material as TextureMaterial).diffuseMap != null)
							{
								(material as TextureMaterial).diffuseMap.dispose();
								(material as TextureMaterial).diffuseMap = null;
							}
							(material as TextureMaterial).diffuseMap = diffuse;
						}
						else if(material is LightMapMaterial)
						{
							if((material as LightMapMaterial).diffuseMap != null)
							{
								(material as LightMapMaterial).diffuseMap.dispose();
								(material as LightMapMaterial).diffuseMap = null;
							}
							(material as LightMapMaterial).diffuseMap = diffuse;
						}
						else if(material is StandardMaterial)
						{
							if((material as StandardMaterial).diffuseMap != null)
							{
								(material as StandardMaterial).diffuseMap.dispose();
								(material as StandardMaterial).diffuseMap = null;
							}
							(material as StandardMaterial).diffuseMap = diffuse;
						}
						else
						{
							subMesh.getSurface(0).material = new TextureMaterial(diffuse);
						}
					}
				}
				else
				{
					var loadingMaterial:L3DMaterialInformations = new L3DMaterialInformations();
					loadingMaterial.userData = cmaterial.userData;
					loadingMaterial.userData3 = true;
					loadingMaterial.addEventListener(L3DLibraryEvent.DownloadMaterialInfo, SearchTextureInfoHandler);
					loadingMaterial.SearchMaterialInformation((loadingMaterial.userData as L3DMesh).MaterialCode, 3);
				}
			}
		}
		
		public function MakeCombintion():Boolean
		{
			if(!Exist || module == null || stage3D == null)
			{
				return false;
			}
			
			L3DPartsModule.LoadingPartsMode = false;
			hadMadeCombintion = true;
			return true;
		}
		
		public static function WriteString(buffer:ByteArray, text:String):Boolean
		{
			if(buffer == null)
			{
				return false;
			}
			
			if(text == null || text.length == 0)
			{
				buffer.writeInt(0);
				return true;
			}
			
			var textBuffer:ByteArray = new ByteArray();
			textBuffer.writeUTFBytes(text.toUpperCase());
			buffer.writeInt(textBuffer.length);
			buffer.writeBytes(textBuffer,0,textBuffer.length);
			
			return true;
		}
		
		public static function ReadString(buffer:ByteArray):String
		{
			if(buffer == null)
			{
				return "";
			}
			
			var l:int = buffer.readInt();
			if(l == 0)
			{
				return "";
			}
			
			var textBuffer:ByteArray = new ByteArray();
			buffer.readBytes(textBuffer,0,l);
			textBuffer.position = 0;
			
			var text:String = textBuffer.readUTFBytes(textBuffer.length);
			if(text == null || text.length == 0)
			{
				return "";
			}
			
			return text.toUpperCase();
		}
		
		private static function UploadResources(object:Object3D, context:Context3D):void
		{
			for each (var res:Resource in object.getResources(true))
			{
				res.upload(context);
			}
		}
	}
}