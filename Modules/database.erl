-module(database).
-author('AleksanderLisiecki').
-include_lib("stdlib/include/qlc.hrl").

-export([
        % init -> ok | Error
        % creates DB schema, starts mnesia, creates table measurement 
        % returns ok no matter if table does not exist it is created
        % returns Error if something goes wrong
        init/0,                
        % stops mnesia - when called prints INFO RAPORT and
        % returns stopped
        terminate/0,            
        % inserts measurement record into db with current time and date (see erlang:universaltime()) 
        % Temperature single temperature measurement
        % Humidity single humidity measurement 
        % returns {aborted, Reason} | {atomic, ResultOfFun}
        insert_measurement/2,
        % UniversalTime is date and time in format {{Year, Month, Day}, {Hour, Minute, Second}}
        insert_measurement/3,
        % gests all measurements from db 
        % returns [{measurement,{{Year, Month, Day}, {Hour, Minute, Second}},Temperature,Humidity}] | error (if db is not running)
        get_measurements/0,
        % Filter is fun({measurement,{{Year, Month, Day}, {Hour, Minute, Second}},Temperature,Humidity}) -> bool(), allows to filter returned records
        %example 1
        %db:get_measurements(fun({_,_,X,_}) -> X > 4 end). 
        % will return only measurements where  Temperature is grater than 4
        %example 2
        %db:get_measurements(fun({measurement,{{Year,Month,_},{_,_,_}},_,_}) -> ((Year == 1995) and (Month == 1)) end).
        % will return only measurements from January 1995
        get_measurements/1]).

-record(measurement, {datetime = {{0,0,0},{0,0,0}}, %erlang:universaltime() returns {{Year, Month, Day}, {Hour, Minute, Second}}
                      temperature = -273.0,
                      humidity = 0.0}). %for future use

init() ->
    mnesia:create_schema([node()]),
    mnesia:start(),
    Init = mnesia:create_table(measurement, [{attributes, record_info(fields, measurement)}]),
    case Init of
        {atomic,ok} -> ok;
        {aborted,{already_exists,measurement}} -> ok;
        Error -> Error
    end.

terminate() -> mnesia:stop().

insert_measurement(Temperature,Humidity,{{Year, Month, Day}, {Hour, Minute, Second}}) ->
    UniversalTime = {{Year, Month, Day}, {Hour, Minute, Second}},
    NewRecord = {measurement,UniversalTime,Temperature,Humidity},
    io:fwrite("Adding: ~p to db\n",[NewRecord]),
    Fun = fun() -> mnesia:write(NewRecord) end,
    mnesia:transaction(Fun).

insert_measurement(Temperature,Humidity) ->
    UniversalTime = erlang:universaltime(),
    insert_measurement(Temperature,Humidity,UniversalTime).

get_measurements() ->
     get_measurements(fun(_) -> true end).

get_measurements(Filter) ->
     F = fun() ->
		Result = qlc:q([Measurement || Measurement <- mnesia:table(measurement), Filter(Measurement)]),
		qlc:e(Result)
	end,
    {atomic,Results} = mnesia:transaction(F),
    Results.