package {
	import flash.geom.Point;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	
	/**
	 * ...
	 * @author Michael M
	 */
	public class Ground extends Sprite {
		public const WIDTH:uint = 284;
		private var main:MainGame;
		private var spawn:Point;
		
		public function Ground() {
			super();
			main = MainGame.inst;
			
			addChild(new Image(MainGame.inst.assets.getTexture("ground")));
			spawn = new Point(0, main.ground_y - 40);
			touchable = false;
			//blendMode = BlendMode.NONE;
		
		}
		
		public function init(sX:Number):void {
			visible = true;
			x = sX;
			y = spawn.y;
			//width += 30;
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			main.addChild(this);
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void {
			if (!main.gameover && !main.isPause) {
				//trace(main.velocity.x);
				
				if (x < -WIDTH) {
					x += main.stage.stageWidth + WIDTH;
				} else if (x > main.stage.stageWidth) {
					x -= main.stage.stageWidth + WIDTH;
				}
				x -= main.velocity.x;
			}
		}
	}

}