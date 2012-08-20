package 
{
	import com.smp.common.display.ShapeUtils;
	import com.smp.common.math.NumberUtils;
	import com.smp.physics.core.BodyDefinition;
	import com.smp.physics.core.Force;
	import com.smp.physics.core.Impulse;
	import com.smp.physics.core.Viewport;
	
	import com.smp.physics.core.Actor;
	import com.smp.physics.core.Body;
	import com.smp.physics.core.World;
	
	import flash.geom.Vector3D;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	
	public class Main extends MovieClip
	{
		private var toycount:int = 20;
		private var radius:int = 20;
		
		public function Main() {
			
			var world:World = new World(new Viewport(stage.stageWidth,stage.stageHeight));
			
			
			for (var i:int = 0; i < 8; i++) {
				var body:Body = new Body(new BodyDefinition(radius, '', 0.5, 0.005));
				body.position = new Vector3D(NumberUtils.random(0, stage.stageWidth), NumberUtils.random(0, stage.stageHeight), 0);
				world.addBody(body);
				
				body.addImpulse(new Impulse(new Vector3D( NumberUtils.random(-4, 4), NumberUtils.random(-4, 4), 0)));
				var ball:Sprite = new Sprite();
				ball.addChild(ShapeUtils.createCircle(radius, 0xffffff, 0.5));
				addChild(ball);
				var actor:Actor = new Actor(body, ball, world);
			}
			

			
		}
	}
	
}