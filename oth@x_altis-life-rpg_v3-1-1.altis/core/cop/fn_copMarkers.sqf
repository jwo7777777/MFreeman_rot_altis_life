/*
	File: fn_copMarkers.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Marks cops on the map for other cops. Only initalizes when the actual map is open.
*/
private["_markers","_cops"];
_markers = [];
_cops = [];

while {true} do
{
	waitUntil {visibleMap};
	
	{if(side _x == west) then {_cops set[count _cops,_x];}} foreach playableUnits; //Fetch list of cops / blufor
	
	//Create markers
	{
		_marker = createMarkerLocal [format["%1_marker",_x],getPos _x];
		_marker setMarkerColorLocal "ColorBlue";
		_marker setMarkerTypeLocal "Mil_dot";
		_marker setMarkerTextLocal format["%1", name _x];
		
		_markers set[count _markers,[_marker,_x]];
	} foreach _cops;
			
	while {visibleMap} do
	{
		{
			private["_marker","_unit"];
			_marker = _x select 0;
			_unit = _x select 1;
			if(!isNil "_unit") then
			{
				if(!isNull _unit) then
				{
					_marker setMarkerPosLocal (getPos _unit);
				};
			};
		} foreach _markers;
		if(!visibleMap) exitWith {};
		sleep 0.02;
	};
	
	{deleteMarkerLocal (_x select 0);} foreach _markers;
	_markers = [];
	_cops = [];
};