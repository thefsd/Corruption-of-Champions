package coc.view {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class StatBar extends MovieClip {
		public static const
			DEFAULT_WIDTH :Number = 196,
			DEFAULT_HEIGHT :Number = 41,
			LABEL_HEIGHT :Number = 27,
			STAT_HEIGHT :Number = 36,
			BAR_TOP_OFFSET :Number = 21,
			COLON_FIELD_WIDTH :Number = 14,
			BAR_MAX_RIGHT_OFFSET :Number = 81; // Offset from right edge of this.

		public static const
			DEFAULT_MAXIMUM_VALUE :Number = 100;

		protected var
			_label :String,
			_maximumValue :Number,
			_labelField :TextField,
			_colonField :TextField,
			_valueField :TextField,
			_bar :Sprite,
			_upDown :MovieClip;

		protected var
			_currentValue :Number;

		private var
			_wholeWidth :Number,
			_wholeHeight :Number;



		//////// Constructor ////////

		public function StatBar(
			label :String,
			maximumValue :Number = DEFAULT_MAXIMUM_VALUE, // syntax error?
			labelField :TextField = null,
			valueField :TextField = null,
			bar :Sprite = null,
			upDown :MovieClip = null
		) :void {
			_wholeWidth = DEFAULT_WIDTH;
			_wholeHeight = DEFAULT_HEIGHT;

			setupLabelField( labelField );
			setupColonField();
			setupValueField( valueField );
			setupBar( bar );
			setupUpDown( upDown );

			this.label = label;
			this.maximumValue = maximumValue;
		};

		protected function setupLabelField( labelField :TextField ) :void {
			if( ! labelField ) {
				labelField = createLabelField();
			}

			this.labelField = labelField;
		};

		protected function setupColonField() :void {
			_colonField = new TextField();
			_colonField.height = labelField.height;
			_colonField.width = COLON_FIELD_WIDTH;
			_colonField.defaultTextFormat = labelField.defaultTextFormat;
			_colonField.embedFonts = true;
			_colonField.text = ':';

			this.addChild( _colonField );
		};

		protected function setupValueField( valueField :TextField ) :void {
			if( ! valueField ) {
				valueField = createValueField();
			}

			this.valueField = valueField;
		};

		protected function setupBar( bar :Sprite ) :void {
			if( ! bar ) {
				bar = createBar();
			}

			this.bar = bar;
		};

		protected function setupUpDown( upDown :MovieClip ) :void {
			if( ! upDown ) {
				upDown = createUpDown();
			}

			this.upDown = upDown;
		};

		protected function layoutChildren() :void {
			// Reposition and resize all children here...
			if( labelField ) {
				labelField.x = 0;
				labelField.y = 0;
			}

			if( valueField ) {
				if( upDown )
					valueField.x = this.width - upDown.width - valueField.width;
				valueField.y = 0;
			}

			if( bar ) {
				bar.x = 0;
				bar.y = BAR_TOP_OFFSET;
				bar.height = this.height - bar.y;

				// This handles width.
				updateBar();
			}

			if( upDown ) {
				upDown.x = this.width - upDown.width;
				upDown.y = (this.height - upDown.height) / 2;
			}

			// update colon TF.  ... Well, that sounds really kinky in the context of this game.
			if( _colonField )
				_colonField.x = barMaximumWidth - _colonField.width/2;
		};

		protected function updateBar() :void {
			bar.width = currentValue / maximumValue * barMaximumWidth;
		};

		protected function updateCurrentValue() :void {
			var val :Number = Math.floor( _currentValue );

			if( val >= 10000 ) {
				valueField.text = "++++";
			}
			else {
				valueField.text = String( val );
			}
		};



		//////// Creators ////////

		protected function createLabelField() :TextField {
			// boop
			throw new Error( "Not implemented." );
			return null;
		};

		protected function createValueField() :TextField {
			// boop
			throw new Error( "Not implemented." );
			return null;
		};

		protected function createBar() :Sprite {
			// body...
			throw new Error( "Not implemented." );
			return null;
		};

		protected function createUpDown() :MovieClip {
			// body...
			throw new Error( "Not implemented." );
			return null;
		};



		//////// Public thingers ////////

		public function showUp() :void {
			upDown.up.visible = true;
			upDown.down.visible = false;
		};

		public function showDown() :void {
			upDown.up.visible = false;
			upDown.down.visible = true;
		};

		public function hideUpDown() :void {
			// Mysteriously enough, this function will hide the up and down arrows.
			upDown.up.visible = false;
			upDown.down.visible = false;

		};



		//////// Getters/Setters ////////

		protected function get barMaximumWidth() :Number {
			return width - BAR_MAX_RIGHT_OFFSET;
		};

		override public function get width() :Number {
			return _wholeWidth;
		};

		override public function set width( value :Number ) :void {
			// do other stuff here...
			_wholeWidth = value;

			layoutChildren();
		};

		override public function get height() :Number {
			return _wholeHeight;
		};

		override public function set height( value :Number ) :void {
			// do other stuff here...
			_wholeHeight = value;

			layoutChildren();
		};

		public function get label() :String { return _label; };

		public function set label( value :String ) :void {
			_label = value;

			if( labelField ) {
				labelField.text = _label;
			}
		};

		public function get maximumValue() :Number { return _maximumValue; };

		public function set maximumValue( value :Number ) :void {
			_maximumValue = value;
			updateBar();
		};

		public function get currentValue() :Number { return _currentValue; };

		public function set currentValue( value :Number ) :void {
			if( value > _currentValue ) {
				showUp();
			}
			else if( value < _currentValue ) {
				showDown();
			}
			else {
				hideUpDown();
			}

			_currentValue = value;
			updateCurrentValue();
			updateBar();
		};

		public function get labelField() :TextField { return _labelField; };

		public function set labelField( value :TextField ) :void {
			_labelField = value;

			if( ! _labelField ) return;

			this.addChild( _labelField );
			layoutChildren();
		};

		public function get valueField() :TextField { return _valueField; };

		public function set valueField( value :TextField ) :void {
			_valueField = value;

			if( ! _valueField ) return;

			this.addChild( _valueField );
			layoutChildren();
		};

		public function get bar() :Sprite { return _bar; };

		public function set bar( value :Sprite ) :void {
			_bar = value;

			if( ! _bar ) return;

			this.addChild( _bar );
			layoutChildren();
			updateBar();
		};

		public function get upDown() :MovieClip { return _upDown; };

		public function set upDown( value :MovieClip ) :void {
			_upDown = value;

			if( ! _upDown ) return;

			this.addChild( _upDown );
			layoutChildren();
		};
	}
}