package de.mime.rw.world.gridData 
{
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Manuel Hanisch
	 */
	public class Biome 
	{
		
		
		
		public var name:String;
		public var uniqueID:String;
		public var baseColor:uint;
		
		public var environments:Vector.<Environment>;
		public var environments_dropRates:Vector.<int>;
		
		
		private var _temp_start:int;
		private var _temp_end:int;
		private var _rain_start:int;
		private var _rain_end:int;
		
		
		private var BiomeDiagramPositions:Vector.<Rectangle>; // x = temperature, y = rain
		
		
		
		public function Biome(xmlBiome:XML = null,globalEnvironments:Dictionary = null) 
		{
			
			environments = new Vector.<Environment>;
			environments_dropRates = new Vector.<int>;
			
			
			if (xmlBiome != null && globalEnvironments != null) {				
				
				
				setRange(xmlBiome.temperature.@start, xmlBiome.temperature.@end, xmlBiome.rain.@start, xmlBiome.rain.@end);
				name = xmlBiome.name;
				uniqueID = xmlBiome.uniqueID;
				baseColor = uint("0x" + xmlBiome.basecolor);
				
				
				for each(var env:XML in xmlBiome.environments.environment) {
					
					
					if (globalEnvironments[String(env.linkID)] != null) {	
						
						environments.push(globalEnvironments[String(env.linkID)]);
						environments_dropRates.push(int(env.dropRate));
						
					}
					
					
					
				}
				
				
			}
			
			
		}
		
		public function getRange():Vector.<int> {
			
			return Vector.<int>([_temp_start,_temp_end,_rain_start,_rain_end]);
			
		}
		private function setRange(ts:int = -1, te:int = -1, rs:int = -1, re:int = -1):void {
			
			if(ts >= 0) _temp_start = ts;
			if(te >= 0) _temp_end = te;
			if(rs >= 0) _rain_start = rs;
			if(re >= 0) _rain_end = re;
			
		}
		
		
		
	}

}