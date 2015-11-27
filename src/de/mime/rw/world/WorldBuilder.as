package de.mime.rw.world 
{
	import de.mime.rw.world.gridData.Grid;
	import de.mime.rw.world.mapData.PaintedMap;
	import de.mime.utils.math.PM_PRNG;
	import de.mime.utils.XMLLoader;
	
	/*
	 * change with starling classes inside game
	*/	
	/*
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.textures.Texture;
	*/	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	
	
	
	/**
	 * ...
	 * @author Manuel Hanisch
	 */
	public class WorldBuilder 
	{
		
		private var _seed:uint;
		private var _rng:PM_PRNG;
				
		private var _gridData:Grid;
		private var _paintedMapData:PaintedMap;		
		private var _worldMap:Sprite;
		
		private var _created:Boolean;
		
		
		public function WorldBuilder(seed:uint = 0) 
		{
			
			_created = false;
			
			_rng = new PM_PRNG();			
			if (seed > 0) _rng.seed = seed;
			else _rng.seed = uint(new Date().time);			
			_seed = _rng.seed;
			
			
			
		}
		
		public function createWorld():WorldBuilder {
			
			
			//XML LOADING
			var tempMapsXML:XML = XMLLoader.loadXMLFromFile("temperaturemaps.xml");
			var rainMapsXML:XML = XMLLoader.loadXMLFromFile("rainmaps.xml");
			var envXML:XML = XMLLoader.loadXMLFromFile("environments.xml");
			var biomesXML:XML = XMLLoader.loadXMLFromFile("biomes.xml");
			
			//IMAGE LOADING
			//TODO - asynch with events, will probably be implemented inside game framework
			
			
			
			
			_gridData = new Grid(_rng, 45, 65, tempMapsXML, rainMapsXML, biomesXML, envXML);
			
			
			
			
			
			_paintedMapData = new PaintedMap(_rng, _gridData);
			
			_worldMap = new Sprite();
			
			/*
			 * change with starling classes inside game
			*/
			//_worldMap.addChild(new Image(Texture.fromBitmapData(_paintedMapData.paintedMapBackground, false, false)));
			//_worldMap.addChild(new Image(Texture.fromBitmapData(_paintedMapData.paintedMap, false, false)));
			
			_worldMap.addChild(new Bitmap(_paintedMapData.paintedMapBackground));
			_worldMap.addChild(new Bitmap(_paintedMapData.paintedMap));
			
			
			_created = true;
			
			return this;
			
		}
		
		
		public function get seed():uint {
			return _seed;
		}
		public function get worldMap():Sprite {
			return _worldMap;
		}
		public function get created():Boolean {
			return _created;
		}
		
	}

}