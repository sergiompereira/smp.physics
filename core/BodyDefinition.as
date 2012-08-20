package com.smp.physics.core
{
	
	
	public class BodyDefinition 
	{
		
		public var radius:Number;
		public var shape:String;
		public var color:Number;
		public var restitution:Number;
		public var friction:Number;
		
		public function BodyDefinition(radius:Number, shape:String = "", restitution:Number = 1, friction:Number = 0) {
			this.radius = radius;
			this.shape = shape;
			this.color = color;
			this.restitution = restitution;
			this.friction = friction;
		}
	}
	
}