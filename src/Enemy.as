package {
	import flash.display.Bitmap;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Stage;
	
	/**
	 * ...
	 * @author Michael M
	 */
	public class Enemy {
		[Embed(source="GGvect_100x100.png")]
		private static const ggImage:Class
		private var img:Image;
		private var stage:Stage;
		private var vel:Point;
		
		public function Enemy(spawn:Point, stage:Stage) {
			super();
			var myBitmap:Bitmap = new ggImage();
			img = Image.fromBitmap(myBitmap);
			
			// Change images origin to it's center
			// (Otherwise by default it's top left)
			img.pivotX = img.width / 2;
			img.pivotY = img.height / 2;
			
			// Where to place the image on screen
			img.x = spawn.x;
			img.y = spawn.y;
			
			vel = new Point(-5,0);
			this.stage = stage;
			stage.addChild(img);
			MyStarlingApp.inst.enemies.push(this);
		}
		
		public function update():void {
			img.rotation-=0.1;
			img.x += vel.x;
			img.y += vel.y;
			if (img.x < 0 || img.y > stage.stageHeight || img.y < 0) {
				stage.removeChild(img);
				MyStarlingApp.inst.enemies.splice(MyStarlingApp.inst.enemies.indexOf(this), 1);
			}
		}
	}

}