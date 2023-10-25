package grimoire.game
{
   import flash.events.MouseEvent;
   import grimoire.Root;
   
   public class Setting
   {
      
      private static var game:* = Root.Game;
      
      private static var pref:* = Root.Game.userPreference;
      
      private static var _untargetDeadTgts:Boolean = false;
      
      private static var _untargetSelf:Boolean = false;
      
      private static var _reaccQuest:Boolean = false;
      
      private static var _warnDecline:Boolean = false;
      
      private static var _presetDropUI:Boolean = false;
      
      public static var _visibility:Boolean = true;
      
      public static var oneTime:Object = {
         "lagKiller":false,
         "setFPS":false
      };
       
      
      public function Setting()
      {
         super();
      }
      
      public static function toggleInfiniteRange(param1:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            if(param1)
            {
               game.world.actions.active[_loc2_].range = 20000;
            }
            else
            {
               _loc3_ = parseInt(Skill.skillRange.split(";")[_loc2_]);
               game.world.actions.active[_loc2_].range = _loc3_;
            }
            _loc2_++;
         }
      }
      
      public static function provokeMonsters() : void
      {
         game.world.aggroAllMon();
      }
      
      public static function setEnemyMagnet() : void
      {
         if(game.world.myAvatar.target != null)
         {
            game.world.myAvatar.target.pMC.x = game.world.myAvatar.pMC.x;
            game.world.myAvatar.target.pMC.y = game.world.myAvatar.pMC.y;
         }
      }
      
      public static function toggleLagKiller(param1:Boolean) : void
      {
         if(!param1 && !oneTime.lagKiller)
         {
            Client.msgBox("The game screen is on Lag Killer mode. This mode improves the client\'s performance. You can turn it off by going to the Options tab on the main menu and untick the option.");
            oneTime.lagKiller = true;
         }
         _visibility = param1;
         game.world.visible = param1;
      }
      
      public static function hidePlayers(param1:Boolean) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in game.world.avatars)
         {
            if(_loc2_ != null && _loc2_.pnm != null && !_loc2_.isMyAvatar)
            {
               if(param1)
               {
                  _loc2_.hideMC();
               }
               else
               {
                  _loc2_.showMC();
               }
            }
         }
      }
      
      public static function skipCutscenes(param1:String, param2:String) : void
      {
         while(game.mcExtSWF.numChildren > 0)
         {
            game.mcExtSWF.removeChildAt(0);
         }
         if(game.world.strFrame != param1)
         {
            game.world.moveToCell(param1,param2);
         }
         if(_visibility)
         {
            game.world.visible = true;
         }
         game.showInterface();
      }
      
      public static function setWalkSpeed(param1:int) : void
      {
         game.world.WALKSPEED = param1;
      }
      
      public static function disableAnimations(param1:Boolean) : void
      {
         game.world.showAnimations = !param1;
      }
      
      public static function toggleAdvancedOpt(param1:Boolean) : void
      {
         var _loc2_:* = game.litePreference.data;
         if(Boolean(_loc2_.bUntargetDead) || _untargetDeadTgts)
         {
            _untargetDeadTgts = !_untargetDeadTgts;
            _loc2_.bUntargetDead = !_loc2_.bUntargetDead;
         }
         if((_loc2_.bUntargetSelf || _untargetSelf) && param1)
         {
            _untargetSelf = !_untargetSelf;
            _loc2_.bUntargetSelf = !_loc2_.bUntargetSelf;
         }
         if(Boolean(_loc2_.bReaccept) || _reaccQuest)
         {
            _reaccQuest = !_reaccQuest;
            _loc2_.bReaccept = !_loc2_.bReaccept;
         }
         if(Boolean(_loc2_.bCustomDrops) && (_loc2_.dOptions["warnDecline"] || _warnDecline))
         {
            _warnDecline = !_warnDecline;
            _loc2_.dOptions["warnDecline"] = !_loc2_.dOptions["warnDecline"];
         }
      }
      
      public static function toggleDropUIOpt(param1:Boolean) : void
      {
         var _loc2_:* = game.litePreference.data;
         if(_loc2_.bCustomDrops)
         {
            if(param1 || _loc2_.dOptions["dragMode"] && !game.cDropsUI.isMenuOpen())
            {
               game.cDropsUI.mcDraggable.menuBar.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            }
            else if(param1 || !_loc2_.dOptions["dragMode"] && !game.cDropsUI.isMenuOpen())
            {
               game.cDropsUI.inner_menu.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            }
         }
      }
      
      public static function disableDeathAd() : void
      {
         var _loc1_:* = game.userPreference.data.bDeathAd;
         if(_loc1_ || _loc1_ == null)
         {
            _loc1_ = false;
         }
      }
      
      public static function enableChat() : void
      {
         if(game.world.myAvatar.objData.intActivationFlag != 5)
         {
            game.world.myAvatar.objData.intActivationFlag = 5;
         }
      }
   }
}
