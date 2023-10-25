package grimoire.game
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import grimoire.Root;
   
   public class Shop
   {
      
      private static var game:* = Root.Game;
      
      private static var pref:* = Root.Game.userPreference;
      
      private static var LoadedShops:Array = [];
       
      
      public function Shop()
      {
         super();
      }
      
      public static function onShopLoaded(param1:Object) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Object = new Object();
         _loc2_.Location = param1.Location;
         _loc2_.sName = param1.sName;
         _loc2_.ShopID = param1.ShopID;
         _loc2_.items = [];
         while(_loc3_ < param1.items.length)
         {
            _loc2_.items.push(param1.items[_loc3_]);
            _loc3_++;
         }
         LoadedShops.push(_loc2_);
      }
      
      public static function resetShopInfo() : void
      {
         game.world.shopinfo = null;
      }
      
      public static function isShopLoaded() : String
      {
         var _loc1_:* = game.world.shopinfo;
         return _loc1_ != null && _loc1_.items != null && _loc1_.items.length > 0 ? Root.trueString : Root.falseString;
      }
      
      public static function buyItem(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:MovieClip = null;
         var _loc6_:* = false;
         var _loc7_:* = undefined;
         var _loc8_:MovieClip = null;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:* = undefined;
         if(!param2)
         {
            _loc3_ = getShopItem(param1.toLowerCase());
            if(_loc3_ != null)
            {
               game.world.sendBuyItemRequest(_loc3_);
            }
         }
         else
         {
            _loc4_ = new Array();
            _loc5_ = game.ui.mcPopup.getChildByName("mcShop") as MovieClip;
            _loc7_ = (_loc6_ = game.ui.mcPopup.currentLabel == "MergeShop") ? _loc5_.getChildAt(0) : _loc5_.getChildAt(2);
            _loc8_ = _loc6_ ? _loc7_.frames[8].mc.iList : _loc7_.frames[5].mc.iList;
            _loc12_ = 0;
            while(_loc12_ < _loc8_.numChildren)
            {
               if((_loc10_ = String((_loc9_ = (_loc13_ = _loc8_.getChildAt(_loc12_)).fData).sName)).indexOf(param1) > -1)
               {
                  if(_loc9_.iStk > 1)
                  {
                     _loc11_ = _loc10_.indexOf(" x" + _loc9_.iQty) + 100;
                     _loc10_ = _loc10_.slice(0,_loc11_);
                  }
                  else if(_loc9_.sES == "ar" && _loc9_.EnhID > 0)
                  {
                     _loc11_ = _loc10_.indexOf(", Rank " + _loc9_.iQty) + 100;
                     _loc10_ = _loc10_.slice(0,_loc11_);
                  }
                  if(_loc10_.toLowerCase() == param1.toLowerCase())
                  {
                     _loc8_.getChildAt(_loc12_).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                     if(!_loc6_)
                     {
                        _loc5_.previewPanel.frames[6].mc.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                     }
                     else
                     {
                        _loc7_.frames[12].mc.btn2.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                     }
                     break;
                  }
               }
               _loc12_++;
            }
         }
      }
      
      public static function buyItemByID(param1:int, param2:int, param3:int, param4:Boolean = false) : void
      {
         var _loc5_:Array = null;
         var _loc6_:MovieClip = null;
         var _loc7_:* = false;
         var _loc8_:* = undefined;
         var _loc9_:MovieClip = null;
         var _loc10_:Object = null;
         var _loc11_:int = 0;
         var _loc12_:* = undefined;
         if(!param4)
         {
            game.sfc.sendXtMessage("zm","buyItem",[param1,param2,param3],"str",Root.Game.world.curRoom);
         }
         else
         {
            _loc5_ = new Array();
            _loc6_ = game.ui.mcPopup.getChildByName("mcShop") as MovieClip;
            _loc8_ = (_loc7_ = game.ui.mcPopup.currentLabel == "MergeShop") ? _loc6_.getChildAt(0) : _loc6_.getChildAt(2);
            _loc9_ = _loc7_ ? _loc8_.frames[8].mc.iList : _loc8_.frames[5].mc.iList;
            _loc11_ = 0;
            while(_loc11_ < _loc9_.numChildren)
            {
               if((_loc10_ = (_loc12_ = _loc9_.getChildAt(_loc11_)).fData).ItemID == param1 && _loc10_.ShopItemID == param3)
               {
                  _loc9_.getChildAt(_loc11_).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  if(!_loc7_)
                  {
                     _loc6_.previewPanel.frames[6].mc.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  else
                  {
                     _loc8_.frames[12].mc.btn2.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  break;
               }
               _loc11_++;
            }
         }
      }
      
      public static function getShopItem(param1:String) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         while(_loc3_ < game.world.shopinfo.items.length)
         {
            _loc2_ = game.world.shopinfo.items[_loc3_];
            if(_loc2_.sName.toLowerCase() == param1)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public static function getShops() : String
      {
         return JSON.stringify(LoadedShops);
      }
      
      public static function load(param1:String) : void
      {
         game.world.sendLoadShopRequest(parseInt(param1));
      }
      
      public static function loadHairShop(param1:String) : void
      {
         game.world.sendLoadHairShopRequest(parseInt(param1));
      }
      
      public static function loadArmorCustomizer() : void
      {
         game.openArmorCustomize();
      }
      
      public static function sellItem(param1:String) : void
      {
         var _loc2_:Object = Inventory.getItem(param1);
         game.world.sendSellItemRequest(_loc2_);
      }
      
      public static function openShop() : void
      {
         if(game.world.shopinfo.bHouse == 1)
         {
            game.ui.mcPopup.fOpen("HouseShop");
         }
         else if(game.isMergeShop(game.world.shopinfo))
         {
            game.ui.mcPopup.fOpen("MergeShop");
         }
         else
         {
            game.ui.mcPopup.fOpen("Shop");
         }
      }
   }
}
