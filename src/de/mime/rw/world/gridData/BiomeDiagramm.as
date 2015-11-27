package de.mime.rw.world.gridData 
{	
	import de.mime.utils.ds.Array2D;
	import de.mime.utils.ds.Array2DIterator;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Manuel Hanisch
	 */
	public class BiomeDiagramm
	{
		
		public var map:Array2D;
		
		
		public static const WIDTH:int = 10;
		public static const HEIGHT:int = 10;
		
		public function BiomeDiagramm(biomes:Dictionary) 
		{
			
			map = new Array2D(10, 10);
			
			
			for each (var b:Biome in biomes) 
			{
				
				var rg:Vector.<int> = b.getRange();
				for (var t:int = rg[0]; t <= rg[1]; t++) {
					for (var r:int = rg[2]; r <= rg[3]; r++) {
						
						map.set(t, r, b);
					
					}
				}
				
				
			}
			
			
			//fill empty with oceans
			var it:Array2DIterator = Array2DIterator(map.getIterator());	
			var m:Biome;
			var c:Point;
			while (it.hasNext()) {
				
				m = it.next();
				c = it.cursor;
				
				if (m == null) map.set(c.x, c.y, biomes[0]);			
				
			}
			
			
			
			//trace(Biome(map.get(4, 6)).name);
		
			
			
			
		}
		
		
		public function getBiome(temperaturePos:int, rainPosition:int):Biome {
			return Biome(map.get(temperaturePos,rainPosition));
		}
		
	}

}
