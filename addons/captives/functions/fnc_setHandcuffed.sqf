/*
 * Author: Nic547, commy2
 * Handcuffs a unit
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: True to take captive, false to release captive <BOOL>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * TODO
 *
 * Public: No
 */
#include "script_component.hpp"

PARAMS_2(_unit,_state);


if (!local _unit) exitWith {
    ERROR("setHandcuffed unit not local");
};

if (_state isEqualTo (_unit getVariable [QGVAR(isHandcuffed), false])) exitWith {
    ERROR("new state equals current");
};

if (_state) then {
    _unit setVariable [QGVAR(isHandcuffed), true, true];
    [_unit, QGVAR(Handcuffed), true] call EFUNC(common,setCaptivityStatus);

    // fix anim on mission start (should work on dedicated servers)

    _fixAnimationFnc = {
        PARAMS_1(_unit);
        if (_unit getVariable [QGVAR(isHandcuffed), false] && {vehicle _unit == _unit}) then {
            [_unit] call EFUNC(common,fixLoweredRifleAnimation);
            [_unit, "ACE_AmovPercMstpScapWnonDnon", 0] call EFUNC(common,doAnimation);
        };
    };

    [_fixAnimationFnc, [_unit], 0.05, 0] call EFUNC(common,waitAndExecute);

    _unit setVariable [QGVAR(CargoIndex), ((vehicle _unit) getCargoIndex _unit), true];

    if (_unit == ACE_player) then {
        showHUD false;
    };
} else {
    _unit setVariable [QGVAR(isHandcuffed), false, true];
    [_unit, QGVAR(Handcuffed), false] call EFUNC(common,setCaptivityStatus);
    if ((vehicle _unit) == _unit) then {
        [_unit, "ACE_AmovPercMstpScapWnonDnon_AmovPercMstpSnonWnonDnon", 2] call EFUNC(common,doAnimation);
    };

    if (_unit getVariable [QGVAR(CargoIndex), -1] != -1) then {
        _unit setVariable [QGVAR(CargoIndex), -1, true];
    };

    if (_unit == ACE_player) then {
        showHUD true;
    };
};
