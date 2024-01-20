# tofu-satellite

FiveM client-side spy satellite that can automatically track players, or use manually with keyboard controls.

This resource could be used in cases like accessing a laptop or as a result from some sort of hacking/minigame.

### Features

- Automated tracking mode
- Manual tracking mode
- Simulated rotaton / angle shift to represent to some degree orbital shifts
- Configurable timeout, zoom, speed, and camera rotations
- Tracks players that are out of view with indicator arrows

![Spy Satellite](./docs/tracker1.png)

### Dependencies

- [qb-core](https://github.com/qbcore-framework/qb-core)

\_Note: If you want to run this without qb-core dependency, simply delete `server/commands.lua` and substitue the qbcore arithmatic functions with an equivalent in `client/threads.lua`.

### How to use

Simply invoke the client-side event with the list of players that you want to track. Press `spacebar` to exit.

```lua
local players = {"-1"}
TriggerClientEvent('tofu-satellite:open', -1, players, 0)
```

### Commands

To help demonstrate capabilities, the following commands are included by default _(restricted to those with qb-core admin priviledges)_.

- `trackallplayers` - tracks all players in the server _(will probably be laggy with large numbers)_
- `trackallplayerstimeout` - same as above, but includes a 30s timeout window at which point the user will lose access to the satellite.
- `trackphone` - track a player by their phone number
- `manualtracking` - allow the player free-roam access with the satellite _(doesn't show tracker icon around any players)_
