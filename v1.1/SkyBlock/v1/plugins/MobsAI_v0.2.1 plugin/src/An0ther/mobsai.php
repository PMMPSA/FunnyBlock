<?php

namespace An0ther;

use pocketmine\Player;
use pocketmine\Server;
use pocketmine\plugin\PluginBase;
use pocketmine\event\Listener;
use pocketmine\utils\Config;
use An0ther\AIHolder;

class mobsai extends PluginBase implements Listener
{
	public function onEnable(){
		new AIHolder($this->getServer());
	}
}

?>