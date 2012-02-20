package srg.physics {
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.Event;
	
	import srg.components.core.DisplayComposite;
	import srg.components.core.Composite;
	
	public class JointedSegment extends DisplayComposite {
		
		protected var length:Number
		
		public function JointedSegment(length:Number) {
			
			this.length = length;
			super();
		}
		
		
		override public function update(evt:Event = null):void {
			
			if (this.getParent() != null)
			{
				var myParent:Composite = this.getParent();
				var parentLoc:Point = new Point((myParent as JointedSegment).getView().x, (myParent as JointedSegment).getView().y);
				var myLoc:Point = new Point(view.x, view.y);
				
				var tempPoint:Point = parentLoc.subtract(myLoc);
				var angle:Number = Math.atan2(tempPoint.y, tempPoint.x);
				view.rotation = angle * 180 / Math.PI;
				
				var currentDistance:Number = Point.distance(parentLoc, myLoc);
				var myNewLoc:Point = Point.interpolate(myLoc, parentLoc, length/currentDistance);
				
				view.x = myNewLoc.x;
				view.y = myNewLoc.y;
				
				
			}
			super.update();
		}
	}
}