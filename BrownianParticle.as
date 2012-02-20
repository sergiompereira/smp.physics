package srg.physics{
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import srg.display.utils.MovieClipId;
	import ascb.util.NumberUtilities;
	
	
	
	public class BrownianParticle extends MovieClipId{
		
		public var vx:Number=0;
		public var vy:Number=0;
		public var friction:Number=0.97;
		public var bounds:Rectangle;
		public var impulseDelayInterval:Array;
		public var speedMax:Number;
		
		private var _timer:Timer;
		
		public function BrownianParticle(bounds:Rectangle = null, impulseDelayInterval:Array = null, friction:Number = 0.97, speedMax:Number = 1 ){
			
			this.bounds = bounds;
			
			this.impulseDelayInterval = impulseDelayInterval;
			if(this.impulseDelayInterval == null){
				this.impulseDelayInterval = new Array(1000,2000);
			}
			this.friction = friction;
			this.speedMax = speedMax;
			
	        
	        createView();
	        setUpdateInterval();
	        
	        onTimer();
	       
		}
		
		protected function createView():void{
			//set the visual display
		}
		
		protected function setUpdateInterval():void
		{
			_timer = new Timer(Math.random()*impulseDelayInterval[0]+(impulseDelayInterval[1]-impulseDelayInterval[0]));
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			update();
		}
		
		private function onTimer(evt:TimerEvent = null):void{
			
		   vx +=  NumberUtilities.random(-speedMax, speedMax);
		   vy +=  NumberUtilities.random(-speedMax, speedMax);
		}
		
		private function onEnterFrame(evt:Event):void
		{
		  update();
		      
		}
		
		private function update():void
		{
			// !! colision detection 
            x += vx;
            y += vy;
            vx *= friction;
            vy *= friction;

			if(bounds != null){
	            if(x > bounds.x + bounds.width){
	            	x = bounds.x + bounds.width;
	            	vx = -vx;
	            } else if( x < bounds.x)
	            {
	            	x = bounds.x;
	                vx = -vx;
	            }
	           
	            if(y > bounds.y + bounds.height ){
	            	y = bounds.y + bounds.height;
	            	vy = -vy;
	            }else if(y < bounds.y)
	            {
	            	y = bounds.y;
	                vy = -vy;
	            }
            }
           
		}	
		
		public function freeze():void{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_timer.stop();
		}
		
		public function defrost():void{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);	
			_timer.start();
			
		}
		
		// !! colision detection
		private function detectColision():void{
			/*
			for(var i:uint = 0; i<particleColl.length -1; i++){
				
				for(var j:uint = i+1; j<particleColl.length; j++){
					
					var distance:Number = MathUtils.getDistance(particleColl[j].x, particleColl[j].y, particleColl[i].x, particleColl[i].y);
					var mindist:Number = particleColl[j].width+particleColl[i].width;
					if(distance < mindist) {
						
					}
					
				}
			}
			*/	
		}
		
	}
}