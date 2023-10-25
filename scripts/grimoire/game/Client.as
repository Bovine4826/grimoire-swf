package grimoire.game
{
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import grimoire.Root;
   
   public class Client
   {
      
      private static var game:* = Root.Game;
      
      private static var pref:* = Root.Game.userPreference;
      
      private static var charPage:*;
      
      public static var cTravelTriggers:String = "";
      
      public static var timer:Timer = new Timer(10000);
      
      public static var shouldPing:Boolean;
      
      public static var funcYes:Function;
      
      public static var funcNo:Function;
      
      public static var latency:Number;
       
      
      public function Client()
      {
         super();
      }
      
      public static function isClientLoading(param1:String) : String
      {
         switch(param1)
         {
            case "Account":
               return game.mcConnDetail.txtDetail.text == "Authenticating Account Info..." && game.mcConnDetail.stage != null ? Root.trueString : Root.falseString;
            case "Client":
               return game.mcConnDetail.txtDetail.text == "Initializing Client..." && game.mcConnDetail.stage != null ? Root.trueString : Root.falseString;
            case "Lobby":
               return game.mcConnDetail.txtDetail.text == "Joining Lobby.." && game.mcConnDetail.stage != null ? Root.trueString : Root.falseString;
            case "Server":
               return game.mcConnDetail.txtDetail.text == "Connecting to game server..." && game.mcConnDetail.stage != null ? Root.trueString : Root.falseString;
            case "Character":
               return game.mcConnDetail.txtDetail.text == "Loading Character Data..." && game.mcConnDetail.stage != null ? Root.trueString : Root.falseString;
            case "Communication":
               return game.mcConnDetail.txtDetail.text == "Communication with server has been lost. Please check your internet connection and try again." && game.mcConnDetail.stage != null ? Root.trueString : Root.falseString;
            case "MapLoading":
               return game.mcConnDetail.txtDetail.text == "Loading Map Files..." && game.mcConnDetail.stage != null ? Root.trueString : Root.falseString;
            case "MapLoadingStuck":
               return game.mcConnDetail.txtDetail.text == "Loading Map... 100%" && game.mcConnDetail.btnBack.visible == Root.trueString && game.mcConnDetail.stage != null ? Root.trueString : Root.falseString;
            case "MapLoadingError":
               return game.mcConnDetail.txtDetail.text == "Loading Map Files... Failed!" && game.mcConnDetail.stage != null ? Root.trueString : Root.falseString;
            default:
               return Root.falseString;
         }
      }
      
      public static function loginLabel() : String
      {
         return game.currentLabel == "Login" || game.currentLabel == "Select" ? Root.trueString : Root.falseString;
      }
      
      public static function serverLabel() : String
      {
         return game.mcLogin.currentLabel == "Servers" ? Root.trueString : Root.falseString;
      }
      
      public static function gameLabel() : String
      {
         return game.currentLabel == "Game" ? Root.trueString : Root.falseString;
      }
      
      public static function inGame() : String
      {
         if(game.intChatMode)
         {
            return !!game.ui.mcInterface.ncText.visible ? Root.trueString : Root.falseString;
         }
         return !!game.ui.mcInterface.te.visible ? Root.trueString : Root.falseString;
      }
      
      public static function inConnStage() : String
      {
         return game.mcConnDetail.stage != null ? Root.trueString : Root.falseString;
      }
      
      public static function modifyBtnSend() : void
      {
         game.ui.mcInterface.ncSendText.removeEventListener(MouseEvent.CLICK,game.chatF.onBtnSendText);
         game.ui.mcInterface.ncSendText.addEventListener(MouseEvent.CLICK,onBtnSendText);
         game.ui.mcInterface.ncText.removeEventListener(KeyboardEvent.KEY_DOWN,game.key_ChatEntry);
         game.ui.mcInterface.ncText.addEventListener(KeyboardEvent.KEY_DOWN,key_ChatEntry);
      }
      
      public static function loadTravelTriggers(param1:String) : void
      {
         cTravelTriggers = param1;
      }
      
      public static function startLatencyTimer() : void
      {
         var f:Function = null;
         if(!timer.running)
         {
            latency = new Date().getTime();
            game.sfc.sendXtMessage("zm","hi",[],"str",1);
            shouldPing = false;
            timer.addEventListener(TimerEvent.TIMER,f = function():void
            {
               if(Root.isLoggedIn && shouldPing && !game.world.myAvatar.dataLeaf.afk)
               {
                  latency = new Date().getTime();
                  game.sfc.sendXtMessage("zm","hi",[],"str",1);
                  shouldPing = false;
               }
            });
            timer.start();
         }
      }
      
      public static function gotoCustomTravel(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         if(cTravelTriggers != "" && cTravelTriggers != null)
         {
            _loc2_ = cTravelTriggers.split("|");
            _loc3_ = int(param1.split("t")[1]);
            if(_loc3_ <= _loc2_.length - 1)
            {
               _loc5_ = (_loc4_ = String(_loc2_[_loc3_])).split("`");
               game.world.gotoTown(_loc5_[1],_loc5_[2],_loc5_[3]);
            }
         }
      }
      
      public static function displayCharPage(param1:String) : void
      {
         var _loc2_:Class = Class(Root.gameDomain.getDefinition("liteAssets.draw.charPage"));
         charPage = new _loc2_(game,param1);
         game.ui.addChild(charPage);
      }
      
      public static function gullible() : void
      {
         game.world.strAreaName = "gullible-1";
         game.updateAreaName();
         game.world.loadMap("town-limbo.swf");
         game.chatF.pushMsg("server","You joined \"gullible-1\"","SERVER","",0);
      }
      
      public static function msgBox(param1:String, param2:Boolean = true, param3:Boolean = false, param4:Function = null, param5:Function = null) : void
      {
         var _loc6_:MovieClip = null;
         if(param3)
         {
            game.showConfirmtaionBox(param1,null);
         }
         else
         {
            game.showMessageBox(param1,null);
         }
         funcYes = param4;
         funcNo = param5;
         var _loc7_:int = 0;
         while(_loc7_ < game.ui.ModalStack.numChildren)
         {
            if((_loc6_ = game.ui.ModalStack.getChildAt(_loc7_) as MovieClip).cnt.strBody.text == param1)
            {
               _loc6_.greedy = param2;
               if(param3)
               {
                  _loc6_.cnt.btns.dual.ybtn.removeEventListener(MouseEvent.CLICK,_loc6_.yClick);
                  _loc6_.cnt.btns.dual.nbtn.removeEventListener(MouseEvent.CLICK,_loc6_.nClick);
                  _loc6_.cnt.btns.dual.ybtn.addEventListener(MouseEvent.CLICK,yClick,false,0,true);
                  _loc6_.cnt.btns.dual.nbtn.addEventListener(MouseEvent.CLICK,nClick,false,0,true);
               }
               break;
            }
            _loc7_++;
         }
      }
      
      private static function onBtnSendText(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(game.ui.mcInterface.ncText.text.indexOf(".") == 0 && game.ui.mcInterface.ncText.text.indexOf("c") == 1 && game.ui.mcInterface.ncText.text.indexOf("t") == 2)
         {
            gotoCustomTravel(game.ui.mcInterface.ncText.text);
            closeChat();
         }
         else
         {
            _loc2_ = String(game.ui.mcInterface.ncText.text);
            if(_loc2_.indexOf("/join gullible") == 0)
            {
               gullible();
               return;
            }
            if(_loc2_.indexOf("/join ") == 0 && _loc2_.indexOf("-") > -1 && _loc2_.split("-")[1].indexOf("1e99") == 0)
            {
               _loc3_ = Math.floor(Math.random() * 98999 | 1001);
               _loc2_ = _loc2_.split("-")[0] + "-" + (_loc2_.split("-")[1] = _loc3_.toString());
            }
            if(_loc2_.indexOf("/") == 0)
            {
               ExternalInterface.call("chatCommand",_loc2_.replace("/",""));
               if(_loc2_.indexOf("/combat") == 0 || _loc2_.indexOf("/fps") == 0)
               {
                  closeChat();
                  return;
               }
            }
            game.chatF.submitMsg(_loc2_,game.chatF.chn.cur.typ,game.chatF.pmNm);
            game.stage.focus = null;
         }
      }
      
      private static function key_ChatEntry(param1:KeyboardEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         if(param1.keyCode == Keyboard.ENTER)
         {
            _loc2_ = !!game.intChatMode ? String(game.ui.mcInterface.ncText.text) : String(game.ui.mcInterface.te.text);
            if(_loc2_.indexOf(".") == 0 && _loc2_.indexOf("c") == 1 && _loc2_.indexOf("t") == 2)
            {
               gotoCustomTravel(_loc2_);
               closeChat();
            }
            else
            {
               _loc3_ = _loc2_;
               if(_loc3_.indexOf("/join gullible") == 0)
               {
                  gullible();
                  return;
               }
               if(_loc3_.indexOf("/join ") == 0 && _loc3_.indexOf("-") > -1 && _loc3_.split("-")[1].indexOf("1e99") == 0)
               {
                  _loc4_ = Math.floor(Math.random() * 98999 | 1001);
                  _loc3_ = _loc3_.split("-")[0] + "-" + (_loc3_.split("-")[1] = _loc4_.toString());
               }
               if(_loc3_.indexOf("/") == 0)
               {
                  ExternalInterface.call("chatCommand",_loc3_.replace("/",""));
                  if(_loc3_.indexOf("/combat") == 0 || _loc3_.indexOf("/fps") == 0)
                  {
                     closeChat();
                     return;
                  }
               }
               game.chatF.submitMsg(_loc3_,game.chatF.chn.cur.typ,game.chatF.pmNm);
            }
         }
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            game.chatF.closeMsgEntry();
         }
      }
      
      private static function closeChat() : void
      {
         if(game.intChatMode)
         {
            game.ui.mcInterface.ncText.text = "";
         }
         else
         {
            game.ui.mcInterface.te.text = "";
         }
         game.stage.focus = null;
      }
      
      private static function yClick(param1:MouseEvent) : void
      {
         funcYes();
      }
      
      private static function nClick(param1:MouseEvent) : void
      {
         funcNo();
      }
   }
}
