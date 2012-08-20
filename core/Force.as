package com.smp.physics.core 
{	
	import flash.geom.Vector3D;
	
	public class Force 
	{
		public var direction:Vector3D;
		
		public function Force(direction:Vector3D) {
			this.direction = direction;
		}
		public function apply(body:Body):void {
			body.speed.x += this.direction.x;
			body.speed.y += this.direction.y;
			body.speed.z += this.direction.z;
		}
	
	}
	
}