/*
 * Author: commy2
 *
 * Get the turret index of a vehicles commander.
 *
 * Argument:
 * 0: Vehicle (Object)
 *
 * Return value:
 * Turret index of the vehicles commander. Empty array means no observer position. (Array)
 */
#include "script_component.hpp"

private ["_vehicle", "_turrets", "_turret", "_config"];

_vehicle = _this select 0;

_turrets = allTurrets [_vehicle, true];

_turret = [];
{
  _config = configFile >> "CfgVehicles" >> typeOf _vehicle;

  _config = [_config, _x] call FUNC(getTurretConfigPath);

  if (getNumber (_config >> "primaryObserver") == 1) exitWith {
    _turret = _x;
  };
} forEach _turrets;
_turret
