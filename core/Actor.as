package com.smp.physics.core
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	public class Actor 
	{
		private var _world:World;
		private var _ctl:Body;
		private var _view:Sprite;
		
		public function Actor(controller:Body, view:Sprite,world:World) {
			_ctl = controller;
			_view = view;
			_world = world;
			
			_world.addEventListener(World.UPDATE, update);
		}
		
		public function get view():Sprite {
			return _view;
		}
		public function get body():Body {
			return _ctl;
		}
		public function update(evt:Event = null) {
			_view.x = _ctl.position.x;
			_view.y = _ctl.position.y;
			_view.z = _ctl.position.z;
		}
	}
	
}