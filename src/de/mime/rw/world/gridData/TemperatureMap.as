package de.mime.rw.world.gridData 
{	
	import de.mime.utils.ds.Array2D;
	/**
	 * ...
	 * @author Manuel Hanisch
	 */
	public class TemperatureMap 
	{
		
		public var probability:int;
		public var map:Array2D;
		
		
		public static const WIDTH:int = 10;
		public static const HEIGHT:int = 10;
		
		public function TemperatureMap(xmlMap:XML) 
		{
			
			
			
			var p:int = int(xmlMap.probability);
			
			
			if (p < 0) this.probability = 0;
			else if (p > 3) this.probability = 3;
			else this.probability = p;
			
						
			
			this.map = new Array2D(10, 10);
			
			for (var x:int = 0; x < 10; x++) {
				for (var y:int = 0; y < 10; y++) {
					
					map.set(x, y, int(xmlMap.map.cell.(@x==x && @y==y)[0]));
					
				}
				
				
			}
			
			
			
			
		}
		
	}

}

