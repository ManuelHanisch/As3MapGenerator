package de.mime.rw.world.gridData 
{
	
	import de.mime.rw.world.gridData.voigraph.Center;
	import de.mime.rw.world.gridData.voigraph.Corner;
	import de.mime.rw.world.gridData.voigraph.Edge;
	
	/**
	 * ...
	 * @author Manuel Hanisch
	 */
	public class Location 
	{		
		
		
		public var gridX:int;
		public var gridY:int;
		
		private var _hub:Hub;
		private var _biome:Biome;
		public var isCoast:Boolean;
		
		public var environment:Environment;
		public var environment_sprite:int;
		
		
		
		
		public var onEdges:Vector.<Edge>;				
		public var onCorners:Vector.<Corner>;
		
		private var _temperature:int;
		private var _rain:int;
		
		
		//public var path:int;// temporary
		
		public function Location(x:int,y:int,h:Hub) { 
			
			
			gridX = x;
			gridY = y;
			
			_hub = h;
			
			onEdges = new Vector.<Edge>;
			isCoast = false;
			
			onCorners = new Vector.<Corner>;
			
			
			
		}
		
		
		
		
		public function get hub():Hub {
			return _hub;
		}
		public function setHub(h:Hub):void {
			_hub = h;
		}
		
		public function get biome():Biome {
			return _biome;
		}
		public function setBiome(b:Biome):void {			
			_biome = b;
		}	
		
		public function get temperature():int {
			return _temperature;
		}
		public function setTemperature(t:int):void {
			_temperature = t;			
		}
		
		
		public function get rain():int {
			return _rain;
		}
		public function setRain(r:int):void {
			_rain = r;			
		}
		
		
		public function isHub():Boolean {
			if (!_hub.emptyhub && gridX == _hub.center.gridX && gridY == _hub.center.gridY) return true;
			else return false;
		}
		
		
		
	}

}