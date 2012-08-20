package com.smp.physics.core
{

	import com.smp.common.math.MathUtils;
	import com.smp.physics.core.Body;
	import flash.events.TimerEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.geom.Vector3D;
	
	public class World extends EventDispatcher
	{
		public static const UPDATE:String = "UPDATE";
		
		private var _timer:Timer;
		private var _space:Space;
		private var _gravity:Force;
		private var _bodies:Vector.<Body>;
		private var _bodiesCollChanged:Boolean = false;
		private var _collGrid:CollisionGrid;
		
		public function World(space:Space, gravity:Boolean = true) {
			
			_space = space;
			_collGrid = new CollisionGrid(_space.width, _space.height, 80);
			_bodies = new Vector.<Body>();
			
			if (gravity) {
				_gravity = new Force(new Vector3D(0, 1 / 15, 0));
			}
			
			_timer = new Timer(33);
			_timer.addEventListener(TimerEvent.TIMER, update);
			_timer.start();
			//addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function addBody(body:Body) {
			_bodies.push(body);
			_bodiesCollChanged = true;
			if (_gravity) {
				body.addForce(_gravity);
			}
		}
		
		private function update(evt:Event):void {
			
			var i:int,j:int, len:int = _bodies.length;
		/*	if (_bodiesCollChanged) {
				_collGrid.check(_bodies);
				_bodiesCollChanged = false;
			}
			
			var numChecks:int = _collGrid.checks.length;
			for (var j:int = 0; j < numChecks-1; j++) {
				checkCollision(_collGrid.checks[j] as Body, _collGrid.checks[j + 1] as Body);
			}*/
			for (i = 0; i < len; i++) { 
				var body:Body = _bodies[i];
				if (!body.frozen) {
					body.update();
				}
				
				//handle space boundaries
				if (body.position.x <= body.definition.radius) {
					body.position.x = body.definition.radius;
					body.speed = reflect(body.speed, new Vector3D(1, 0, 0));
					body.speed.scaleBy(body.definition.restitution);
				}else if (body.position.x >= _space.width - body.definition.radius) {
					body.position.x = _space.width - body.definition.radius;
					body.speed = reflect(body.speed, new Vector3D( -1, 0, 0));
					body.speed.scaleBy(body.definition.restitution);
				}
				
				if (body.position.y <= body.definition.radius) {
					body.position.y = body.definition.radius;
					body.speed = reflect(body.speed, new Vector3D(0, 1, 0));
					body.speed.scaleBy(body.definition.restitution);
					
				}else if (body.position.y >= _space.height - body.definition.radius) {
					body.position.y = _space.height - body.definition.radius;
					body.speed = reflect(body.speed, new Vector3D(0, -1, 0));
					body.speed.scaleBy(body.definition.restitution);
				}
				
				if (body.position.z <= body.definition.radius) {
					body.position.z = body.definition.radius;
					body.speed = reflect(body.speed, new Vector3D(0, 0, 1));
					body.speed.scaleBy(body.definition.restitution);
				}else if (body.position.z >= _space.depth - body.definition.radius) {
					body.position.z = _space.depth - body.definition.radius;
					body.speed = reflect(body.speed, new Vector3D(0, 0, -1));
					body.speed.scaleBy(body.definition.restitution);
				}
				
				
				/*if (Math.abs(body.speed.x) < 0.01 && Math.abs(body.speed.y) < 0.01 && Math.abs(body.speed.z) < 0.01) {
					body.frozen = true;
				}else {
					body.frozen = false;
				}*/
			}
			
			var n = (len * len - len) / 2;
			for (i = 0; i < len-1; i++) {
				for (j = i + 1; j < len; j++) {
					checkCollision(_bodies[i], _bodies[j]);
				}
			}
			
			dispatchEvent(new Event(UPDATE));
			
		}
		
		private function checkCollision(objA:Body, objB:Body):void {
		
			if (Math.abs(objA.position.x - objB.position.x) < objA.definition.radius + objB.definition.radius
			&& 
			Math.abs(objA.position.y - objB.position.y) < objA.definition.radius + objB.definition.radius
			&& 
			Math.abs(objA.position.z - objB.position.z) < objA.definition.radius + objB.definition.radius) {
				
				handleCollision(objA, objB);
			}
		}
		private function handleCollision(objA:Body, objB:Body):void {
			//b * ( -2*(V dot N)*N + V )
						
			var radiusRatio:Number = objA.definition.radius / objB.definition.radius ;
			
			var interCenter:Vector3D = new Vector3D((objA.position.x - objB.position.x), 
												(objA.position.y - objB.position.y), 
												(objA.position.z - objB.position.z));
				
			//resolve superpositions
			var diff:Number = interCenter.length - (objA.definition.radius + objB.definition.radius);
			if (diff < 0) {
				var displ:Vector3D = interCenter.clone();
				displ.normalize();
				displ.scaleBy(diff-2);
				objA.position = objA.position.subtract(displ);
			}
				
			//compute new speed on each object
			var normalA:Vector3D = interCenter.clone();
			normalA.scaleBy(radiusRatio);
			normalA.negate();
			normalA.normalize();
			
			var normalB:Vector3D = interCenter.clone();
			normalB.scaleBy(1 / radiusRatio);
			normalB.normalize();

			objA.speed = reflect(objA.speed, normalB);
			objB.speed = reflect(objB.speed, normalA);
			
			objA.speed.scaleBy(objA.definition.restitution);
			objB.speed.scaleBy(objB.definition.restitution);
		}
	
		private function reflect(vector:Vector3D, normal:Vector3D):Vector3D {
		/*	
		 * http://scidiv.bellevuecollege.edu/dh/Calculus_all/CC11_7_VectorReflections.pdf
			http://math.stackexchange.com/questions/13261/how-to-get-a-reflection-vector
			http://www.3dkingdoms.com/weekly/weekly.php?a=2
			*/
			normal.scaleBy(2 * vector.dotProduct(normal));
			return vector.subtract(normal);
		}
		
		public function get space():Space {
			return _space;
		}
		
	}
	
}