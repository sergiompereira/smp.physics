package com.smp.physics.core
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	public class Scene extends Sprite
	{
		
		private var _world:World;
		private var _actors:Vector.<Actor>;
		
		public function Scene(world:World) {
			_world = world;
			_actors = new Vector.<Actor>();
			
			_world.addEventListener(World.UPDATE, update);
		}
		
		public function createActor(body:Body,view:Shape):void {
			var viewcont:Sprite = new Sprite();
			viewcont.addChild(view);
			addChild(viewcont);
			_actors.push(new Actor(body, viewcont, _world));
		}
		
		public function update(evt:Event = null) {
			//light
			
			var len:int = _actors.length;
			var color:ColorTransform;
			var ratioz:Number;
			var actor:Actor;
			_actors.sort(depthSort);
			
			for (var i:int = 0; i < len; i++) {
				actor = _actors[i];
				
				//light
				color = new ColorTransform();
				ratioz = 1-actor.body.position.z / _world.space.depth;
				color.redMultiplier = ratioz;
				color.greenMultiplier = ratioz;
				color.blueMultiplier = ratioz;
				_actors[i].view.transform.colorTransform = color; 
				
				//deepth
				addChildAt(actor.view, i);
			}
			
			
			
			
		}
		
		private function depthSort(objA:Actor, objB:Actor):Number {
			return   objB.body.position.z - objA.body.position.z;
		}

	}
	
}