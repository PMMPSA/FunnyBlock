<?php

namespace Water;

use pocketmine\plugin\PluginBase;
use pocketmine\event\Listener;
use pocketmine\command\Command;
use pocketmine\command\CommandSender;
use pocketmine\Player;
use pocketmine\utils\Config;

class Main extends PluginBase implements Listener{
	
	public $players = [];
	private $config = [];
	
	public function onEnable()
	{
		$df = $this->getDataFolder();
		@mkdir($df);
		if(!is_file($df . "config.yml")){
			$cfg = new Config($df . "config.yml", Config::YAML);
			$cfg->setAll([
				"wings-off" => "§8»§c Water Flügel wurden deaktiviert!",
				"wings-on" => "§8»§a Water Flügel wurden aktiviert!",
				"update-period" => 20
			]);
			$cfg->save();
		}
		$this->config = (new Config($df . "config.yml", Config::YAML))->getAll();
		$this->getScheduler()->scheduleRepeatingTask(new SendWingsTask($this), $this->config["update-period"]);
	}
	
	public function onCommand(CommandSender $sender, Command $command, string $label, array $params) : bool
	{
		if(!$sender instanceof Player){
			$sender->sendMessage("§8§cDu hast keine Rechte !");
			return false;
		}
		$username = strtolower($sender->getName());
		if($command->getName() == "water"){
			if($sender->hasPermission("case.water")){
			if(isset($this->players[$username])){
				unset($this->players[$username]);
				$sender->sendMessage($this->config["wings-off"]);
				return true;
			}else{
				$this->players[$username] = true;
				$sender->sendMessage($this->config["wings-on"]);
				return true;
			}
		}else{
			return false;
			return True; 
		}
	}
	}
}
