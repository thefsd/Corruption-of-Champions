package coc.view {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.DisplayObject;

    import flash.text.TextField;

    import coc.model.GameModel;

    // Remove dynamic once you've added all the DOs as instance properties.
    public dynamic class StatsView extends Sprite {
        // add things from main view here?
        // yes because we'll need to update all the TFs and progress bars.
        public var upDownsContainer :Sprite;
        public var levelUp :Sprite;

        protected var model :GameModel;

        protected var
            // Stats that have bars.  Yup.
            statBars :Array,

            // All our stat bars.
            strStatBar :StatBar,
            touStatBar :StatBar,
            speStatBar :StatBar,
            inteStatBar :StatBar,
            libStatBar :StatBar,
            sensStatBar :StatBar,
            corStatBar :StatBar,
            lustStatBar :StatBar,
            fatigueStatBar :StatBar,
            hpStatBar :StatBar;

        // protected var
            // Stats that have a label and number but no bar.
            // plainStats :Array,

            // All our non-bar stats.
            // levelText :PlainStat,
            // xpText :PlainStat,
            // gemsText :PlainStat,

        public function StatsView( mainView :MovieClip, model :* ) {
            super();

            if( ! mainView ) {
                return;
            }

            this.model = model;

            var statsThingsNames :Array = [
                    "strBar",     "strText",     "strNum",      // "strUp",      "strDown",
                    "touBar",     "touText",     "touNum",      // "touUp",      "touDown",
                    "speBar",     "speText",     "speNum",      // "speUp",      "speDown",
                    "inteBar",    "inteText",    "inteNum",     // "inteUp",     "inteDown",
                    "libBar",     "libText",     "libNum",      // "libUp",      "libDown",
                    "sensBar",    "senText",     "senNum",      // "sensUp",     "sensDown",
                    "corBar",     "corText",     "corNum",      // "corUp",      "corDown",
                    "lustBar",    "lustText",    "lustNum",     // "lustUp",     "lustDown",
                    "fatigueBar", "fatigueText", "fatigueNum",  // "fatigueUp",  "fatigueDown",
                    "HPBar",      "HPText",      "HPNum",       // "hpUp",       "hpDown",
                                  "levelText",   "levelNum",    // "levelUp",
                                  "xpText",      "xpNum",       // "xpUp",       "xpDown",
                                  "gemsText",    "gemsNum",
                    "coreStatsText",
                    "advancementText",
                    "combatStatsText",
                    "timeText",
                    "timeBG",
                    "sideBarBG"
                ];

            var statsUpDownsNames :Array = [
                    "strUp",      "strDown",
                    "touUp",      "touDown",
                    "speUp",      "speDown",
                    "inteUp",     "inteDown",
                    "libUp",      "libDown",
                    "sensUp",     "sensDown",
                    "corUp",      "corDown",
                    "fatigueUp",  "fatigueDown",
                    "hpUp",       "hpDown",
                    "lustUp",     "lustDown",
                    // These last two are somewhat different...
                    // "levelUp",
                    "xpUp",       "xpDown"
                ];

            for each( var statsDOName :* in statsThingsNames ) {
                // adding at 0 because BG is at the end.
                this.addChildAt( mainView.getChildByName( statsDOName ), 0 );
            }

            this.upDownsContainer = new Sprite();
            this.addChild( this.upDownsContainer );

            for each( var statsUpDownDOName :* in statsUpDownsNames ) {
                this.upDownsContainer.addChild( mainView.getChildByName( statsUpDownDOName ) );
            }

            this.levelUp = mainView.getChildByName( 'levelUp' ) as Sprite;
            this.addChild( this.levelUp );

            createStatBars();
        };

        protected function createStatBars() :void {
            var statBarAssetNames = [
                "str", "tou", "spe", "inte", "lib", "sens", "cor", "lust", "fatigue", "HP"
            ];

            // statNameLower is only for HP which is sometimes lowercase and sometimes uppercase.
            // Specifically, the StatBar on this is named hpBar, but the main assets are HP* except the up and down.
            var statBar :StatBar,
                statName :String,
                statNameLower :String,
                labelField :TextField;

            var upDown :MovieClip;//, up :Sprite, down :Sprite;

            var x :Number, y :Number;

            this.statBars = [];

            for each( statName in statBarAssetNames ) {
                statNameLower = statName.toLowerCase();

                labelField = this.getChildByName( (statName == "sens" ? "sen" : statName) + "Text" ) as TextField;

                if( ! labelField ) throw new Error( "Could not find labelField for stat " + statName );

                x = labelField.x;
                y = labelField.y;

                upDown = new MovieClip();
                upDown.up = this.upDownsContainer.getChildByName( statNameLower + "Up" ) as Sprite;
                upDown.down = this.upDownsContainer.getChildByName( statNameLower + "Down" ) as Sprite;

                upDown.up.x = upDown.up.y = 0;
                upDown.down.x = upDown.down.y = 0;

                upDown.addChild( upDown.up );
                upDown.addChild( upDown.down );

                statBar = new StatBar(
                    labelField.text.replace( /[\s:]*$/, '' ),
                    100,
                    labelField,
                    //  lol.
                    this.getChildByName( (statName == "sens" ? "sen" : statName) + "Num" ) as TextField,
                    this.getChildByName( statName + "Bar" ) as Sprite,
                    upDown
                    );

                statBar.name = statNameLower + "StatBar";
                statBar.x = x;
                statBar.y = y;

                this[ statNameLower + "StatBar" ] = statBar;
                this.statBars.push( statBar );
                this.addChild( statBar );
            }
        };

        protected function setStatText( name :String, value :* ) {
            if ( /Num$/.test( name ) )
            {
                var fVal:* = Math.floor( value );
                var dispText:String;
                
                if (fVal >= 10000)
                {
                    dispText = "++++";
                }
                else
                {
                    dispText = String( fVal );
                }
                
                (this.getChildByName( name ) as TextField).htmlText = dispText;
            }
            else
                (this.getChildByName( name ) as TextField).htmlText = value;
        };

        protected function setStatBar( name :String, progress :Number ) {
            this.getChildByName( name ).width = Math.round( progress * 115 );
        };

        // <- statsScreenRefresh
        public function refresh() :void {
            // this.show();
            // this.visible = true;

            setStatText( "coreStatsText",
                "<b><u>Name : {NAME}</u>\nCore Stats</b>"
                    .replace( "{NAME}", model.player.short ) );

            // setStatText( "strNum", model.player.str );
            // setStatText( "touNum", model.player.tou );
            // setStatText( "speNum", model.player.spe );
            // setStatText( "inteNum", model.player.inte );
            // setStatText( "libNum", model.player.lib );
            // setStatText( "senNum", model.player.sens );
            // setStatText( "corNum", model.player.cor );
            // setStatText( "fatigueNum", model.player.fatigue );
            // setStatText( "HPNum", model.player.HP );
            // setStatText( "lustNum", model.player.lust );

            setStatText( "levelNum", model.player.level );
            setStatText( "xpNum", model.player.XP );
            setStatText( "gemsNum", model.player.gems );

            setStatText( "timeText",
                "<b><u>Day #: {DAYS}</u></b>\n<b>Time : {HOURS}:00</b>"
                    .replace( "{DAYS}", model.time.days )
                    .replace( "{HOURS}", model.time.hours ) );

            // setStatBar( "strBar", model.player.str/100 );
            // setStatBar( "touBar", model.player.tou/100 );
            // setStatBar( "speBar", model.player.spe/100 );
            // setStatBar( "inteBar", model.player.inte/100 );
            // setStatBar( "libBar", model.player.lib/100 );
            // setStatBar( "sensBar", model.player.sens/100 );
            // setStatBar( "corBar", model.player.cor/100 );
            // setStatBar( "fatigueBar", model.player.fatigue/100 );
            // setStatBar( "HPBar", model.player.HP/model.maxHP() );
            // setStatBar( "lustBar", model.player.lust/100 );

            strStatBar.currentValue     = model.player.str;
            touStatBar.currentValue     = model.player.tou;
            speStatBar.currentValue     = model.player.spe;
            inteStatBar.currentValue    = model.player.inte;
            libStatBar.currentValue     = model.player.lib;
            sensStatBar.currentValue    = model.player.sens;
            corStatBar.currentValue     = model.player.cor;
            fatigueStatBar.currentValue = model.player.fatigue;
            lustStatBar.currentValue    = model.player.lust;

            hpStatBar.maximumValue = model.maxHP();
            hpStatBar.currentValue = model.player.HP;
        };

        // <- showStats
        public function show() {
            // make all the stats DOs visible.
            this.refresh();
            this.visible = true;
        };

        // <- hideStats
        public function hide() {
            // body...
            this.visible = false;
        };

        // <- hideUpDown
        public function hideUpDown() {
            var ci,
                cc = this.upDownsContainer.numChildren,
                statBar :StatBar;

            this.upDownsContainer.visible = false;

            // children also need to be hidden because they're selectively shown on change.
            for( ci = 0; ci < cc; ++ci ) {
                this.upDownsContainer.getChildAt( ci ).visible = false;
            }

            this.hideLevelUp();

            for each( statBar in this.statBars ) {
                statBar.hideUpDown();
            }
        };

        public function showUpDown() {
            function _oldStatNameFor( statName :String ) {
                return 'old' + statName.charAt( 0 ).toUpperCase() + statName.substr( 1 );
            }

            var statName :String,
                oldStatName :String,
                allStats :Array;

            this.upDownsContainer.visible = true;

            allStats = [ "str", "tou", "spe", "inte", "lib", "sens", "cor", "lust", "hp" ];

            for each( statName in allStats ) {
                oldStatName = _oldStatNameFor( statName );

                if( this.model.player[ statName ] > this.model.oldStats[ oldStatName ] ) {
                    this[ statName + "StatBar" ].showUp();
                    // this.showStatUp( statName );
                }
                if( this.model.player[ statName ] < this.model.oldStats[ oldStatName ] ) {
                    this[ statName + "StatBar" ].showDown();
                    // this.showStatDown( statName );
                }
                else {
                    this[ statName + "StatBar" ].hideUpDown();
                }
            }
        };

        public function showLevelUp() :void {
            this.levelUp.visible = true;
        };

        public function hideLevelUp() :void {
            this.levelUp.visible = false;
        };

        public function showStatUp( statName :String ) :void {
            var statUp :DisplayObject,
                statDown :DisplayObject;

            if( this[ statName + "StatBar" ] ) {
                this[ statName + "StatBar" ].showUp();
            }
            else {
                statUp = this.upDownsContainer.getChildByName( statName + 'Up' );
                statDown = this.upDownsContainer.getChildByName( statName + 'Down' );

                statUp.visible = true;
                statDown.visible = false;
            }
        };

        public function showStatDown( statName :String ) :void {
            var statUp :DisplayObject,
                statDown :DisplayObject;

            if( this[ statName + "StatBar" ] ) {
                this[ statName + "StatBar" ].showDown();
            }
            else {
                statUp = this.upDownsContainer.getChildByName( statName + 'Up' );
                statDown = this.upDownsContainer.getChildByName( statName + 'Down' );

                statUp.visible = false;
                statDown.visible = true;
            }
        };
    }
}