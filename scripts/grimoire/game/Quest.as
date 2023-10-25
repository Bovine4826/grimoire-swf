package grimoire.game
{
   import flash.utils.ByteArray;
   import grimoire.Root;
   
   public class Quest
   {
      
      private static var game:* = Root.Game;
      
      private static var pref:* = Root.Game.userPreference;
       
      
      public function Quest()
      {
         super();
      }
      
      public static function isInProgress(param1:String) : String
      {
         return !game.world.isQuestInProgress(parseInt(param1)) ? Root.falseString : Root.trueString;
      }
      
      public static function completeQuest(param1:String, param2:String = "-1", param3:Boolean = false) : void
      {
         if(game.world.coolDown("tryQuestComplete"))
         {
            game.world.tryQuestComplete(parseInt(param1),parseInt(param2),param3);
         }
      }
      
      public static function acceptQuest(param1:String) : void
      {
         if(game.world.coolDown("acceptQuest"))
         {
            game.world.acceptQuest(parseInt(param1));
         }
      }
      
      public static function loadQuest(param1:String) : void
      {
         game.world.showQuests([param1],"q");
      }
      
      public static function loadMultipleQuests(param1:String) : void
      {
         game.world.showQuests(param1.split(","),"q");
      }
      
      public static function getQuests(param1:String) : void
      {
         game.world.getQuests(param1.split(","));
      }
      
      public static function isAvailable(param1:String) : String
      {
         var _loc2_:Object = game.world.questTree[parseInt(param1)];
         var _loc3_:String = Root.trueString;
         if(_loc2_.sField != null && game.world.getAchievement(_loc2_.sField,_loc2_.iIndex) != 0 || _loc2_.iLvl > game.world.myAvatar.objData.intLevel || _loc2_.bUpg == 1 && !game.world.myAvatar.isUpgraded() || _loc2_.iSlot >= 0 && game.world.getQuestValue(_loc2_.iSlot) < Math.abs(_loc2_.iValue) - 1 || _loc2_.iClass > 0 && game.world.myAvatar.getCPByID(_loc2_.iClass) < _loc2_.iReqCP || _loc2_.FactionID > 1 && game.world.myAvatar.getRep(_loc2_.FactionID) < _loc2_.iReqRep)
         {
            _loc3_ = Root.falseString;
         }
         return _loc3_;
      }
      
      public static function canComplete(param1:String) : String
      {
         return Boolean(game.world.canTurnInQuest(parseInt(param1))) && getQuestValidation(parseInt(param1)) == "" ? Root.trueString : Root.falseString;
      }
      
      private static function cloneObject(param1:Object) : Object
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeObject(param1);
         _loc2_.position = 0;
         return _loc2_.readObject();
      }
      
      public static function getQuestTree() : String
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc8_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc7_:* = undefined;
         var _loc9_:* = undefined;
         var _loc12_:Array = [];
         for each(_loc1_ in Root.Game.world.questTree)
         {
            _loc2_ = cloneObject(_loc1_);
            _loc3_ = [];
            _loc4_ = [];
            if(_loc1_.turnin != null && _loc1_.oItems != null)
            {
               for each(_loc5_ in _loc1_.turnin)
               {
                  _loc6_ = new Object();
                  _loc7_ = _loc1_.oItems[_loc5_.ItemID];
                  _loc6_.sName = _loc7_.sName;
                  _loc6_.ItemID = _loc7_.ItemID;
                  _loc6_.iQty = _loc5_.iQty;
                  _loc6_.bTemp = _loc7_.bTemp;
                  _loc3_.push(_loc6_);
               }
            }
            _loc2_.RequiredItems = _loc3_;
            if(_loc1_.reward != null && _loc1_.oRewards != null)
            {
               for each(_loc8_ in _loc1_.reward)
               {
                  for each(_loc9_ in _loc1_.oRewards)
                  {
                     for each(_loc10_ in _loc9_)
                     {
                        if(_loc10_.ItemID != null && _loc10_.ItemID == _loc8_.ItemID)
                        {
                           (_loc11_ = new Object()).sName = _loc10_.sName;
                           _loc11_.ItemID = _loc8_.ItemID;
                           _loc11_.iQty = _loc8_.iQty;
                           _loc11_.DropChance = String(_loc8_.iRate) + "%";
                           _loc4_.push(_loc11_);
                        }
                     }
                  }
               }
            }
            _loc2_.Rewards = _loc4_;
            _loc12_.push(_loc2_);
         }
         return JSON.stringify(_loc12_);
      }
      
      public static function hasRequiredItems(param1:Object) : String
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         if(param1.reqd != null && param1.reqd.length > 0)
         {
            for each(_loc2_ in param1.reqd)
            {
               _loc3_ = int(_loc2_.ItemID);
               _loc4_ = int(_loc2_.iQty);
               if((_loc5_ = Root.Game.world.invTree[_loc3_]) == null || _loc5_.iQty < _loc4_)
               {
                  return Root.falseString;
               }
            }
         }
         return Root.trueString;
      }
      
      public static function getQuestValidation(param1:int) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc5_:* = null;
         var _loc10_:Object;
         if((_loc10_ = Root.Game.world.questTree[param1]).sField != null && Root.Game.world.getAchievement(_loc10_.sField,_loc10_.iIndex) != 0)
         {
            if(_loc10_.sField == "im0")
            {
               return "Monthly Quests are only available once per month.";
            }
            return "Daily Quests are only available once per day.";
         }
         if(_loc10_.bUpg == 1 && !Root.Game.world.myAvatar.isUpgraded())
         {
            return "Upgrade is required for this quest!";
         }
         if(_loc10_.iSlot >= 0 && Root.Game.world.getQuestValue(_loc10_.iSlot) < _loc10_.iValue - 1)
         {
            return "Quest has not been unlocked!";
         }
         if(_loc10_.iLvl > Root.Game.world.myAvatar.objData.intLevel)
         {
            return "Unlocks at Level " + _loc10_.iLvl + ".";
         }
         if(_loc10_.iClass > 0 && Root.Game.world.myAvatar.getCPByID(_loc10_.iClass) < _loc10_.iReqCP)
         {
            _loc2_ = int(Root.Game.getRankFromPoints(_loc10_.iReqCP));
            _loc3_ = _loc10_.iReqCP - Root.Game.arrRanks[_loc2_ - 1];
            if(_loc3_ > 0)
            {
               return "Requires " + _loc3_ + " Class Points on " + _loc10_.sClass + ", Rank " + _loc2_ + ".";
            }
            return "Requires " + _loc10_.sClass + ", Rank " + _loc2_ + ".";
         }
         if(_loc10_.FactionID > 1 && Root.Game.world.myAvatar.getRep(_loc10_.FactionID) < _loc10_.iReqRep)
         {
            _loc2_ = int(Root.Game.getRankFromPoints(_loc10_.iReqRep));
            if((_loc4_ = _loc10_.iReqRep - Root.Game.arrRanks[_loc2_ - 1]) > 0)
            {
               return "Requires " + _loc4_ + " Reputation for " + _loc10_.sFaction + ", Rank " + _loc2_ + ".";
            }
            return "Requires " + _loc10_.sFaction + ", Rank " + _loc2_ + ".";
         }
         if(_loc10_.reqd != null && !hasRequiredItems(_loc10_))
         {
            _loc5_ = "Required Item(s): ";
            for each(_loc6_ in _loc10_.reqd)
            {
               _loc7_ = int(_loc6_.ItemID);
               _loc8_ = int(_loc6_.iQty);
               if((_loc9_ = Root.Game.world.invTree[_loc7_]).sES == "ar")
               {
                  _loc2_ = int(Root.Game.getRankFromPoints(_loc8_));
                  _loc3_ = _loc8_ - Root.Game.arrRanks[_loc2_ - 1];
                  if(_loc3_ > 0)
                  {
                     _loc5_ = _loc5_ + _loc3_ + " Class Points on ";
                  }
                  _loc5_ = _loc5_ + _loc9_.sName + ", Rank " + _loc2_;
               }
               else
               {
                  _loc5_ += _loc9_.sName;
                  if(_loc8_ > 1)
                  {
                     _loc5_ = _loc5_ + "x" + _loc8_;
                  }
               }
               _loc5_ += ", ";
            }
            return _loc5_.substr(0,_loc5_.length - 2) + ".";
         }
         return "";
      }
   }
}
