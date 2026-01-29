@echo off
rem
copy LUA\entry_Fly.lua entry.lua
rem  Cockpit
copy LUA\Cockpit_Cessna_210N.lods Shapes\Cockpit_Cessna_210N.lods
copy LUA\cockpit_cessna_210n.edm Shapes\cockpit_cessna_210n.edm
rem
echo.
echo.
echo.
echo.
echo --------------  Cessna Flyable  ----------------
echo.
echo.
echo.
echo.
rem  pause>nul
timeout 3