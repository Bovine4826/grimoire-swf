package grimoire.game
{
   import grimoire.Root;
   
   public class World
   {
      
      private static var game:* = Root.Game;
      
      private static var pref:* = Root.Game.userPreference;
      
      public static var mapCells:Array = [];
      
      public static var busy:Boolean = false;
       
      
      public function World()
      {
         super();
      }
      
      public static function mapLoadComplete() : String
      {
         if(!game.world.mapLoadInProgress)
         {
            try
            {
               return game.getChildAt(game.numChildren - 1) != game.mcConnDetail ? Root.trueString : Root.falseString;
            }
            catch(e:*)
            {
               return Root.falseString;
            }
         }
         else
         {
            return Root.falseString;
         }
      }
      
      public static function isActionAvailable(param1:String) : String
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         _loc2_ = game.world.lock[param1];
         _loc3_ = new Date();
         return (_loc5_ = (_loc4_ = _loc3_.getTime()) - _loc2_.ts) < _loc2_.cd ? Root.falseString : Root.trueString;
      }
      
      public static function playersInMap() : String
      {
         return JSON.stringify(game.world.areaUsers);
      }
      
      public static function getMonstersInCell() : String
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc1_:* = null;
         var _loc4_:Array = game.world.getMonstersByCell(Root.Game.world.strFrame);
         var _loc5_:Array = [];
         for(_loc1_ in _loc4_)
         {
            _loc2_ = _loc4_[_loc1_];
            _loc3_ = new Object();
            _loc3_.sRace = _loc2_.objData.sRace;
            _loc3_.strMonName = _loc2_.objData.strMonName;
            _loc3_.MonID = _loc2_.dataLeaf.MonID;
            _loc3_.iLvl = _loc2_.dataLeaf.iLvl;
            _loc3_.intState = _loc2_.dataLeaf.intState;
            _loc3_.intHP = _loc2_.dataLeaf.intHP;
            _loc3_.intHPMax = _loc2_.dataLeaf.intHPMax;
            _loc5_.push(_loc3_);
         }
         return JSON.stringify(_loc5_);
      }
      
      public static function getVisibleMonstersInCell() : String
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc1_:* = null;
         var _loc4_:Array = Root.Game.world.getMonstersByCell(Root.Game.world.strFrame);
         var _loc5_:Array = [];
         for(_loc1_ in _loc4_)
         {
            _loc2_ = _loc4_[_loc1_];
            if(!(_loc2_.pMC == null || !_loc2_.pMC.visible || _loc2_.dataLeaf.intState <= 0))
            {
               _loc3_ = new Object();
               _loc3_.sRace = _loc2_.objData.sRace;
               _loc3_.strMonName = _loc2_.objData.strMonName;
               _loc3_.MonID = _loc2_.dataLeaf.MonID;
               _loc3_.iLvl = _loc2_.dataLeaf.iLvl;
               _loc3_.intState = _loc2_.dataLeaf.intState;
               _loc3_.intHP = _loc2_.dataLeaf.intHP;
               _loc3_.intHPMax = _loc2_.dataLeaf.intHPMax;
               _loc5_.push(_loc3_);
            }
         }
         return JSON.stringify(_loc5_);
      }
      
      public static function setSpawnPoint() : void
      {
         game.world.setSpawnPoint(game.world.strFrame,game.world.strPad);
      }
      
      public static function isMonsterAvailable(param1:String) : String
      {
         return getMonsterByName(param1) != null ? Root.trueString : Root.falseString;
      }
      
      public static function getSkillName(param1:String) : String
      {
         return "\"" + Root.Game.world.actions.active[parseInt(param1)].nam + "\"";
      }
      
      public static function getMonster(param1:String) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:Object = game.world.getMonstersByCell(game.world.strFrame);
         for each(_loc2_ in _loc4_)
         {
            if(_loc2_.pMC)
            {
               if(param1)
               {
                  _loc3_ = String(_loc2_.pMC.pname.ti.text.toLowerCase());
                  if(_loc3_.indexOf(param1.toLowerCase()) > -1 || param1 == "*" && _loc2_.dataLeaf.intState > 0)
                  {
                     return _loc2_;
                  }
               }
               else if(_loc2_.dataLeaf.intState > 0)
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
      
      public static function getMonsterByName(param1:String) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         for each(_loc2_ in game.world.getMonstersByCell(game.world.strFrame))
         {
            _loc3_ = String(_loc2_.pMC.pname.ti.text.toLowerCase());
            if((_loc3_.indexOf(param1.toLowerCase()) > -1 || param1 == "*") && _loc2_.dataLeaf.intState > 0)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getCells() : String
      {
         var _loc1_:Object = null;
         var _loc2_:Array = [];
         for each(_loc1_ in game.world.map.currentScene.labels)
         {
            _loc2_.push(_loc1_.name);
         }
         return JSON.stringify(_loc2_);
      }
      
      public static function getPads(param1:Boolean = true) : *
      {
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < game.world.map.numChildren)
         {
            if(game.world.map.getChildAt(_loc3_).toString().split(" ")[1].toLowerCase().indexOf("pad") > -1)
            {
               _loc2_.push(game.world.map.getChildAt(_loc3_).name);
            }
            _loc3_++;
         }
         if(!param1)
         {
            return _loc2_;
         }
         return JSON.stringify(_loc2_);
      }
      
      public static function getMapItems(param1:Boolean = true) : *
      {
         var mapItem:Object = null;
         var json:Boolean = param1;
         var mapItems:Array = [];
         var ID:int = 0;
         var i:int = 0;
         while(i < game.world.map.numChildren)
         {
            try
            {
               game.world.map.getChildAt(i)["componentInspectorSetting"] = true;
            }
            catch(err:Error)
            {
            }
            if("mapItem" in game.world.map.getChildAt(i) && ID != game.world.map.getChildAt(i).mapItem)
            {
               mapItem = new Object();
               mapItem.ID = game.world.map.getChildAt(i).mapItem;
               mapItem.name = game.world.map.getChildAt(i).strName.replace(/(^[a-z]|\s[a-z])/g,function():String
               {
                  return arguments[1].toUpperCase();
               });
               mapItem.qID = game.world.map.getChildAt(i).intQuest;
               mapItem.itemName = game.world.map.getChildAt(i).strItemName;
               mapItem.collectMsg = game.world.map.getChildAt(i).strCollectMsg;
               mapItems.push(mapItem);
               ID = int(game.world.map.getChildAt(i).mapItem);
            }
            try
            {
               game.world.map.getChildAt(i)["componentInspectorSetting"] = false;
            }
            catch(err:Error)
            {
            }
            i++;
         }
         if(!json)
         {
            return mapItems;
         }
         return JSON.stringify(mapItems);
      }
      
      public static function scanMap(param1:Boolean = false) : *
      {
         var _loc2_:Object = null;
         var _loc3_:int = int(game.stage.frameRate);
         busy = true;
         mapCells = [];
         game.stage.frameRate = 60;
         for each(_loc2_ in game.world.map.currentScene.labels)
         {
            if(_loc2_.name != "Wait" && _loc2_.name != "Blank")
            {
               mapCells.push(getCellInfo(_loc2_.name,false));
            }
         }
         game.stage.frameRate = _loc3_;
         busy = false;
         if(param1)
         {
            return JSON.stringify(mapCells);
         }
      }
      
      public static function getMapCells() : String
      {
         return JSON.stringify(mapCells);
      }
      
      public static function isBusy() : String
      {
         return busy ? Root.trueString : Root.falseString;
      }
      
      public static function getCellInfo(param1:String, param2:Boolean = true) : *
      {
         var cell:Object = null;
         var name:String = param1;
         var json:Boolean = param2;
         game.world.visible = false;
         if(game.world.strFrame != name)
         {
            game.world.map.gotoAndPlay(name);
         }
         cell = new Object();
         cell.name = game.world.map.currentLabel;
         try
         {
            cell.pads = getPads(false);
         }
         catch(e:Error)
         {
            cell.pads = ["Left"];
         }
         try
         {
            cell.mapItems = getMapItems(false);
         }
         catch(e:Error)
         {
            cell.mapItems = [];
         }
         if(game.world.strFrame != name)
         {
            game.world.exitCell();
            game.world.map.gotoAndPlay("Blank");
         }
         game.world.visible = Setting._visibility;
         if(!json)
         {
            return cell;
         }
         return JSON.stringify(cell);
      }
      
      public static function getItemTree() : String
      {
         var _loc1_:* = null;
         var _loc2_:Array = [];
         for(_loc1_ in game.world.invTree)
         {
            _loc2_.push(game.world.invTree[_loc1_]);
         }
         return JSON.stringify(_loc2_);
      }
      
      public static function roomID() : String
      {
         return game.world.curRoom.toString();
      }
      
      public static function roomNumber() : String
      {
         return game.world.strAreaName.split("-")[1];
      }
      
      public static function players() : String
      {
         return JSON.stringify(game.world.uoTree);
      }
      
      public static function monsterHealth(param1:String) : int
      {
         var _loc2_:Object = World.getMonsterByName(param1);
         if(_loc2_ != null)
         {
            return _loc2_.dataLeaf.intHP;
         }
         return 0;
      }
      
      public static function isPlayerInCombat(param1:String) : String
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = game.world.uoTree;
         var _loc5_:String = Root.falseString;
         for(_loc3_ in _loc4_)
         {
            _loc2_ = _loc4_[_loc3_];
            if(_loc2_.strUsername.toLowerCase() == param1.toLowerCase() && _loc2_.intState == 2)
            {
               _loc5_ = Root.trueString;
            }
         }
         return _loc5_;
      }
      
      public static function isPlayerWithClass(param1:String, param2:String) : String
      {
         var _loc3_:Object = World.getAvatar(param1);
         var _loc4_:String = Root.falseString;
         if(_loc3_ != null && _loc3_.objData.strClassName.toLowerCase() == param2.toLowerCase())
         {
            _loc4_ = Root.trueString;
         }
         return _loc4_;
      }
      
      public static function getAvatar(param1:String) : Object
      {
         var _loc2_:* = undefined;
         var _loc3_:String = null;
         var _loc4_:* = game.world.avatars;
         for each(_loc2_ in _loc4_)
         {
            if(_loc2_.pMC)
            {
               if(!param1)
               {
                  return _loc2_;
               }
               _loc3_ = String(_loc2_.pnm.toLowerCase());
               if(_loc3_.indexOf(param1.toLowerCase()) > -1 || param1 == "*")
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
      
      public static function reloadCurrentMap() : void
      {
         game.world.reloadCurrentMap();
      }
      
      public static function changeAreaName(param1:String) : void
      {
         game.world.strAreaName = param1;
         game.updateAreaName();
      }
      
      public static function loadMap(param1:String) : void
      {
         game.world.loadMap(param1);
      }
      
      public static function avatarsInMap() : String
      {
         var _loc1_:* = undefined;
         var _loc2_:Object = null;
         var _loc3_:Array = [];
         for each(_loc1_ in game.world.avatars)
         {
            _loc2_ = new Object();
            _loc2_.uoName = _loc1_.dataLeaf.uoName;
            _loc2_.strUsername = _loc1_.dataLeaf.strUsername;
            _loc2_.intHP = _loc1_.dataLeaf.intHP;
            _loc2_.intHPMax = _loc1_.dataLeaf.intHPMax;
            _loc2_.intMP = _loc1_.dataLeaf.intMP;
            _loc2_.afk = _loc1_.dataLeaf.afk;
            _loc2_.entID = _loc1_.dataLeaf.entID;
            _loc2_.intLevel = _loc1_.dataLeaf.intLevel;
            _loc2_.strFrame = _loc1_.dataLeaf.strFrame;
            _loc2_.strPad = _loc1_.dataLeaf.strPad;
            _loc2_.intState = _loc1_.dataLeaf.intState;
            _loc3_.push(_loc2_);
         }
         return JSON.stringify(_loc3_);
      }
      
      public static function monstersInMap() : String
      {
         var _loc1_:* = undefined;
         var _loc2_:Object = null;
         var _loc3_:Array = [];
         for each(_loc1_ in game.world.monsters)
         {
            _loc2_ = new Object();
            _loc2_.sRace = _loc1_.objData.sRace;
            _loc2_.strMonName = _loc1_.objData.strMonName;
            _loc2_.MonID = _loc1_.dataLeaf.MonID;
            _loc2_.iLvl = _loc1_.dataLeaf.iLvl;
            _loc2_.intState = _loc1_.dataLeaf.intState;
            _loc2_.intHP = _loc1_.dataLeaf.intHP;
            _loc2_.intHPMax = _loc1_.dataLeaf.intHPMax;
            _loc3_.push(_loc2_);
         }
         return JSON.stringify(_loc3_);
      }
      
      public static function GetCellPlayers(param1:*) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = Root.Game.world.uoTree;
         var _loc5_:String = Root.falseString;
         for(_loc3_ in _loc4_)
         {
            _loc2_ = _loc4_[_loc3_];
            if(_loc2_.strUsername.toLowerCase() == param1.toLowerCase())
            {
               if(_loc2_.strFrame.toLowerCase() == Root.Game.world.strFrame.toLowerCase())
               {
                  _loc5_ = Root.trueString;
               }
            }
         }
         return _loc5_;
      }
   }
}
