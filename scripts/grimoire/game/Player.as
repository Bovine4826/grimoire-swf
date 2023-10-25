package grimoire.game
{
   import flash.filters.GlowFilter;
   import grimoire.Root;
   
   public class Player
   {
      
      private static var game:* = Root.Game;
      
      private static var pref:* = Root.Game.userPreference;
       
      
      public function Player()
      {
         super();
      }
      
      public static function isLoggedIn() : String
      {
         return game != null && game.sfc != null && Boolean(game.sfc.isConnected) ? Root.trueString : Root.falseString;
      }
      
      public static function cell() : String
      {
         return "\"" + game.world.strFrame + "\"";
      }
      
      public static function factions() : String
      {
         return JSON.stringify(game.world.myAvatar.factions);
      }
      
      public static function pad() : String
      {
         return "\"" + game.world.strPad + "\"";
      }
      
      public static function state() : int
      {
         return game.world.myAvatar.dataLeaf.intState;
      }
      
      public static function health() : int
      {
         return game.world.myAvatar.dataLeaf.intHP;
      }
      
      public static function maxHealth() : int
      {
         return game.world.myAvatar.dataLeaf.intHPMax;
      }
      
      public static function mana() : int
      {
         return game.world.myAvatar.dataLeaf.intMP;
      }
      
      public static function maxMana() : int
      {
         return game.world.myAvatar.dataLeaf.intMPMax;
      }
      
      public static function map() : String
      {
         return "\"" + game.world.strMapName + "\"";
      }
      
      public static function level() : int
      {
         return game.world.myAvatar.dataLeaf.intLevel;
      }
      
      public static function isMember() : String
      {
         return game.world.myAvatar.objData.iUpgDays > -1 ? Root.trueString : Root.falseString;
      }
      
      public static function gold() : int
      {
         return game.world.myAvatar.objData.intGold;
      }
      
      public static function hasTarget() : String
      {
         return game.world.myAvatar.target != null && game.world.myAvatar.target.dataLeaf.intHP > 0 ? Root.trueString : Root.falseString;
      }
      
      public static function isAFK() : String
      {
         return !game.world.myAvatar.dataLeaf.afk ? Root.falseString : Root.trueString;
      }
      
      public static function position() : String
      {
         return JSON.stringify([game.world.myAvatar.pMC.x,game.world.myAvatar.pMC.y]);
      }
      
      public static function walkToPoint(param1:String, param2:String) : void
      {
         game.world.myAvatar.pMC.walkTo(parseInt(param1),parseInt(param2),game.world.WALKSPEED);
         game.world.moveRequest({
            "mc":game.world.myAvatar.pMC,
            "tx":parseInt(param1),
            "ty":parseInt(param2),
            "sp":game.world.WALKSPEED
         });
      }
      
      public static function cancelAutoAttack() : void
      {
         game.world.cancelAutoAttack();
      }
      
      public static function cancelTarget() : void
      {
         game.world.cancelTarget();
         if(game.world.myAvatar.target != null)
         {
            game.world.setTarget(null);
         }
      }
      
      public static function cancelTargetSelf() : void
      {
         if(game.world.myAvatar.target == game.world.myAvatar)
         {
            game.world.cancelTarget();
         }
      }
      
      public static function muteToggle() : void
      {
         if(game.chatF.amIMute())
         {
            Root.Game.chatF.unmuteMe();
         }
         else
         {
            Root.Game.chatF.muteMe(300000);
         }
      }
      
      public static function attackMonster(param1:String) : void
      {
         var _loc2_:Object = World.getMonster(param1);
         if(_loc2_ != null)
         {
            game.world.setTarget(_loc2_);
            game.world.approachTarget();
         }
      }
      
      public static function jump(param1:String = "Enter", param2:String = "Spawn") : void
      {
         game.world.moveToCell(param1,param2);
      }
      
      public static function rest() : void
      {
         game.world.rest();
      }
      
      public static function join(param1:String, param2:String = "Enter", param3:String = "Spawn") : void
      {
         game.world.gotoTown(param1,param2,param3);
      }
      
      public static function equipItem(param1:String) : void
      {
         game.world.sendEquipItemRequest({"ItemID":parseInt(param1)});
      }
      
      public static function equipUseableItem(param1:int, param2:String, param3:String, param4:String) : void
      {
         game.world.equipUseableItem({
            "ItemID":param1,
            "sDesc":param2,
            "sFile":param3,
            "sName":param4
         });
      }
      
      public static function unequipItem(param1:String) : void
      {
         game.world.sendUnequipItemRequest({"ItemID":parseInt(param1)});
      }
      
      public static function unequipUseableItem(param1:String) : void
      {
         game.world.unequipUseableItem(Inventory.getItem(param1));
      }
      
      public static function goTo(param1:String) : void
      {
         game.world.goto(param1);
      }
      
      public static function useBoost(param1:String) : void
      {
         var _loc2_:Object = Inventory.getItemByID(parseInt(param1));
         if(_loc2_ != null)
         {
            game.world.sendUseItemRequest(_loc2_);
         }
      }
      
      public static function getMapItem(param1:String) : void
      {
         game.world.getMapItem(parseInt(param1));
      }
      
      public static function hasActiveBoost(param1:String) : String
      {
         if(param1.toLowerCase().indexOf("gold") > -1)
         {
            return game.world.myAvatar.objData.iBoostG > 0 ? Root.trueString : Root.falseString;
         }
         if(param1.toLowerCase().indexOf("xp") > -1)
         {
            return game.world.myAvatar.objData.iBoostXP > 0 ? Root.trueString : Root.falseString;
         }
         if(param1.toLowerCase().indexOf("rep") > -1)
         {
            return game.world.myAvatar.objData.iBoostRep > 0 ? Root.trueString : Root.falseString;
         }
         if(param1.toLowerCase().indexOf("class") > -1)
         {
            return game.world.myAvatar.objData.iBoostCP > 0 ? Root.trueString : Root.falseString;
         }
         return Root.falseString;
      }
      
      public static function className() : String
      {
         return "\"" + game.world.myAvatar.objData.strClassName.toUpperCase() + "\"";
      }
      
      public static function userID() : int
      {
         return game.world.myAvatar.uid;
      }
      
      public static function charID() : int
      {
         return game.world.myAvatar.objData.CharID;
      }
      
      public static function gender() : String
      {
         return "\"" + game.world.myAvatar.objData.strGender.toUpperCase() + "\"";
      }
      
      public static function playerData() : Object
      {
         return game.world.myAvatar.objData;
      }
      
      public static function setEquip(param1:*, param2:*) : void
      {
         if(game.world.myAvatar.pMC.pAV.objData.eqp.Weapon == null)
         {
            return;
         }
         if(param1 == "Off")
         {
            game.world.myAvatar.pMC.pAV.objData.eqp.Weapon.sLink = param2.sLink;
            game.world.myAvatar.pMC.loadWeaponOff(param2.sFile,param2.sLink);
            game.world.myAvatar.pMC.pAV.getItemByEquipSlot("Weapon").sType = "Dagger";
         }
         else
         {
            game.world.myAvatar.objData.eqp[param1] = param2;
            game.world.myAvatar.loadMovieAtES(param1,param2.sFile,param2.sLink);
         }
      }
      
      public static function getEquip(param1:int) : String
      {
         return JSON.stringify(game.world.avatars[param1].objData.eqp);
      }
      
      public static function changeName(param1:String) : void
      {
         game.world.myAvatar.pMC.pAV.objData.strUsername = param1.toUpperCase();
         game.world.myAvatar.objData.strUsername = param1.toUpperCase();
         game.world.myAvatar.pMC.pname.ti.text = param1.toUpperCase();
         game.ui.mcPortrait.strName.text = param1.toUpperCase();
      }
      
      public static function changeGuild(param1:String) : void
      {
         game.world.myAvatar.pMC.pname.tg.text = param1.toUpperCase();
         game.world.myAvatar.objData.guild.Name = param1.toUpperCase();
         game.world.myAvatar.pMC.pAV.objData.guild.Name = param1.toUpperCase();
      }
      
      public static function changeAccessLevel(param1:String) : void
      {
         if(param1 == "Non Member")
         {
            game.world.myAvatar.pMC.pname.ti.textColor = 16777215;
            game.world.myAvatar.pMC.pname.filters = [new GlowFilter(0,1,3,3,64,1)];
            game.world.myAvatar.objData.iUpgDays = -1;
            game.world.myAvatar.objData.iUpg = 0;
         }
         else if(param1 == "Member")
         {
            game.world.myAvatar.pMC.pname.ti.textColor = 9229823;
            game.world.myAvatar.pMC.pname.filters = [new GlowFilter(0,1,3,3,64,1)];
            game.world.myAvatar.objData.iUpgDays = 30;
            game.world.myAvatar.objData.iUpg = 1;
         }
         else if(param1 == "Moderator")
         {
            game.world.myAvatar.pMC.pname.ti.textColor = 16698168;
            game.world.myAvatar.pMC.pname.filters = [new GlowFilter(0,1,3,3,64,1)];
            game.world.myAvatar.objData.intAccessLevel = 60;
         }
      }
      
      public static function changeClass(param1:String) : void
      {
         game.ui.mcPortrait.strClass.text = param1;
         game.world.myAvatar.objData.strClassName = param1;
      }
      
      public static function hasTargetByID(param1:int) : String
      {
         var _loc2_:Object = game.world.getMonster(param1);
         return game.world.myAvatar.target == _loc2_ && game.world.myAvatar.target.dataLeaf.intHP > 0 ? Root.trueString : Root.falseString;
      }
      
      public static function afkPostpone() : void
      {
         var _loc1_:* = new Date().getTime();
         var _loc2_:* = game.world.uoTree[game.sfc.myUserName];
         _loc2_.afkts = _loc1_;
      }
      
      public static function cancelAfk() : void
      {
         game.world.afkPostpone();
      }
      
      public static function isAvatarLoaded() : String
      {
         return Boolean(game.world.myAvatar.invLoaded) || Boolean(game.world.myAvatar.pMC.artLoaded()) ? Root.trueString : Root.falseString;
      }
   }
}
