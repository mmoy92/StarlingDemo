package {
	/**
	 * ...
	 * @author Michael M
	 */
	import starling.textures.Texture;
	
	public class Assets {
		[Embed(source="carb.png")]
		private static const carbPNG:Class
		public static var carbTexture:Texture;
		
		[Embed(source="STHOMAS.png")]
		private static const thomPNG:Class
		public static var thomTexture:Texture;
		
		[Embed(source="bg.png")]
		private static const bgPNG:Class;
		public static var bgTexture:Texture;
		
		[Embed(source="slash.png")]
		private static const slashPNG:Class;
		public static var slashTexture:Texture;
		
		[Embed(source="ground.png")]
		private static const groundPNG:Class;
		public static var groundTexture:Texture;
		
		public function Assets() {
		
		}
		
		public static function init():void {
			carbTexture = Texture.fromBitmap(new carbPNG());
			thomTexture = Texture.fromBitmap(new thomPNG());
			bgTexture = Texture.fromBitmap(new bgPNG());
			slashTexture = Texture.fromBitmap(new slashPNG());
			groundTexture = Texture.fromBitmap(new groundPNG());
		}
	
	}

}