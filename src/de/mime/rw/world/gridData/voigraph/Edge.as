package de.mime.rw.world.gridData.voigraph 
{
	
	import de.mime.utils.geom.Triangle;
	
	import de.mime.rw.world.gridData.Biome;
	import de.mime.rw.world.gridData.Grid;
	import de.mime.rw.world.gridData.voigraph.Center;
	import de.mime.rw.world.gridData.voigraph.Corner;
	
	import de.mime.utils.math.PM_PRNG;
	
	import flash.geom.Point;

	/**
	 * ...
	 * @author Manuel Hanisch
	 */
	public class Edge 
	{
		
		public var touchesBorder:Boolean;		
		public var biomeEdgeType:int;
		//public var biomeDominant:Biome;
		
		public var d0:Center, d1:Center; // Delaunay edge
		public var v0:Corner, v1:Corner; // Voronoi edge
		
		
		//public var noisyGridPath:Vector.<Point>;
		
		public static const BIOME_EDGETYPE_NULL:int = 0;
		public static const BIOME_EDGETYPE_OCEAN:int = 1;
		public static const BIOME_EDGETYPE_COAST:int = 2;
		public static const BIOME_EDGETYPE_INLAND_SOFTBORDER:int = 3; // edge between equal biomes
		public static const BIOME_EDGETYPE_INLAND_HARDBORDER:int = 4; //edge between different biomes
		
		
		//play around with these
		public static const NOISY_EDGE_ROUGHNESS_SMOOTH:Number = 0;
		public static const NOISY_EDGE_ROUGHNESS_CURVY:Number = 10;
		public static const NOISY_EDGE_ROUGHNESS_ROUGH:Number = 2;
		
		
		
		
		public function Edge() {
			
			touchesBorder = false;
			biomeEdgeType = BIOME_EDGETYPE_NULL;
			
		}
		
		
		public function getWesternmostCenter():Center {
			
			if (d0.gridX <= d1.gridX) return d0;		
			else return d1;			
			
		}
		public function getEasternmostCenter():Center {
			
			if (d0.gridX > d1.gridX) return d0;		
			else return d1;				
			
		}
		public function getSouthernmostCenter():Center {
			
			if (d0.gridY <= d1.gridY) return d0;		
			else return d1;			
			
		}
		public function getNorthernmostCenter():Center {
			
			if (d0.gridY > d1.gridY) return d0;
			else return d1;			
			
		}
		
		
		/**
		 * 		 
		 * @param	grid2Pixels = dimensions for bitmap
		 */		 
		public static function buildNoisyEdgeLine(random:PM_PRNG,e:Edge,grid2Pixels:int,roughness:Number = NOISY_EDGE_ROUGHNESS_CURVY):Vector.<Point> {
		
			
			function grid2PixelMid(x:int):Number {
			
				return (x * grid2Pixels) + (grid2Pixels / 2);
				
			}
			
			var v0:Point = new Point(grid2PixelMid(e.v0.gridPoint.x), grid2PixelMid(e.v0.gridPoint.y));
			var v1:Point = new Point(grid2PixelMid(e.v1.gridPoint.x), grid2PixelMid(e.v1.gridPoint.y));
			var d0:Point = new Point(grid2PixelMid(e.d0.gridX), grid2PixelMid(e.d0.gridY));
			var d1:Point = new Point(grid2PixelMid(e.d1.gridX), grid2PixelMid(e.d1.gridY));
			
			
			
			
			if (roughness == NOISY_EDGE_ROUGHNESS_SMOOTH || v0.subtract(v1).length <= 0 || isCenterOutsideEffectiveArea(v0,v1,d0,d1)) {
				
				var rv:Vector.<Point> = new Vector.<Point>;
				rv.push(v0); rv.push(v1);
				
				return rv;
				
			}
			else {
				
				
				var e_midpoint:Point = Point.interpolate(v0,v1,0.5);
				
				var t:Point = Point.interpolate(v0,d0, 0.5);
				var q:Point = Point.interpolate(v0,d1, 0.5);
				var r:Point = Point.interpolate(v1,d0, 0.5);
				var s:Point = Point.interpolate(v1,d1, 0.5);
				//trace(e.v0.gridPoint); trace(new Point(e.d0.gridX, e.d0.gridY)); trace("to:" + t);
				
				return buildNoisyLineSegments(random, v0, t, e_midpoint, q, roughness).concat(buildNoisyLineSegments(random, v1, s, e_midpoint, r, roughness).reverse());
			
			
			}
		
		
		}
		
		/**
		 *  checks if a center is outside the 90 degree angle of the 2 edge points. If its outside the Noisy Lines can look messy.
		 */
		private static function isCenterOutsideEffectiveArea(v0:Point,v1:Point,d0:Point,d1:Point):Boolean {
				
				
			
			var triangle:Triangle = new Triangle();
			
			//d0
			triangle.updatePoints(d0, v1, v0);			
			if (Math.abs(triangle.gamma) > 90) return true;	
			triangle.updatePoints(d0, v0, v1);			
			if (Math.abs(triangle.gamma) > 90) return true;	
			
			//d1
			triangle.updatePoints(d1, v1, v0);
			if (Math.abs(triangle.gamma) > 90) return true;
			triangle.updatePoints(d1, v0, v1);
			if (Math.abs(triangle.gamma) > 90) return true;	
				
			return false;
			
			
			
			
		}
		
		// Helper function: build a single noisy line in a quadrilateral A-B-C-D,
		// and store the output points in a Vector.
		private static function buildNoisyLineSegments(random:PM_PRNG, A:Point, B:Point, C:Point, D:Point, minLength:Number):Vector.<Point> {
			
		
			var points:Vector.<Point> = new Vector.<Point>();

			function subdivide(A:Point, B:Point, C:Point, D:Point):void {
				
				if (A.subtract(C).length < minLength || B.subtract(D).length < minLength) {
					  return;
				}

				// Subdivide the quadrilateral
				var p:Number = random.nextDoubleRange(0.2, 0.8);  // vertical (along A-D and B-C)
				var q:Number = random.nextDoubleRange(0.2, 0.8);  // horizontal (along A-B and D-C)

				// Midpoints
				var E:Point = Point.interpolate(A, D, p);
				var F:Point = Point.interpolate(B, C, p);
				var G:Point = Point.interpolate(A, B, q);
				var I:Point = Point.interpolate(D, C, q);
					
				// Central point !
				var H:Point = Point.interpolate(E, F, q);
				
				
				// Divide the quad into subquads, but meet at H
				var s:Number = 1.0 - random.nextDoubleRange(-0.4, +0.4);
				var t:Number = 1.0 - random.nextDoubleRange(-0.4, +0.4);

				
				subdivide(A, Point.interpolate(G, B, s), H, Point.interpolate(E, D, t));
				points.push(H);
				subdivide(H, Point.interpolate(F, C, s), C, Point.interpolate(I, D, t));
			}

			 points.push(A);
			 subdivide(A, B, C, D);
			 points.push(C);
			 return points;
			 
			 
		}
		
		
		
	}
}