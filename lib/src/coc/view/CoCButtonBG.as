package coc.view {
	import flash.display.MovieClip;
	import flash.display.Sprite;

	import buttonBackground0;
	import buttonBackground1;
	import buttonBackground2;
	import buttonBackground3;
	import buttonBackground4;
	import buttonBackground5;
	import buttonBackground6;
	import buttonBackground7;
	import buttonBackground8;
	import buttonBackground9;

	public class CoCButtonBG extends MovieClip {
		public static const
			BG_ClASSES :Array = [
				buttonBackground0,
				buttonBackground1,
				buttonBackground2,
				buttonBackground3,
				buttonBackground4,
				buttonBackground5,
				buttonBackground6,
				buttonBackground7,
				buttonBackground8,
				buttonBackground9
				];

		public static var
			BG_CLASS_CURR_INDEX :int = 0;

		public static function createNextBG() :MovieClip {
			var bg :MovieClip;

			bg = createBG( BG_CLASS_CURR_INDEX );
			BG_CLASS_CURR_INDEX = (BG_CLASS_CURR_INDEX + 1) % BG_ClASSES.length;

			return bg;
		};

		public static function createBG( bgIndex :int = 0 ) :MovieClip {
			if( bgIndex < 0 ) bgIndex = 0;

			return new (BG_ClASSES[ bgIndex % BG_ClASSES.length ])();
		};

		////////

		public var bgSprite :MovieClip;

		////////

		public function CoCButtonBG( bgIndex :int = -1 ) :void {
			var bg;

			if( bgIndex < 0 ) {
				bgSprite = createNextBG();
			}
			else {
				bgSprite = createBG( bgIndex );
			}

			addChild( bgSprite );
		};
	}
}