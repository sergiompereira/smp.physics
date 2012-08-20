package com.smp.physics.core
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	public class  Body
	{
		private var _forces:Array = [];
		private var _position:Vector3D;
		private var _speed:Vector3D;
		private var _def:BodyDefinition;
		
		public var frozen:Boolean = false;
		
		public function Body(def:BodyDefinition) {
			_def = def;
			_speed = new Vector3D();
			
		}
	
		/**
		 * Will be applied on each update
		 * @param	force
		 */
		public function addForce(force:Force):void {
			_forces.push(force);
		}
		public function removeForce(force:Force):void {
			
			var i;
			for (i = 0; i < _forces.length; i++) {
				if (force == (_forces[i] as Force)) {
					_forces.splice(i,1);
					break;
				}
			}
			
		}
		/**
		 * Is applied just once
		 * @param	impulse
		 */
		public function addImpulse(impulse:Impulse):void {
			impulse.apply(this);
		}
		
		
		public function set position(vector:Vector3D):void {
			_position = vector;
		}
		public function set speed(vector:Vector3D):void {
			_speed = vector;
		}
		
		public function update(evt:Event = null):void {
			
			//apply forces
			var i;
			for (i = 0; i < _forces.length; i++) {
				(_forces[i] as Force).apply(this);
			}
			//apply friction
			var magn:Number = _speed.length;
			if (_def.friction > 0 && magn > _def.friction) {
				//trace(_speed.x)
				_speed.x = (1 - _def.friction) * _speed.x;
				_speed.y = (1 - _def.friction) * _speed.y;
				_speed.z = (1 - _def.friction) * _speed.z;
			}
			
			
			_position.y += _speed.y;
			_position.x += _speed.x;
			_position.z += _speed.z;
			
			
		}
		
		public function get position():Vector3D {
			return _position;
		}
		public function get speed():Vector3D {
			return _speed;
		}
		public function get definition():BodyDefinition {
			return _def;
		}
		
		
		
	}
	
}