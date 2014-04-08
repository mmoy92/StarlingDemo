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
		private const WIDTH:uint = 170;
		private var main:MainGame;
		private var spawn:Point;
		
		public function Ground() 
		{
			super();
			main = MainGame.inst;
			
			addChild( new Image(MainGame.inst.assets.getTexture("ground")));
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
				x -= main.velocity.x;
				if (x < -WIDTH) {
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