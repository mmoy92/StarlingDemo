package  
{
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	
	/**
	 * ...
	 * @author Michael M
	 */
	public class Ground extends Sprite 
	{
		private var main:MyStarlingApp;
		private var spawn:Point;
		
		public function Ground() 
		{
			super();
			main = MyStarlingApp.inst;
			
			addChild(new Image(Assets.groundTexture));
			spawn = new Point(main.stage.stageWidth + 50, main.ground_y - 10);
			touchable = false;
			
		}
		public function init():void {
			visible = true;
			x = spawn.x;
			y = spawn.y;
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			main.addChild(this);
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void {
			if (!main.gameover) {
				x -= e.passedTime * 100 * main.velocity.x;
				if (x < -width) {
					free();
				}
			}
		}
		public function free():void {
			main.addGround();
			main.groundPool.freeSprite(this);
			main.removeChild(this);
			
			removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			visible = false;
		}
	}

}