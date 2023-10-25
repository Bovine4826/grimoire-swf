package grimoire
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.Security;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import grimoire.game.Bank;
   import grimoire.game.Client;
   import grimoire.game.Network;
   import grimoire.tools.SFSEvent;
   
   public class Root extends MovieClip
   {
      
      private static var _handler:*;
      
      private static var objLogin:Object = new Object();
      
      public static const trueString:String = "\"True\"";
      
      public static const falseString:String = "\"False\"";
      
      public static var username:String;
      
      public static var password:String;
      
      public static var Game:Object;
      
      public static var instance:Root;
      
      public static var isLoggedIn:Boolean = false;
      
      public static var gameDomain:ApplicationDomain;
       
      
      private const sURL:String = "https://game.aq.com/game/";
      
      private const versionURL:String = this.sURL + "api/data/gameversion";
      
      private var loginURL:*;
      
      private var external:Externalizer;
      
      private var loader:Loader;
      
      private var urlLoader:URLLoader;
      
      private var doSignup:Boolean;
      
      private var isEU:Boolean;
      
      private var isWeb:Boolean;
      
      private var loaderVars:Object;
      
      private var sBG:String;
      
      private var sFile:*;
      
      private var stg:*;
      
      public function Root()
      {
         this.loginURL = this.sURL + "api/login/now";
         super();
         Root.instance = this;
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public static function waitFor(param1:Function, param2:Function, param3:Array, param4:int = 300, param5:String = "\"True\"") : void
      {
         var f:Function = null;
         var timer:Timer = null;
         var bool:Function = param1;
         var func:Function = param2;
         var funcParams:Array = param3;
         var delay:int = param4;
         var boolString:String = param5;
         timer = new Timer(delay);
         timer.addEventListener(TimerEvent.TIMER,f = function():void
         {
            if(bool() == boolString)
            {
               timer.removeEventListener(TimerEvent.TIMER,f);
               timer.stop();
               func.apply(null,funcParams);
            }
         });
         timer.start();
      }
      
      public static function Username() : String
      {
         return "\"" + username + "\"";
      }
      
      public static function Password() : String
      {
         return "\"" + password + "\"";
      }
      
      public static function setFPS(param1:int) : void
      {
         Game.addUpdate("Frames Per Second (FPS) cap has been changed from " + instance.stg.frameRate + " FPS to " + param1 + " FPS.");
         instance.stg.frameRate = param1;
      }
      
      public static function setTitle(param1:String) : void
      {
         Game.mcLogin.mcLogo.txtTitle.htmlText = "<font color=\"#CC1F41\">Release:</font>: " + param1;
         Game.params.sTitle.htmlText = "<font color=\"#CC1F41\">Release:</font>: " + param1;
      }
      
      public static function gameMessage(param1:String) : void
      {
         Game.MsgBox.notify(param1);
      }
      
      public static function gamePopup(param1:String, param2:Boolean = false) : void
      {
         Game.addUpdate(param1,param2);
      }
      
      public static function sendClientPacket(param1:String, param2:String) : void
      {
         var _loc3_:Class = null;
         if(_handler == null)
         {
            _loc3_ = Class(gameDomain.getDefinition("it.gotoandplay.smartfoxserver.handlers.ExtHandler"));
            _handler = new _loc3_(Game.sfc);
         }
         if(param2 == "xml")
         {
            xmlReceived(param1);
         }
         else if(param2 == "json")
         {
            jsonReceived(param1);
         }
         else if(param2 == "str")
         {
            strReceived(param1);
         }
      }
      
      public static function xmlReceived(param1:String) : void
      {
         _handler.handleMessage(new XML(param1),"xml");
      }
      
      public static function jsonReceived(param1:String) : void
      {
         _handler.handleMessage(JSON.parse(param1)["b"],"json");
      }
      
      public static function strReceived(param1:String) : void
      {
         var _loc2_:Array = param1.substr(1,param1.length - 2).split("%");
         _handler.handleMessage(_loc2_.splice(1,_loc2_.length - 1),"str");
      }
      
      public static function callGameFunction(param1:String, ... rest) : String
      {
         var _loc3_:Array = param1.split(".");
         var _loc4_:String = _loc3_.pop();
         var _loc5_:*;
         var _loc6_:Function = (_loc5_ = _getObjectA(Root.Game,_loc3_))[_loc4_] as Function;
         return JSON.stringify(_loc6_.apply(null,rest));
      }
      
      public static function selectArrayObjects(param1:String, param2:String) : String
      {
         var _loc6_:int = 0;
         var _loc3_:* = _getObjectS(Root.Game,param1);
         if(!(_loc3_ is Array))
         {
            return "";
         }
         var _loc4_:Array = _loc3_ as Array;
         var _loc5_:Array = new Array();
         while(_loc6_ < _loc4_.length)
         {
            _loc5_.push(_getObjectS(_loc4_[_loc6_],param2));
            _loc6_++;
         }
         return JSON.stringify(_loc5_);
      }
      
      public static function _getObjectA(param1:*, param2:Array) : *
      {
         var _loc3_:int = 0;
         var _loc4_:* = param1;
         _loc3_ = 0;
         while(_loc3_ < param2.length)
         {
            _loc4_ = _loc4_[param2[_loc3_]];
            _loc3_++;
         }
         return _loc4_;
      }
      
      public static function _getObjectS(param1:*, param2:String) : *
      {
         return _getObjectA(param1,param2.split("."));
      }
      
      public static function getGameObject(param1:String) : String
      {
         var _loc2_:* = _getObjectS(Root.Game,param1);
         return JSON.stringify(_loc2_);
      }
      
      public static function setGameObject(param1:String, param2:*) : void
      {
         var _loc3_:Array = param1.split(".");
         var _loc4_:String = _loc3_.pop();
         var _loc5_:*;
         (_loc5_ = _getObjectA(Root.Game,_loc3_))[_loc4_] = param2;
      }
      
      public static function isNull(param1:String) : String
      {
         try
         {
            return (_getObjectS(Root.Game,param1) == null).toString();
         }
         catch(ex:Error)
         {
         }
         return "true";
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         Security.allowDomain("*");
         this.urlLoader = new URLLoader();
         this.urlLoader.addEventListener(Event.COMPLETE,this.onDataComplete);
         this.urlLoader.load(new URLRequest(this.versionURL));
      }
      
      private function onDataComplete(param1:Event) : void
      {
         this.urlLoader.removeEventListener(Event.COMPLETE,this.onDataComplete);
         var _loc2_:Object = JSON.parse(param1.target.data);
         this.sFile = _loc2_.sFile + "?ver=" + _loc2_.sVersion;
         this.sBG = _loc2_.sBG;
         this.loaderVars = _loc2_;
         this.loadGame();
      }
      
      private function loadGame() : void
      {
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
         this.loader.load(new URLRequest(this.sURL + "gamefiles/" + this.sFile));
      }
      
      private function onProgress(param1:ProgressEvent) : void
      {
         ExternalInterface.call("progress",Math.round(Number(param1.currentTarget.bytesLoaded / param1.currentTarget.bytesTotal) * 100));
      }
      
      private function onComplete(param1:Event) : void
      {
         var _loc2_:* = undefined;
         this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
         this.stg = stage;
         this.stg.removeChildAt(0);
         Game = this.stg.addChildAt(param1.currentTarget.content,0);
         for(_loc2_ in root.loaderInfo.parameters)
         {
            Game.params[_loc2_] = root.loaderInfo.parameters[_loc2_];
         }
         Game.params.vars = this.loaderVars;
         Game.params.sURL = this.sURL;
         Game.params.sTitle = "<font color=\"#e02045\">Grimlite Rev v1.3</font>";
         Game.params.sBG = "Skyguard.swf";
         Game.params.isWeb = this.isWeb;
         Game.params.isEU = this.isEU;
         Game.params.doSignup = this.doSignup;
         Game.params.loginURL = this.loginURL;
         Game.addEventListener(MouseEvent.CLICK,this.onGameClick);
         Game.addEventListener(KeyboardEvent.KEY_DOWN,this.onGameKeyboard);
         Game.loginLoader.addEventListener(Event.COMPLETE,this.onLoginComplete);
         Game.sfc.addEventListener(SFSEvent.onConnectionLost,this.onDisconnect);
         Game.sfc.addEventListener(SFSEvent.onExtensionResponse,this.onExtensionResponse);
         Game.sfc.addEventListener(SFSEvent.onDebugMessage,this.onXtPacketResponse);
         Game.sfc.addEventListener(SFSEvent.onDebugMessage,this.onPacketResponse);
         gameDomain = LoaderInfo(param1.target).applicationDomain;
         this.external = new Externalizer();
         this.external.init(this);
      }
      
      private function onDisconnect(param1:*) : void
      {
         ExternalInterface.call("disconnect");
      }
      
      private function onLoginComplete(param1:Event) : void
      {
         objLogin = JSON.parse(param1.target.data);
         param1.target.data = String(ExternalInterface.call("modifyServers",param1.target.data));
         if(Game.mcCharSelect)
         {
            Game.mcCharSelect.Game.objLogin = objLogin;
         }
      }
      
      private function onGameClick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         switch(param1.target.name)
         {
            case "btnLogin":
               if(!Game.mcCharSelect)
               {
                  username = Game.mcLogin.ni.text;
                  password = Game.mcLogin.pi.text;
               }
               else
               {
                  Game.mcCharSelect.btnLogin.removeEventListener(MouseEvent.CLICK,Game.mcCharSelect.onBtnLogin);
                  this.onCharBtnClick("Login");
               }
               return;
            case "btnServer":
               if(Game.mcCharSelect)
               {
                  Game.mcCharSelect.btnServer.removeEventListener(MouseEvent.CLICK,Game.mcCharSelect.onBtnServer);
                  this.onCharBtnClick("Server");
               }
               return;
            case "charPage":
               ExternalInterface.call("openWebsite","https://www.aq.com/aw-character.asp?id=" + gameDomain.getDefinition("Game").loginInfo.strUsername);
               return;
            case "txtClassName":
            case "txtWeapon":
            case "txtArmor":
            case "txtHelm":
            case "txtCape":
            case "txtPet":
            case "txtMisc":
               if(param1.target.text != "None")
               {
                  ExternalInterface.call("openWebsite","http://aqwwiki.wikidot.com/" + param1.target.text);
               }
               return;
            case "btCharPage":
               ExternalInterface.call("openWebsite","https://account.aq.com/CharPage?id=" + param1.target.parent.txtUserName.text);
               return;
            case "hit":
               if(getQualifiedClassName(param1.target.parent) != "LPFElementScrollBar" && param1.target.parent.ti && param1.target.parent.ti.text == "Wiki Monster")
               {
                  ExternalInterface.call("openWebsite","http://aqwwiki.wikidot.com/" + Game.ui.mcPortraitTarget.strName.text);
               }
               return;
            case "btnWiki":
               _loc2_ = getQualifiedClassName(param1.target.parent);
               if(_loc2_.indexOf("LPFFrameItemPreview") > -1)
               {
                  ExternalInterface.call("openWebsite","http://aqwwiki.wikidot.com/" + param1.target.parent.tInfo.getLineText(0));
               }
               else if(_loc2_.indexOf("LPFFrameHousePreview") > -1)
               {
                  ExternalInterface.call("openWebsite","http://aqwwiki.wikidot.com/" + Game.ui.mcPopup.getChildByName("mcInventory").previewPanel.frames[3].mc.tInfo.getLineText(0));
               }
               else if(_loc2_.indexOf("mcQFrame") > -1)
               {
                  ExternalInterface.call("openWebsite","http://aqwwiki.wikidot.com/search:site/a/p/q/" + Game.getInstanceFromModalStack("QFrameMC").qData.sName);
               }
               return;
            default:
               return;
         }
      }
      
      private function onGameKeyboard(param1:KeyboardEvent) : void
      {
         switch(param1.target.name)
         {
            case "ni":
            case "pi":
               if(param1.keyCode == Keyboard.ENTER)
               {
                  username = Game.mcLogin.ni.text;
                  password = Game.mcLogin.pi.text;
               }
         }
      }
      
      private function onCharBtnClick(param1:String) : void
      {
         var _loc3_:String = null;
         if(param1 == "Login")
         {
            _loc3_ = String(Game.mcCharSelect.mngr.displayAvts[Game.mcCharSelect.pos].server);
         }
         username = Game.mcCharSelect.mngr.displayAvts[Game.mcCharSelect.pos].loginInfo.strUsername;
         password = Game.mcCharSelect.mngr.displayAvts[Game.mcCharSelect.pos].loginInfo.strPassword;
         var _loc2_:* = Game.mcCharSelect.mngr.displayAvts[Game.mcCharSelect.pos].loginInfo;
         if(_loc2_.bAsk)
         {
            Game.mcCharSelect.utl.close(1);
            Game.mcCharSelect.passwordui.pos = Game.mcCharSelect.pos;
            Game.mcCharSelect.passwordui.bCharOpts = false;
            Game.mcCharSelect.passwordui.visible = true;
         }
         else
         {
            Game.removeAllChildren();
            Game.gotoAndPlay("Login");
            Game.login(username,password);
            if(param1 == "Login")
            {
               waitFor(Network.areServersLoaded,Network.connect,[_loc3_]);
            }
         }
      }
      
      private function filter(param1:String) : String
      {
         var _loc2_:int = 0;
         if(param1.indexOf("[Sending - STR]: ") > -1)
         {
            param1 = param1.replace("[Sending - STR]: ","");
         }
         if(param1.indexOf("[Sending - JSON]: ") > -1)
         {
            param1 = param1.replace("[Sending - JSON]: ","");
         }
         if(param1.indexOf("[ RECEIVED ]: ") > -1)
         {
            param1 = param1.replace("[ RECEIVED ]: ","");
         }
         if(param1.indexOf("[Sending]: ") > -1)
         {
            param1 = param1.replace("[Sending]: ","");
         }
         if(param1.indexOf(", (len: ") > -1)
         {
            _loc2_ = param1.indexOf(", (len: ");
            param1 = param1.slice(0,_loc2_);
         }
         return param1;
      }
      
      public function onXtPacketResponse(param1:*) : void
      {
         if(param1.params.message.indexOf("%xt%zm%") > -1 && param1.params.message.indexOf("%hi%") < 0)
         {
            ExternalInterface.call("xtPacket",this.filter(param1.params.message));
         }
      }
      
      public function onPacketResponse(param1:*) : void
      {
         if(param1.params.message.indexOf("%xt%zm%hi%") > -1)
         {
            return;
         }
         if(param1.params.message.indexOf("%xt%hi%") > -1 || param1.params.message.indexOf("Please slow down. Last action was too soon!") > -1)
         {
            Client.shouldPing = true;
            return;
         }
         if(param1.params.message.indexOf("%xt%loginResponse%") > -1)
         {
            Bank.loaded = false;
         }
         else if(param1.params.message.indexOf("\"cmd\":\"loadInventoryBig\"") > -1)
         {
            isLoggedIn = true;
            Client.shouldPing = true;
         }
         else if(param1.params.message.indexOf("<msg t=\'sys\'><body action=\'logout\' r=\'0\'></body></msg>") > -1)
         {
            isLoggedIn = false;
            Client.shouldPing = false;
         }
         ExternalInterface.call("packet",this.filter(param1.params.message));
      }
      
      public function onExtensionResponse(param1:*) : void
      {
         if(param1.params.type == "str")
         {
            if(param1.params.dataObj[0] == "hi")
            {
               Client.latency -= new Date().getTime();
               Client.latency = Math.abs(Client.latency);
               ExternalInterface.call("ping",Client.latency);
               if(Game.ui.mcPopup.getChildByName("mcO") != null)
               {
                  Game.ui.mcPopup.getChildByName("mcO").latency = Client.latency;
                  Game.ui.mcPopup.getChildByName("mcO").updateLatency();
               }
            }
         }
         ExternalInterface.call("pext",JSON.stringify(param1));
      }
   }
}
