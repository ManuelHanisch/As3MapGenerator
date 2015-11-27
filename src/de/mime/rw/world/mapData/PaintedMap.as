package de.mime.rw.world.mapData 
{
	import de.mime.utils.ds.Array2DIterator;
	import flash.display.Sprite;
	
	import de.mime.rw.world.gridData.Grid;
	import de.mime.rw.world.gridData.Location;
	import de.mime.rw.world.gridData.voigraph.Center;
	import de.mime.rw.world.gridData.voigraph.Edge;
	import de.mime.rw.world.gridData.voigraph.Corner;
	
	import de.mime.utils.math.PM_PRNG;
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	import flash.filters.GradientGlowFilter;
	import flash.geom.Rectangle;
		
	
	import flash.display.BitmapData;
	import flash.geom.Point;	
	
	
	
	/**
	 * ...
	 * @author Manuel Hanisch
	 */
	public class PaintedMap extends Sprite
	{
		
		public var paintedMap:BitmapData;
		public var paintedMapBackground:BitmapData;
		
		private var _dimensions_grid2Pixels:int
		
		public static const BIOME_COLOR_EMPTY:uint = 0xede4db;
		
		
				
		
		public function PaintedMap(random:PM_PRNG,grid:Grid) {	
			
			this._dimensions_grid2Pixels = 16;
			
			paintedMapBackground = new BitmapData(grid.width * 16, grid.height * 16, false, BIOME_COLOR_EMPTY);
			
			paintedMap = new BitmapData(grid.width * 16, grid.height * 16, true);			
            
			
			var center:Center;
			var e:Edge;
			
			
			
			for each(e in grid.voimap.edges) {
				
				//Draw.line(e.v0.voiPoint.x * 16 + 8, e.v0.voiPoint.y * 16 + 8, e.v1.voiPoint.x * 16 + 8, e.v1.voiPoint.y * 16 + 8, 0x000000, 0.5);
				//Draw.line(e.v0.gridPoint.x * 16 + 8, e.v0.gridPoint.y * 16 + 8, e.v1.gridPoint.x * 16 + 8, e.v1.gridPoint.y * 16 + 8, 0x000000);
				
				var path:Vector.<Point>;
				
				
				
				var linewidth:int = 0;
				if (e.biomeEdgeType == Edge.BIOME_EDGETYPE_COAST) linewidth = 4;
				else if (e.biomeEdgeType == Edge.BIOME_EDGETYPE_INLAND_HARDBORDER) linewidth = 1;
				
				if (linewidth > 0) {
					
					path = Edge.buildNoisyEdgeLine(random, e, _dimensions_grid2Pixels, Edge.NOISY_EDGE_ROUGHNESS_ROUGH);		
					
					for (var i:int = 0; i < path.length - 1; i++) {
					
						var sh:Shape = new Shape();
						sh.graphics.lineStyle(linewidth, 0x000000);
						sh.graphics.moveTo(path[i].x, path[i].y); 
						sh.graphics.lineTo(path[i + 1].x, path[i + 1].y);						
						
						paintedMap.draw(sh);
						
					}
				}
				
				
				
				
				
				
				
				
			}
			
			
			for each(center in grid.voimap.centers) {
				
				l = grid.locationGrid.get(center.gridX, center.gridY);		
				var alpha:uint = 10;
				if (l.biome == grid._oceanBiome) alpha = 100;
				paintedMap.floodFill(l.gridX * 16, l.gridY * 16, addAlphaToRGB(l.biome.baseColor, alpha));
				
			}
			
			//paintedMap.noise(1, 120, 130);
			//paintedMap.perlinNoise(grid.width * 16, grid.height * 16, 7, 1,false, true);
			
			
			
			var it:Array2DIterator = Array2DIterator(grid.locationGrid.getIterator());
			var l:Location;
			var c:Point;			
			while (it.hasNext()) {
				
				
				l = it.next();				
				c = it.cursor;
				
				if (l.isHub()) {
					
					sh = new Shape();
					sh.graphics.lineStyle(1, 0xFF0000);
					sh.graphics.drawCircle((c.x * 16) +8, (c.y * 16) +8, 7);
					
					paintedMap.draw(sh);
					
				}
				
				if (l.environment != null) {
					
					//paintedMap.copyPixels(l.biome.environments[dr].Sprites[0].sprite.bitmapData, new Rectangle(0, 0, 16, 16), new Point(c.x * 16,c.y * 16),null,null,true);
						
					sh = new Shape();	
					
					//trace(l.environment.uniqueID);
					if (l.environment.uniqueID == "mountainsse" || l.environment.uniqueID == "mountainssw") {
						
						sh.graphics.beginFill(0x993300);
						sh.graphics.moveTo((c.x * 16) + 8,(c.y * 16));
						sh.graphics.lineTo((c.x * 16),(c.y * 16) + 16);
						sh.graphics.lineTo((c.x * 16) + 16,(c.y * 16) + 16);
						sh.graphics.lineTo((c.x * 16) + 8 ,(c.y * 16));
						sh.graphics.endFill();
						
					}
					else if (l.environment.uniqueID == "hills") {
						
						sh.graphics.beginFill(0x999933);
						sh.graphics.moveTo((c.x * 16) + 8,(c.y * 16) + 8);
						sh.graphics.lineTo((c.x * 16),(c.y * 16) + 16);
						sh.graphics.lineTo((c.x * 16) + 16,(c.y * 16) + 16);
						sh.graphics.lineTo((c.x * 16) + 8 ,(c.y * 16) + 8);
						sh.graphics.endFill();
					}
					else if (l.environment.uniqueID == "flowerfield") {
						
						sh.graphics.lineStyle(1, 0xFFFF00);	
						sh.graphics.drawCircle((c.x * 16) +8, (c.y * 16) +8, 7);
					}
					else if (l.environment.uniqueID == "birchforrest") {
						
						sh.graphics.beginFill(0x009900);
						sh.graphics.drawEllipse((c.x * 16) + 3, (c.y * 16), 10, 14);
						sh.graphics.endFill();
						
					}
					else if (l.environment.uniqueID == "rainforrest") {
						
						sh.graphics.beginFill(0x003300);
						sh.graphics.drawEllipse((c.x * 16) + 3, (c.y * 16), 10, 14);
						sh.graphics.endFill();
						
					}
					else if (l.environment.uniqueID == "borealforrest") {
						
						sh.graphics.beginFill(0x009966);
						sh.graphics.moveTo((c.x * 16) + 8,(c.y * 16));
						sh.graphics.lineTo((c.x * 16) + 2,(c.y * 16) + 16);
						sh.graphics.lineTo((c.x * 16) + 14,(c.y * 16) + 16);
						sh.graphics.lineTo((c.x * 16) + 8 ,(c.y * 16));
						sh.graphics.endFill();
						
					}
					else if (l.environment.uniqueID == "acaciacluster") {
						
						sh.graphics.beginFill(0xCCCC33);
						sh.graphics.drawEllipse((c.x * 16) + 3, (c.y * 16), 10, 14);
						sh.graphics.endFill();
						
					}
					else if (l.environment.uniqueID == "swamp") {
						
						sh.graphics.beginFill(0x663366);
						sh.graphics.drawRect((c.x * 16), (c.y * 16) + 4, 12,8);
						sh.graphics.endFill();
						
					}
					
					
					
					paintedMap.draw(sh);
					
					
					
				}
				
				//Draw.rect(c.x * 16, c.y * 16, 16, 16, l.biome.baseColor);
				
				
				
				//Draw.text(l.biome.name, c.x * 16, c.y * 16);
				//Draw.text(l.temperature.toString(), c.x * 16, c.y * 16);
				//Draw.text(l.rain.toString(), c.x * 16, c.y * 16);
				
				
				/*				
				var es:int = 0;
				for each(var cor:Corner in l.onCorners) {
					
					 Draw.rectPlus((c.x * 16) +8, (c.y * 16) +8, 7 - es,7 - es, 0x006666,1,false,1);
					 //Draw.text(l.path.toString(), c.x * 16, c.y * 16, {size:10});
					 es += 2;
					
				}
				
				
				es = 0;
				for each(var e:Edge in l.onEdges) {
					
					 Draw.circle((c.x * 16) +8, (c.y * 16) +8, 7 - es, 0x006666);
					 //Draw.text(l.path.toString(), c.x * 16, c.y * 16, {size:10});
					 es += 2;
					
				}
				*/
				
				
				//if (l.isCoast) Draw.rect(8 + c.x * 16, 8 + c.y * 16, 4, 4, 0x668800);
				
				
			}
			
			
			
			
			
			
			
			
			
		}
		
		public function grid2PixelMid(x:int):int {
			
			return (x * _dimensions_grid2Pixels) + (_dimensions_grid2Pixels / 2);
			
		}
		
		public static function addAlphaToRGB(rgb:uint, alphaPercent:uint = 0):uint {
			 
			
			var a:uint = uint(2.55 * alphaPercent);			
			return (a << 24) | rgb;
		}
		
		

		
		
	}

}