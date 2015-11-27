package de.mime.rw.world.gridData.voigraph 
{
	
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Manuel Hanisch
	 */
	public class Center 
	{		

		
		public var gridX:int;
		public var gridY:int;
		
		
		
		public var onFrameBorder:Boolean; //if an edge hits frameborder (calculated in voigraph)		
		public var neighbors:Vector.<Center>;
		public var borders:Vector.<Edge>;
		public var corners:Vector.<Corner>;
		
		
		public function Center() {
			
			onFrameBorder = false;
			
			neighbors = new Vector.<Center>();
			borders = new Vector.<Edge>();
			corners = new Vector.<Corner>();
			
		}

		
	}

}