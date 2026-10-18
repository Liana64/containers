# qbittorrent

## Offical environment configuration

| Name                     | Default |
|--------------------------|---------|
| QBT_TORRENTING_PORT      | `50413` |
| QBT_WEBUI_PORT           | `8080`  |

## Config file environment configuration

Applied to `qBittorrent.conf` on every start, overriding WebUI changes.

| Name                                  | Config                                |
|---------------------------------------|---------------------------------------|
| `QBT_<Section>__<Key>[__<Subkey>...]` | `[<Section>]` `<Key>\<Subkey>`        |
| QBT_BitTorrent__Session__Interface  | `[BitTorrent]` `Session\Interface`    |
| QBT_Preferences__WebUI__Username    | `[Preferences]` `WebUI\Username`      |
