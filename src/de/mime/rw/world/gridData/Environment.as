package de.mime.rw.world.gridData 
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Manuel Hanisch
	 */
	public class Environment 
	{
		
		public var name:String;
		public var uniqueID:String;
		
		public var sprBitmapVariations:Vector.<Bitmap>;
		public var sprOffset:Point;
		public var sprUsedTiles:Vector.<Point>;
		public var sprOriginTile:Point; //Most top, most left Coordinate. 
		
		
		public function Environment(xmlEnv:XML) {
			
			
			name = xmlEnv.name;
			uniqueID = xmlEnv.uniqueID;
			
			sprBitmapVariations = new Vector.<Bitmap>;
			//Upload needed : 
			//for each(var x:XML in xmlEnv.sprite.variations.variation) sprBitmapVariations.push(new Point(tl.@x, tl.@y));
			/*
			var imageLoader:Loader = new Loader();
			var image:URLRequest = new URLRequest(File.applicationDirectory.url + spriteFileName);
			
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			imageLoader.load(image);			
			*/
			 
			sprOffset = new Point(int(xmlEnv.sprite.offset.@x), int(xmlEnv.sprite.offset.@y));
			
			sprUsedTiles = new Vector.<Point>;					
			for each(var x:XML in xmlEnv.sprite.usedTiles.tile) sprUsedTiles.push(new Point(x.@x, x.@y));
			
			setOriginTile();
			
		}
		
		private function onImageLoaded(e:Event):void {
			
			trace("onimageloaded method...");
			sprBitmapVariations.push(new Bitmap(e.target.content.bitmapData));
			
		}
		
		private function setOriginTile():void {
			
			var p:Point;
			var res:Point;
			
			if (sprUsedTiles.length > 1) {
				for each(p in sprUsedTiles) if (sprOriginTile == null || (p.x <= sprOriginTile.x && p.y < sprOriginTile.y)) sprOriginTile = p;
			}
			else sprOriginTile = new Point(0, 0);
			
			
			
		}
		
	}

}