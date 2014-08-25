(function() {
  var Ability, Armor, Assassin, CantEquip, CantTake, Death, Druid, Entity, Game, Hero, Item, Monster, Paladin, Trash, Warlock, Weapon, adjectives, blueTrash, clickManager, gold, grayTrash, greenTrash, handleCharacterDeath, monsterHpFromLevel, newTrash, orangeTrash, print, purpleTrash, randomElementFromArray, removeFirstMatchFromArray, updateBottomBar, whiteTrash,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  Death = function(message) {
    this.name = "DeathError";
    return this.message = message || "Entity is dead.";
  };

  CantEquip = function(message) {
    this.name = "EquipError";
    return this.message = message || "Can't equip that!";
  };

  CantTake = function(message) {
    this.name = "InventoryError";
    return this.message = message || "Not enough room!";
  };

  print = function(message) {
    return console.log(message);
  };

  removeFirstMatchFromArray = function(element, array) {
    var item, newArray, theSwitch, _i, _len;
    newArray = [];
    theSwitch = true;
    for (_i = 0, _len = array.length; _i < _len; _i++) {
      item = array[_i];
      if (element !== item) {
        newArray.push(item);
      } else {
        if (theSwitch === true) {
          theSwitch = false;
        } else {
          newArray.push(item);
        }
      }
    }
    return newArray;
  };

  randomElementFromArray = function(array) {
    var index;
    index = Math.floor(Math.random() * array.length);
    return array[index];
  };

  handleCharacterDeath = function(character) {
    return print("" + character.name + " is dead.");
  };

  newTrash = function(hero) {
    var adjective, noun;
    adjective = randomElementFromArray(adjectives);
    noun = (function() {
      switch (false) {
        case !(hero.level < 20):
          return randomElementFromArray(grayTrash);
        case !(hero.level < 30):
          return randomElementFromArray(whiteTrash);
        case !(hero.level < 40):
          return randomElementFromArray(greenTrash);
        case !(hero.level < 50):
          return randomElementFromArray(blueTrash);
        case !(hero.level < 60):
          return randomElementFromArray(purpleTrash);
        default:
          return randomElementFromArray(orangeTrash);
      }
    })();
    print("Creating new level " + hero.level + " " + adjective + noun);
    return new Trash(adjective + noun, hero.level, monsterHpFromLevel(hero.level));
  };

  monsterHpFromLevel = function(level) {
    return Math.floor(20 * level + 5 * Math.pow(1.35, level));
  };

  Ability = (function() {
    function Ability(name, level, value, description) {
      this.name = name;
      this.level = level;
      this.value = value;
      this.description = description;
    }

    return Ability;

  })();

  Item = (function() {
    function Item(name, ilvl, color, value) {
      this.name = name;
      this.ilvl = ilvl;
      this.color = color;
      this.value = value;
    }

    return Item;

  })();

  Armor = (function(_super) {
    __extends(Armor, _super);

    function Armor(name, ilvl, color, defense) {
      var attributes, _i, _len, _ref;
      this.defense = defense;
      _ref = [name, ilvl, color];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        attributes = _ref[_i];
        Armor.__super__.constructor.call(this, attributes);
      }
    }

    return Armor;

  })(Item);

  Weapon = (function(_super) {
    __extends(Weapon, _super);

    function Weapon(name, ilvl, color, dps) {
      var attributes, _i, _len, _ref;
      this.dps = dps;
      _ref = [name, ilvl, color];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        attributes = _ref[_i];
        Weapon.__super__.constructor.call(this, attributes);
      }
    }

    return Weapon;

  })(Item);

  Entity = (function() {
    function Entity(name, level, hp) {
      this.name = name;
      this.level = level;
      this.hp = hp;
      this.def = 0;
      this.defModifier = 1;
      this.dps = 1;
      this.dpsModifier = 1;
      this.hps = 0;
      this.hpsModifier = 1;
    }

    Entity.prototype.attack = function(target) {
      var damage;
      damage = this.dps * this.dpsModifier;
      return target.takeDamage(damage);
    };

    Entity.prototype.takeDamage = function(dps) {
      var damage, mitigated;
      mitigated = this.def * this.defModifier;
      damage = dps - mitigated;
      if (this.hp - damage > 0) {
        return this.hp -= damage;
      } else {
        throw new Death(this.name + " has been slain!");
      }
    };

    Entity.prototype.getHealed = function(hps) {
      return this.hp = (function() {
        if (this.hp >= 0) {
          return this.hp + hps;
        } else {
          throw new Death(this.name + " is dead.");
        }
      }).call(this);
    };

    return Entity;

  })();

  Hero = (function(_super) {
    __extends(Hero, _super);

    function Hero(name, level, hp) {
      Hero.__super__.constructor.call(this, name, level, hp);
      this.gold = 0;
      this.exp = 0;
      this.armor = [];
      this.inventory = [];
      this.inventorySpace = 10;
      this.abilities = [];
    }

    Hero.prototype.learnAbility = function(ability) {
      return this.abilities.push(ability.name);
    };

    Hero.prototype.gainGold = function(amount) {
      return this.gold += amount;
    };

    Hero.prototype.equipArmor = function(armor) {
      var _ref;
      if (_ref = armor.name, __indexOf.call(this.inventory, _ref) >= 0) {
        this.armor.push(armor.name);
        return removeItemFromInventory(armor);
      } else {
        throw new EquipError("I don't have " + armor.name + " in my inventory!");
      }
    };

    Hero.prototype.unequipArmor = function(armor) {
      var error, _ref;
      if (_ref = armor.name, __indexOf.call(this.armor, _ref) >= 0) {
        try {
          return this.addItemToInventory(armor);
        } catch (_error) {
          error = _error;
          if (error instanceof InventoryFull) {
            return print(error.message);
          } else {
            throw error;
          }
        }
      }
    };

    Hero.prototype.addItemToInventory = function(item) {
      if (this.inventory.length < this.inventorySpace) {
        return this.inventory.push(item.name);
      } else {
        throw new CantTake("I don't have enough room for " + item.name + "!");
      }
    };

    Hero.prototype.removeItemFromInventory = function(item) {
      var _ref;
      if (_ref = item.name, __indexOf.call(this.inventory, _ref) >= 0) {
        return this.inventory = removeFirstMatchFromArray(item.name, this.inventory);
      } else {
        throw new CantTake("I don't have that item in my inventory!");
      }
    };

    Hero.prototype.buy = function(thing) {
      var e, gold;
      gold = this.gold;
      if (thing.value <= gold) {
        if (thing instanceof Item) {
          try {
            addItemToInventory(thing);
            return this.gold -= thing.value;
          } catch (_error) {
            e = _error;
            if (e.name === "CantTake") {
              print(e.message);
              return this.gold = gold;
            } else {
              this.gold = gold;
              throw e;
            }
          }
        } else if (thing instanceof Ability) {
          try {
            return learnAbility(thing);
          } catch (_error) {
            e = _error;
            return print(e.message);
          }
        } else {
          throw new Error("I'm not sure what you're trying to buy?");
        }
      } else {
        throw new CantTake("I don't have enough money!");
      }
    };

    return Hero;

  })(Entity);

  Warlock = (function(_super) {
    __extends(Warlock, _super);

    function Warlock(name, level, hp) {
      Warlock.__super__.constructor.call(this, name, level, hp);
      this.role = "rdps";
      this.def = 1;
      this.defModifier = 1;
      this.dps = 5;
      this.dpsModifier = 1.1;
      this.hps = 0;
      this.hpsModifier = 1;
    }

    return Warlock;

  })(Hero);

  Paladin = (function(_super) {
    __extends(Paladin, _super);

    function Paladin(name, level, hp) {
      Paladin.__super__.constructor.call(this, name, level, hp);
      this.role = "tank";
      this.def = 5;
      this.defModifier = 1.1;
      this.dps = 2;
      this.dpsModifier = 1;
      this.hps = 0;
      this.hpsModifier = 1;
    }

    return Paladin;

  })(Hero);

  Assassin = (function(_super) {
    __extends(Assassin, _super);

    function Assassin(name, level, hp) {
      Assassin.__super__.constructor.call(this, name, level, hp);
      this.role = "mdps";
    }

    return Assassin;

  })(Hero);

  Druid = (function(_super) {
    __extends(Druid, _super);

    function Druid(name, level, hp) {
      Druid.__super__.constructor.call(this, name, level, hp);
      this.role = "healer";
    }

    return Druid;

  })(Hero);

  Monster = (function(_super) {
    __extends(Monster, _super);

    function Monster(name, level, hp, difficulty) {
      this.difficulty = difficulty;
      Monster.__super__.constructor.call(this, name, level, hp);
      this.gold = hp;
    }

    return Monster;

  })(Entity);

  Trash = (function(_super) {
    __extends(Trash, _super);

    function Trash(name, level, hp) {
      Trash.__super__.constructor.call(this, name, level, hp, "easy");
    }

    return Trash;

  })(Monster);

  Game = (function() {
    function Game(hash) {
      var gameData, gameDataString, key, value;
      gameDataString = window.atob(hash);
      gameData = JSON.parse(gameDataString);
      for (key in gameData) {
        value = gameData[key];
        this[key] = value;
      }
    }

    Game.prototype.save = function() {
      var gameData, key, value;
      gameData = {};
      for (key in this) {
        value = this[key];
        if (typeof this[key] !== "function") {
          gameData[key] = value;
        }
      }
      return window.btoa(JSON.stringify(gameData));
    };

    Game.prototype.heroes = [];

    Game.prototype.villains = [];

    return Game;

  })();

  gold = {
    "rat": 5,
    "snake": 6,
    "bat": 7,
    "boar": 8
  };

  adjectives = ["sneaky ", "filthy ", "diseased ", "carcinogenic ", "slimy ", "tragic ", "scared ", "scary ", "Martian ", "belligerent "];

  grayTrash = ["rat", "snake", "bat", "boar"];

  whiteTrash = [];

  greenTrash = [];

  blueTrash = [];

  purpleTrash = [];

  orangeTrash = [];

  updateBottomBar = function(hero, monster) {
    $(".hero-gold").text(hero.gold);
    $(".hero-name").text(hero.name);
    $(".hero-dps").text(hero.dps);
    $(".hero-hp").text(hero.hp);
    $(".monster-name").text(monster.name);
    $(".monster-difficulty").text(monster.difficulty);
    return $(".monster-hp").text(monster.hp);
  };

  clickManager = function() {
    var error, hero, monster;
    hero = belligerents.hero;
    monster = belligerents.monster;
    try {
      hero.attack(monster);
      updateBottomBar(hero, monster);
    } catch (_error) {
      error = _error;
      if (error instanceof Death) {
        print(error.message);
        hero.gainGold(monster.gold);
        belligerents.monster = newTrash(hero);
        updateBottomBar(hero, monster);
        return;
      } else {
        throw error;
      }
    }
    try {
      return monster.attack(hero);
    } catch (_error) {
      error = _error;
      if (error instanceof Death) {
        print(error.message);
        return handleCharacterDeath(hero);
      } else {
        throw error;
      }
    }
  };

  $(function() {});

}).call(this);
